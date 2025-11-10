import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:x10devs/core/router/go_router_refresh_stream.dart';
import 'package:x10devs/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:x10devs/features/auth/presentation/bloc/auth_state.dart';
import 'package:x10devs/features/auth/presentation/pages/login_page.dart';
import 'package:x10devs/features/auth/presentation/pages/register_page.dart';
import 'package:x10devs/features/decks/presentation/pages/decks_page.dart';
import 'package:x10devs/injectable_config.dart';

final GoRouter router = GoRouter(
  refreshListenable: GoRouterRefreshStream(getIt<AuthCubit>().stream),
  redirect: (BuildContext context, GoRouterState state) {
    final authState = getIt<AuthCubit>().state;
  
    final publicRoutes = ['/login', '/register'];
    final isPublicRoute = publicRoutes.contains(state.uri.toString());

    final isAuthenticated = authState.maybeMap(
      authenticated: (_) => true,
      orElse: () => false,
    );

    if (isAuthenticated && isPublicRoute) {
      return '/decks'; // Redirect to home if logged in and on a public page
    }

    if (!isAuthenticated && !isPublicRoute) {
      return '/login'; // Redirect to login if not logged in and on a protected page
    }

    // No redirect needed
    return null;
  },
  routes: <GoRoute>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        // This will be handled by the redirect logic
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    ),
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginPage();
      },
    ),
    GoRoute(
      path: '/register',
      builder: (BuildContext context, GoRouterState state) {
        return const RegisterPage();
      },
    ),
    GoRoute(
      path: '/decks',
      builder: (BuildContext context, GoRouterState state) {
        return const DecksPage();
      },
    ),
  ],
);
