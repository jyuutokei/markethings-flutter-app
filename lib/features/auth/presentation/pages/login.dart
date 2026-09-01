import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mt/core/router/routes.dart';
import 'package:mt/injection_container.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:talker_flutter/talker_flutter.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final logger = sl<TalkerLogger>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Center(
            child: Image.asset(
              'assets/images/logo/mt-logo.png',
              width: 250,
              height: 250,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SupaEmailAuth(
              redirectTo: kIsWeb
                  ? null
                  : 'io.supabase.markethings://login-callback/',
              onSignInComplete: (response) {
                context.goNamed(AppRoute.home);
              },
              onSignUpComplete: (response) {
                context.goNamed(AppRoute.home);
              },
              onError: (error) {
                logger.error('Auth error: $error');
              },
            ),
          ),
          Gap(20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SupaSocialsAuth(
              redirectUrl: kIsWeb
                  ? null
                  : 'io.supabase.markethings://login-callback/',
              socialProviders: [OAuthProvider.google],
              onSuccess: (session) {
                context.goNamed(AppRoute.home);
              },
              onError: (error) {
                logger.error('Auth error: $error');
              },
            ),
          ),
        ],
      ),
    );
  }
}
