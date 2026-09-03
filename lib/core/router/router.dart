import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mt/core/router/go_router_refresh_stream.dart';
import 'package:mt/core/router/routes.dart';
import 'package:mt/features/auth/domain/repository/auth_repo.dart';
import 'package:mt/features/auth/presentation/pages/confirm_email_otp.dart';
import 'package:mt/features/error/presentation/error404.dart';
import 'package:mt/features/auth/presentation/pages/login.dart';
import 'package:mt/features/home/presentation/pages/home.dart';
import 'package:mt/injection_container.dart';
import 'package:talker_flutter/talker_flutter.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final authRepo = sl<AuthRepo>();

final goRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  observers: [sl<TalkerRouteObserver>()],
  initialLocation: '/',
  refreshListenable: GoRouterRefreshStream(authRepo.authStateChange),
  redirect: (context, state) {
    final isLoggedIn = authRepo.isLoggedIn;
    final location = state.matchedLocation;
    final isGuestOnlyRoute = AppRouteGuard.guestOnlyRoutes.contains(location);
    final isAuthenticatedOnlyRoute = AppRouteGuard.authenticatedOnlyRoutes
        .contains(location);

    if (!isLoggedIn && (isAuthenticatedOnlyRoute || !isGuestOnlyRoute)) {
      return '/login';
    }
    if (isLoggedIn && isGuestOnlyRoute) return '/';

    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      name: AppRoute.home,
      builder: (context, state) => const Home(),
    ),
    GoRoute(
      path: '/login',
      name: AppRoute.login,
      builder: (context, state) => const Login(),
    ),
    GoRoute(
      path: '/confirm_email_otp',
      name: AppRoute.confirmEmailOtp,
      builder: (context, state) {
        final email = state.extra as String?;
        return email != null ? ConfirmEmailOtp(email: email) : const Login();
      },
    ),
  ],
  errorPageBuilder: (context, state) => CustomTransitionPage(
    key: state.pageKey,
    child: const Error404(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(opacity: animation, child: child),
  ),
);
