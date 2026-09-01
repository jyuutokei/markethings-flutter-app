import 'dart:async';

import 'package:flutter/material.dart';

// general TLDR: whenever the given stream emits anything at all, call notifyListeners()
class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    // example listener event: auth check
    // initital listener, uses what current auth state supabase returns to listen, happens once
    notifyListeners();

    // if everytime during runtime of the app the auth state changes, run this callback
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
