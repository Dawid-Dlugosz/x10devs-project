Frontend - Flutter + Dart:
- Flutter 3.5 - narzędzie które pozwala na szybkie tworzenie ładnego UI oraz animacji
- Dart 3.9 - jezyk w którym jest pisanan logiką w Flutterze
- Shadcn/ui 0.0.46 -  zapewnia bibliotekę dostępnych komponentów React, na których oprzemy UI (https://pub.dev/packages/shadcn_flutter)
- BLoC 9.1.0 - biblioteka która słuzy do trzymania stanu aplikacji, głownie będzie to cubit (https://pub.dev/packages/bloc)
- Freezed 3.2.3  - biblioteka, która słuzy do towrzena niemutowalnych obiektów + zapewnie serializację (https://pub.dev/packages/bloc)
- Dio 5.9.0 - biblioeka, która zapewnia połączennia http do api (https://pub.dev/packages/dio)
- fpDart 1.2.0 - biblioteka, która zapewnia lepsze zarządzanie błędami i obsługa ich (https://pub.dev/packages/fpdart)
- getIt 8.3.0 - bibliteka która tworzy depenency injection (https://pub.dev/packages/get_it)
- injectable 2.5.2 - słuzy do lepszego zarządzania getIt i robi to automatycznnie (https://pub.dev/packages/injectable)
- go_router 16.3.0 - biblioteka do zarządzania routingiem w aplikacji, wspierana przez zespół Fluttera (https://pub.dev/packages/go_router)


Backend - Supabase zapewni dostęp do bazy + autoryzację 
    - Zapewnia bazę danych PostgreSQL
    - Zapewnia SDK w wielu językach, które posłużą jako Backend-as-a-Service
    - Jest rozwiązaniem open source, które można hostować lokalnie lub na własnym serwerze
    - Posiada wbudowaną autentykację użytkowników

AI - Komunikacja z modelami przez usługę Openrouter.ai:
- Dostęp do szerokiej gamy modeli (OpenAI, Anthropic, Google i wiele innych), które pozwolą nam znaleźć rozwiązanie zapewniające wysoką efektywność i niskie koszta
- Pozwala na ustawianie limitów finansowych na klucze API

Testing - Kompleksowa strategia testowania:
- flutter_test (wbudowane) - framework do testów jednostkowych i widgetów
- mocktail 1.0.4 - biblioteka do mockowania zależności w testach (https://pub.dev/packages/mocktail)
- bloc_test 10.0.0 - dedykowane narzędzie do testowania Cubitów i Bloców (https://pub.dev/packages/bloc_test)
- integration_test (wbudowane) - framework do testów E2E i integracyjnych

Typy testów:
1. Testy Jednostkowe (Unit Tests):
   - Testowanie izolowanych jednostek kodu (Cubits, Repositories, Data Sources, Models)
   - Cel pokrycia: ≥80% dla warstw Data i Domain
   - Mockowanie zależności zewnętrznych (Supabase, OpenRouter API)

2. Testy Widgetów (Widget Tests):
   - Testowanie komponentów UI w izolacji
   - Walidacja formularzy, renderowanie list, widoki stanów
   - Cel pokrycia: ≥60% dla warstwy Presentation

3. Testy Integracyjne (Integration Tests):
   - Testowanie współpracy między warstwami (Data → Domain → Presentation)
   - Integracja z Supabase (RLS policies, triggery bazy danych)
   - Integracja z OpenRouter API (generowanie fiszek)

4. Testy E2E (End-to-End Tests):
   - Testowanie kompletnych scenariuszy użytkownika
   - Przepływy: rejestracja → tworzenie talii → dodawanie fiszek → generowanie AI
   - Testy na różnych przeglądarkach (Chrome)

Środowiska testowe:
- Lokalne: Supabase Local (Docker) + Mock serwery dla API
- Staging: Dedykowany projekt Supabase + testowe klucze API
- CI/CD: GitHub Actions z automatycznym uruchamianiem testów

CI/CD i Hosting:
- Github Actions do tworzenia pipeline'ów CI/CD
  * Automatyczne uruchamianie testów przy każdym commit/PR
  * Generowanie raportów pokrycia kodu
  * Linter i analiza statyczna kodu
- DigitalOcean do hostowania aplikacji za pośrednictwem obrazu docker