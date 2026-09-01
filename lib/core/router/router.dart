import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mt/core/router/go_router_refresh_stream.dart';
import 'package:mt/core/router/routes.dart';
import 'package:mt/features/error/presentation/error404.dart';
import 'package:mt/features/auth/data/repository/auth_repo_impl.dart';
import 'package:mt/features/auth/presentation/pages/login.dart';
import 'package:mt/features/home/presentation/pages/home.dart';
import 'package:mt/injection_container.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final authRepo = AuthRepoImpl(sl<SupabaseClient>());

final goRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  observers: [sl<TalkerRouteObserver>()],
  initialLocation: '/',
  refreshListenable: GoRouterRefreshStream(authRepo.authStateChange),
  redirect: (context, state) {
    final isLoggedIn = authRepo.isLoggedIn;
    final isAuthRoute =
        state.matchedLocation == '/login' ||
        state.matchedLocation == '/register';

    if (!isLoggedIn && !isAuthRoute) return '/login';
    if (isLoggedIn && isAuthRoute) return '/';

    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      name: AppRoute.home,
      builder: (context, state) => Home(),
    ),
    GoRoute(
      path: '/login',
      name: AppRoute.login,
      builder: (context, state) => Login(),
    ),
    GoRoute(
      path: '/register',
      name: AppRoute.register,
      builder: (context, state) => const Scaffold(),
    ),
  ],
  errorPageBuilder: (context, state) => CustomTransitionPage(
    key: state.pageKey,
    child: Error404(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(opacity: animation, child: child),
  ),
);
