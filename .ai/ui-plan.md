
# Architektura UI dla Inteligentne Fiszki

## 1. Przegląd struktury UI

Architektura interfejsu użytkownika (UI) dla aplikacji "Inteligentne Fiszki" została zaprojektowana w oparciu o zasady czystości, responsywności i spójności, z wykorzystaniem biblioteki komponentów `shadcn_flutter`. System opiera się na kilku kluczowych, odseparowanych widokach, które odpowiadają za poszczególne funkcjonalności aplikacji, takie jak uwierzytelnianie, zarządzanie taliami i fiszkami oraz proces generowania treści przez AI.

Nawigacja w aplikacji jest zarządzana przez `go_router`, co umożliwia implementację bezpiecznych, chronionych tras w oparciu o stan uwierzytelnienia użytkownika. Każdy główny widok jest powiązany z dedykowanym Cubitem (zgodnie z biblioteką BLoC), który zarządza jego stanem, logiką i komunikacją z warstwą danych. Architektura kładzie nacisk na jasny i intuicyjny przepływ użytkownika, minimalizując jego wysiłek i prowadząc go przez kluczowe funkcje aplikacji, ze szczególnym uwzględnieniem procesu automatycznego tworzenia fiszek.

## 2. Lista widoków

### Widok Logowania (Login View)
- **Ścieżka widoku**: `/login`
- **Główny cel**: Umożliwienie istniejącym użytkownikom zalogowania się do aplikacji.
- **Kluczowe informacje do wyświetlenia**:
    - Formularz z polami na adres e-mail i hasło.
    - Komunikaty o błędach walidacji lub nieudanym logowaniu.
    - Link do widoku rejestracji.
- **Kluczowe komponenty widoku**:
    - `ShadcnInput` dla pól formularza.
    - `ShadcnButton` do zatwierdzenia logowania.
    - `BlocListener` do obsługi stanu błędu i sukcesu z `AuthCubit`.
- **UX, dostępność i względy bezpieczeństwa**:
    - Walidacja formularza w czasie rzeczywistym.
    - Jasna komunikacja błędów (np. "Nieprawidłowe dane logowania").
    - Ukrywanie wprowadzanego hasła.

### Widok Rejestracji (Register View)
- **Ścieżka widoku**: `/register`
- **Główny cel**: Umożliwienie nowym użytkownikom założenia konta.
- **Kluczowe informacje do wyświetlenia**:
    - Formularz z polami na adres e-mail i hasło.
    - Wymagania dotyczące hasła (np. minimalna długość).
    - Link do widoku logowania.
- **Kluczowe komponenty widoku**:
    - `ShadcnInput` dla pól formularza.
    - `ShadcnButton` do zatwierdzenia rejestracji.
- **UX, dostępność i względy bezpieczeństwa**:
    - Walidacja formatu adresu e-mail i złożoności hasła.
    - Informacja zwrotna po udanej rejestracji i automatyczne zalogowanie.

### Widok Listy Talii (Decks List View)
- **Ścieżka widoku**: `/decks`
- **Główny cel**: Wyświetlanie wszystkich talii fiszek użytkownika oraz umożliwienie zarządzania nimi (tworzenie, edycja, usuwanie).
- **Kluczowe informacje do wyświetlenia**:
    - Lista lub siatka talii.
    - Nazwa każdej talii.
    - Liczba fiszek w każdej talii.
    - Widok "pustego stanu" (empty state) w przypadku braku talii.
- **Kluczowe komponenty widoku**:
    - `LayoutBuilder` do przełączania między `GridView` (desktop) a `ListView` (mobile).
    - `Card` reprezentujący pojedynczą talię.
    - Przycisk akcji do tworzenia nowej talii.
    - Menu kontekstowe (lub przyciski) dla opcji "Zmień nazwę" i "Usuń".
    - `AlertDialog` do potwierdzenia operacji usunięcia.
- **UX, dostępność i względy bezpieczeństwa**:
    - Jasne wezwanie do działania (CTA) w pustym stanie.
    - Wymaganie potwierdzenia przed usunięciem talii, aby zapobiec przypadkowej utracie danych.
    - Wskaźnik ładowania podczas pobierania danych.

### Widok Szczegółów Talii / Lista Fiszek (Flashcards List View)
- **Ścieżka widoku**: `/decks/:deckId`
- **Główny cel**: Wyświetlanie i zarządzanie wszystkimi fiszkami w obrębie wybranej talii.
- **Kluczowe informacje do wyświetlenia**:
    - Nazwa bieżącej talii (np. w nawigacji okruszkowej).
    - Lista fiszek z widoczną treścią przodu i tyłu.
    - Widok "pustego stanu" z opcjami dodania fiszek.
- **Kluczowe komponenty widoku**:
    - Komponent nawigacji okruszkowej (breadcrumbs).
    - `ListView` do wyświetlania fiszek.
    - Niestandardowy widżet fiszki z opcjami edycji i usunięcia.
    - Przyciski akcji: "Dodaj fiszkę" i "Generuj z tekstu".
    - Okno modalne z formularzem do manualnego tworzenia/edycji fiszki.
    - Okno modalne do wklejenia tekstu dla AI.
- **UX, dostępność i względy bezpieczeństwa**:
    - Dwa wyraźne CTA w pustym stanie, aby naprowadzić użytkownika na kluczowe akcje.
    - Potwierdzenie przed usunięciem pojedynczej fiszki.

### Widok Recenzji Fiszek AI (AI Review View)
- **Ścieżka widoku**: `/decks/:deckId/review`
- **Główny cel**: Umożliwienie użytkownikowi weryfikacji, edycji i akceptacji fiszek wygenerowanych przez AI przed ich finalnym zapisaniem w talii.
- **Kluczowe informacje do wyświetlenia**:
    - Lista "kandydatów" na fiszki.
    - Treść przodu i tyłu każdego kandydata.
- **Kluczowe komponenty widoku**:
    - `ListView` do wyświetlania kandydatów.
    - Niestandardowy widżet kandydata z przyciskami "Zaakceptuj", "Edytuj", "Odrzuć".
    - Pola `TextField` do edycji treści fiszki w trybie "inline".
- **UX, dostępność i względy bezpieczeństwa**:
    - Jasny i efektywny przepływ pracy umożliwiający szybkie przetwarzanie listy.
    - Wykorzystanie "optimistic UI" – natychmiastowe usuwanie kandydata z listy po akcji użytkownika.
    - Zapewnienie, że użytkownik ma pełną kontrolę nad treścią zapisywaną w jego talii.

## 3. Mapa podróży użytkownika

1.  **Start**: Użytkownik wchodzi na stronę główną i jest przekierowywany do `/login`.
2.  **Uwierzytelnianie**: Użytkownik loguje się lub tworzy nowe konto (`/register`), po czym zostaje przekierowany do widoku listy talii (`/decks`).
3.  **Tworzenie i wybór talii**: W widoku `/decks` użytkownik tworzy nową talię, a następnie klika na nią, aby przejść do widoku szczegółów (`/decks/:deckId`).
4.  **Generowanie fiszek**: W widoku szczegółów talii klika przycisk "Generuj z tekstu", wkleja swoje notatki w oknie modalnym i rozpoczyna proces.
5.  **Recenzja AI**: Po zakończeniu generowania, użytkownik jest automatycznie przenoszony do widoku recenzji (`/decks/:deckId/review`).
6.  **Zarządzanie kandydatami**: Użytkownik przegląda wygenerowane fiszki, akceptując je, edytując lub odrzucając.
7.  **Zakończenie**: Po zakończeniu recenzji, użytkownik wraca do widoku szczegółów talii (`/decks/:deckId`), gdzie widzi wszystkie zaakceptowane fiszki i może rozpocząć naukę lub dodać kolejne manualnie.

## 4. Układ i struktura nawigacji

Nawigacja opiera się na `go_router` i ma charakter płaskiej struktury, typowej dla aplikacji internetowych.

- **Routing**:
    - `/login`, `/register`: Trasy publiczne.
    - `/decks`, `/decks/:deckId`, `/decks/:deckId/review`: Trasy chronione, dostępne tylko dla zalogowanych użytkowników. Próba dostępu bez autoryzacji skutkuje przekierowaniem do `/login`. Deck musi tez nalezeć do uzytkownika
- **Nawigacja wewnątrz aplikacji**:
    - Głównym punktem startowym po zalogowaniu jest `/decks`.
    - Przejście do szczegółów talii odbywa się przez kliknięcie jej na liście.
    - Powrót z widoków zagnieżdżonych (szczegóły talii, recenzja) jest realizowany za pomocą **nawigacji okruszkowej (breadcrumbs)** oraz standardowych przycisków przeglądarki, a nie przez przycisk "wstecz" w `AppBar`.
    - Wylogowanie jest dostępne z poziomu menu użytkownika, dostępnego w głównym layoucie aplikacji, i powoduje powrót do `/login`.

## 5. Kluczowe komponenty

- **Globalny Snackbar**: Reużywalny komponent do wyświetlania komunikatów o błędach i sukcesach na podstawie stanów z Cubitów, zapewniający spójną komunikację z użytkownikiem w całej aplikacji.
- **Widżet "Empty State"**: Komponent wyświetlany w miejscach list (talii, fiszek), gdy nie ma jeszcze żadnych danych. Zawiera czytelną informację oraz przyciski z wezwaniem do działania (CTA).
- **Widżet Fiszki/Kandydata na Fiszkę**: Niestandardowe, reużywalne komponenty do wyświetlania pojedynczej fiszki (lub kandydata) wraz z opcjami interakcji (edycja, usuwanie, akceptacja).
- **Okno dialogowe potwierdzenia**: Standardowy `AlertDialog` używany przed każdą operacją destrukcyjną (usunięcie talii/fiszki), aby zapobiec przypadkowej utracie danych.
- **Responsywny layout siatki/listy**: Komponent oparty na `LayoutBuilder`, który dynamicznie dostosowuje sposób wyświetlania list (np. talii) w zależności od szerokości ekranu.
