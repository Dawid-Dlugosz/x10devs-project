import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:x10devs/features/flashcard/data/models/flashcard_model.dart';
import 'package:x10devs/features/flashcard/presentation/bloc/flashcard_cubit.dart';


class AddEditFlashcardDialog extends StatefulWidget {
  const AddEditFlashcardDialog({
    super.key,
    required this.deckId,
    this.initialData,
  });

  final int deckId;
  final FlashcardModel? initialData;

  @override
  State<AddEditFlashcardDialog> createState() => _AddEditFlashcardDialogState();
}

class _AddEditFlashcardDialogState extends State<AddEditFlashcardDialog> {
  final _formKey = GlobalKey<ShadFormState>();
  late final TextEditingController _frontController;
  late final TextEditingController _backController;

  @override
  void initState() {
    super.initState();
    _frontController = TextEditingController(text: widget.initialData?.front);
    _backController = TextEditingController(text: widget.initialData?.back);
  }

  @override
  void dispose() {
    _frontController.dispose();
    _backController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.saveAndValidate()) {
      final front = _frontController.text;
      final back = _backController.text;
      final cubit = context.read<FlashcardCubit>();

      if (widget.initialData == null) {
        cubit.createFlashcard(
          deckId: widget.deckId,
          front: front,
          back: back,
        );
      } else {
        cubit.updateFlashcard(
          deckId: widget.deckId,
          flashcardId: widget.initialData!.id,
          newFront: front,
          newBack: back,
        );
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialData != null;
    return ShadDialog(
      title: Text(isEditing ? 'Edytuj fiszkę' : 'Dodaj fiszkę'),
      actions: [
        ShadButton(
          onPressed: _save,
          child: const Text('Zapisz'),
        ),
      ],
    child: ShadForm(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShadInputFormField(
              id: 'front',
              controller: _frontController,
              label: const Text('Przód'),
              placeholder: const Text('Wpisz tekst na przód fiszki'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Pole jest wymagane';
                }
                if (value.length > 200) {
                  return 'Maksymalnie 200 znaków';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ShadInputFormField(
              id: 'back',
              controller: _backController,
              label: const Text('Tył'),
              placeholder: const Text('Wpisz tekst na tył fiszki'),
              maxLines: 5,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Pole jest wymagane';
                }
                if (value.length > 500) {
                  return 'Maksymalnie 500 znaków';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
