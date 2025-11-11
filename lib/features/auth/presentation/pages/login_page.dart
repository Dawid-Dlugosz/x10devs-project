import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:x10devs/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:x10devs/features/auth/presentation/bloc/auth_state.dart';
import 'package:x10devs/features/auth/presentation/widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          state.whenOrNull(
            authenticated: (_) => context.go('/decks'),
            error: (failure) {
              ShadToaster.of(context).show(
                ShadToast.destructive(
                  title: const Text('Błąd logowania'),
                  description: Text(failure.message),
                ),
              );
            },
          );
        },
        child: const Center(
          child: LoginForm(),
        ),
      ),
    );
  }
}
