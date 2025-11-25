import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:x10devs/features/flashcard/data/models/flashcard_model.dart';
import 'package:x10devs/features/flashcard/presentation/bloc/flashcard_cubit.dart';
import 'package:x10devs/features/flashcard/presentation/widgets/add_edit_flashcard_dialog.dart';

class FlashcardCard extends StatelessWidget {
  const FlashcardCard({super.key, required this.flashcard});

  final FlashcardModel flashcard;

  @override
  Widget build(BuildContext context) {
    return ShadCard(
      title: Text(flashcard.front, style: ShadTheme.of(context).textTheme.p),
      description: Text(
        flashcard.back,
        style: ShadTheme.of(context).textTheme.small,
      ),
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ShadButton.ghost(
            child: const Icon(LucideIcons.pencil, size: 16),
            onPressed: () {
              showShadDialog(
                context: context,
                builder: (_) => BlocProvider.value(
                  value: context.read<FlashcardCubit>(),
                  child: AddEditFlashcardDialog(
                    deckId: flashcard.deckId,
                    initialData: flashcard,
                  ),
                ),
              );
            },
          ),
          ShadButton.ghost(
            child: const Icon(LucideIcons.trash2, size: 16),
            onPressed: () {
              context.read<FlashcardCubit>().deleteFlashcard(
                flashcard.deckId,
                flashcard.id,
              );
            },
          ),
        ],
      ),
    );
  }
}
