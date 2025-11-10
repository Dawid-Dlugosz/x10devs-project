import 'package:flutter/material.dart';
import 'package:x10devs/features/decks/data/models/deck_model.dart';
import 'package:x10devs/features/decks/presentation/widgets/deck_card_widget.dart';

class DecksListWidget extends StatelessWidget {
  const DecksListWidget({
    required this.decks,
    super.key,
  });

  final List<DeckModel> decks;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          // Use GridView for wider screens
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 2,
            ),
            itemCount: decks.length,
            itemBuilder: (context, index) {
              return DeckCardWidget(deck: decks[index]);
            },
          );
        } else {
          // Use ListView for narrower screens
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: decks.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: DeckCardWidget(deck: decks[index]),
              );
            },
          );
        }
      },
    );
  }
}
