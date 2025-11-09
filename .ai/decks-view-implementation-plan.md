# Plan implementacji widoku: Lista Talii (Decks View)

## 1. Przegląd

Widok "Lista Talii" jest głównym ekranem aplikacji po zalogowaniu użytkownika. Jego celem jest wyświetlenie wszystkich talii fiszek stworzonych przez użytkownika oraz zapewnienie narzędzi do zarządzania nimi, w tym tworzenia nowych talii, zmiany ich nazw oraz usuwania. Widok ten stanowi centralny punkt nawigacyjny, z którego użytkownik przechodzi do szczegółów wybranej talii.
Dodatkowo w tym widoku trzeba dać moliwość wylogowywania uzytkownika.

## 2. Routing widoku

-   **Ścieżka**: `/decks`
-   **Ochrona**: Trasa chroniona. Dostępna tylko dla zalogowanych użytkowników. Próba wejścia bez autoryzacji powinna skutkować przekierowaniem na stronę logowania (`/login`).

## 3. Struktura komponentów

Struktura widoku będzie oparta na architekturze BLoC, reagując na stany emitowane przez `DecksCubit`.

```
DecksPage
└── BlocProvider<DecksCubit>
    └── Scaffold
        ├── AppBar (z tytułem "Twoje Talie" i akcją wylogowania)
        └── BlocBuilder<DecksCubit, DecksState>
            ├── (stan: loading) => CircularProgressIndicator
            ├── (stan: error) => ErrorDisplayWidget(onRetry: ...)
            └── (stan: loaded)
                ├── (jeśli talie są puste) => EmptyDecksView
                │   └── ShadButton (wezwanie do akcji "Stwórz talię")
                ├── (jeśli talie istnieją) => DecksListWidget
                │   └── LayoutBuilder
                │       └── GridView/ListView
                │           └── DeckCardWidget (dla każdej talii)
                │               ├── Text (Nazwa talii)
                │               ├── Text (Liczba fiszek)
                │               └── ShadcnContextMenu (opcje: Zmień nazwę, Usuń)
                └── FloatingActionButton (do tworzenia nowej talii)
```

## 4. Szczegóły komponentów

### DecksPage

-   **Opis**: Główny widżet strony, odpowiedzialny za inicjalizację `DecksCubit`, zarządzanie ogólnym layoutem (Scaffold) oraz obsługę logiki `BlocBuilder` do renderowania odpowiednich komponentów w zależności od stanu.
-   **Główne elementy**: `Scaffold`, `AppBar`, `BlocProvider`, `BlocBuilder`, `FloatingActionButton`.
-   **Obsługiwane interakcje**:
    -   Inicjalizacja pobierania talii przy wejściu na widok.
    -   Naciśnięcie `FloatingActionButton` w celu otwarcia dialogu tworzenia talii.
-   **Propsy**: Brak.

### DecksListWidget

-   **Opis**: Komponent renderujący listę lub siatkę talii. Jest responsywny – używa `LayoutBuilder` do wyboru między `GridView` na szerszych ekranach a `ListView` na węższych.
-   **Główne elementy**: `LayoutBuilder`, `GridView`, `ListView`, `DeckCardWidget`.
-   **Obsługiwane interakcje**: Nawigacja do widoku szczegółów talii po kliknięciu na `DeckCardWidget`.
-   **Propsy**: `required List<DeckModel> decks`.

### DeckCardWidget

-   **Opis**: Reprezentuje pojedynczą talię na liście. Wyświetla jej nazwę, liczbę fiszek i udostępnia menu kontekstowe z opcjami zarządzania.
-   **Główne elementy**: `Card`, `Text`, `MenuAnchor`.
-   **Obsługiwane interakcje**:
    -   `onTap`: Nawigacja do `/decks/{deck.id}`.
    -   `onEdit`: Otwarcie dialogu edycji nazwy talii.
    -   `onDelete`: Otwarcie dialogu potwierdzenia usunięcia talii.
-   **Propsy**: `required DeckModel deck`.

### EmptyDecksView

-   **Opis**: Komponent "pustego stanu", wyświetlany, gdy użytkownik nie ma jeszcze żadnych talii. Zawiera informację tekstową i wyraźne wezwanie do działania (CTA).
-   **Główne elementy**: `Center`, `Text`, `ShadButton`.
-   **Obsługiwane interakcje**: Kliknięcie przycisku "Stwórz talię" otwiera dialog tworzenia talii.
-   **Propsy**: `VoidCallback onCreateDeckPressed`.

### CreateOrEditDeckDialog

-   **Opis**: Dialog modalny służący do tworzenia nowej talii lub edycji nazwy istniejącej. Zawiera pole tekstowe i przyciski akcji.
-   **Główne elementy**: `Dialog`, `Form`, `ShadInputFormField` (TextFormField), `ShadButton` ("Zapisz", "Anuluj").
-   **Obsługiwane zdarzenia**: `onSubmit(String name)`.
-   **Warunki walidacji**:
    -   Nazwa nie może być pusta.
    -   Nazwa nie może przekraczać 100 znaków.
-   **Propsy**: `DeckModel? deckToEdit` (opcjonalny, jeśli edytujemy).

### DeleteConfirmationDialog

-   **Opis**: Prosty dialog potwierdzający operację usunięcia talii, aby zapobiec przypadkowej utracie danych.
-   **Główne elementy**: `Dialog`, `Text`, `ShadButton` ("Usuń", "Anuluj").
-   **Obsługiwane zdarzenia**: `onConfirm()`.
-   **Propsy**: `required DeckModel deckToDelete`.

## 5. Typy

Głównym modelem danych dla tego widoku jest `DeckModel`.

```dart
// Zakładana struktura na podstawie dokumentacji
// lib/features/decks/data/models/deck_model.dart
class DeckModel {
  final int id;
  final String name;
  final int flashcardCount; // Lub pole, z którego można to wyliczyć
  final String userId;

  DeckModel({
    required this.id,
    required this.name,
    required this.flashcardCount,
    required this.userId,
  });
}
```

## 6. Zarządzanie stanem

Zarządzanie stanem będzie realizowane w całości przez `DecksCubit`, zgodnie z dokumentacją `cubits-plan.md`.

-   **Dostawca stanu**: `BlocProvider<DecksCubit>` będzie umieszczony na szczycie drzewa widżetów `DecksPage`.
-   **Konsumpcja stanu**: `BlocBuilder<DecksCubit, DecksState>` będzie nasłuchiwał zmian stanu i przebudowywał interfejs.
    -   `DecksState.loading`: Wyświetlanie wskaźnika ładowania.
    -   `DecksState.loaded`: Wyświetlanie `DecksListWidget` lub `EmptyDecksView`.
    -   `DecksState.error`: Wyświetlanie komunikatu błędu.
-   **Wyzwalanie akcji**: Interakcje użytkownika (np. kliknięcie przycisku) będą wywoływać odpowiednie metody na instancji cubita: `context.read<DecksCubit>().createDeck(name)`.
-   **Komunikaty zwrotne**: `BlocListener` może być użyty do wyświetlania komunikatów typu `Toast/Snackbar` po udanej operacji (np. "Talia została utworzona") lub w przypadku błędu, który nie blokuje całego widoku.

## 7. Integracja z cubitami

Integracja będzie polegać na wywoływaniu metod `DecksCubit` i reagowaniu na emitowane przez niego stany.

-   **Pobieranie talii**: `DecksCubit.getDecks()`
    -   **Akcja**: Wywoływana automatycznie przy inicjalizacji `DecksPage`.
    -   **Odpowiedź (sukces)**: Stan `DecksState.loaded` z `List<DeckModel>`.
    -   **Odpowiedź (błąd)**: Stan `DecksState.error` z `Failure`.
-   **Tworzenie talii**: `DecksCubit.createDeck(String name)`
    -   **Akcja**: Wywoływana po zatwierdzeniu formularza w `CreateOrEditDeckDialog`.
    -   **Odpowiedź**: Cubit wewnętrznie przechodzi w stan `loading`, a po sukcesie odświeża listę, wywołując `getDecks()`, co skutkuje emisją nowego stanu `loaded`.
-   **Aktualizacja talii**: `DecksCubit.updateDeck(int deckId, String newName)`
    -   **Akcja**: Wywoływana po zatwierdzeniu formularza w `CreateOrEditDeckDialog` w trybie edycji.
    -   **Odpowiedź**: Analogicznie do tworzenia, cubit odświeża listę po operacji.
-   **Usuwanie talii**: `DecksCubit.deleteDeck(int deckId)`
    -   **Akcja**: Wywoływana po potwierdzeniu w `DeleteConfirmationDialog`.
    -   **Odpowiedź**: Analogicznie do tworzenia, cubit odświeża listę po operacji.

## 8. Interakcje użytkownika

-   **Przeglądanie talii**: Użytkownik scrolluje listę/siatkę.
-   **Nawigacja do fiszek**: Kliknięcie lewym przyciskiem myszy na karcie talii przenosi na ścieżkę `/decks/{id}`.
-   **Tworzenie talii**:
    1.  Użytkownik klika `FloatingActionButton`.
    2.  Otwiera się dialog `CreateOrEditDeckDialog`.
    3.  Użytkownik wpisuje nazwę i klika "Zapisz".
    4.  Dialog jest zamykany, a nowa talia pojawia się na liście.
-   **Zmiana nazwy talii**:
    1.  Użytkownik klika prawym przyciskiem myszy na karcie talii, aby otworzyć menu kontekstowe, i wybiera "Zmień nazwę".
    2.  Otwiera się dialog `CreateOrEditDeckDialog` z wypełnioną obecną nazwą.
    3.  Użytkownik modyfikuje nazwę i klika "Zapisz".
    4.  Dialog jest zamykany, a nazwa talii na liście zostaje zaktualizowana.
-   **Usuwanie talii**:
    1.  Użytkownik otwiera menu kontekstowe i wybiera "Usuń".
    2.  Otwiera się dialog `DeleteConfirmationDialog`.
    3.  Użytkownik klika "Usuń", aby potwierdzić.
    4.  Dialog jest zamykany, a talia znika z listy.

## 9. Warunki i walidacja

-   **Formularz tworzenia/edycji talii**:
    -   Pole nazwy jest wymagane (nie może być puste). Wyświetlany jest komunikat "Nazwa talii jest wymagana."
    -   Długość nazwy jest ograniczona do 100 znaków. Wyświetlany jest komunikat "Nazwa nie może przekraczać 100 znaków."
    -   Walidacja jest przeprowadzana po stronie klienta przy próbie zapisu. Przycisk "Zapisz" jest nieaktywny, dopóki formularz nie jest poprawny.

## 10. Obsługa błędów

-   **Błąd pobierania talii**: Jeśli `DecksCubit` emituje stan `DecksState.error`, `BlocBuilder` powinien wyświetlić dedykowany widżet błędu. Widżet ten powinien zawierać czytelny komunikat (np. "Nie udało się wczytać talii") oraz przycisk "Spróbuj ponownie", który ponownie wywoła metodę `getDecks()`.
-   **Błędy operacji CRUD**: Błędy podczas tworzenia, edycji lub usuwania talii powinny być komunikowane użytkownikowi w sposób nieinwazyjny, np. za pomocą `ShadcnToast` lub `Snackbar`. Należy użyć `BlocListener` do nasłuchiwania na stan `DecksState.error` i wyświetlania odpowiedniego komunikatu z obiektu `Failure`.

## 11. Kroki implementacji

1.  **Struktura plików**: Stworzyć pliki dla nowych widżetów zgodnie ze strukturą projektu:
    -   `lib/features/decks/presentation/pages/decks_page.dart`
    -   `lib/features/decks/presentation/widgets/decks_list_widget.dart`
    -   `lib/features/decks/presentation/widgets/deck_card_widget.dart`
    -   `lib/features/decks/presentation/widgets/empty_decks_view.dart`
    -   `lib/features/decks/presentation/widgets/dialogs/...` (dla dialogów)
2.  **Routing**: Zaktualizować konfigurację `go_router` w `lib/core/router/app_router.dart`, dodając nową, chronioną trasę dla `/decks` wskazującą na `DecksPage`.
3.  **Implementacja `DecksPage`**: Zaimplementować główny widżet z `Scaffold`, `BlocProvider` i `BlocBuilder`, który będzie obsługiwał przełączanie między stanami `loading`, `error` i `loaded`. Dodać `FloatingActionButton`.
4.  **Implementacja `DecksListWidget` i `DeckCardWidget`**: Stworzyć widżety do wyświetlania listy talii, dbając o responsywność (`LayoutBuilder`) i obsługę interakcji (nawigacja, menu kontekstowe).
5.  **Implementacja stanu pustego**: Stworzyć widżet `EmptyDecksView` z odpowiednim komunikatem i przyciskiem CTA.
6.  **Implementacja dialogów**: Stworzyć reużywalny `CreateOrEditDeckDialog` z walidacją formularza oraz `DeleteConfirmationDialog`.
7.  **Połączenie z Cubitem**: Zintegrować interakcje użytkownika z metodami `DecksCubit` (`createDeck`, `updateDeck`, `deleteDeck`) w odpowiednich miejscach (np. po zatwierdzeniu dialogu).
8.  **Obsługa błędów**: Dodać `BlocListener` do wyświetlania komunikatów o błędach operacji CRUD oraz zaimplementować widżet błędu dla stanu `DecksState.error`.
9.  **Testowanie**: Napisać testy widżetowe dla kluczowych komponentów, sprawdzając poprawność renderowania w różnych stanach cubita i obsługę interakcji.
