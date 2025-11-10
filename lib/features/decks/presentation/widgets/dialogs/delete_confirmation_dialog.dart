import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:x10devs/features/decks/data/models/deck_model.dart';

Future<bool?> showDeleteConfirmationDialog(
  BuildContext context, {
  required DeckModel deck,
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return DeleteConfirmationDialog(deckToDelete: deck);
    },
  );
}

class DeleteConfirmationDialog extends StatelessWidget {
  const DeleteConfirmationDialog({
    required this.deckToDelete,
    super.key,
  });

  final DeckModel deckToDelete;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Potwierdź usunięcie'),
      content: Text('Czy na pewno chcesz usunąć talię "${deckToDelete.name}"?'),
      actions: [
        ShadButton.ghost(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Anuluj'),
        ),
        ShadButton.destructive(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Usuń'),
        ),
      ],
    );
  }
}
