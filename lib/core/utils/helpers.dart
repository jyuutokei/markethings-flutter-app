import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mt/injection_container.dart';
import 'package:talker_flutter/talker_flutter.dart';

final rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class AppHelpers {
  // Private constructor prevents instantiation of this class
  AppHelpers._();

  static Color primaryColor(BuildContext context) {
    return Theme.of(context).colorScheme.primary;
  }

  static Color secondaryColor(BuildContext context) {
    return Theme.of(context).colorScheme.secondary;
  }

  static Color errorColor(BuildContext context) {
    return Theme.of(context).colorScheme.error;
  }

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
          persist: false,
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
          persist: false,
          content: AwesomeSnackbarContent(
            title: title,
            message: message,
            contentType: contentType,
          ),
        ),
      );
  }

  static String pesoFormatter(num price) {
    return NumberFormat.currency(
      locale: 'en_PH',
      symbol: '₱',
      decimalDigits: 2,
    ).format(price);
  }

  static TalkerLogger logger() {
    return sl<TalkerLogger>();
  }

  static Future<bool> showCenterModal(
    BuildContext context,
    String title,
    String desc,
  ) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: true,
          builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(desc),
            actions: [
              TextButton(
                onPressed: () => context.pop(false),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: AppHelpers.errorColor(context)),
                ),
              ),
              ElevatedButton(
                onPressed: () => context.pop(true),
                child: const Text('Confirm'),
              ),
            ],
          ),
        ) ??
        false;
  }
}
