// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;
import 'package:x10devs/core/di/injectable_module.dart' as _i385;
import 'package:x10devs/features/auth/data/data_sources/auth_remote_data_source.dart'
    as _i45;
import 'package:x10devs/features/auth/data/repositories/auth_repository_impl.dart'
    as _i420;
import 'package:x10devs/features/auth/domain/repositories/auth_repository.dart'
    as _i551;
import 'package:x10devs/features/auth/presentation/bloc/auth_cubit.dart'
    as _i1054;
import 'package:x10devs/features/decks/data/data_sources/decks_remote_data_source_impl.dart'
    as _i566;
import 'package:x10devs/features/decks/data/repositories/decks_repository_impl.dart'
    as _i360;
import 'package:x10devs/features/decks/domain/data_sources/decks_remote_data_source.dart'
    as _i47;
import 'package:x10devs/features/decks/domain/repositories/decks_repository.dart'
    as _i806;
import 'package:x10devs/features/decks/presentation/bloc/decks_cubit.dart'
    as _i514;
import 'package:x10devs/features/flashcard/data/data_sources/ai_generation_remote_data_source_impl.dart'
    as _i164;
import 'package:x10devs/features/flashcard/data/data_sources/flashcard_remote_data_source_impl.dart'
    as _i230;
import 'package:x10devs/features/flashcard/data/repositories/ai_generation_repository_impl.dart'
    as _i31;
import 'package:x10devs/features/flashcard/data/repositories/flashcard_repository_impl.dart'
    as _i40;
import 'package:x10devs/features/flashcard/domain/data_sources/ai_generation_remote_data_source.dart'
    as _i1017;
import 'package:x10devs/features/flashcard/domain/data_sources/flashcard_remote_data_source.dart'
    as _i370;
import 'package:x10devs/features/flashcard/domain/repositories/ai_generation_repository.dart'
    as _i1053;
import 'package:x10devs/features/flashcard/domain/repositories/flashcard_repository.dart'
    as _i600;
import 'package:x10devs/features/flashcard/presentation/bloc/ai_generation_cubit.dart'
    as _i994;
import 'package:x10devs/features/flashcard/presentation/bloc/flashcard_cubit.dart'
    as _i559;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final injectableModule = _$InjectableModule();
    gh.lazySingleton<_i454.SupabaseClient>(
      () => injectableModule.supabaseClient,
    );
    gh.lazySingleton<_i361.Dio>(() => injectableModule.dio);
    gh.lazySingleton<_i1017.IAIGenerationRemoteDataSource>(
      () => _i164.AIGenerationRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i45.IAuthRemoteDataSource>(
      () => _i45.AuthRemoteDataSourceImpl(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i1053.IAIGenerationRepository>(
      () => _i31.AIGenerationRepositoryImpl(
        gh<_i1017.IAIGenerationRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i370.IFlashcardsRemoteDataSource>(
      () => _i230.FlashcardsRemoteDataSourceImpl(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i600.IFlashcardRepository>(
      () =>
          _i40.FlashcardRepositoryImpl(gh<_i370.IFlashcardsRemoteDataSource>()),
    );
    gh.lazySingleton<_i559.FlashcardCubit>(
      () => _i559.FlashcardCubit(gh<_i600.IFlashcardRepository>()),
    );
    gh.lazySingleton<_i47.IDecksRemoteDataSource>(
      () => _i566.DecksRemoteDataSourceImpl(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i994.AiGenerationCubit>(
      () => _i994.AiGenerationCubit(gh<_i1053.IAIGenerationRepository>()),
    );
    gh.lazySingleton<_i551.IAuthRepository>(
      () => _i420.AuthRepositoryImpl(gh<_i45.IAuthRemoteDataSource>()),
    );
    gh.lazySingleton<_i1054.AuthCubit>(
      () => _i1054.AuthCubit(gh<_i551.IAuthRepository>()),
    );
    gh.lazySingleton<_i806.IDecksRepository>(
      () => _i360.DecksRepositoryImpl(gh<_i47.IDecksRemoteDataSource>()),
    );
    gh.factory<_i514.DecksCubit>(
      () => _i514.DecksCubit(gh<_i806.IDecksRepository>()),
    );
    return this;
  }
}

class _$InjectableModule extends _i385.InjectableModule {}
