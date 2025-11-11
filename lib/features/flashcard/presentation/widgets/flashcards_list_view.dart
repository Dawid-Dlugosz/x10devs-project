import 'package:flutter/material.dart';
import 'package:x10devs/features/flashcard/data/models/flashcard_model.dart';
import 'package:x10devs/features/flashcard/presentation/widgets/flashcard_card.dart';

class FlashcardsListView extends StatelessWidget {
  const FlashcardsListView({
    super.key,
    required this.flashcards,
  });

  final List<FlashcardModel> flashcards;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: flashcards.length,
      itemBuilder: (context, index) {
        final flashcard = flashcards[index];
        return FlashcardCard(flashcard: flashcard);
      },
    );
  }
}
