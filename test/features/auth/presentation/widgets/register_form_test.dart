import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:x10devs/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:x10devs/features/auth/presentation/bloc/auth_state.dart'
    as app_auth;
import 'package:x10devs/features/auth/presentation/widgets/register_form.dart';

class MockAuthCubit extends Mock implements AuthCubit {}

void main() {
  late MockAuthCubit mockAuthCubit;
  late StreamController<app_auth.AuthState> stateController;

  setUp(() {
    mockAuthCubit = MockAuthCubit();
    stateController = StreamController<app_auth.AuthState>.broadcast();

    when(
      () => mockAuthCubit.state,
    ).thenReturn(const app_auth.AuthState.initial());
    when(() => mockAuthCubit.stream).thenAnswer((_) => stateController.stream);
    when(
      () => mockAuthCubit.close(),
    ).thenAnswer((_) async => stateController.close());
    when(() => mockAuthCubit.login(any(), any())).thenAnswer((_) async {});
    when(() => mockAuthCubit.register(any(), any())).thenAnswer((_) async {});
  });

  tearDown(() {
    stateController.close();
  });

  Widget createWidgetUnderTest() {
    return ShadApp(
      home: Scaffold(
        body: BlocProvider<AuthCubit>.value(
          value: mockAuthCubit,
          child: const RegisterForm(),
        ),
      ),
    );
  }

  group('RegisterForm Widget Tests', () {
    testWidgets('should render all form fields and buttons', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.text('Stwórz konto'), findsOneWidget);
      expect(find.byType(ShadInputFormField), findsNWidgets(3));
      expect(find.text('Zarejestruj się'), findsOneWidget);
      expect(find.text('Masz już konto? Zaloguj się'), findsOneWidget);
    });

    testWidgets('should show validation error when email is empty', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest());

      // Act - Tap register button without filling fields
      final registerButton = find.text('Zarejestruj się');
      await tester.tap(registerButton);
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Pole e-mail jest wymagane'), findsOneWidget);
    });

    testWidgets('should show validation error when email format is invalid', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest());

      // Act - Enter invalid email
      final emailField = find.byType(ShadInputFormField).first;
      await tester.enterText(emailField, 'invalid-email');

      // Tap register button to trigger validation
      final registerButton = find.text('Zarejestruj się');
      await tester.tap(registerButton);
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Wprowadź poprawny adres e-mail'), findsOneWidget);
    });

    testWidgets('should show validation error when password is empty', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest());

      // Act - Enter valid email but no password
      final emailField = find.byType(ShadInputFormField).first;
      await tester.enterText(emailField, 'test@example.com');

      // Tap register button to trigger validation
      final registerButton = find.text('Zarejestruj się');
      await tester.tap(registerButton);
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Pole hasło jest wymagane'), findsOneWidget);
    });

    testWidgets('should show validation error when password is too short', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest());

      // Act - Enter valid email and short password
      final emailField = find.byType(ShadInputFormField).first;
      final passwordField = find.byType(ShadInputFormField).at(1);

      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'short');

      // Tap register button to trigger validation
      final registerButton = find.text('Zarejestruj się');
      await tester.tap(registerButton);
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Hasło musi mieć co najmniej 8 znaków'), findsOneWidget);
    });

    testWidgets('should show validation error when confirm password is empty', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest());

      // Act - Enter email and password but no confirm password
      final emailField = find.byType(ShadInputFormField).first;
      final passwordField = find.byType(ShadInputFormField).at(1);

      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'password123');

      // Tap register button to trigger validation
      final registerButton = find.text('Zarejestruj się');
      await tester.tap(registerButton);
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Proszę potwierdzić hasło'), findsOneWidget);
    });

    testWidgets('should show validation error when passwords do not match', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest());

      // Act - Enter mismatched passwords
      final emailField = find.byType(ShadInputFormField).first;
      final passwordField = find.byType(ShadInputFormField).at(1);
      final confirmPasswordField = find.byType(ShadInputFormField).at(2);

      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'password123');
      await tester.enterText(confirmPasswordField, 'different123');

      // Tap register button to trigger validation
      final registerButton = find.text('Zarejestruj się');
      await tester.tap(registerButton);
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Hasła nie są zgodne'), findsOneWidget);
    });

    testWidgets('should call register when form is valid', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest());

      // Act - Enter valid credentials
      final emailField = find.byType(ShadInputFormField).first;
      final passwordField = find.byType(ShadInputFormField).at(1);
      final confirmPasswordField = find.byType(ShadInputFormField).at(2);

      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'password123');
      await tester.enterText(confirmPasswordField, 'password123');

      // Tap register button
      final registerButton = find.text('Zarejestruj się');
      await tester.tap(registerButton);
      await tester.pumpAndSettle();

      // Assert
      verify(
        () => mockAuthCubit.register('test@example.com', 'password123'),
      ).called(1);
    });

    testWidgets('should have password visibility toggle buttons', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert - Should have two visibility toggle buttons (password and confirm)
      expect(find.byIcon(Icons.visibility_off_outlined), findsNWidgets(2));

      // Act - Tap first visibility toggle button (password)
      final visibilityButtons = find.byIcon(Icons.visibility_off_outlined);
      await tester.tap(visibilityButtons.first);
      await tester.pumpAndSettle();

      // Assert - Should have one visibility on and one visibility off
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    });

    testWidgets('should toggle confirm password visibility independently', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest());

      // Act - Tap second visibility toggle button (confirm password)
      final visibilityButtons = find.byIcon(Icons.visibility_off_outlined);
      await tester.tap(visibilityButtons.last);
      await tester.pumpAndSettle();

      // Assert - Should have one visibility on and one visibility off
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    });

    testWidgets('should disable register button when loading', (
      WidgetTester tester,
    ) async {
      // Arrange - Set loading state
      when(
        () => mockAuthCubit.state,
      ).thenReturn(const app_auth.AuthState.loading());
      stateController.add(const app_auth.AuthState.loading());

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Assert - Button should show loading state
      expect(find.text('Tworzenie konta...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Find the button
      final registerButton = find.ancestor(
        of: find.text('Tworzenie konta...'),
        matching: find.byType(ShadButton),
      );

      final buttonWidget = tester.widget<ShadButton>(registerButton);
      expect(buttonWidget.onPressed, isNull);
    });

    testWidgets('should accept password with exactly 8 characters', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest());

      // Act - Enter password with exactly 8 characters
      final emailField = find.byType(ShadInputFormField).first;
      final passwordField = find.byType(ShadInputFormField).at(1);
      final confirmPasswordField = find.byType(ShadInputFormField).at(2);

      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, '12345678');
      await tester.enterText(confirmPasswordField, '12345678');

      final registerButton = find.text('Zarejestruj się');
      await tester.tap(registerButton);
      await tester.pumpAndSettle();

      // Assert - Should not show password length error
      expect(find.text('Hasło musi mieć co najmniej 8 znaków'), findsNothing);
      verify(
        () => mockAuthCubit.register('test@example.com', '12345678'),
      ).called(1);
    });

    testWidgets('should handle special characters in password', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest());

      // Act - Enter password with special characters
      final emailField = find.byType(ShadInputFormField).first;
      final passwordField = find.byType(ShadInputFormField).at(1);
      final confirmPasswordField = find.byType(ShadInputFormField).at(2);

      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'P@ssw0rd!#\$');
      await tester.enterText(confirmPasswordField, 'P@ssw0rd!#\$');

      final registerButton = find.text('Zarejestruj się');
      await tester.tap(registerButton);
      await tester.pumpAndSettle();

      // Assert
      verify(
        () => mockAuthCubit.register('test@example.com', 'P@ssw0rd!#\$'),
      ).called(1);
    });

    testWidgets('should validate confirm password matches current password', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest());

      // Act - Enter password and then change it
      final passwordField = find.byType(ShadInputFormField).at(1);
      final confirmPasswordField = find.byType(ShadInputFormField).at(2);

      await tester.enterText(passwordField, 'password123');
      await tester.enterText(confirmPasswordField, 'password123');

      // Change password after confirming
      await tester.enterText(passwordField, 'newpassword123');

      final registerButton = find.text('Zarejestruj się');
      await tester.tap(registerButton);
      await tester.pumpAndSettle();

      // Assert - Should show mismatch error
      expect(find.text('Hasła nie są zgodne'), findsOneWidget);
    });

    testWidgets('should accept valid email with dot and subdomain', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest());

      // Act
      final emailField = find.byType(ShadInputFormField).first;
      final passwordField = find.byType(ShadInputFormField).at(1);
      final confirmPasswordField = find.byType(ShadInputFormField).at(2);

      await tester.enterText(emailField, 'user.name@example.co.uk');
      await tester.enterText(passwordField, 'password123');
      await tester.enterText(confirmPasswordField, 'password123');

      final registerButton = find.text('Zarejestruj się');
      await tester.tap(registerButton);
      await tester.pumpAndSettle();

      // Assert - Should not show email validation error
      expect(find.text('Wprowadź poprawny adres e-mail'), findsNothing);
      verify(
        () => mockAuthCubit.register('user.name@example.co.uk', 'password123'),
      ).called(1);
    });

    testWidgets('should reject email with space', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest());

      // Act
      final emailField = find.byType(ShadInputFormField).first;
      await tester.enterText(emailField, 'test @example.com');

      final registerButton = find.text('Zarejestruj się');
      await tester.tap(registerButton);
      await tester.pumpAndSettle();

      // Assert - Should show email validation error
      expect(find.text('Wprowadź poprawny adres e-mail'), findsOneWidget);
    });
  });
}
