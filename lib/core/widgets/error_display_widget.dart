import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ErrorDisplayWidget extends StatelessWidget {
  const ErrorDisplayWidget({
    required this.errorMessage,
    required this.onRetry,
    super.key,
  });

  final String errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Wystąpił błąd: $errorMessage'),
          const SizedBox(height: 16),
          ShadButton(
            onPressed: onRetry,
            child: const Text('Spróbuj ponownie'),
          ),
        ],
      ),
    );
  }
}
