import 'package:flutter/material.dart';
import 'package:mt/injection_container.dart';
import 'package:talker_flutter/talker_flutter.dart';

Positioned talkerScreen(GlobalKey<NavigatorState> navigatorKey) {
  return Positioned(
    bottom: 40,
    right: 20,
    child: FloatingActionButton(
      onPressed: () {
        navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (_) => TalkerScreen(talker: sl<Talker>())),
        );
      },
      child: const Icon(Icons.bug_report, color: Colors.black),
    ),
  );
}
