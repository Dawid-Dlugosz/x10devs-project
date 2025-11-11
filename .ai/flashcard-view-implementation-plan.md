# Plan implementacji widoku — Lista Fiszek

## 1. Przegląd

Widok "Lista Fiszek" jest głównym interfejsem do zarządzania fiszkami w obrębie jednej talii. Umożliwia użytkownikom przeglądanie istniejących fiszek, edytowanie ich, usuwanie, a także inicjowanie procesu tworzenia nowych fiszek — zarówno ręcznie, jak i za pomocą generatora AI. Widok ten musi obsługiwać stany ładowania, błędu oraz pusty stan (brak fiszek w talii), prowadząc użytkownika do kluczowych akcji.

## 2. Routing widoku

Widok będzie dostępny pod dynamiczną ścieżką, zawierającą identyfikator talii.

- **Ścieżka**: `/decks/:deckId`
- **Przykład**: `/decks/123`

## 3. Struktura komponentów

Hierarchia komponentów (widżetów) będzie zorganizowana w sposób zapewniający czytelność i reużywalność.

```
FlashcardsPage (Główny widżet strony)
└── BlocBuilder<FlashcardCubit, FlashcardState>
    └── switch (stan)
        ├── case loading: CircularProgressIndicator
        ├── case error: WidokBłędu(failure: stan.błędu)
        ├── case loaded:
            ├── if (fiszki.sąPuste):
            │   └── WidokPustegoStanu
            │       ├── onDodajRęcznie -> pokaż AddEditFlashcardDialog
            │       └── onGenerujAI -> pokaż GenerateWithAiDialog
            └── else:
                ├── Scaffold
                │   ├── AppBar (z przyciskami "Dodaj" i "Generuj")
                │   └── FlashcardsListView(fiszki: stan.fiszki)
                │       └── ListView.builder
                │           └── FlashcardCard(fiszka: fiszka)
                │               ├── onEdytuj -> pokaż AddEditFlashcardDialog(initialData: fiszka)
                │               └── onUsuń -> pokaż ConfirmationDialog -> wywołaj cubit.deleteFlashcard
```

## 4. Szczegóły komponentów

### `FlashcardsPage`
- **Opis komponentu**: Główny, stanowy widżet strony. Odpowiedzialny za pobranie `deckId` z routera, dostarczenie `FlashcardCubit` oraz `AiGenerationCubit`, a także za reagowanie na zmiany ich stanu w celu renderowania odpowiednich widżetów podrzędnych (ładowanie, błąd, lista, pusty stan).
- **Główne elementy**: `Scaffold`, `AppBar` z tytułem (nazwa talii), `BlocBuilder` do budowania UI na podstawie stanu `FlashcardCubit`, `BlocListener` do obsługi efektów ubocznych (nawigacja, snackbary) z `AiGenerationCubit`.
- **Obsługiwane interakcje**: Inicjalizacja pobierania danych przy wejściu na widok. Otwieranie dialogów do tworzenia/generowania fiszek.
- **Typy**: Wstrzykiwane `FlashcardCubit` i `AiGenerationCubit`.
- **Propsy**: `deckId: String` (otrzymany z `go_router`).

### `FlashcardsListView`
- **Opis komponentu**: Widżet odpowiedzialny za renderowanie listy fiszek.
- **Główne elementy**: `ListView.builder` tworzący listę komponentów `FlashcardCard`.
- **Obsługiwane interakcje**: Przewijanie listy. Przekazywanie zdarzeń edycji/usunięcia w górę hierarchii.
- **Typy**: `List<FlashcardModel>`.
- **Propsy**: `flashcards: List<FlashcardModel>`.

### `FlashcardCard`
- **Opis komponentu**: Reprezentuje pojedynczą fiszkę na liście. Wyświetla jej przód i tył.
- **Główne elementy**: `Card`, `Text` dla treści, `PopupMenuButton` (lub podobny) z opcjami "Edytuj" i "Usuń".
- **Obsługiwane interakcje**: Kliknięcie opcji "Edytuj", kliknięcie opcji "Usuń".
- **Typy**: `FlashcardModel`.
- **Propsy**: `flashcard: FlashcardModel`.

### `AddEditFlashcardDialog`
- **Opis komponentu**: Okno dialogowe służące do ręcznego dodawania nowej fiszki lub edycji istniejącej.
- **Główne elementy**: `AlertDialog`, `Form`, dwa `TextFormField` ("Przód", "Tył"), przycisk "Zapisz".
- **Obsługiwane interakcje**: Wprowadzanie tekstu, walidacja formularza, zapis.
- **Warunki walidacji**:
    - Pole "Przód": Wymagane, maksymalnie 200 znaków.
    - Pole "Tył": Wymagane, maksymalnie 500 znaków.
    - Przycisk "Zapisz" jest nieaktywny, dopóki formularz nie jest poprawny.
- **Propsy**: `initialData: FlashcardModel?` (opcjonalny, przekazywany podczas edycji).

### `GenerateWithAiDialog`
- **Opis komponentu**: Okno dialogowe do wklejania tekstu, z którego AI wygeneruje fiszki.
- **Główne elementy**: `AlertDialog`, wieloliniowy `TextFormField`, przycisk "Generuj".
- **Obsługiwane interakcje**: Wklejanie/wprowadzanie tekstu, uruchomienie generowania.
- **Warunki walidacji**:
    - Pole tekstowe: Wymagane, maksymalnie 10 000 znaków.
- **Propsy**: Brak.

## 5. Typy
Na potrzeby widoku, kluczowe będą istniejące modele z warstwy danych:

- **`FlashcardModel`**:
  ```dart
  // Zakładając istnienie tego modelu
  class FlashcardModel {
    final int id;
    final String front;
    final String back;
    final int deckId;
  }
  ```
- **`FlashcardCandidateModel`**: (używany przez `AiGenerationCubit`)
  ```dart
  // Zakładając istnienie tego modelu
  class FlashcardCandidateModel {
    final String front;
    final String back;
  }
  ```

## 6. Zarządzanie stanem

Stan widoku jest zarządzany przez dwa Cubity dostarczane przez `get_it` i `BlocProvider`.

- **`FlashcardCubit`**: Główny Cubit dla tego widoku. Przechowuje stan listy fiszek (`loading`, `loaded`, `error`). Wszystkie operacje CRUD na fiszkach są delegowane do tego Cubita, który po wykonaniu operacji emituje nowy stan, powodując odświeżenie UI.
- **`AiGenerationCubit`**: Używany do obsługi procesu generowania fiszek. `FlashcardsPage` nasłuchuje na zmiany jego stanu (`BlocListener`), aby obsłużyć efekty uboczne: pokazać wskaźnik ładowania (np. w `SnackBar`), obsłużyć błąd generowania lub zainicjować nawigację do widoku recenzji po pomyślnym zakończeniu.

Nie ma potrzeby tworzenia customowych hooków ani zarządzania skomplikowanym stanem lokalnym poza kontrolerami formularzy w oknach dialogowych.

## 7. Integracja z Cubitami

### `FlashcardCubit`
- **Pobieranie fiszek**:
  - Wywołanie: `context.read<FlashcardCubit>().getFlashcards(deckId)` przy inicjalizacji widoku.
  - Reakcja UI: `BlocBuilder` renderuje odpowiedni stan (`loading`, `loaded`, `error`).
- **Tworzenie fiszki**:
  - Wywołanie: `context.read<FlashcardCubit>().createFlashcard(deckId: deckId, front: '...', back: '...')`.
  - Reakcja UI: Cubit wewnętrznie odświeży listę, emitując stan `loading`, a następnie `loaded` z nową listą.
- **Aktualizacja fiszki**:
  - Wywołanie: `context.read<FlashcardCubit>().updateFlashcard(deckId: deckId, flashcardId: id, newFront: '...', newBack: '...')`.
  - Reakcja UI: Jak przy tworzeniu.
- **Usuwanie fiszki**:
  - Wywołanie: `context.read<FlashcardCubit>().deleteFlashcard(deckId, flashcardId)`.
  - Reakcja UI: Jak przy tworzeniu.

### `AiGenerationCubit`
- **Generowanie fiszek**:
  - Wywołanie: `context.read<AiGenerationCubit>().generateFlashcards(text)`.
  - Reakcja UI: `BlocListener` reaguje na stany:
    - `loading`: Pokazuje `SnackBar` z informacją o trwającym procesie.
    - `error`: Pokazuje `SnackBar` z komunikatem błędu.
    - `loaded`: Używa `go_router` do nawigacji: `context.go('/decks/$deckId/review')`.

## 8. Interakcje użytkownika

- **Wejście na widok**: Aplikacja automatycznie wywołuje `getFlashcards` i pokazuje stan ładowania.
- **Kliknięcie "Dodaj fiszkę"**: Otwiera `AddEditFlashcardDialog` w trybie tworzenia.
- **Zapis nowej fiszki**: Po walidacji i kliknięciu "Zapisz", dialog jest zamykany, a Cubit jest wywoływany w celu utworzenia fiszki. Lista jest odświeżana.
- **Kliknięcie "Edytuj" na fiszce**: Otwiera `AddEditFlashcardDialog` z polami wypełnionymi danymi edytowanej fiszki.
- **Kliknięcie "Usuń" na fiszce**: Otwiera standardowe okno dialogowe z prośbą o potwierdzenie. Po potwierdzeniu Cubit usuwa fiszkę, a lista jest odświeżana.
- **Kliknięcie "Generuj z tekstu"**: Otwiera `GenerateWithAiDialog`.
- **Zatwierdzenie tekstu dla AI**: Po walidacji i kliknięciu "Generuj", dialog jest zamykany, a `AiGenerationCubit` jest wywoływany. Aplikacja przechodzi do widoku recenzji po pomyślnym zakończeniu operacji.

## 9. Warunki i walidacja

- **Stan `FlashcardCubit`**:
  - `loading`: Cały obszar contentu jest zastąpiony przez `CircularProgressIndicator`.
  - `error`: Zastąpiony widokiem błędu z opcją ponowienia (`Retry`).
  - `loaded`: Jeśli lista jest pusta, wyświetlany jest `WidokPustegoStanu`. W przeciwnym razie renderowana jest `FlashcardsListView`.
- **Walidacja formularzy (w dialogach)**:
  - Pola tekstowe używają właściwości `validator` w `TextFormField`.
  - Stan przycisków "Zapisz"/"Generuj" jest powiązany z wynikiem walidacji formularza (`Form.of(context).validate()`), aby zapobiec wysyłaniu nieprawidłowych danych.

## 10. Obsługa błędów

- **Błąd pobierania danych**: Jeśli `getFlashcards` zwróci błąd, `FlashcardCubit` emituje stan `error`. UI wyświetla widok błędu na pełnym ekranie, informując użytkownika o problemie i dając możliwość ponowienia próby.
- **Błędy operacji CRUD (Create, Update, Delete)**: W przypadku błędu podczas zapisu, aktualizacji lub usuwania, zalecane jest użycie `BlocListener`, aby wyświetlić `SnackBar` z komunikatem o błędzie, zamiast przeładowywać cały widok do stanu błędu. Pozwoli to użytkownikowi pozostać w kontekście listy i spróbować ponownie, bez utraty widoku danych.
- **Błąd generowania AI**: `AiGenerationCubit` emituje stan `error`. `BlocListener` na `FlashcardsPage` przechwytuje ten stan i wyświetla `SnackBar` z informacją o niepowodzeniu generowania, pozwalając użytkownikowi pozostać na bieżącym ekranie.
- **Błędy walidacji**: Są obsługiwane lokalnie w formularzach wewnątrz okien dialogowych, wyświetlając komunikaty bezpośrednio przy odpowiednich polach.

## 11. Kroki implementacji

1. **Utworzenie plików**: Stwórz nowe pliki dla widżetów: `flashcards_page.dart`, `widgets/flashcards_list_view.dart`, `widgets/flashcard_card.dart`, `widgets/add_edit_flashcard_dialog.dart`, `widgets/generate_with_ai_dialog.dart`.
2. **Routing**: Dodaj nową ścieżkę `/decks/:deckId` w konfiguracji `go_router`, kierującą do `FlashcardsPage` i przekazując `deckId` jako parametr.
3. **Implementacja `FlashcardsPage`**:
    - Zaimplementuj główny layout ze `Scaffold`.
    - Dodaj `BlocProvider` (lub użyj globalnego) dla `FlashcardCubit` i `AiGenerationCubit`.
    - W metodzie `initState` lub równoważnej wywołaj `context.read<FlashcardCubit>().getFlashcards(deckId)`.
    - Zaimplementuj `BlocBuilder` dla `FlashcardCubit` do obsługi stanów `loading`, `error`, `loaded`.
    - Zaimplementuj `BlocListener` dla `AiGenerationCubit` do obsługi nawigacji i snackbarów.
4. **Implementacja widżetów listy**: Stwórz `FlashcardsListView` i `FlashcardCard` zgodnie ze specyfikacją, dbając o przekazywanie zdarzeń `onEdit` i `onDelete`.
5. **Implementacja okien dialogowych**:
    - Stwórz `AddEditFlashcardDialog` z formularzem, walidacją i logiką do obsługi trybu tworzenia i edycji.
    - Stwórz `GenerateWithAiDialog` z formularzem do wprowadzania tekstu.
6. **Połączenie interakcji**: Podłącz akcje użytkownika (kliknięcia przycisków, zapis formularzy) do odpowiednich metod w Cubitach.
7. **Obsługa pustego stanu i błędów**: Zaimplementuj dedykowane widżety dla `WidokPustegoStanu` i widoku błędu z przyciskiem ponowienia.
8. **Stylowanie**: Zastosuj komponenty i style z biblioteki `shadcn_flutter`, aby zapewnić spójność wizualną z resztą aplikacji.
9. **Testowanie**: Napisz testy widżetów dla kluczowych komponentów, weryfikując poprawne renderowanie w różnych stanach Cubita.
