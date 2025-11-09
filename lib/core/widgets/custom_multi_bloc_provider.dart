import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x10devs/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:x10devs/injectable_config.dart';

class CustomMultiBlocProvider extends StatelessWidget {
  const CustomMultiBlocProvider({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => getIt<AuthCubit>()..checkAuthStatus(),
        ),
      ],
      child: child,
    );
  }
}
