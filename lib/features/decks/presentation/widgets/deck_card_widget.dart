import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:x10devs/features/decks/data/models/deck_model.dart';
import 'package:x10devs/features/decks/presentation/bloc/decks_cubit.dart';
import 'package:x10devs/features/decks/presentation/widgets/dialogs/create_or_edit_deck_dialog.dart';
import 'package:x10devs/features/decks/presentation/widgets/dialogs/delete_confirmation_dialog.dart';

class DeckCardWidget extends StatefulWidget {
  const DeckCardWidget({
    required this.deck,
    super.key,
  });

  final DeckModel deck;

  @override
  State<DeckCardWidget> createState() => _DeckCardWidgetState();
}

class _DeckCardWidgetState extends State<DeckCardWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go('/decks/${widget.deck.id}'),
        child: ShadCard(
          backgroundColor: theme.colorScheme.secondary,
          shadows: _isHovered
              ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withAlpha(63),
                    spreadRadius: 2,
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.deck.name),
              PopupMenuButton<String>(
                onSelected: (value) async {
                  if (value == 'edit') {
                    final newName = await showCreateOrEditDeckDialog(
                      context,
                      deck: widget.deck,
                    );
                    if (newName != null && context.mounted) {
                      context
                          .read<DecksCubit>()
                          .updateDeck(widget.deck.id, newName);
                    }
                  } else if (value == 'delete') {
                    final confirmed = await showDeleteConfirmationDialog(
                      context,
                      deck: widget.deck,
                    );
                    if (confirmed == true && context.mounted) {
                      context.read<DecksCubit>().deleteDeck(widget.deck.id);
                    }
                  }
                },
                itemBuilder:
                    (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'edit',
                    child: Text('Zmień nazwę'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'delete',
                    child: Text('Usuń'),
                  ),
                ],
              ),
            ],
          ),
          description: Text('${widget.deck.flashcardCount} fiszek'),
          // child: const SizedBox(height: 50),
        ),
      ),
    );
  }
}
