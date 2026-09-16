import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

final rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class AppHelpers {
  // Private constructor prevents instantiation of this class
  AppHelpers._();

  static void showGlobalSnackBar(
    String title,
    String message,
    ContentType contentType,
  ) {
    rootScaffoldMessengerKey.currentState
      ?..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: title,
            message: message,
            contentType: contentType,
          ),
        ),
      );
  }

  static void showSnackBar(
    BuildContext context,
    String title,
    String message,
    ContentType contentType,
  ) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: title,
            message: message,
            contentType: contentType,
          ),
        ),
      );
  }
}
