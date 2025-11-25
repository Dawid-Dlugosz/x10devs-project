import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:x10devs/features/flashcard/presentation/bloc/ai_generation_cubit.dart';
import 'package:x10devs/features/flashcard/presentation/bloc/flashcard_cubit.dart';
import 'package:x10devs/features/flashcard/presentation/widgets/add_edit_flashcard_dialog.dart';
import 'package:x10devs/features/flashcard/presentation/widgets/generate_with_ai_dialog.dart';

class EmptyFlashcardsView extends StatelessWidget {
  const EmptyFlashcardsView({super.key, required this.deckId});

  final int deckId;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(LucideIcons.folderOpen, size: 48),
            const SizedBox(height: 16),
            Text('Brak fiszek', style: theme.textTheme.h4),
            const SizedBox(height: 8),
            Text(
              'Dodaj swoją pierwszą fiszkę ręcznie lub wygeneruj ją z AI.',
              style: theme.textTheme.muted,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShadButton(
                  trailing: const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(LucideIcons.plus, size: 16),
                  ),
                  child: const Text('Dodaj ręcznie'),
                  onPressed: () {
                    showShadDialog(
                      context: context,
                      builder: (_) => BlocProvider.value(
                        value: context.read<FlashcardCubit>(),
                        child: AddEditFlashcardDialog(deckId: deckId),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 16),
                ShadButton.secondary(
                  trailing: const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(LucideIcons.sparkles, size: 16),
                  ),
                  child: const Text('Generuj z AI'),
                  onPressed: () {
                    showShadDialog(
                      context: context,
                      builder: (_) => BlocProvider.value(
                        value: context.read<AiGenerationCubit>(),
                        child: const GenerateWithAiDialog(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
