Twoim zadaniem jest wdrożenie klasy Serwisu i Repozytorium w oparciu o podany plan implementacji, zgodnie z zasadami Czystej Architektury. Twoim celem jest stworzenie solidnej i dobrze zorganizowanej implementacji, która wykorzystuje fpDart do obsługi błędów, wstrzykiwanie zależności z injectable oraz podąża za wszystkimi krokami opisanymi w planie.
Najpierw dokładnie przejrzyj dostarczony plan wdrożenia:
<feature_name>
decks
</feature_name>
<implementation_plan>
@backend-plan.md 
</implementation_plan>
<implementation_rules>
@flutter-pro-rules.mdc 
</implementation_rules>
<implementation_approach>
Realizuj maksymalnie 3 kroki planu implementacji, podsumuj krótko co zrobiłeś i opisz plan na 3 kolejne działania - zatrzymaj w tym momencie pracę i czekaj na mój feedback.
</implementation_approach>
Teraz wykonaj następujące kroki, aby zaimplementować Serwis i Repozytorium:
Stwórz odpowiedni folder w folderze features nazwa tego folderu jest w tagach feature_name zgody z clean architecture dostarczonym w tagach implementation_rules.
Przeanalizuj plan wdrożenia:
Określ interfejs (klasę abstrakcyjną), który ma być zaimplementowany.
Zidentyfikuj wszystkie metody do zaimplementowania oraz ich sygnatury (parametry i typy zwracane, np. Future<Either<Failure, T>>).
Zrozum logikę biznesową i wymagane interakcje ze źródłami danych (np. Supabase, API zewnętrzne).
Zwróć szczególną uwagę na wymagania dotyczące obsługi błędów i mapowania wyjątków na konkretne typy Failure.
Rozpocznij implementację:
Zacznij od zdefiniowania klasy implementującej wymagany interfejs.
Skonfiguruj wstrzykiwanie zależności dla klasy i jej wymagań (np. SupabaseClient, Dio) za pomocą adnotacji @Injectable lub @LazySingleton.
Zaimplementuj każdą metodę zgodnie z logiką opisaną w planie wdrożenia.
Wszelkie operacje I/O (zapytania do bazy danych, wywołania API) umieść w blokach try-catch.
Zapewnij właściwe przetwarzanie danych i mapowanie modeli.
Przygotuj strukturę danych do zwrotu: Right(data) w przypadku sukcesu i Left(Failure()) w przypadku błędu.
Obsługa błędów i Walidacja:
Implementuj dokładną obsługę wyjątków, mapując je na odpowiednie, predefiniowane klasy Failure (np. ServerFailure, AuthFailure).
Dostarczaj jasne i pomocne komunikaty o błędach wewnątrz obiektów Failure.
Unikaj rzucania wyjątków (throw) poza warstwę danych; zamiast tego zawsze zwracaj Either.
Jeśli to konieczne, dodaj walidację dla parametrów wejściowych metod.
Rozważania dotyczące testowania:
Zastanów się nad przypadkami brzegowymi i potencjalnymi problemami, które powinny zostać przetestowane jednostkowo.
Upewnij się, że implementacja obejmuje wszystkie scenariusze (sukces, różne rodzaje błędów) wymienione w planie.
Dokumentacja:
Dodaj jasne komentarze, aby wyjaśnić złożoną logikę lub ważne decyzje projektowe.
Dołącz dokumentację DartDoc dla klasy i wszystkich metod publicznych.
Po zakończeniu implementacji upewnij się, że zawiera ona wszystkie niezbędne importy, definicje klas i zależności wymagane do jej poprawnego działania.
Jeśli musisz przyjąć jakieś założenia lub masz jakiekolwiek pytania dotyczące planu implementacji, przedstaw je przed rozpoczęciem pisania kodu.
Pamiętaj, aby przestrzegać najlepszych praktyk Czystej Architektury, stosować się do wytycznych dotyczących stylu kodu w Dart i upewnić się, że kod jest czysty, czytelny i dobrze zorganizowany. Utrzymuj komunikację w języku polskim.
Wszystkie niezbędne klasy potrzebne do implementacji masz podane w <implementation_plan> trzymaj się ich i nie dorabiaj jakiś innych wartst klasy freezed mają gotową serializację + są niemutowalne.
Trzymaj się jegnego nazwenictwa między serwisem a repo
 
dla repo: 
nazwaFolderu_repository.dart i implementacja nazwaFolderu_repository_impl.dart
przykład
auth_repository.dart  i implementacja auth_repository_impl.dart

dla serwisu
nazwaFolderu_remote_data_source.dart i dla implementacji nazwaFolderu_remote_data_source_impl.dart

przykład 
auth_remote_data_source.dart i dla implementacji auth_remote_data_source_impl.dart

Wszystkie klasy modeli mają być tworzone za pomocą freezed
