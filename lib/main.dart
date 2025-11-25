import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
// import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:x10devs/core/router/app_router.dart';
import 'package:x10devs/features/decks/presentation/bloc/decks_cubit.dart';

import 'package:x10devs/injectable_config.dart';
import 'package:x10devs/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:x10devs/features/flashcard/presentation/bloc/ai_generation_cubit.dart';
import 'package:x10devs/features/flashcard/presentation/bloc/flashcard_cubit.dart';

Future<void> main() async {
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  // For production builds, use --dart-define
  // For local development, use .env file
  String supabaseUrl;
  String supabaseAnonKey;

  const dartDefineSupabaseUrl = String.fromEnvironment('SUPABASE_URL');
  const dartDefineSupabaseKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  if (dartDefineSupabaseUrl.isNotEmpty && dartDefineSupabaseKey.isNotEmpty) {
    // Production build with --dart-define
    supabaseUrl = dartDefineSupabaseUrl;
    supabaseAnonKey = dartDefineSupabaseKey;
  } else {
    // Local development with .env file
    await dotenv.load(fileName: ".env");
    supabaseUrl = dotenv.env['SUPABASE_URL']!;
    supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY']!;
  }

  await configureDependencies();
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  // runApp(const ShadcnApp(home: MyApp(),)
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
