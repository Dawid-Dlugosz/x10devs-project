# Plan implementacji widoku: Rejestracja

## 1. Przegląd
Widok Rejestracji umożliwia nowym użytkownikom utworzenie konta w aplikacji przy użyciu adresu e-mail i hasła. Po pomyślnej walidacji i utworzeniu konta, użytkownik jest automatycznie logowany i przekierowywany do głównego panelu aplikacji. Widok ten jest kluczowym elementem przepływu uwierzytelniania i musi zapewniać jasne komunikaty zwrotne, zwłaszcza w przypadku błędów.

## 2. Routing widoku
Widok będzie dostępny pod następującą ścieżką:
- **/register**

## 3. Struktura komponentów
Hierarchia komponentów widoku zostanie zorganizowana w następujący sposób, aby zapewnić separację odpowiedzialności i reużywalność:

```
RegisterPage
└── BlocListener<AuthCubit, AuthState>
    └── Scaffold
        └── RegisterForm
            ├── EmailInput (TextFormField)
            ├── PasswordInput (TextFormField)
            └── SubmitButton (ElevatedButton)
```

## 4. Szczegóły komponentów

### `RegisterPage`
- **Opis komponentu:** Główny widok (strona), który zawiera całą logikę rejestracji. Jest odpowiedzialny za dostarczenie `AuthCubit` do drzewa komponentów oraz nasłuchiwanie na zmiany stanu w celu obsługi efektów ubocznych (nawigacja, wyświetlanie błędów).
- **Główne elementy:** `Scaffold`, `BlocProvider`, `BlocListener`, `RegisterForm`.
- **Obsługiwane interakcje:** Brak bezpośrednich interakcji; deleguje je do `RegisterForm`.
- **Propsy:** Brak.

### `RegisterForm`
- **Opis komponentu:** Komponent stanowy (`StatefulWidget`) zawierający formularz z polami do wprowadzenia danych rejestracyjnych. Zarządza stanem formularza, w tym walidacją i obsługą zdarzenia wysłania.
- **Główne elementy:** `Form` z `GlobalKey<FormState>`, `EmailInput`, `PasswordInput` `ConfirmPassword`, `SubmitButton`.
- **Obsługiwane interakcje:**
  - `onSubmit`: Po naciśnięciu `SubmitButton`, formularz jest walidowany. Jeśli dane są poprawne, wywoływana jest metoda `register` z `AuthCubit`.
- **Obsługiwana walidacja:** Uruchamia walidację dla wszystkich pól formularza.
- **Propsy:** Brak.

### `EmailInput`
- **Opis komponentu:** Pole tekstowe (`TextFormField`) do wprowadzania adresu e-mail.
- **Obsługiwane interakcje:** Wprowadzanie tekstu przez użytkownika.
- **Obsługiwana walidacja:**
  - Pole nie może być puste.
  - Wartość musi być poprawnym formatem adresu e-mail (np. `user@domain.com`).
- **Propsy:**
  - `controller`: `TextEditingController` do zarządzania wartością pola.
  - `validator`: `FormFieldValidator<String>` do logiki walidacyjnej.

### `PasswordInput`
- **Opis komponentu:** Pole tekstowe (`TextFormField`) do wprowadzania hasła, z ukrytą treścią.
- **Obsługiwane interakcje:** Wprowadzanie tekstu przez użytkownika.
- **Obsługiwana walidacja:**
  - Pole nie może być puste.
  - Hasło musi mieć co najmniej 8 znaków długości.
- **Propsy:**
  - `controller`: `TextEditingController` do zarządzania wartością pola.
  - `validator`: `FormFieldValidator<String>` do logiki walidacyjnej.

### `ConfirmPasswordInput`
- **Opis komponentu:** Pole tekstowe (`TextFormField`) do wprowadzania hasła, z ukrytą treścią.
- **Obsługiwane interakcje:** Wprowadzanie tekstu przez użytkownika.
- **Obsługiwana walidacja:**
  - Musi być takie samo jak pole `PasswordInput`
- **Propsy:**
  - `controller`: `TextEditingController` do zarządzania wartością pola.
  - `validator`: `FormFieldValidator<String>` do logiki walidacyjnej.

### `SubmitButton`
- **Opis komponentu:** Przycisk (`ElevatedButton` lub odpowiednik z `shadcn_flutter`) inicjujący proces rejestracji.
- **Główne elementy:** Wyświetla tekst "Zarejestruj się" lub wskaźnik ładowania.
- **Obsługiwane interakcje:** `onPressed` wywołuje funkcję `onSubmit` w `RegisterForm`.
- **Warunki:** Przycisk jest nieaktywny (`disabled`), jeśli formularz jest niepoprawny lub gdy trwa proces rejestracji (`AuthState` jest w stanie `loading`).
- **Propsy:**
  - `onPressed`: `VoidCallback`.
  - `isLoading`: `bool`.

## 5. Typy
Nie przewiduje się tworzenia nowych typów ani modeli dla tego widoku. Będziemy operować na istniejących typach:
- `String` dla wartości pól email i hasło.
- `User` (z Supabase) jako część `AuthState.authenticated`.
- `Failure` jako część `AuthState.error`.

## 6. Zarządzanie stanem
Zarządzanie stanem będzie realizowane na dwóch poziomach:
1.  **Stan lokalny komponentu (`RegisterForm`):**
    -   `GlobalKey<FormState>` do zarządzania walidacją i stanem formularza.
    -   `TextEditingController` dla każdego pola do odczytu wartości.
    -   Lokalna zmienna `bool` do śledzenia postępu walidacji w celu włączania/wyłączania przycisku.
2.  **Stan globalny/funkcji (`AuthCubit`):**
    -   `AuthCubit` będzie zarządzał stanem procesu uwierzytelniania.
    -   Widok będzie reagował na emitowane stany: `loading`, `authenticated`, `unauthenticated`, `error`.

## 7. Integracja cubitów
Integracja z `AuthCubit` jest kluczowa i odbędzie się w następujący sposób:
-   **Dostarczenie Cubita:** `RegisterPage` zostanie owinięty w `BlocProvider`, aby udostępnić instancję `AuthCubit` w drzewie komponentów.
-   **Wywołanie akcji:** W `RegisterForm`, po pomyślnej walidacji, zostanie wywołana metoda:
    ```dart
    context.read<AuthCubit>().register(email, password);
    ```
-   **Reakcja na stany:**
    -   **Żądanie:** `register(email: String, password: String)`
    -   **Odpowiedź (Stany):**
        -   `AuthState.loading()`: Wyświetla wskaźnik ładowania na `SubmitButton` i blokuje formularz.
        -   `AuthState.authenticated({required User user})`: `BlocListener` przechwytuje ten stan i nawiguje użytkownika do panelu głównego (np. `/decks`) używając `go_router`.
        -   `AuthState.error({required Failure failure})`: `BlocListener` przechwytuje ten stan i wyświetla `SnackBar` z komunikatem błędu pobranym z obiektu `failure`.

## 8. Interakcje użytkownika
1.  **Wprowadzanie danych:** Użytkownik wpisuje swój e-mail i hasło w odpowiednie pola. Walidacja odbywa się po interakcji (`AutovalidateMode.onUserInteraction`).
2.  **Próba wysłania (niepoprawne dane):** Użytkownik klika przycisk "Zarejestruj się". Komunikaty o błędach walidacji pojawiają się pod polami. Akcja rejestracji nie jest wywoływana.
3.  **Próba wysłania (poprawne dane):** Użytkownik klika przycisk "Zarejestruj się".
    -   Przycisk przechodzi w stan ładowania.
    -   Formularz zostaje zablokowany.
    -   Wywoływana jest metoda `authCubit.register()`.
4.  **Zakończenie operacji (sukces):** Użytkownik zostaje przekierowany na nową stronę.
5.  **Zakończenie operacji (błąd):** Pojawia się `SnackBar` z komunikatem błędu, a formularz ponownie staje się aktywny.

## 9. Warunki i walidacja
-   **Email:** Musi być niepusty i zgodny z formatem email.
-   **Hasło:** Musi być niepuste i mieć co najmniej 8 znaków.
-   **Przycisk `SubmitButton`:** Jest aktywny tylko wtedy, gdy oba pola formularza przejdą walidację i stan `AuthCubit` nie jest `loading`.

## 10. Obsługa błędów
-   **Błędy walidacji (po stronie klienta):** Obsługiwane przez `validator` w `TextFormField` i wyświetlane bezpośrednio pod polami.
-   **Błędy serwera/sieci (z Cubita):**
    -   `BlocListener` nasłuchuje na `AuthState.error`.
    -   Po otrzymaniu stanu błędu, wyświetlany jest `SnackBar` (lub inny komponent z `shadcn_flutter`) z komunikatem dla użytkownika, np.:
        -   "Ten adres e-mail jest już zajęty."
        -   "Wystąpił błąd serwera. Spróbuj ponownie później."
        -   "Brak połączenia z internetem."
    -   Treść komunikatu jest pobierana z obiektu `Failure`.

## 11. Kroki implementacji
1.  **Utworzenie struktury plików:**
    -   `lib/features/auth/presentation/pages/register_page.dart`
    -   `lib/features/auth/presentation/widgets/register_form.dart`
2.  **Zdefiniowanie routingu:** Dodać nową trasę `/register` w konfiguracji `go_router`, która będzie wskazywać na `RegisterPage`.
3.  **Implementacja `RegisterPage`:**
    -   Stworzyć `StatelessWidget`.
    -   Dodać `Scaffold` z podstawowym layoutem.
    -   Zaimplementować `BlocProvider` dla `AuthCubit`.
    -   Dodać `BlocListener`, który będzie obsługiwał nawigację po sukcesie (`authenticated`) i wyświetlanie `SnackBar` przy błędzie (`error`).
    -   Umieścić `RegisterForm` w ciele `Scaffold`.
4.  **Implementacja `RegisterForm`:**
    -   Stworzyć `StatefulWidget`.
    -   Dodać `Form` z `GlobalKey`.
    -   Dodać `TextEditingController` dla obu pól.
    -   Zaimplementować pola `EmailInput` i `PasswordInput` jako `TextFormField` z odpowiednimi walidatorami.
    -   Dodać `SubmitButton`, którego stan `onPressed` zależy od stanu `AuthCubit` (`loading`) i walidacji formularza.
    -   Zaimplementować logikę `onSubmit`, która waliduje formularz i wywołuje `authCubit.register()`.
5.  **Stylizacja komponentów:** Użyć komponentów i stylów z biblioteki `shadcn_flutter` w celu zachowania spójności wizualnej aplikacji.
6.  **Testowanie:** Przeprowadzić manualne testy wszystkich scenariuszy, w tym poprawnej rejestracji, błędów walidacji i błędów serwera.
