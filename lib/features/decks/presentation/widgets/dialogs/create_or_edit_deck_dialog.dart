import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:x10devs/features/decks/data/models/deck_model.dart';

Future<String?> showCreateOrEditDeckDialog(
  BuildContext context, {
  DeckModel? deck,
}) {
  return showDialog<String>(
    context: context,
    builder: (context) {
      return CreateOrEditDeckDialog(deckToEdit: deck);
    },
  );
}

class CreateOrEditDeckDialog extends StatefulWidget {
  const CreateOrEditDeckDialog({
    this.deckToEdit,
    super.key,
  });

  final DeckModel? deckToEdit;

  @override
  State<CreateOrEditDeckDialog> createState() => _CreateOrEditDeckDialogState();
}

class _CreateOrEditDeckDialogState extends State<CreateOrEditDeckDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.deckToEdit?.name);
    _nameController.addListener(() {
      final isValid = _formKey.currentState?.validate() ?? false;
      if (_isFormValid != isValid) {
        setState(() {
          _isFormValid = isValid;
        });
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nazwa talii jest wymagana.';
    }
    if (value.length > 100) {
      return 'Nazwa nie może przekraczać 100 znaków.';
    }
    return null;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop(_nameController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.deckToEdit != null;
    return AlertDialog(
      title: Text(isEditing ? 'Edytuj talię' : 'Stwórz nową talię'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Form(
          key: _formKey,
          child: ShadInputFormField(
            controller: _nameController,
            placeholder: const Text('Nazwa talii'),
            validator: _validateName,
          ),
        ),
      ),
      actions: [
        ShadButton.ghost(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Anuluj'),
        ),
        ShadButton(
          onPressed: _isFormValid ? _submit : null,
          child: const Text('Zapisz'),
        ),
      ],
    );
  }
}
