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



Backend - Supabase zapewni dostęp do bazy + autoryzację 
    - Zapewnia bazę danych PostgreSQL
    - Zapewnia SDK w wielu językach, które posłużą jako Backend-as-a-Service
    - Jest rozwiązaniem open source, które można hostować lokalnie lub na własnym serwerze
    - Posiada wbudowaną autentykację użytkowników

AI - Komunikacja z modelami przez usługę Openrouter.ai:
- Dostęp do szerokiej gamy modeli (OpenAI, Anthropic, Google i wiele innych), które pozwolą nam znaleźć rozwiązanie zapewniające wysoką efektywność i niskie koszta
- Pozwala na ustawianie limitów finansowych na klucze API

CI/CD i Hosting:
- Github Actions do tworzenia pipeline’ów CI/CD
- DigitalOcean do hostowania aplikacji za pośrednictwem obrazu docker