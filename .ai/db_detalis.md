<conversation_summary>
<decisions>
1.  Zarządzanie użytkownikami będzie w pełni opierać się na wbudowanej tabeli `auth.users` w Supabase, bez tworzenia dodatkowej tabeli `users`.
2.  Zatwierdzono relację jeden-do-wielu między taliami (`decks`) a fiszkami (`flashcards`) z regułą `ON DELETE CASCADE`, co oznacza, że usunięcie talii spowoduje usunięcie wszystkich powiązanych z nią fiszek.
3.  Fiszki-kandydaci generowane przez AI nie będą przechowywane w bazie danych. W bazie zapisywane będą wyłącznie fiszki zaakceptowane lub stworzone ręcznie, z odpowiednią flagą określającą ich pochodzenie.
4.  W tabeli `flashcards` zostaną dodane kolumny `is_ai_generated` i `was_modified_by_user` w celu śledzenia metryk sukcesu produktu.
5.  Zabezpieczenia na poziomie wiersza (Row-Level Security) zostaną zaimplementowane dla tabel `decks` i `flashcards`, aby zapewnić, że użytkownicy mają dostęp wyłącznie do swoich danych.
6.  Wydajność zapytań o liczbę fiszek w talii zostanie zoptymalizowana przez denormalizację – dodanie kolumny `flashcard_count` w tabeli `decks`, aktualizowanej za pomocą triggerów bazodanowych.
7.  Limity znaków dla pól tekstowych (nazwa talii, przód/tył fiszki) będą egzekwowane na poziomie bazy danych za pomocą ograniczeń `CHECK`.
8.  Wszystkie klucze obce (`user_id`, `deck_id`) zostaną zaindeksowane w celu poprawy wydajności zapytań.
9.  Nazwy talii będą unikalne w obrębie konta jednego użytkownika, co zostanie zapewnione przez `UNIQUE constraint` na parze kolumn (`user_id`, `name`).
10. Usunięcie konta użytkownika z `auth.users` spowoduje kaskadowe usunięcie wszystkich jego danych (talii i fiszek) dzięki regule `ON DELETE CASCADE`.
</decisions>

<matched_recommendations>
1.  **Zarządzanie użytkownikami**: Poleganie na tabeli `auth.users` z Supabase i referowanie do niej za pomocą klucza obcego `user_id` we wszystkich powiązanych tabelach.
2.  **Relacje i integralność danych**: Zdefiniowanie relacji jeden-do-wielu (`decks` -> `flashcards` i `users` -> `deks`) i użycie `ON DELETE CASCADE` w celu zapewnienia spójności danych przy usuwaniu.
3.  **Śledzenie pochodzenia fiszek**: Użycie flag `is_ai_generated` oraz `was_modified_by_user` do mierzenia kluczowych metryk produktu, zgodnie z PRD.
4.  **Bezpieczeństwo**: Włączenie i skonfigurowanie Row-Level Security (RLS) dla wszystkich tabel przechowujących dane użytkowników w celu ścisłej izolacji danych.
5.  **Optymalizacja wydajności**: Denormalizacja licznika fiszek (`flashcard_count`) i aktualizowanie go za pomocą triggerów, aby uniknąć kosztownych obliczeń dynamicznych.
6.  **Ograniczenia i typy danych**: Zastosowanie odpowiednich typów danych (`TEXT`, `BOOLEAN`, `UUID`, `BIGINT`) oraz ograniczeń `CHECK` do walidacji danych na poziomie bazy.
7.  **Indeksowanie**: Utworzenie indeksów na wszystkich kluczach obcych w celu przyspieszenia operacji filtrowania i łączenia tabel.
8.  **Unikalność danych**: Zastosowanie ograniczenia unikalności na nazwę talii w obrębie jednego użytkownika, aby poprawić użyteczność i zapobiec duplikatom.
</matched_recommendations>

<database_planning_summary>
Na podstawie przeprowadzonej analizy i podjętych decyzji, schemat bazy danych dla MVP będzie składał się z dwóch głównych tabel: `decks` i `flashcards`.

**Encje i Relacje:**
-   **`public.decks`**: Tabela przechowująca talie fiszek. Będzie zawierała kolumny `id`, `user_id` (klucz obcy do `auth.users`), `name` (z ograniczeniem unikalności w parze z `user_id`), `flashcard_count` (denormalizowany licznik) oraz `created_at`.
-   **`public.flashcards`**: Tabela przechowująca pojedyncze fiszki. Będzie zawierała kolumny `id`, `deck_id` (klucz obcy do `public.decks`), `front` (przód fiszki), `back` (tył fiszki), `is_ai_generated`, `was_modified_by_user` oraz `created_at`.
-   **Relacja**: Między tabelami `decks` i `flashcards` zostanie ustanowiona relacja jeden-do-wielu. Usunięcie talii spowoduje kaskadowe usunięcie wszystkich należących do niej fiszek. Taka sama relacja będzie między `users` a `decks`

**Bezpieczeństwo i Skalowalność:**
-   **Uwierzytelnianie**: System będzie w pełni zintegrowany z Supabase Auth. Dostęp do danych będzie autoryzowany na podstawie `auth.uid()`.
-   **Row-Level Security (RLS)**: RLS zostanie aktywowane dla obu tabel. Polityki bezpieczeństwa zapewnią, że operacje (`SELECT`, `INSERT`, `UPDATE`, `DELETE`) będą dozwolone tylko wtedy, gdy `user_id` w rekordzie odpowiada identyfikatorowi zalogowanego użytkownika.
-   **Wydajność**: W celu zapewnienia skalowalności, wszystkie klucze obce zostaną zaindeksowane. Dodatkowo, licznik fiszek w talii będzie zdenormalizowany i zarządzany przez automatyczne triggery, co znacznie przyspieszy odczyt list talii.

**Integralność Danych:**
-   Integralność danych będzie zapewniona przez użycie kluczy obcych z regułami `ON DELETE CASCADE`, ograniczeń `NOT NULL` oraz `CHECK` weryfikujących długość tekstu wprowadzanego przez użytkownika.
</database_planning_summary>

<unresolved_issues>
Wszystkie początkowe pytania i niejasności zostały wyjaśnione w trakcie rozmowy. Na obecnym etapie nie ma nierozwiązanych kwestii dotyczących projektu schematu bazy danych dla MVP.
</unresolved_issues>
</conversation_summary>