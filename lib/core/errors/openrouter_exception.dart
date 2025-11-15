enum OpenRouterErrorType {
  network,
  timeout,
  authentication,
  rateLimit,
  invalidRequest,
  modelNotFound,
  serverError,
  parsing,
  validation,
  noResults,
  unknown,
}

class OpenRouterException implements Exception {
  OpenRouterException({
    required this.message,
    required this.type,
    this.originalError,
  });

  final String message;
  final OpenRouterErrorType type;
  final dynamic originalError;

  @override
  String toString() => 'OpenRouterException($type): $message';
}
