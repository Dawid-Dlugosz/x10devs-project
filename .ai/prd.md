# Dokument wymagań produktu (PRD) - Inteligentne Fiszki

## 1. Przegląd produktu

Inteligentne Fiszki to aplikacja internetowa zaprojektowana, aby zrewolucjonizować sposób, w jaki studenci i uczniowie tworzą materiały do nauki. Główne założenie produktu polega na wykorzystaniu sztucznej inteligencji do automatycznego generowania fiszek edukacyjnych z notatek tekstowych dostarczonych przez użytkownika. Aplikacja ma na celu znaczące skrócenie czasu potrzebnego na przygotowanie materiałów do nauki, jednocześnie zachowując wysoką jakość merytoryczną.

Wersja MVP (Minimum Viable Product) skupia się na podstawowych funkcjonalnościach, które obejmują pełen cykl zarządzania fiszkami (tworzenie, odczyt, aktualizacja, usuwanie - CRUD), organizację fiszek w tematyczne talie oraz system kont użytkowników oparty na Supabase do bezpiecznego przechowywania danych.

## 2. Problem użytkownika

Tradycyjne, manualne tworzenie fiszek jest procesem czasochłonnym i monotonnym. Uczniowie i studenci często rezygnują z tej efektywnej metody nauki (spaced repetition) z powodu bariery czasowej i wysiłku wymaganego do przygotowania wysokiej jakości materiałów. W rezultacie tracą możliwość optymalizacji procesu uczenia się. Inteligentne Fiszki adresują ten problem, automatyzując najbardziej żmudną część procesu – tworzenie treści fiszek – co pozwala użytkownikom skupić się na nauce, a nie na przygotowaniach.

## 3. Wymagania funkcjonalne

- FR-01: System Kont Użytkowników: Użytkownicy muszą mieć możliwość rejestracji, logowania i wylogowywania się z aplikacji. Dane użytkownika i jego fiszki muszą być bezpiecznie przechowywane.
- FR-02: Zarządzanie Taliami (Decks): Użytkownik może tworzyć, przeglądać, edytować nazwę i usuwać talie, które służą jako tematyczne kontenery na fiszki.
- FR-03: Zarządzanie Fiszkami (Flashcards): W obrębie talii użytkownik może przeglądać, edytować i usuwać pojedyncze fiszki.
- FR-04: Generowanie Fiszek przez AI: Użytkownik może wkleić tekst (do 10 000 znaków), z którego system AI wygeneruje propozycje fiszek (tzw. "kandydatów").
- FR-05: Proces Akceptacji Fiszek AI: Użytkownik ma dostęp do interfejsu, w którym może przeglądać wygenerowane przez AI fiszki, a następnie zaakceptować je (zapisując w talii), zmodyfikować przed zapisem lub całkowicie odrzucić.
- FR-06: Manualne Tworzenie Fiszek: Użytkownik ma możliwość ręcznego dodawania fiszek do talii za pomocą dedykowanego formularza.
- FR-07: Walidacja i Komunikacja Błędów: Aplikacja musi walidować dane wejściowe (np. limity znaków) i informować użytkownika o błędach w sposób nieinwazyjny (np. za pomocą powiadomień typu toast/snackbar).

## 4. Granice produktu

Następujące funkcjonalności są świadomie wykluczone z zakresu MVP, aby umożliwić szybkie wdrożenie i zebranie opinii od pierwszych użytkowników:
- Sesja nauki i algorytmy powtórek (np. SM-2, Anki).
- Zaawansowany import plików (np. PDF, DOCX, zdjęcia).
- Współdzielenie talii fiszek między użytkownikami.
- Integracje z zewnętrznymi platformami edukacyjnymi.
- Dedykowane aplikacje mobilne (produkt będzie dostępny jako aplikacja webowa).
- Zaawansowana analityka zachowań użytkowników.
- Wbudowane mechanizmy zbierania opinii (feedback).
- Funkcje monetyzacji i subskrypcji.
- Limity użycia API (rate limiting).

## 5. Historyjki użytkowników

### Zarządzanie Kontem

- ID: US-001
- Tytuł: Rejestracja nowego użytkownika
- Opis: Jako nowy użytkownik, chcę móc założyć konto za pomocą adresu e-mail i hasła, aby móc zapisywać i przechowywać moje fiszki.
- Kryteria akceptacji:
  - Formularz rejestracji zawiera pola na adres e-mail i hasło.
  - Walidacja sprawdza poprawność formatu adresu e-mail.
  - Walidacja wymaga, aby hasło miało co najmniej 8 znaków.
  - Po pomyślnej rejestracji użytkownik jest automatycznie logowany i przekierowywany do głównego panelu.
  - W przypadku błędu (np. zajęty e-mail) wyświetlany jest stosowny komunikat.

- ID: US-002
- Tytuł: Logowanie użytkownika
- Opis: Jako zarejestrowany użytkownik, chcę móc zalogować się na moje konto, aby uzyskać dostęp do moich talii i fiszek.
- Kryteria akceptacji:
  - Formularz logowania zawiera pola na adres e-mail i hasło.
  - Po pomyślnym zalogowaniu użytkownik jest przekierowywany do głównego panelu.
  - W przypadku podania błędnych danych uwierzytelniających wyświetlany jest stosowny komunikat.

- ID: US-003
- Tytuł: Wylogowanie użytkownika
- Opis: Jako zalogowany użytkownik, chcę móc się wylogować, aby zabezpieczyć dostęp do mojego konta.
- Kryteria akceptacji:
  - W interfejsie aplikacji znajduje się przycisk "Wyloguj".
  - Po kliknięciu przycisku sesja użytkownika jest kończona, a on sam jest przekierowywany na stronę logowania.

### Zarządzanie Taliami

- ID: US-004
- Tytuł: Tworzenie nowej talii
- Opis: Jako użytkownik, chcę móc stworzyć nową talię fiszek i nadać jej nazwę, aby tematycznie organizować moje materiały.
- Kryteria akceptacji:
  - Na głównym panelu znajduje się przycisk "Utwórz talię".
  - Po kliknięciu pojawia się pole do wpisania nazwy talii (limit 100 znaków).
  - Nowo utworzona talia pojawia się na liście moich talii.
  - Nazwa talii nie może być pusta.

- ID: US-005
- Tytuł: Przeglądanie listy talii
- Opis: Jako użytkownik, chcę widzieć listę wszystkich moich talii, aby mieć szybki dostęp do moich materiałów.
- Kryteria akceptacji:
  - Po zalogowaniu wyświetla się lista wszystkich talii stworzonych przez użytkownika.
  - Każda pozycja na liście pokazuje nazwę talii oraz liczbę fiszek w środku.
  - Kliknięcie na talię przenosi do widoku fiszek w tej talii.

- ID: US-006
- Tytuł: Zmiana nazwy talii
- Opis: Jako użytkownik, chcę mieć możliwość zmiany nazwy istniejącej talii, aby poprawić ewentualne błędy lub przeorganizować materiały.
- Kryteria akceptacji:
  - W widoku listy talii lub w widoku talii istnieje opcja "Zmień nazwę".
  - Po wybraniu opcji nazwa talii staje się edytowalna.
  - Zmieniona nazwa jest zapisywana i widoczna na liście talii.

- ID: US-007
- Tytuł: Usuwanie talii
- Opis: Jako użytkownik, chcę móc usunąć talię, której już nie potrzebuję, wraz ze wszystkimi zawartymi w niej fiszkami.
- Kryteria akceptacji:
  - Przy każdej talii na liście znajduje się opcja "Usuń".
  - Przed usunięciem wyświetlane jest okno z prośbą o potwierdzenie operacji.
  - Po potwierdzeniu talia i wszystkie jej fiszki są trwale usuwane z bazy danych.

### Zarządzanie Fiszkami

- ID: US-008
- Tytuł: Manualne tworzenie fiszki
- Opis: Jako użytkownik, chcę mieć możliwość ręcznego dodania nowej fiszki do wybranej talii, gdy mam specyficzną wiedzę do zanotowania.
- Kryteria akceptacji:
  - W widoku talii znajduje się przycisk "Dodaj fiszkę".
  - Po kliknięciu otwiera się okno modalne z polami "Przód" (limit 200 znaków) i "Tył" (limit 500 znaków).
  - Po wypełnieniu i zapisaniu, nowa fiszka pojawia się na liście fiszek w danej talii.
  - Pola "Przód" i "Tył" nie mogą być puste.

- ID: US-009
- Tytuł: Generowanie fiszek z tekstu przez AI
- Opis: Jako użytkownik, chcę wkleić tekst z moich notatek (do 10 000 znaków) i automatycznie wygenerować z niego fiszki, aby zaoszczędzić czas.
- Kryteria akceptacji:
  - W widoku talii znajduje się opcja "Generuj z tekstu".
  - Po jej wybraniu pojawia się pole tekstowe na wklejenie notatek.
  - Po wklejeniu tekstu i uruchomieniu generowania, aplikacja komunikuje, że proces jest w toku.
  - Po zakończeniu procesu użytkownik jest przenoszony do widoku akceptacji fiszek-kandydatów.

- ID: US-010
- Tytuł: Przeglądanie i akceptacja fiszek od AI
- Opis: Jako użytkownik, chcę mieć możliwość przejrzenia fiszek wygenerowanych przez AI przed ich zapisaniem, aby upewnić się co do ich jakości.
- Kryteria akceptacji:
  - Wygenerowane fiszki są wyświetlane jako lista "kandydatów".
  - Każdy kandydat ma treść przodu i tyłu.
  - Przy każdym kandydacie znajdują się przyciski: "Zaakceptuj", "Edytuj" i "Odrzuć".
  - Zaakceptowanie fiszki powoduje jej zapisanie w docelowej talii i usunięcie z listy kandydatów.
  - Odrzucenie fiszki powoduje jej trwałe usunięcie z listy kandydatów.

- ID: US-011
- Tytuł: Edycja fiszki-kandydata przed zapisaniem
- Opis: Jako użytkownik, chcę móc edytować treść fiszki-kandydata od AI, aby poprawić jej treść przed ostatecznym zapisaniem.
- Kryteria akceptacji:
  - Kliknięcie przycisku "Edytuj" przy kandydacie sprawia, że jego pola "Przód" i "Tył" stają się edytowalne.
  - Po dokonaniu zmian użytkownik może zapisać fiszkę, która zostanie dodana do talii.
  - Fiszka zapisana po edycji jest oznaczana w bazie danych jako zmodyfikowana.

- ID: US-012
- Tytuł: Edycja istniejącej fiszki w talii
- Opis: Jako użytkownik, chcę móc edytować zapisaną już fiszkę, aby poprawić błędy lub zaktualizować informacje.
- Kryteria akceptacji:
  - W widoku listy fiszek każda z nich ma opcję "Edytuj".
  - Wybranie opcji pozwala na edycję treści przodu i tyłu fiszki (edycja inline).
  - Zmiany są zapisywane automatycznie po zakończeniu edycji lub po kliknięciu przycisku zapisu.

- ID: US-013
- Tytuł: Usuwanie pojedynczej fiszki
- Opis: Jako użytkownik, chcę móc usunąć pojedynczą fiszkę z talii, jeśli uznam, że nie jest już potrzebna.
- Kryteria akceptacji:
  - Każda fiszka na liście ma opcję "Usuń".
  - Przed usunięciem wyświetlane jest okno z prośbą o potwierdzenie.
  - Po potwierdzeniu fiszka jest trwale usuwana.

## 6. Metryki sukcesu

Sukces wersji MVP będzie mierzony za pomocą następujących kluczowych wskaźników:

- Główne kryterium sukcesu: Poziom akceptacji fiszek generowanych przez AI wynosi co najmniej 75%. Oznacza to, że 3 na 4 fiszki proponowane przez AI są uznawane przez użytkowników za wartościowe (bezpośrednio lub po niewielkiej edycji).
  - Sposób mierzenia: W bazie danych każda fiszka będzie miała flagi `is_ai_generated` oraz `was_modified_by_user`. Wskaźnik będzie obliczany jako stosunek zaakceptowanych fiszek AI (zmodyfikowanych lub nie) do wszystkich wygenerowanych propozycji.

- Poboczne kryterium sukcesu: Co najmniej 75% wszystkich nowo tworzonych fiszek w aplikacji powstaje przy użyciu generatora AI.
  - Sposób mierzenia: Analiza flagi `is_ai_generated` w bazie danych pozwoli na określenie stosunku fiszek stworzonych manualnie do tych zainicjowanych przez AI. Osiągnięcie tego celu potwierdzi, że kluczowa propozycja wartości produktu jest realizowana.
