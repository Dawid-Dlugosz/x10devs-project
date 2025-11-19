/// Test data constants and generators for E2E tests

class TestData {
  // Test user credentials
  static const String testEmail = 'test@example.com';
  static const String testPassword = 'TestPassword123!';

  // Test deck names
  static const String deckName1 = 'Test Deck 1';
  static const String deckName2 = 'Test Deck 2';
  static const String deckNameWithSpecialChars = 'Test <>&"\' Deck';
  static const String deckNameWithUnicode = 'Test 中文 العربية 📚 Deck';

  // Test flashcard content
  static const String flashcardFront1 = 'What is Flutter?';
  static const String flashcardBack1 =
      'Flutter is a UI toolkit for building natively compiled applications.';

  static const String flashcardFront2 = 'What is Dart?';
  static const String flashcardBack2 =
      'Dart is a programming language optimized for building mobile, desktop, server, and web applications.';

  // Test text for AI generation
  static const String aiTestTextShort = '''
Flutter is an open-source UI software development kit created by Google. 
It is used to develop applications for Android, iOS, Linux, macOS, Windows, and the web.
Flutter uses the Dart programming language.
''';

  static const String aiTestTextMedium = '''
Flutter is an open-source UI software development kit created by Google. 
It is used to develop cross-platform applications from a single codebase for mobile, web, and desktop.

Key features of Flutter include:
- Hot reload for fast development
- Rich set of customizable widgets
- Native performance
- Beautiful and flexible UI design

Flutter uses the Dart programming language, which is also developed by Google.
Dart is optimized for building user interfaces with features like sound null safety.

Flutter applications are built using widgets, which are the basic building blocks of the UI.
Everything in Flutter is a widget, from buttons to padding to layout structures.
''';

  static const String aiTestTextLong = '''
Flutter is an open-source UI software development kit created by Google. 
It is used to develop cross-platform applications from a single codebase for mobile, web, and desktop.

Architecture:
Flutter uses a layered architecture that provides flexibility and control. 
The framework consists of widgets, rendering, and platform layers.

Widgets:
Everything in Flutter is a widget. Widgets describe what their view should look like given their current configuration and state.
There are two types of widgets: StatelessWidget and StatefulWidget.

StatelessWidget:
A stateless widget never changes. Icon, IconButton, and Text are examples of stateless widgets.

StatefulWidget:
A stateful widget is dynamic. It can change its appearance in response to events triggered by user interactions or when it receives data.

Rendering:
Flutter uses its own rendering engine called Skia to draw widgets on the screen.
This allows Flutter to have consistent UI across different platforms.

Hot Reload:
One of Flutter's most loved features is hot reload, which allows developers to see changes instantly without losing the app state.

Dart Language:
Flutter uses Dart, a modern programming language with features like:
- Sound null safety
- Async/await for asynchronous programming
- Strong typing with type inference
- Just-in-time (JIT) and ahead-of-time (AOT) compilation

Performance:
Flutter apps are compiled to native machine code, which ensures high performance.
The framework is designed to help developers easily achieve 60fps or 120fps on devices that support it.
''';

  // Edge case test data
  static const String emptyString = '';
  static const String whitespaceOnly = '   ';
  static String maxLengthFront = 'A' * 200;
  static String maxLengthBack = 'B' * 500;
  static String exceedMaxLengthFront = 'A' * 201;
  static String exceedMaxLengthBack = 'B' * 501;

  // Special characters
  static const String specialCharsText = '<script>alert("XSS")</script>';
  static const String unicodeText = '中文 العربية 日本語 한국어';
  static const String emojiText = '📚 ✨ 🎯 🚀 💡';

  // Validation messages (should match app's actual messages)
  static const String emailRequiredError = 'Email jest wymagany';
  static const String emailInvalidError = 'Nieprawidłowy format email';
  static const String passwordRequiredError = 'Hasło jest wymagane';
  static const String passwordTooShortError =
      'Hasło musi mieć co najmniej 8 znaków';
  static const String passwordsDoNotMatchError = 'Hasła nie są identyczne';
  static const String deckNameRequiredError = 'Nazwa talii jest wymagana';
  static const String flashcardFrontRequiredError = 'Przód fiszki jest wymagany';
  static const String flashcardBackRequiredError = 'Tył fiszki jest wymagany';
  static const String flashcardFrontTooLongError =
      'Przód fiszki może mieć maksymalnie 200 znaków';
  static const String flashcardBackTooLongError =
      'Tył fiszki może mieć maksymalnie 500 znaków';
  static const String aiTextTooLongError =
      'Tekst może mieć maksymalnie 10,000 znaków';

  // Success messages
  static const String deckCreatedSuccess = 'Talia utworzona pomyślnie';
  static const String deckUpdatedSuccess = 'Talia zaktualizowana pomyślnie';
  static const String deckDeletedSuccess = 'Talia usunięta pomyślnie';
  static const String flashcardCreatedSuccess = 'Fiszka utworzona pomyślnie';
  static const String flashcardUpdatedSuccess =
      'Fiszka zaktualizowana pomyślnie';
  static const String flashcardDeletedSuccess = 'Fiszka usunięta pomyślnie';

  // Timeouts
  static const Duration shortTimeout = Duration(seconds: 5);
  static const Duration mediumTimeout = Duration(seconds: 10);
  static const Duration longTimeout = Duration(seconds: 30);

  /// Generates a unique deck name with timestamp
  static String generateUniqueDeckName() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'Test Deck $timestamp';
  }

  /// Generates a unique flashcard front with timestamp
  static String generateUniqueFlashcardFront() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'Question $timestamp?';
  }

  /// Generates a unique flashcard back with timestamp
  static String generateUniqueFlashcardBack() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'Answer $timestamp';
  }
}

