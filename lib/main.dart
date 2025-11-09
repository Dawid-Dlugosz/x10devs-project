import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
// import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:x10devs/core/router/app_router.dart';
import 'package:x10devs/core/widgets/custom_multi_bloc_provider.dart';
import 'package:x10devs/injectable_config.dart';

void main() async {
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  await configureDependencies();
  await Supabase.initialize(
    url: dotenv.env['UPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  // runApp(const ShadcnApp(home: MyApp(),)
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadApp.custom(
      themeMode: ThemeMode.dark,
      darkTheme: ShadThemeData(
        brightness: Brightness.dark,
        colorScheme: ShadColorScheme.fromName('blue', brightness: Brightness.dark),
      ),
      appBuilder: (context) {
        return CustomMultiBlocProvider(
          child: MaterialApp.router(
            routerConfig: router,
            theme: Theme.of(context),
            builder: (context, child) {
              return ShadAppBuilder(
                child: child!,
              );
            },
          ),
        );
      },
    );
  }  
}
