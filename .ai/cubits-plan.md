# Dokumentacja Techniczna Cubitów

Ten dokument zawiera techniczną specyfikację Cubitów używanych w aplikacji. Każdy Cubit jest odpowiedzialny za zarządzanie stanem określonego fragmentu interfejsu użytkownika i logiki biznesowej.

## Spis Treści
1.  [AuthCubit](#authcubit)
2.  [DecksCubit](#deckscubit)
3.  [AiGenerationCubit](#aigenerationcubit)
4.  [FlashcardCubit](#flashcardcubit)

---

## 1. AuthCubit

-   **Ścieżka**: `lib/features/auth/presentation/bloc/auth_cubit.dart`
-   **Odpowiedzialność**: Zarządza stanem uwierzytelniania użytkownika, w tym logowaniem, rejestracją, wylogowywaniem oraz sprawdzaniem bieżącego statusu sesji.

### Zależności

-   `IAuthRepository`: Repozytorium odpowiedzialne za komunikację z zewnętrznym serwisem uwierzytelniającym.

### Metody

-   `Future<void> checkAuthStatus()`
    -   **Opis**: Sprawdza, czy użytkownik jest aktualnie zalogowany.
    -   **Emituje**: `AuthState.authenticated` w przypadku aktywnej sesji (z danymi użytkownika) lub `AuthState.unauthenticated`, jeśli użytkownik nie jest zalogowany. W przypadku błędu emituje `AuthState.error`.

-   `Future<void> login(String email, String password)`
    -   **Opis**: Przeprowadza proces logowania użytkownika przy użyciu emaila i hasła.
    -   **Parametry**:
        -   `email`: Adres email użytkownika.
        -   `password`: Hasło użytkownika.
    -   **Emituje**: `AuthState.authenticated` po pomyślnym zalogowaniu. W przypadku błędu emituje `AuthState.error`.

-   `Future<void> register(String email, String password)`
    -   **Opis**: Rejestruje nowego użytkownika.
    -   **Parametry**:
        -   `email`: Adres email do rejestracji.
        -   `password`: Hasło dla nowego konta.
    -   **Emituje**: `AuthState.authenticated` po pomyślnej rejestracji i zalogowaniu. W przypadku błędu emituje `AuthState.error`.

-   `Future<void> logout()`
    -   **Opis**: Wylogowuje bieżącego użytkownika.
    -   **Emituje**: `AuthState.unauthenticated` po pomyślnym wylogowaniu. W przypadku błędu emituje `AuthState.error`.

### Stany (`AuthState`)

-   `initial()`: Stan początkowy, przed podjęciem jakiejkolwiek akcji.
-   `loading()`: Stan ładowania, wskazuje na trwającą operację asynchroniczną.
-   `authenticated({required User user})`: Stan informujący, że użytkownik jest zalogowany. Przechowuje obiekt `User`.
-   `unauthenticated()`: Stan informujący, że użytkownik nie jest zalogowany.
-   `error({required Failure failure})`: Stan błędu, przechowuje obiekt `Failure` z informacją o błędzie.

---

## 2. DecksCubit

-   **Ścieżka**: `lib/features/decks/presentation/bloc/decks_cubit.dart`
-   **Odpowiedzialność**: Zarządza taliami fiszek (decks), w tym ich pobieraniem, tworzeniem, aktualizacją i usuwaniem.

### Zależności

-   `IDecksRepository`: Repozytorium do zarządzania danymi talii.

### Metody

-   `Future<void> getDecks()`
    -   **Opis**: Pobiera listę wszystkich talii należących do użytkownika.
    -   **Emituje**: `DecksState.loaded` z listą obiektów `DeckModel` lub `DecksState.error` w przypadku niepowodzenia.

-   `Future<void> createDeck(String name)`
    -   **Opis**: Tworzy nową talię. Po pomyślnym utworzeniu odświeża listę talii.
    -   **Parametry**:
        -   `name`: Nazwa nowej talii.
    -   **Emituje**: Stan `loading`, a następnie wywołuje `getDecks()`.

-   `Future<void> updateDeck(int deckId, String newName)`
    -   **Opis**: Aktualizuje nazwę istniejącej talii. Po pomyślnej aktualizacji odświeża listę talii.
    -   **Parametry**:
        -   `deckId`: ID talii do zaktualizowania.
        -   `newName`: Nowa nazwa dla talii.
    -   **Emituje**: Stan `loading`, a następnie wywołuje `getDecks()`.

-   `Future<void> deleteDeck(int deckId)`
    -   **Opis**: Usuwa talię. Po pomyślnym usunięciu odświeża listę talii.
    -   **Parametry**:
        -   `deckId`: ID talii do usunięcia.
    -   **Emituje**: Stan `loading`, a następnie wywołuje `getDecks()`.

### Stany (`DecksState`)

-   `initial()`: Stan początkowy.
-   `loading()`: Stan ładowania.
-   `loaded({required List<DeckModel> decks})`: Stan pomyślnego załadowania danych, przechowuje listę talii.
-   `error({required Failure failure})`: Stan błędu.

---

## 3. AiGenerationCubit

-   **Ścieżka**: `lib/features/flashcard/presentation/bloc/ai_generation_cubit.dart`
-   **Odpowiedzialność**: Zarządza procesem generowania kandydatów na fiszki na podstawie dostarczonego tekstu przy użyciu serwisu AI.

### Zależności

-   `IAIGenerationRepository`: Repozytorium do komunikacji z serwisem AI generującym fiszki.

### Metody

-   `Future<void> generateFlashcards(String text)`
    -   **Opis**: Wysyła tekst do serwisu AI w celu wygenerowania propozycji fiszek.
    -   **Parametry**:
        -   `text`: Tekst źródłowy do generowania fiszek.
    -   **Emituje**: `AiGenerationState.loaded` z listą obiektów `FlashcardCandidateModel` lub `AiGenerationState.error` w przypadku błędu.

### Stany (`AiGenerationState`)

-   `initial()`: Stan początkowy.
-   `loading()`: Stan ładowania.
-   `loaded({required List<FlashcardCandidateModel> candidates})`: Stan pomyślnego wygenerowania kandydatów, przechowuje listę propozycji fiszek.
-   `error({required Failure failure})`: Stan błędu.

---

## 4. FlashcardCubit

-   **Ścieżka**: `lib/features/flashcard/presentation/bloc/flashcard_cubit.dart`
-   **Odpowiedzialność**: Zarządza fiszkami w obrębie konkretnej talii, w tym ich pobieraniem, tworzeniem, aktualizacją i usuwaniem.

### Zależności

-   `IFlashcardRepository`: Repozytorium do zarządzania danymi fiszek.

### Metody

-   `Future<void> getFlashcards(int deckId)`
    -   **Opis**: Pobiera listę fiszek dla określonej talii.
    -   **Parametry**:
        -   `deckId`: ID talii, z której mają zostać pobrane fiszki.
    -   **Emituje**: `FlashcardState.loaded` z listą obiektów `FlashcardModel` lub `FlashcardState.error` w przypadku błędu.

-   `Future<void> createFlashcard({required int deckId, required String front, required String back, bool isAiGenerated = false})`
    -   **Opis**: Tworzy nową fiszkę w talii. Po pomyślnym utworzeniu odświeża listę fiszek.
    -   **Parametry**:
        -   `deckId`: ID talii.
        -   `front`: Awers fiszki.
        -   `back`: Rewers fiszki.
        -   `isAiGenerated`: Flaga określająca, czy fiszka została wygenerowana przez AI.
    -   **Emituje**: Stan `loading`, a następnie wywołuje `getFlashcards(deckId)`.

-   `Future<void> updateFlashcard({required int deckId, required int flashcardId, required String newFront, required String newBack})`
    -   **Opis**: Aktualizuje istniejącą fiszkę. Po pomyślnej aktualizacji odświeża listę fiszek.
    -   **Parametry**:
        -   `deckId`: ID talii (potrzebne do odświeżenia).
        -   `flashcardId`: ID fiszki do aktualizacji.
        -   `newFront`: Nowa treść awersu.
        -   `newBack`: Nowa treść rewersu.
    -   **Emituje**: Stan `loading`, a następnie wywołuje `getFlashcards(deckId)`.

-   `Future<void> deleteFlashcard(int deckId, int flashcardId)`
    -   **Opis**: Usuwa fiszkę. Po pomyślnym usunięciu odświeża listę fiszek.
    -   **Parametry**:
        -   `deckId`: ID talii (potrzebne do odświeżenia).
        -   `flashcardId`: ID fiszki do usunięcia.
    -   **Emituje**: Stan `loading`, a następnie wywołuje `getFlashcards(deckId)`.

### Stany (`FlashcardState`)

-   `initial()`: Stan początkowy.
-   `loading()`: Stan ładowania.
-   `loaded({required List<FlashcardModel> flashcards})`: Stan pomyślnego załadowania danych, przechowuje listę fiszek.
-   `error({required Failure failure})`: Stan błędu.
