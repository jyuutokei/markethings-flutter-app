import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mt/core/router/router.dart';
import 'package:mt/injection_container.dart';
import 'package:mt/config/theme/app_theme.dart';
import 'package:mt/config/talker/talker_screen.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:talker_flutter/talker_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // load services
  setupLocator();

  FlutterError.onError = (details) {
    sl<Talker>().handle(details.exception, details.stack);
  };

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      localizationsDelegates:
          SupabaseAuthUILocalizations.localizationsDelegates,
      supportedLocales: SupabaseAuthUILocalizations.supportedLocales,
      builder: (context, child) {
        child = DevicePreview.appBuilder(context, child);

        return Stack(children: [child, talkerScreen(rootNavigatorKey)]);
      },
      themeMode: ThemeMode.light,
      theme: theme(),
    );
  }
}
