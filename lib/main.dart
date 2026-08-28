import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mt/core/router/router.dart';
import 'package:mt/injection_container.dart';
import 'package:mt/config/theme/app_theme.dart';
import 'package:mt/config/talker/talker_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // load services
  setupLocator();

  FlutterError.onError = (details) {
    sl<Talker>().handle(details.exception, details.stack);
  };

  await Supabase.initialize(
    url: 'https://xmtwpsaocedqqjetmzwa.supabase.co',
    publishableKey: 'sb_publishable_SDuDZC8EDK7vYUHxY61rdA_ms9YoefJ',
  );

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
      builder: (context, child) {
        child = DevicePreview.appBuilder(context, child);

        return Stack(children: [child, talkerScreen(rootNavigatorKey)]);
      },
      themeMode: ThemeMode.light,
      theme: theme(),
    );
  }
}
