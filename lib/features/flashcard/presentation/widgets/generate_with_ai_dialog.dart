import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:x10devs/features/flashcard/presentation/bloc/ai_generation_cubit.dart';

class GenerateWithAiDialog extends StatefulWidget {
  const GenerateWithAiDialog({super.key});

  @override
  State<GenerateWithAiDialog> createState() => _GenerateWithAiDialogState();
}

class _GenerateWithAiDialogState extends State<GenerateWithAiDialog> {
  final _formKey = GlobalKey<ShadFormState>();
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _generate() {
    if (_formKey.currentState!.saveAndValidate()) {
      final text = _textController.text;
      context.read<AiGenerationCubit>().generateFlashcards(text);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ShadDialog(
      title: const Text('Generuj fiszki z AI'),
      actions: [
        ShadButton(
          onPressed: _generate,
          child: const Text('Generuj'),
        ),
      ],
      child: ShadForm(
        key: _formKey,
        child: ShadInputFormField(
          id: 'source_text',
          controller: _textController,
          placeholder:
              const Text('Wklej tutaj tekst, z którego AI ma stworzyć fiszki...'),
          maxLines: 10,
          validator: (value) {
            if (value.isEmpty) {
              return 'Pole jest wymagane';
            }
            if (value.length > 10000) {
              return 'Maksymalnie 10 000 znaków';
            }
            return null;
          },
        ),
      ),
    );
  }
}
