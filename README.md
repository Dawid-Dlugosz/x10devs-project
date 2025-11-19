# Smart Flashcards

[![Project Status: In Development](https://img.shields.io/badge/status-in_development-brightgreen.svg)](https://github.com/x10devs/x10devs)
[![Flutter Version](https://img.shields.io/badge/flutter-3.5-blue.svg)](https://flutter.dev/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

An intelligent web application that revolutionizes the way students create and use study materials by automatically generating flashcards from text notes using AI.

## Table of Contents

- [Project Description](#project-description)
- [Tech Stack](#tech-stack)
- [Getting Started Locally](#getting-started-locally)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Available Scripts](#available-scripts)
- [Project Scope](#project-scope)
  - [Key Features (MVP)](#key-features-mvp)
  - [Out of Scope](#out-of-scope)
- [Project Status](#project-status)
- [License](#license)

## Project Description

Smart Flashcards is a web application designed to streamline the study process for students. It addresses the time-consuming and tedious task of manually creating flashcards by leveraging AI to automatically generate them from user-provided text notes. This allows users to focus on learning rather than on the preparation of study materials.

The Minimum Viable Product (MVP) focuses on core functionalities, including complete flashcard and deck management (CRUD), AI-powered content generation, and a secure user account system powered by Supabase.

## Tech Stack

The project is built with a modern, scalable tech stack:

| Category      | Technology / Library                                                              | Description                                                                 |
|---------------|-----------------------------------------------------------------------------------|-----------------------------------------------------------------------------|
| **Frontend**  | [Flutter](https://flutter.dev/) `3.5` & [Dart](https://dart.dev/) `3.9`           | UI toolkit for building natively compiled applications for mobile, web, and desktop. |
|               | [shadcn_flutter](https://pub.dev/packages/shadcn_flutter)                         | A port of the shadcn/ui library for creating beautiful UIs.                 |
| **State Mngmt** | [BLoC/Cubit](https://pub.dev/packages/bloc) `9.1.0`                               | Predictable state management library for Dart.                              |
|               | [Freezed](https://pub.dev/packages/freezed) `3.2.3`                               | Code generator for immutable classes and unions.                            |
| **Routing**   | [go_router](https://pub.dev/packages/go_router) `14.2.0`                          | Declarative routing package for Flutter, supported by the Flutter team.     |
| **Networking**| [Dio](https://pub.dev/packages/dio) `5.9.0`                                       | A powerful HTTP client for Dart.                                            |
| **DI**        | [get_it](https://pub.dev/packages/get_it) `8.3.0` & [injectable](https://pub.dev/packages/injectable) `2.5.2` | Service locator for dependency injection.                                   |
| **Error Hndl**| [fpdart](https://pub.dev/packages/fpdart) `1.2.0`                                 | Functional programming library for robust error handling.                   |
| **Backend**   | [Supabase](https://supabase.io/)                                                  | Open-source Firebase alternative for database, auth, and storage.           |
| **AI**        | [OpenRouter.ai](https://openrouter.ai/)                                           | Access to a wide range of AI models (OpenAI, Anthropic, Google).            |
| **CI/CD**     | [GitHub Actions](https://github.com/features/actions)                             | Automation of build, test, and deployment pipelines.                        |

## Getting Started Locally

Follow these instructions to get a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (version 3.5 or higher)
- An IDE such as [VS Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio)

### Installation

1.  **Clone the repository:**
    ```sh
    git clone https://github.com/your-username/x10devs.git
    cd x10devs
    ```

2.  **Install dependencies:**
    ```sh
    flutter pub get
    ```

3.  **Set up environment variables:**
    Create a `.env` file in the root of the project and add the necessary API keys and URLs. You will need to get these from Supabase and OpenRouter.ai.
    ```env
    SUPABASE_URL=YOUR_SUPABASE_URL
    SUPABASE_ANON_KEY=YOUR_SUPABASE_ANON_KEY
    OPENROUTER_API_KEY=YOUR_OPENROUTER_API_KEY
    ```

4.  **Run the code generator:**
    This project uses code generation for dependency injection and immutable classes. Run the following command to generate the necessary files:
    ```sh
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

5.  **Run the application:**
    ```sh
    flutter run
    ```

## Available Scripts

-   `flutter pub get`: Installs or updates all project dependencies.
-   `flutter run`: Compiles and runs the application on a connected device or emulator.
-   `flutter test`: Executes all unit and widget tests in the project.
-   `flutter test --coverage`: Runs tests and generates code coverage report.
-   `flutter pub run build_runner build --delete-conflicting-outputs`: Runs the build runner to generate required files.
-   `flutter analyze`: Analyzes the project's Dart code for potential errors.

### Testing
-   `flutter test`: Executes all unit and widget tests in the project.
-   `flutter test --coverage`: Runs tests and generates code coverage report.
-   `flutter drive --target=test_driver/app.dart`: Runs E2E integration tests.

### Database Migration
-   `./setup_remote_db.sh`: Automated script to link project and run migrations (recommended).
-   `./migrate_from_env.sh`: Migrate using connection string from `.env.test`.
-   `./migrate.sh`: Direct migration using `DATABASE_URL` environment variable.
-   `supabase db push`: Push migrations using Supabase CLI (after linking project).

See [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md) for detailed database migration instructions.

## Project Scope

### Key Features (MVP)

-   **User Authentication**: Secure user registration, login, and session management.
-   **Deck Management**: Create, view, edit, and delete thematic flashcard decks.
-   **Flashcard Management**: Manually create, view, edit, and delete individual flashcards within a deck.
-   **AI-Powered Generation**: Generate flashcard suggestions from raw text (up to 10,000 characters).
-   **AI Suggestion Workflow**: Review, accept, edit, or reject AI-generated flashcards before saving them to a deck.

### Out of Scope

The following features are intentionally excluded from the MVP to ensure a focused and rapid initial release:

-   Learning sessions and spaced repetition algorithms (e.g., SM-2).
-   Advanced file imports (PDF, DOCX, images).
-   Sharing decks between users.
-   Integrations with external educational platforms.
-   Dedicated native mobile applications.

## Testing

This project follows a comprehensive testing strategy to ensure high quality, reliability, and maintainability.

### Testing Approach

We implement a multi-layered testing strategy:

-   **Unit Tests**: Testing isolated units of code (functions, methods, classes) in the Data and Domain layers
-   **Widget Tests**: Testing UI components in isolation
-   **Integration Tests**: Testing collaboration between different layers and external services
-   **E2E Tests**: Testing complete user scenarios from start to finish

### Testing Tools & Libraries

| Tool | Version | Purpose |
|------|---------|---------|
| [flutter_test](https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html) | Built-in | Unit and widget testing framework |
| [mocktail](https://pub.dev/packages/mocktail) | `1.0.4` | Mocking dependencies in tests |
| [integration_test](https://api.flutter.dev/flutter/integration_test/integration_test-library.html) | Built-in | E2E testing framework |

**Note**: We use `mocktail` directly instead of `bloc_test` due to version compatibility with `bloc ^9.1.0`.

### Test Coverage Goals & Current Status

-   **Overall Coverage**: ≥ 80% (Target)
-   **Data Layer**: ≥ 85% (Target)
-   **Domain Layer**: ≥ 90% (Target)
-   **Presentation Layer**: ≥ 60% (Target)

**Current Status: 147 unit tests ✅ (All passing)**

- ✅ **Auth Module**: 48 tests, ~95% coverage
  - AuthRemoteDataSource: 15 tests
  - AuthRepositoryImpl: 13 tests
  - AuthCubit: 20 tests
- ✅ **Decks Module**: 33 tests, ~90% coverage
  - DecksRepositoryImpl: 14 tests
  - DecksCubit: 19 tests
- ✅ **Flashcard Module**: 66 tests, ~90% coverage
  - FlashcardRepositoryImpl: 21 tests
  - AIGenerationRepositoryImpl: 13 tests
  - FlashcardCubit: 17 tests
  - AIGenerationCubit: 15 tests

### Running Tests

```sh
# Run all tests
flutter test

# Run tests with coverage report
flutter test --coverage

# Generate HTML coverage report
genhtml coverage/lcov.info -o coverage/html

# Run specific test file
flutter test test/features/auth/auth_cubit_test.dart

# Run integration tests
flutter drive --target=test_driver/app.dart
```

### Test Structure

Tests are organized following the same feature-first structure as the main codebase:

```
test/
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── data_sources/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   └── presentation/
│   │       └── bloc/
│   ├── decks/
│   └── flashcard/
└── widget_test.dart
```

### What We Test

#### Unit Tests
-   **Cubits/Blocs**: State management logic (AuthCubit, DecksCubit, FlashcardCubit, AiGenerationCubit)
-   **Repositories**: Domain layer operations and error handling
-   **Data Sources**: API communication with Supabase and OpenRouter
-   **Models**: JSON serialization/deserialization

#### Widget Tests
-   **Forms**: Login, Register, Add/Edit Flashcard, Create/Edit Deck
-   **List Components**: DeckCard, FlashcardCard, DecksListWidget
-   **State Views**: Empty states, error views, loading indicators
-   **Dialogs**: AI generation dialog, confirmation dialogs

#### Integration Tests
-   **Authentication Flows**: Registration → Login → Access to protected routes
-   **CRUD Flows**: Create deck → Add flashcards → Edit → Delete
-   **AI Generation Flow**: Input text → Generate → Review suggestions → Accept → Save
-   **Database Integration**: RLS policies, triggers, cascading deletes

#### E2E Tests
-   Complete user journeys from registration to flashcard creation
-   AI-powered flashcard generation workflow
-   Deck and flashcard management scenarios
-   Cross-browser compatibility (Chrome, Firefox, Safari, Edge)

### Continuous Integration

Tests are automatically run on every commit and pull request via GitHub Actions:

-   ✅ Code analysis (`flutter analyze`)
-   ✅ Unit tests
-   ✅ Widget tests
-   ✅ Integration tests
-   ✅ Coverage report generation
-   ✅ Upload to Codecov

### Test Environment

For local testing, we use:
-   **Supabase Local**: Docker-based local instance for database testing
-   **Mock Servers**: Mock OpenRouter API for AI generation tests
-   **Test Data**: Predefined test users, decks, and flashcards

**Documentation:**
- [Test Plan](.ai/ai-test-plan.md) - Comprehensive testing strategy and scenarios
- [Unit Tests Summary](.ai/unit-tests-summary.md) - Complete unit tests implementation (147 tests ✅)

## Project Status

**Current Status**: In Development

This project is currently under active development. The primary focus is on implementing the core features defined for the MVP.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
