import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:x10devs/features/decks/presentation/bloc/decks_cubit.dart';
import 'package:x10devs/features/flashcard/presentation/bloc/ai_generation_cubit.dart';
import 'package:x10devs/features/flashcard/presentation/bloc/ai_generation_state.dart';
import 'package:x10devs/features/flashcard/presentation/bloc/flashcard_cubit.dart';
import 'package:x10devs/features/flashcard/presentation/bloc/flashcard_state.dart';
import 'package:x10devs/features/flashcard/presentation/widgets/add_edit_flashcard_dialog.dart';
import 'package:x10devs/features/flashcard/presentation/widgets/empty_flashcards_view.dart';
import 'package:x10devs/features/flashcard/presentation/widgets/flashcard_error_view.dart';
import 'package:x10devs/features/flashcard/presentation/widgets/flashcards_list_view.dart';
import 'package:x10devs/features/flashcard/presentation/widgets/generate_with_ai_dialog.dart';

class FlashcardsPage extends StatefulWidget {
  const FlashcardsPage({super.key, required this.deckId});

  final String deckId;

  @override
  State<FlashcardsPage> createState() => _FlashcardsPageState();
}

class _FlashcardsPageState extends State<FlashcardsPage> {
  @override
  void initState() {
    super.initState();
    context.read<FlashcardCubit>().getFlashcards(int.parse(widget.deckId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fiszki'),
        actions: [
          ShadButton.ghost(
            child: const Icon(LucideIcons.plus),
            onPressed: () {
              showShadDialog(
                context: context,
                builder: (_) => BlocProvider.value(
                  value: context.read<FlashcardCubit>(),
                  child: AddEditFlashcardDialog(
                    deckId: int.parse(widget.deckId),
                  ),
                ),
              );
            },
          ),
          ShadButton.ghost(
            child: const Icon(LucideIcons.sparkles),
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
      body: Builder(
        builder: (context) {
          return MultiBlocListener(
            listeners: [
              BlocListener<AiGenerationCubit, AiGenerationState>(
                listener: (context, state) {
                  state.whenOrNull(
                    loading: () {
                      ShadToaster.of(context).show(
                        const ShadToast(
                          title: Text('Generowanie fiszek...'),
                          description: Text(
                            'AI analizuje Twój tekst. Może to chwilę potrwać.',
                          ),
                        ),
                      );
                    },
                    loaded: (candidates) {
                      context.go('/decks/${widget.deckId}/review');
                    },
                    error: (failure) {
                      ShadToaster.of(context).show(
                        ShadToast.destructive(
                          title: const Text('Błąd generowania'),
                          description: Text(failure.message),
                        ),
                      );
                    },
                  );
                },
              ),
              BlocListener<FlashcardCubit, FlashcardState>(
                listener: (context, state) {
                  // TODO: Implement more granular error handling
                },
              ),
            ],
            child: BlocBuilder<FlashcardCubit, FlashcardState>(
              builder: (context, state) {
                return state.when(
                  initial: () => const Center(child: Text('Stan początkowy')),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  loaded: (flashcards) {
                    if (flashcards.isEmpty) {
                      return EmptyFlashcardsView(
                        deckId: int.parse(widget.deckId),
                      );
                    }
                    context.read<DecksCubit>().updateDeckFlashcardCount(
                      int.parse(widget.deckId),
                      flashcards.length,
                    );
                    // context.read<DecksCubit>().updateDeckFlashcardCount(int.parse(widget.deckId), flashcards.length);
                    return FlashcardsListView(flashcards: flashcards);
                  },
                  error: (failure) => FlashcardErrorView(
                    failure: failure,
                    onRetry: () => context.read<FlashcardCubit>().getFlashcards(
                      int.parse(widget.deckId),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
