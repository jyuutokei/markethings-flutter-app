import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mt/injection_container.dart';
import 'package:talker_flutter/talker_flutter.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  observers: [sl<TalkerRouteObserver>()],
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'Home',
      builder: (context, state) => const Scaffold(),
    ),
  ],
);
