import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:x10devs/core/errors/failure.dart';

class FlashcardErrorView extends StatelessWidget {
  const FlashcardErrorView({
    super.key,
    required this.failure,
    required this.onRetry,
  });

  final Failure failure;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ShadAlert.destructive(
        icon: const Icon(Icons.warning),
        title: const Text('Wystąpił błąd'),
        description: Text(failure.message),
        trailing: Row(
          children: [
            ShadButton(
              onPressed: onRetry,
              child: const Text('Spróbuj ponownie'),
            ),
          ],
        ),
      ),
    );
  }
}
