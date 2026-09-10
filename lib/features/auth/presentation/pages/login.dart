import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mt/config/env/env.dart';
import 'package:mt/core/constants/constants.dart';
import 'package:mt/core/router/routes.dart';
import 'package:mt/core/utils/helpers.dart';
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
  bool _isSigningIn = true;
  bool _hasOpenedResetOtp = false;

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
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: SupaEmailAuth(
              key: ValueKey(_isSigningIn),
              isInitiallySigningIn: _isSigningIn,
              showSnackBars: false,
              showConfirmPasswordField: true,
              passwordValidator: (value) {
                if (_isSigningIn) {
                  return null;
                }

                final password = value ?? '';
                final missingRequirements = <String>[];

                if (password.length < 8) {
                  missingRequirements.add('At least 8 characters');
                }
                if (!RegExp(r'\d').hasMatch(password)) {
                  missingRequirements.add('A number');
                }
                if (!RegExp(r'[a-z]').hasMatch(password)) {
                  missingRequirements.add('A lowercase letter');
                }
                if (!RegExp(r'[A-Z]').hasMatch(password)) {
                  missingRequirements.add('An uppercase letter');
                }

                return missingRequirements.isEmpty
                    ? null
                    : 'Password must contain:\n'
                          '${missingRequirements.map((requirement) => '- $requirement').join('\n')}';
              },
              useOtpForPasswordRecovery: true,
              onToggleSignIn: (isSigningIn) {
                setState(() {
                  _isSigningIn = isSigningIn;
                });
              },
              redirectTo: kIsWeb
                  ? null
                  : 'io.supabase.markethings://login_callback/',
              onSignInComplete: (response) {
                AppHelpers.showSnackBar(
                  context,
                  "Signed in successfully. Happy shopping!",
                );
                context.pushReplacementNamed(AppRoute.home);
              },
              onSignUpComplete: (response) async {
                final user = response.user;
                final email = user?.email;

                if (email == null) {
                  AppHelpers.showSnackBar(
                    context,
                    'Could not determine the signup email.',
                  );
                  return;
                }

                // supabase returns an empty identities list for an existing email
                // when email confirmation is enabled.
                if (user?.identities?.isEmpty ?? true) {
                  AppHelpers.showSnackBar(
                    context,
                    'An account may already exist with this email. Try signing in or resetting your password.',
                  );

                  return;
                }

                if (response.session == null) {
                  context.pushNamed(
                    AppRoute.confirmEmailOtp,
                    extra: {
                      'email': response.user!.email,
                      'sentAt': DateTime.now(),
                    },
                  );
                } else {
                  context.pushReplacementNamed(AppRoute.home);
                }
              },
              onPasswordResetEmailSent: (email) {
                if (_hasOpenedResetOtp) return;

                _hasOpenedResetOtp = true;

                context.pushNamed(
                  AppRoute.resetPwdOtp,
                  extra: {'email': email, 'sentAt': DateTime.now()},
                );
              },
              onError: (error) {
                final message = error is AuthApiException
                    ? error.message
                    : error.toString();

                AppHelpers.showSnackBar(context, message);
                logger.error(message);
              },
            ),
          ),
          const Gap(defaultPadding),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: SupaSocialsAuth(
              showSnackBars: false,
              showSuccessSnackBar: false,
              redirectUrl: kIsWeb
                  ? null
                  : 'io.supabase.markethings://login_callback/',
              socialProviders: const [OAuthProvider.google],
              nativeGoogleAuthConfig: NativeGoogleAuthConfig(
                webClientId: Env.googleWebClientId,
              ),
              onSuccess: (session) {
                AppHelpers.showSnackBar(
                  context,
                  "Signed in successfully. Happy shopping!",
                );
                context.pushReplacementNamed(AppRoute.home);
              },
              onError: (error) {
                final message = error is AuthApiException
                    ? error.message
                    : error.toString();

                AppHelpers.showSnackBar(context, message);
                logger.error('Auth error: $error');
              },
            ),
          ),
        ],
      ),
    );
  }
}
