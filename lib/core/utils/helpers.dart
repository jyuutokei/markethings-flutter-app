import 'package:flutter/material.dart';

class AppHelpers {
  // Private constructor prevents instantiation of this class
  AppHelpers._();

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
