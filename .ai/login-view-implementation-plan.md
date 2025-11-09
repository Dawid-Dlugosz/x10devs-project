# Plan implementacji widoku Logowania

## 1. Przegląd
Widok logowania jest kluczowym elementem aplikacji, umożliwiającym powracającym użytkownikom dostęp do ich kont. Jego głównym celem jest zapewnienie bezpiecznego i prostego procesu uwierzytelniania za pomocą adresu e-mail i hasła. Widok ten będzie interfejsem dla `AuthCubit`, obsługując stany ładowania, sukcesu (przekierowanie) i błędu (wyświetlanie komunikatów).

## 2. Routing widoku
Widok będzie dostępny pod następującą ścieżką w aplikacji, zgodnie z konfiguracją w `go_router`:
- **Ścieżka**: `/login`

## 3. Struktura komponentów
Hierarchia komponentów zostanie zorganizowana w celu oddzielenia logiki stanu od prezentacji UI.

```
LoginPage (Strona/Widok)
└── BlocListener<AuthCubit, AuthState>
    └── Scaffold
        └── Center
            └── LoginForm (Formularz)
                ├── Form
                │   ├── ShadcnInput (Email)
                │   ├── ShadcnInput (Hasło)
                │   └── ShadcnButton (Przycisk Zaloguj)
                └── Text (Link do strony rejestracji)
```

## 4. Szczegóły komponentów

### `LoginPage`
- **Opis komponentu**: Główny widget strony, odpowiedzialny za routing i dostarczenie `AuthCubit` do drzewa widgetów (jeśli nie jest zapewniony wyżej). Wykorzystuje `BlocListener` do reagowania na zmiany stanu uwierzytelniania, takie jak pomyślne zalogowanie (nawigacja) lub błąd (wyświetlenie powiadomienia).
- **Główne elementy**: `Scaffold`, `BlocListener`, `LoginForm`.
- **Obsługiwane interakcje**: Brak bezpośrednich interakcji z użytkownikiem. Komponent nasłuchuje na zmiany stanu z `AuthCubit`.
- **Obsługiwana walidacja**: Brak.
- **Propsy**: Brak.

### `LoginForm`
- **Opis komponentu**: `StatefulWidget` zawierający logikę formularza logowania. Zarządza kontrolerami `TextEditingController`, kluczem `GlobalKey<FormState>` oraz lokalnym stanem UI (np. widoczność hasła).
- **Główne elementy**: `Form`, `ShadcnInput` dla e-maila i hasła, `ShadcnButton` do wysłania formularza.
- **Obsługiwane interakcje**:
    - Wprowadzanie tekstu w polach e-mail i hasło.
    - Przesłanie formularza za pomocą przycisku "Zaloguj".
    - Przełączanie widoczności hasła.
- **Obsługiwana walidacja**:
    - **Email**:
        - Pole nie może być puste.
        - Musi mieć format prawidłowego adresu e-mail.
    - **Hasło**:
        - Pole nie może być puste.
        - Musi mieć co najmniej 8 znaków.
- **Propsy**:
    - `isLoading` (typ: `bool`): Informuje, czy trwa proces logowania. Gdy `true`, formularz powinien być zablokowany, a na przycisku powinien pojawić się wskaźnik ładowania.

## 5. Typy
Implementacja widoku nie wymaga tworzenia nowych, niestandardowych typów danych. Będzie operować na istniejących typach:
- `String` dla wartości pól e-mail i hasło.
- `AuthState` z `features/auth/presentation/bloc/auth_state.dart` do reprezentowania stanu uwierzytelniania.
- `Failure` z `core/errors/failure.dart` do obsługi informacji o błędach.

## 6. Zarządzanie stanem
- **Stan globalny**: Zarządzany przez `AuthCubit`. Komponent `LoginPage` będzie nasłuchiwał na zmiany `AuthState` w celu obsługi nawigacji i wyświetlania globalnych błędów.
- **Stan lokalny**: Zarządzany wewnątrz `LoginForm`. Obejmuje:
    - `_formKey = GlobalKey<FormState>()`: Do walidacji i zarządzania stanem formularza.
    - `_emailController = TextEditingController()`: Do odczytu wartości z pola e-mail.
    - `_passwordController = TextEditingController()`: Do odczytu wartości z pola hasła.
    - `_isObscure = true`: Do przełączania widoczności hasła.
    - `_autovalidateMode = AutovalidateMode.disabled`: Do kontrolowania, kiedy mają się pojawiać błędy walidacji.

Nie ma potrzeby tworzenia customowego hooka; standardowe mechanizmy `StatefulWidget` i `bloc` są wystarczające.

## 7. Integracja cubitów
Integracja z `AuthCubit` będzie realizowana w dwóch miejscach:
1.  **Wywołanie akcji**: W `LoginForm`, po pomyślnej walidacji formularza, zostanie wywołana metoda `login` z `AuthCubit`.
    - `context.read<AuthCubit>().login(email, password);`
    - **Typ żądania**: `login(String email, String password)`

2.  **Reakcja na stan**: W `LoginPage`, `BlocListener` będzie obserwował `AuthState`.
    - **Typ odpowiedzi**: `AuthState` (union type: `initial`, `loading`, `authenticated`, `unauthenticated`, `error`).

## 8. Interakcje użytkownika
- **Wprowadzanie danych**: Użytkownik wpisuje e-mail i hasło w odpowiednie pola `ShadcnInput`.
- **Przesłanie formularza**: Użytkownik klika przycisk "Zaloguj".
    - **Wynik**: Aplikacja uruchamia walidację. Jeśli jest poprawna, wywołuje `AuthCubit.login()` i przechodzi w stan ładowania. Jeśli walidacja się nie powiedzie, pod polami pojawiają się komunikaty o błędach.
- **Nawigacja do rejestracji**: Użytkownik klika link tekstowy, który przenosi go na ścieżkę `/register`.

## 9. Warunki i walidacja
- **Warunek 1: Pole e-mail nie jest puste.**
    - **Komponent**: `ShadcnInput` (Email)
    - **Wpływ**: Blokuje przesłanie formularza i wyświetla komunikat "Pole e-mail jest wymagane".
- **Warunek 2: E-mail ma poprawny format.**
    - **Komponent**: `ShadcnInput` (Email)
    - **Wpływ**: Blokuje przesłanie formularza i wyświetla komunikat "Wprowadź poprawny adres e-mail".
- **Warunek 3: Pole hasło nie jest puste.**
    - **Komponent**: `ShadcnInput` (Hasło)
    - **Wpływ**: Blokuje przesłanie formularza i wyświetla komunikat "Pole hasło jest wymagane".
- **Warunek 4: Hasło ma co najmniej 8 znaków.**
    - **Komponent**: `ShadcnInput` (Hasło)
    - **Wpływ**: Blokuje przesłanie formularza i wyświetla komunikat "Hasło musi mieć co najmniej 8 znaków".

## 10. Obsługa błędów
- **Błędy walidacji**: Obsługiwane lokalnie przez `Form` i jego `validator`. Komunikaty wyświetlane są bezpośrednio pod polami formularza.
- **Błędy logowania (API)**: Obsługiwane centralnie przez `BlocListener` w `LoginPage`.
    - Gdy `AuthCubit` emituje `AuthState.error`, `BlocListener` przechwytuje ten stan.
    - Na ekranie wyświetlany jest `SnackBar`  z komunikatem błędu, np. "Nieprawidłowe dane logowania" lub "Błąd serwera. Spróbuj ponownie później". Wiadomość powinna być wyodrębniona z obiektu `Failure`.

## 11. Kroki implementacji
1.  **Struktura plików**: Utwórz plik `lib/features/auth/presentation/pages/login_page.dart` oraz `lib/features/auth/presentation/widgets/login_form.dart`.
2.  **Routing**: Zarejestruj nową ścieżkę `/login` w konfiguracji `go_router`, wskazując na `LoginPage`.
3.  **Implementacja `LoginPage`**: Zbuduj główny widget strony, dodaj `Scaffold` oraz `BlocListener` nasłuchujący na `AuthCubit`. W ciele `Scaffold` umieść `LoginForm`.
4.  **Implementacja `LoginForm`**: Stwórz `StatefulWidget` z `GlobalKey<FormState>`, kontrolerami i logiką walidacji dla pól e-mail i hasła, używając komponentów `ShadcnInput` i `ShadcnButton`.
5.  **Zarządzanie stanem ładowania**: Przekaż stan `isLoading` z `BlocBuilder` lub `BlocSelector` w `LoginPage` jako prop do `LoginForm`, aby zablokować przycisk podczas operacji asynchronicznej.
6.  **Obsługa logowania**: W `LoginForm`, w metodzie `onPressed` przycisku, dodaj logikę walidacji formularza. Jeśli jest poprawny, wywołaj `context.read<AuthCubit>().login()`.
7.  **Obsługa wyników z Cubita**: W `BlocListener` w `LoginPage` zaimplementuj logikę:
    - Dla stanu `AuthState.authenticated`: nawiguj do strony głównej (np. `context.go('/decks')`).
    - Dla stanu `AuthState.error`: wyświetl `SnackBar` z odpowiednim komunikatem błędu.
8.  **Finalizacja UI**: Dodaj link do strony rejestracji i dopracuj wygląd widoku, aby był zgodny z resztą aplikacji.
