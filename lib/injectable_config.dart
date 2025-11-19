import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:x10devs/injectable_config.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  // Reset GetIt if already initialized (for testing purposes)
  // Check for a specific type to see if it's already configured
  if (getIt.isRegistered<SupabaseClient>()) {
    await getIt.reset();
  }
  getIt.init();
}
