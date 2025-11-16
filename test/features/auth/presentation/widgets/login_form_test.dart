import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:x10devs/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:x10devs/features/auth/presentation/bloc/auth_state.dart'
    as app_auth;
import 'package:x10devs/features/auth/presentation/widgets/login_form.dart';

class MockAuthCubit extends Mock implements AuthCubit {}

void main() {
  late MockAuthCubit mockAuthCubit;
  late StreamController<app_auth.AuthState> stateController;

  setUp(() {
    mockAuthCubit = MockAuthCubit();
    stateController = StreamController<app_auth.AuthState>.broadcast();
    
    when(() => mockAuthCubit.state)
        .thenReturn(const app_auth.AuthState.initial());
    when(() => mockAuthCubit.stream).thenAnswer((_) => stateController.stream);
    when(() => mockAuthCubit.close()).thenAnswer((_) async => stateController.close());
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
          child: const LoginForm(),
        ),
      ),
    );
  }

  group('LoginForm Widget Tests', () {
    testWidgets('should render all form fields and buttons',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.byType(ShadInputFormField), findsNWidgets(2));
      expect(find.text('Zaloguj'), findsOneWidget);
      expect(find.text('Nie masz konta? Zarejestruj się'), findsOneWidget);
    });

    testWidgets('should show validation error when email is empty',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest());

      // Act - Find and tap login button
      final loginButton = find.text('Zaloguj');
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Pole e-mail jest wymagane'), findsOneWidget);
    });

    testWidgets('should show validation error when email format is invalid',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest());

      // Act - Enter invalid email
      final emailField = find.byType(ShadInputFormField).first;
      await tester.enterText(emailField, 'invalid-email');

      // Tap login button to trigger validation
      final loginButton = find.text('Zaloguj');
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Wprowadź poprawny adres e-mail'), findsOneWidget);
    });

    testWidgets('should show validation error when password is empty',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest());

      // Act - Enter valid email but no password
      final emailField = find.byType(ShadInputFormField).first;
      await tester.enterText(emailField, 'test@example.com');

      // Tap login button to trigger validation
      final loginButton = find.text('Zaloguj');
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Pole hasło jest wymagane'), findsOneWidget);
    });

    testWidgets('should show validation error when password is too short',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest());

      // Act - Enter valid email and short password
      final emailField = find.byType(ShadInputFormField).first;
      final passwordField = find.byType(ShadInputFormField).last;

      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'short');

      // Tap login button to trigger validation
      final loginButton = find.text('Zaloguj');
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Hasło musi mieć co najmniej 8 znaków'), findsOneWidget);
    });

    testWidgets('should call login when form is valid',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest());

      // Act - Enter valid credentials
      final emailField = find.byType(ShadInputFormField).first;
      final passwordField = find.byType(ShadInputFormField).last;

      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'password123');

      // Tap login button
      final loginButton = find.text('Zaloguj');
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Assert
      verify(() => mockAuthCubit.login('test@example.com', 'password123'))
          .called(1);
    });

    testWidgets('should have password visibility toggle button',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert - Should have visibility toggle button
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);

      // Act - Tap visibility toggle button
      final visibilityButton = find.byIcon(Icons.visibility_off);
      await tester.tap(visibilityButton);
      await tester.pumpAndSettle();

      // Assert - Icon should change to visibility on
      expect(find.byIcon(Icons.visibility), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off), findsNothing);

      // Tap again to hide
      final visibilityOnButton = find.byIcon(Icons.visibility);
      await tester.tap(visibilityOnButton);
      await tester.pumpAndSettle();

      // Assert - Icon should change back to visibility off
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
      expect(find.byIcon(Icons.visibility), findsNothing);
    });

    testWidgets('should disable login button when loading',
        (WidgetTester tester) async {
      // Arrange - Set loading state
      when(() => mockAuthCubit.state)
          .thenReturn(const app_auth.AuthState.loading());
      stateController.add(const app_auth.AuthState.loading());

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Assert - Button should show loading state
      expect(find.text('Logowanie...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Find the button
      final loginButton = find.ancestor(
        of: find.text('Logowanie...'),
        matching: find.byType(ShadButton),
      );

      final buttonWidget = tester.widget<ShadButton>(loginButton);
      expect(buttonWidget.onPressed, isNull);
    });

    testWidgets('should accept valid email with dot and plus',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest());

      // Act
      final emailField = find.byType(ShadInputFormField).first;
      final passwordField = find.byType(ShadInputFormField).last;

      await tester.enterText(emailField, 'user.name+tag@example.com');
      await tester.enterText(passwordField, 'password123');

      final loginButton = find.text('Zaloguj');
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Assert - Should not show email validation error
      expect(find.text('Wprowadź poprawny adres e-mail'), findsNothing);
      verify(() => mockAuthCubit.login('user.name+tag@example.com', 'password123'))
          .called(1);
    });

    testWidgets('should reject email without domain',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest());

      // Act
      final emailField = find.byType(ShadInputFormField).first;
      await tester.enterText(emailField, 'test@');

      final loginButton = find.text('Zaloguj');
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Assert - Should show email validation error
      expect(find.text('Wprowadź poprawny adres e-mail'), findsOneWidget);
    });

    testWidgets('should accept password with exactly 8 characters',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest());

      // Act - Enter password with exactly 8 characters
      final emailField = find.byType(ShadInputFormField).first;
      final passwordField = find.byType(ShadInputFormField).last;

      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, '12345678');

      final loginButton = find.text('Zaloguj');
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Assert - Should not show password length error
      expect(
          find.text('Hasło musi mieć co najmniej 8 znaków'), findsNothing);
      verify(() => mockAuthCubit.login('test@example.com', '12345678'))
          .called(1);
    });

    testWidgets('should handle special characters in password',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest());

      // Act - Enter password with special characters
      final emailField = find.byType(ShadInputFormField).first;
      final passwordField = find.byType(ShadInputFormField).last;

      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'P@ssw0rd!#\$');

      final loginButton = find.text('Zaloguj');
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Assert
      verify(() => mockAuthCubit.login('test@example.com', 'P@ssw0rd!#\$'))
          .called(1);
    });
  });
}

