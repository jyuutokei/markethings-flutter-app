import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mt/core/router/bottom_nav.dart';
import 'package:mt/core/router/go_router_refresh_stream.dart';
import 'package:mt/core/router/routes.dart';
import 'package:mt/features/auth/domain/repository/auth_repo.dart';
import 'package:mt/features/auth/presentation/pages/confirm_email_otp.dart';
import 'package:mt/features/auth/presentation/pages/reset_password_otp.dart';
import 'package:mt/features/error/presentation/error404.dart';
import 'package:mt/features/auth/presentation/pages/login.dart';
import 'package:mt/features/home/data/models/product.dart';
import 'package:mt/features/home/presentation/pages/cart.dart';
import 'package:mt/features/home/presentation/pages/details.dart';
import 'package:mt/features/home/presentation/pages/favorites.dart';
import 'package:mt/features/home/presentation/pages/home.dart';
import 'package:mt/features/home/presentation/pages/profile.dart';
import 'package:mt/injection_container.dart';
import 'package:talker_flutter/talker_flutter.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final authRepo = sl<AuthRepo>();

final goRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  observers: [sl<TalkerRouteObserver>()],
  initialLocation: '/',
  refreshListenable: GoRouterRefreshStream(authRepo.authStateChange),
  redirect: (context, state) async {
    final location = state.matchedLocation;

    if (location == '/reset_pwd_otp') {
      return null;
    }

    final isLoggedIn = authRepo.isLoggedIn;
    final isGuestOnlyRoute = AppRouteGuard.guestOnlyRoutes.contains(location);
    final isAuthenticatedOnlyRoute = AppRouteGuard.authenticatedOnlyRoutes
        .contains(location);

    if (!isLoggedIn && (isAuthenticatedOnlyRoute || !isGuestOnlyRoute)) {
      return '/login';
    }

    if (isLoggedIn && isGuestOnlyRoute) {
      return '/';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      name: AppRoute.login,
      builder: (context, state) => const Login(),
    ),
    GoRoute(
      path: '/confirm_email_otp',
      name: AppRoute.confirmEmailOtp,
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        return args['email'] != null
            ? ConfirmEmailOtp(email: args['email'], sentAt: args['sentAt'])
            : const Login();
      },
    ),
    GoRoute(
      path: '/reset_pwd_otp',
      name: AppRoute.resetPwdOtp,
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        return args['email'] != null
            ? ResetPasswordOtp(email: args['email'], sentAt: args['sentAt'])
            : const Login();
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/product_details',
      name: AppRoute.productDetails,
      builder: (context, state) {
        final product = state.extra as ProductModel;
        return DetailsScreen(product: product);
      },
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return BottomNav(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              name: AppRoute.home,
              builder: (context, state) => const Home(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/cart',
              name: AppRoute.cart,
              builder: (context, state) => const Cart(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/favorites',
              name: AppRoute.favorites,
              builder: (context, state) => const Favorites(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              name: AppRoute.profile,
              builder: (context, state) => const Profile(),
            ),
          ],
        ),
      ],
    ),
  ],
  errorPageBuilder: (context, state) => CustomTransitionPage(
    key: state.pageKey,
    child: const Error404(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(opacity: animation, child: child),
  ),
);
