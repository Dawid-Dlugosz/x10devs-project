<conversation_summary>
<decisions>
Nawigacja w aplikacji będzie zarządzana przez go_router z wykorzystaniem mechanizmu redirect do ochrony tras w oparciu o stan AuthCubit.
Błędy zwracane przez Cubity będą komunikowane użytkownikowi w spójny sposób za pomocą reużywalnego komponentu Snackbar.
Operacje CRUD będą implementowane z podejściem "optimistic UI" w celu poprawy postrzeganej wydajności.
W przypadku braku odpowiednich komponentów w bibliotece shadcn_flutter, będą tworzone własne, spójne stylistycznie widżety.
Aplikacja będzie responsywna, wykorzystując LayoutBuilder do adaptacji layoutu do różnych rozmiarów ekranu.
Instancje FlashcardCubit będą tworzone i dostarczane za pomocą BlocProvider dla każdego widoku szczegółów talii, z deckId przekazywanym jako parametr trasy.
Synchronizacja danych między DecksCubit a FlashcardCubit będzie realizowana poprzez wywołanie odświeżenia w DecksCubit po operacjach w FlashcardCubit.
Stan lokalny formularzy (np. walidacja) będzie zarządzany przez StatefulWidget i Form, a globalny stan aplikacji przez dedykowane Cubity.
Operacje krytyczne (np. usuwanie) będą wymagały potwierdzenia od użytkownika za pomocą standardowego okna dialogowego.
Aplikacja będzie wykorzystywać dedykowane widżety "empty state" z wezwaniem do działania (CTA), aby prowadzić użytkownika.
</decisions>
<matched_recommendations>
Nawigacja i bezpieczeństwo: go_router zdefiniuje główne ścieżki (/login, /decks, /decks/:deckId, etc.) i użyje redirect do ochrony tras w oparciu o stan AuthCubit, uniemożliwiając dostęp niezalogowanym użytkownikom.
Zarządzanie stanem i UI: Każdy Cubit (Auth, Decks, Flashcard, AiGeneration) będzie zarządzał dedykowanym fragmentem UI. Stany loading będą wizualizowane za pomocą wskaźników postępu (pełnoekranowych lub lokalnych), a stany error będą obsługiwane przez globalny mechanizm Snackbar.
Architektura komponentów: Interfejs będzie budowany w oparciu o bibliotekę shadcn_flutter. Brakujące elementy, takie jak animowany widżet fiszki, będą tworzone jako niestandardowe, reużywalne komponenty, dziedziczące styl z globalnego ShadcnThemeData.
Przepływ użytkownika (CRUD): Operacje na danych (tworzenie, edycja, usuwanie) będą stosować "optimistic UI" - interfejs będzie aktualizowany natychmiast, a operacja sieciowa wykonywana w tle.
Przepływ użytkownika (AI): Generowanie fiszek przez AI będzie realizowane w oknie modalnym, a po zakończeniu procesu użytkownik zostanie przeniesiony na dedykowany ekran recenzji, gdzie będzie mógł zarządzać kandydatami na fiszki.
Responsywność: Układ aplikacji będzie adaptacyjny. LayoutBuilder posłuży do dynamicznej zmiany komponentów (np. GridView na ListView) w zależności od dostępnej przestrzeni.
Formularze i walidacja: Logika walidacji (np. puste pola) będzie umieszczona w warstwie prezentacji przy użyciu validator w TextFormField, zapewniając natychmiastowy feedback.
</matched_recommendations>
<ui_architecture_planning_summary>
Na podstawie przeanalizowanych wymagań i przeprowadzonych dyskusji, architektura UI dla MVP aplikacji "Inteligentne Fiszki" została zaplanowana w następujący sposób:
a. Główne wymagania dotyczące architektury UI
Architektura UI musi wspierać wszystkie funkcjonalności zdefiniowane w PRD, w tym pełen cykl CRUD dla talii i fiszek, proces generowania fiszek przez AI oraz uwierzytelnianie użytkowników. Interfejs ma być czysty, spójny i responsywny, zbudowany w oparciu o bibliotekę shadcn_flutter i dostosowany do działania jako aplikacja webowa na różnych urządzeniach.
b. Kluczowe widoki, ekrany i przepływy użytkownika
Autoryzacja: Obejmuje ekrany /login i /register, zarządzane przez AuthCubit. Po pomyślnym uwierzytelnieniu użytkownik jest przekierowywany do głównego widoku.
Lista Talii (Decks View): Główny ekran po zalogowaniu (/decks), wyświetlający listę talii użytkownika (GridView na desktop, ListView na mobile). Zarządzany przez DecksCubit. Umożliwia tworzenie, edycję i usuwanie talii.
Szczegóły Talii (Flashcards View): Widok dostępny pod /decks/:deckId, zarządzany przez FlashcardCubit. Wyświetla listę fiszek w danej talii. Zamiast tradycyjnego AppBar z przyciskiem wstecz (co jest mniej typowe dla aplikacji webowych), nawigacja będzie opierać się na mechanizmach przeglądarki. W UI można zastosować nawigację okruszkową (breadcrumbs), np. "Moje talie > Nazwa Talii", aby zapewnić kontekst i łatwy powrót. Widok zawierać będzie przyciski akcji do manualnego dodawania fiszek i generowania ich przez AI.
Generowanie Fiszek (AI Generation Flow): Inicjowane z widoku talii, otwiera modal z polem tekstowym. Proces jest obsługiwany przez AiGenerationCubit.
Recenzja Fiszek (AI Review View): Po wygenerowaniu, użytkownik jest przenoszony na ekran recenzji (/decks/:deckId/review), gdzie może akceptować, edytować lub odrzucać fiszki-kandydatów.
c. Strategia integracji z cubitami i zarządzania stanem
Dostarczanie zależności: Cubity będą dostarczane do drzewa widżetów za pomocą BlocProvider w odpowiednich miejscach (np. AuthCubit globalnie, FlashcardCubit lokalnie dla widoku talii).
Reakcja na stany: BlocBuilder będzie używany do przebudowywania UI w odpowiedzi na zmiany stanu (np. wyświetlanie listy talii), a BlocListener do obsługi zdarzeń jednorazowych, takich jak nawigacja czy wyświetlanie Snackbarów z błędami.
Synchronizacja: Stan między powiązanymi Cubitami (np. FlashcardCubit i DecksCubit) będzie synchronizowany przez nasłuchiwanie na zmiany w jednym i wywoływanie odświeżenia w drugim.
Stan formularzy: Lokalny stan formularzy będzie oddzielony od globalnego stanu aplikacji i zarządzany przez StatefulWidget oraz FormState.
d. Kwestie dotyczące responsywności, dostępności i bezpieczeństwa
Responsywność: Aplikacja będzie w pełni responsywna dzięki użyciu LayoutBuilder.
Dostępność: Spójność wizualna i obsługa błędów za pomocą shadcn_flutter oraz Snackbar przyczynią się do lepszej dostępności. Dedykowane widżety "empty state" pomogą w nawigacji.
Bezpieczeństwo: Ochrona tras zostanie zaimplementowana w go_router poprzez redirect, który będzie weryfikował stan zalogowania w AuthCubit, uniemożliwiając nieautoryzowany dostęp.
e. Wszelkie nierozwiązane kwestie lub obszary wymagające dalszego wyjaśnienia
Brak. Wszystkie kluczowe aspekty architektury UI zostały omówione i uzgodnione.
</ui_architecture_planning_summary>
<unresolved_issues>
Brak.
</unresolved_issues>
</conversation_summary>