import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:x10devs/core/router/app_router.dart';
import 'package:x10devs/features/decks/presentation/bloc/decks_cubit.dart';
import 'package:x10devs/injectable_config.dart';
import 'package:x10devs/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:x10devs/features/flashcard/presentation/bloc/ai_generation_cubit.dart';
import 'package:x10devs/features/flashcard/presentation/bloc/flashcard_cubit.dart';

/// Main function for integration tests - uses .env.test configuration
/// This ensures tests run against a separate test database
Future<void> main() async {
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();

  // Load TEST environment variables from .env.test
  await dotenv.load(fileName: ".env.test");
  await configureDependencies();
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<AuthCubit>()..checkAuthStatus(),
        ),
        BlocProvider(create: (context) => getIt<FlashcardCubit>()),
        BlocProvider(create: (context) => getIt<AiGenerationCubit>()),
        BlocProvider(create: (context) => getIt<DecksCubit>()),
      ],
      child: ShadApp.router(
        routerConfig: router,
        theme: ShadThemeData(
          brightness: Brightness.dark,
          colorScheme: const ShadSlateColorScheme.dark(),
        ),
      ),
    );
  }
}
