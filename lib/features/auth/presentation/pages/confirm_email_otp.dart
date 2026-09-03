import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mt/core/constants/constants.dart';
import 'package:mt/core/router/routes.dart';
import 'package:mt/injection_container.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';

class ConfirmEmailOtp extends StatefulWidget {
  final String email;

  const ConfirmEmailOtp({required this.email, super.key});

  @override
  State<ConfirmEmailOtp> createState() => _ConfirmEmailOtpState();
}

class _ConfirmEmailOtpState extends State<ConfirmEmailOtp> {
  final _otpController = TextEditingController();
  final _supabase = sl<SupabaseClient>();
  final logger = sl<TalkerLogger>();
  bool _isLoading = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    setState(() => _isLoading = true);

    try {
      final response = await _supabase.auth.verifyOTP(
        email: widget.email,
        token: _otpController.text.trim(),
        type: OtpType.signup,
      );

      if (response.session != null) {
        if (mounted) {
          context.pushReplacementNamed(AppRoute.home);
        }
      }
    } on AuthException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid OTP: ${error.message}')),
        );
        logger.error('OTP verification error: $error');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter the OTP sent to ${widget.email}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Gap(defaultPadding),
            const MaterialPinField(
              length: 6,
              theme: MaterialPinTheme(
                shape: MaterialPinShape.outlined,
                cellSize: Size(46, 54),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
            const Gap(defaultPadding),
            ElevatedButton(
              onPressed: _isLoading ? null : _verifyOtp,
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
