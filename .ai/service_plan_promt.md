db-plan>
{{db-plan}} <- To jest odniesienie do pliku @db-plan.md
</db-plan>


<prd>
{{prd}} <- To jest odniesienie do pliku @prd.md
</prd>


<tech-stack>
{{tech-stack}} <- To jest odniesienie do pliku @tech-stack.md
</tech-stack>


<rules>
{{flutter-pro-rules}} <- To jest odniesienie do pliku @flutter-pro-rules.mdc
</rules>


Jesteś doświadczonym architektem oprogramowania Flutter, którego zadaniem jest stworzenie kompleksowego planu implementacji **warstwy danych (serwisy i repozytoria)** dla aplikacji. Twój plan musi być ściśle oparty na schemacie bazy danych (`<db-plan>`), wymaganiach produktu (`<prd>`) oraz na dostarczonych zasadach architektonicznych (`<rules>`).

Kluczową zasadą jest rozdzielenie odpowiedzialności:
- **Serwisy (Data Sources)**: Komunikują się ze źródłem danych (np. API). Zwracają surowe dane (modele DTO) lub **rzucają wyjątki** (`Exception`) w razie problemów.
- **Repozytoria**: Implementują interfejsy z warstwy domeny. Wywołują metody serwisów, łapią ich wyjątki i konwertują je na typy `Failure`, a następnie zwracają wynik jako `Either<Failure, T>`.


Uważnie przeanalizuj dane wejściowe i wykonaj następujące kroki:


1.  **Przeanalizuj schemat bazy danych (`<db-plan>`):**
   *   Zidentyfikuj główne encje (tabele), które będą wymagały odpowiednich modeli danych (DTO) w warstwie danych.
   *   Zanotuj typy danych i relacje, aby poprawnie zdefiniować modele.


2.  **Przeanalizuj wymagania produktu (`<prd>`):**
   *   Zidentyfikuj kluczowe funkcje i logikę biznesową.
   *   Określ, jakie operacje na danych (CRUD i inne) są potrzebne do realizacji tych funkcji.


3.  **Przeanalizuj zasady architektoniczne (`<rules>`):**
   *   Zwróć szczególną uwagę na strukturę projektu (Clean Architecture), zasady obsługi błędów (`fpDart`), wstrzykiwanie zależności (`getIt` + `injectable`) oraz konwencje nazewnictwa.
   *   Zidentyfikuj, jak wpłynie to na projekt interfejsów serwisów i implementacji repozytoriów, pamiętając o podziale odpowiedzialności za błędy (Wyjątki vs. `Failure`).
   *  Pamiętaj o paginacji danych.


4.  **Stwórz kompleksowy plan implementacji warstwy danych:**
   *   Dla każdej głównej funkcji zidentyfikowanej w `<prd>` zdefiniuj odpowiedni **serwis** (np. `AuthRemoteDataSource`) oraz **implementację repozytorium** (np. `AuthRepositoryImpl`).
   *   **Dla każdego serwisu**:
     *   Zaprojektuj interfejs (abstrakcyjną klasę), który będzie definiował kontrakt.
     *   Zdefiniuj metody, które zwracają `Future<Model>` lub `Future<void>`.
     *   Określ, jakie specyficzne wyjątki (np. `ServerException`, `NotFoundException`) mogą być rzucane przez każdą metodę.
   *   **Dla każdego repozytorium**:
     *   Zaplanuj implementację, która będzie zależeć od interfejsu serwisu.
     *   Zdefiniuj metody, które implementują kontrakt z domeny i zwracają `Future<Either<Failure, T>>`.
     *   Opisz, jak wyjątki z serwisu będą mapowane na konkretne typy `Failure`.
   *   Zdefiniuj struktury modeli danych (DTOs) na podstawie `<db-plan>`.


Przed dostarczeniem ostatecznego planu, pracuj wewnątrz tagów `<service_analysis>` w swoim bloku myślenia, aby udokumentować swój proces analityczny. W tej sekcji:


1.  Wymień kluczowe zasady z `<rules>`, które mają największy wpływ na projekt. Dla każdej zasady zacytuj odpowiedni fragment.
2.  Zmapuj funkcje z `<prd>` na konkretne serwisy, repozytoria i ich metody.
3.  Zaprojektuj hierarchię klas `Failure` (dla repozytoriów) oraz hierarchię klas `Exception` (dla serwisów).
4.  Wylistuj modele danych (klasy z adnotacją `@freezed`), które należy utworzyć.
5.  Dla każdej kluczowej operacji (np. `login`) zaproponuj sygnatury metod zarówno dla serwisu (`Future<UserModel>`), jak i repozytorium (`Future<Either<Failure, User>>`). Opisz przepływ danych i błędów między nimi.


Ostateczny plan powinien być sformatowany w markdown i zawierać następujące sekcje:


```markdown
# Flutter Data Layer Implementation Plan


## 1. Guiding Principles
- A brief summary of how the plan adheres to the core principles (Clean Architecture, Error Handling distinction, DI, etc.).


## 2. Data Models (DTOs)
- Dart code definitions for the required data transfer objects (e.g., `UserModel`, `DeckModel`), using `@freezed` syntax.


## 3. Core Error & Exception Types


### 3.1. Exception Types (Data Layer)
- Dart code definitions for custom exceptions thrown by Data Sources (e.g., `ServerException`, `CacheException`).


### 3.2. Failure Types (Domain Layer)
- Dart code definition for the base `Failure` class and its main subtypes (e.g., `ServerFailure`, `CacheFailure`) used in `Either`.


## 4. Services (Data Sources)
For each service identified:


### 4.1. `[ServiceName]` (e.g., AuthRemoteDataSource)
- **Description**: A brief description of the service's responsibility (raw data fetching).
- **Dependencies**: List of required dependencies (e.g., `Dio`, `SupabaseClient`).


#### Interface Definition
```dart
abstract class IAuthRemoteDataSource {
 Future<UserModel> login({
   required String email,
   required String password,
 });
 // ... other methods
}
```


#### Methods Breakdown
For each method in the interface:
- **`methodName()`**
   - **Description**: What the method does.
   - **Parameters**: List of parameters with types.
   - **Return Type**: The `Future<SuccessType>` signature.
   - **Success Payload**: Description of the DTO returned on success.
   - **Potential Exceptions**: A list of specific `Exception` types that can be thrown.


## 5. Repositories
For each repository implementation:


### 5.1. `[RepositoryName]Impl` (e.g., AuthRepositoryImpl)
- **Description**: Implements the `IAuthRepository` from the domain layer. Handles exceptions from the data source and converts them to `Failure` types.
- **Dependencies**: The corresponding service interface (e.g., `IAuthRemoteDataSource`).


#### Methods Breakdown
For each method implementing the domain interface:
- **`methodName()`**
   - **Description**: What the method does from the business logic perspective.
   - **Parameters**: List of parameters with types.
   - **Return Type**: The full `Future<Either<Failure, SuccessType>>` signature.
   - **Success Payload (`Right`)**: Description of the entity or value returned on success.
   - **Potential Failures (`Left`)**: A list of specific `Failure` types, mapped from exceptions thrown by the service.
```


Upewnij się, że Twój plan jest szczegółowy, zgodny z podanymi zasadami i gotowy do implementacji.


Końcowy wynik powinien składać się wyłącznie z planu w formacie markdown w języku angielskim, który zapiszesz w pliku `.ai/backend-plan.md` i nie powinien powielać ani powtarzać żadnej pracy wykonanej w bloku myślenia.