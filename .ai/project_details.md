<conversation_summary>
<decisions>
Grupa docelowa: Produkt skierowany jest do studentów i uczniów, jako narzędzie ogólnego przeznaczenia do tworzenia fiszek bez koncentracji na konkretnych przedmiotach.
Kluczowa funkcjonalność MVP: Aplikacja w wersji MVP skupi się na pełnym cyklu zarządzania fiszkami (CRUD - Create, Read, Update, Delete) i organizacji ich w talie. Sesja nauki i algorytmy powtórek nie wchodzą w zakres MVP.
Tworzenie fiszek: Użytkownicy będą mieli dwie możliwości tworzenia fiszek:
Automatyczne (AI): Z wklejonego tekstu (do 10 000 znaków). Wygenerowane fiszki są "kandydatami" i nie są zapisywane w bazie danych, dopóki użytkownik ich nie zaakceptuje lub nie zmodyfikuje.
Manualne: Za pomocą przycisku, który otwiera okno modalne (pop-up) z polami na "przód" (do 200 znaków) i "tył" (do 500 znaków) fiszki.
Organizacja treści: Fiszki będą grupowane w "talie" (decks), które użytkownik może samodzielnie tworzyć i nazywać w celu tematycznego powiązania materiału.
Uwierzytelnianie: System kont użytkowników będzie oparty na Supabase + Auth.
Edycja fiszek: Projekt przewiduje potrzebę zarówno edycji pojedynczych fiszek (inline), jak i operacji masowych.
Śledzenie sukcesu: Kluczowy wskaźnik sukcesu (75% akceptacji fiszek AI) będzie mierzony poprzez zapisywanie w bazie danych informacji, czy dana fiszka została wygenerowana przez AI i czy została zaakceptowana lub zmodyfikowana przez użytkownika.
Onboarding: Po rejestracji i logowaniu użytkownik zobaczy pusty interfejs z opcją tworzenia fiszek. Nie będzie samouczka ani domyślnie utworzonych talii.
Komunikacja błędów: Błędy walidacyjne (np. przekroczenie limitu znaków) będą komunikowane za pomocą powiadomień typu toast/snackbar.
Funkcje wykluczone z MVP: Analityka zachowań użytkowników, mechanizmy zbierania feedbacku, monetyzacja oraz limity użycia API (rate limiting).
</decisions>
<matched_recommendations>
Wprowadzenie systemu "talii" (decks) w celu umożliwienia użytkownikom tematycznej organizacji fiszek.
Implementacja okna modalnego (pop-up) do manualnego tworzenia fiszek w celu zapewnienia płynnego i nieinwazyjnego doświadczenia użytkownika.
Zaprojektowanie przejrzystego widoku listy fiszek w talii, prezentującego treść "przodu" karty oraz przyciski do edycji i usuwania.
Wykorzystanie nowoczesnych powiadomień (toast/snackbar) do informowania użytkownika o błędach walidacyjnych.
Zaprojektowanie schematu bazy danych uwzględniającego flagi do śledzenia pochodzenia i statusu fiszek (wygenerowana przez AI, zaakceptowana, zmodyfikowana), co umożliwi mierzenie kluczowych wskaźników sukcesu.
Zdefiniowanie i wdrożenie limitów znaków dla pól tekstowych (tekst źródłowy, przód i tył fiszki), aby zapewnić spójność danych i zapobiec nadużyciom.
</matched_recommendations>
<prd_planning_summary>
a. Główne wymagania funkcjonalne produktu:
System kont: Rejestracja i logowanie użytkowników z wykorzystaniem Supabase.
Zarządzanie taliami (Decks): Użytkownik może tworzyć, przeglądać, edytować nazwę i usuwać talie fiszek.
Zarządzanie fiszkami (Flashcards CRUD): W obrębie talii użytkownik może tworzyć, przeglądać, edytować i usuwać pojedyncze fiszki.
Generowanie fiszek przez AI: Funkcjonalność pozwalająca na wklejenie tekstu i wygenerowanie propozycji (kandydatów) fiszek.
Proces akceptacji fiszek AI: Interfejs do przeglądania kandydatów, ich akceptacji (zapis do bazy), modyfikacji (zapis zmienionej wersji) lub odrzucenia.
Tworzenie manualne fiszek: Dostępny z poziomu talii formularz (w pop-upie) do ręcznego dodawania fiszek.
b. Kluczowe historie użytkownika i ścieżki korzystania:
Jako użytkownik, chcę założyć konto, aby móc zapisywać i przechowywać moje fiszki.
Jako użytkownik, chcę tworzyć osobne talie dla różnych przedmiotów, aby utrzymać porządek w moich materiałach.
Jako użytkownik, chcę wkleić tekst z moich notatek i automatycznie wygenerować z niego fiszki, aby zaoszczędzić czas.
Jako użytkownik, chcę mieć możliwość przejrzenia i edycji fiszek od AI przed ich ostatecznym zapisaniem, aby upewnić się co do ich jakości.
Jako użytkownik, chcę mieć możliwość ręcznego dodania fiszki, jeśli AI czegoś nie wychwyciło lub mam specyficzną wiedzę do zanotowania.
Jako użytkownik, chcę widzieć listę wszystkich moich fiszek w danej talii, aby móc je przeglądać i edytować.
c. Ważne kryteria sukcesu i sposoby ich mierzenia:
Główne kryterium: 75% fiszek wygenerowanych przez AI jest akceptowanych przez użytkownika (bezpośrednio lub po edycji).
Sposób mierzenia: Baza danych będzie zawierać pola logiczne (np. is_ai_generated, was_modified) przy każdej fiszce, co pozwoli na precyzyjne wyliczenie wskaźnika akceptacji.
Poboczne kryterium: 75% wszystkich tworzonych fiszek powstaje z wykorzystaniem generatora AI.
Sposób mierzenia: Analiza flag w bazie danych w celu określenia stosunku fiszek stworzonych manualnie do tych zainicjowanych przez AI.
</prd_planning_summary>
<unresolved_issues>
Mechanizm sesji nauki: Cała logika i interfejs użytkownika związany z procesem uczenia się (wyświetlanie fiszek, ocenianie odpowiedzi, system powtórek) został świadomie przeniesiony na etap po MVP i wymaga dalszych analiz.
Wybór algorytmu powtórek: Decyzja dotycząca konkretnego algorytmu (np. SM-2, FSRS) do przyszłej implementacji sesji nauki jest otwarta.
Szczegółowy UX przepływu akceptacji fiszek AI: Dokładny projekt interfejsu do przeglądania, masowej edycji i akceptacji fiszek-kandydatów wymaga dalszego doprecyzowania.
Model AI i koszty: Wybór konkretnego modelu językowego (LLM) do generowania fiszek oraz analiza związanych z tym kosztów operacyjnych pozostają do ustalenia po stronie technicznej (backend).
</unresolved_issues>
</conversation_summary>