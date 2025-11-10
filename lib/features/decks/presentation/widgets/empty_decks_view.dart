import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class EmptyDecksView extends StatelessWidget {
  const EmptyDecksView({
    required this.onCreateDeckPressed,
    super.key,
  });

  final VoidCallback onCreateDeckPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Nie masz jeszcze żadnych talii.'),
          const SizedBox(height: 16),
          ShadButton(
            onPressed: onCreateDeckPressed,
            child: const Text('Stwórz talię'),
          ),
        ],
      ),
    );
  }
}
