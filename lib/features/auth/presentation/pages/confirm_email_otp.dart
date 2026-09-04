import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mt/core/constants/constants.dart';
import 'package:mt/core/router/routes.dart';
import 'package:mt/core/utils/helpers.dart';
import 'package:mt/injection_container.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';

class ConfirmEmailOtp extends StatefulWidget {
  final String email;

  const ConfirmEmailOtp({required this.email, super.key});

  @override
  State<ConfirmEmailOtp> createState() => _ConfirmEmailOtpState();
}

class _ConfirmEmailOtpState extends State<ConfirmEmailOtp> {
  final PinInputController _otpController = PinInputController();
  final _supabase = sl<SupabaseClient>();
  final logger = sl<TalkerLogger>();
  bool _isLoading = false;
  static const _cooldownDuration = Duration(seconds: 60);
  String get _cooldownKey => 'otp_cooldown_${widget.email}';
  int _cooldownSec = 60;
  bool _isResending = false;
  bool _canResend = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadCooldown();
  }

  @override
  void dispose() {
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadCooldown() async {
    final preferences = await SharedPreferences.getInstance();
    final expiryMs = preferences.getInt(_cooldownKey) ?? 0;

    if (!mounted) return;

    final seconds = ((expiryMs - DateTime.now().millisecondsSinceEpoch) / 1000)
        .ceil();

    setState(() {
      _cooldownSec = seconds.clamp(0, _cooldownDuration.inSeconds).toInt();
      _canResend = seconds <= 0;
    });

    if (seconds > 0) {
      _startTimer();
    } else {
      _timer?.cancel();
    }
  }

  Future<void> _startCooldown() async {
    final preferences = await SharedPreferences.getInstance();
    final expiry = DateTime.now().add(_cooldownDuration);

    await preferences.setInt(_cooldownKey, expiry.millisecondsSinceEpoch);

    if (!mounted) return;

    setState(() {
      _cooldownSec = _cooldownDuration.inSeconds;
      _canResend = false;
    });

    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateCooldown();
    });
  }

  Future<void> _updateCooldown() async {
    final preferences = await SharedPreferences.getInstance();
    final expiryMs = preferences.getInt(_cooldownKey) ?? 0;

    final seconds = ((expiryMs - DateTime.now().millisecondsSinceEpoch) / 1000);

    if (!mounted) return;

    setState(() {
      _cooldownSec = seconds.clamp(0, _cooldownDuration.inSeconds).toInt();
      _canResend = seconds <= 0;
    });

    if (seconds <= 0) {
      _timer?.cancel();
    }
  }

  Future<void> _resendOtp() async {
    if (!_canResend || _isResending) return;

    setState(() => _isResending = true);

    try {
      await _supabase.auth.resend(type: OtpType.signup, email: widget.email);

      if (mounted) {
        AppHelpers.showSnackBar(context, 'New verification code sent!');
      }

      await _startCooldown();
    } on AuthException catch (error) {
      if (mounted) {
        AppHelpers.showSnackBar(context, 'Invalid OTP: ${error.message}');
        logger.error('Resend OTP error: $error');
      }
    } finally {
      if (mounted) {
        setState(() => _isResending = false);
      }
    }
  }

  Future<void> _verifyOtp() async {
    setState(() => _isLoading = true);

    try {
      final response = await _supabase.auth.verifyOTP(
        email: widget.email,
        token: _otpController.text.trim(),
        type: OtpType.signup,
      );

      if (response.session != null && mounted) {
        context.pushReplacementNamed(AppRoute.home);
      }
    } on AuthException catch (error) {
      if (mounted) {
        AppHelpers.showSnackBar(context, 'Invalid OTP: ${error.message}');
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
            Form(
              child: MaterialPinFormField(
                length: 6,
                pinController: _otpController,
              ),
            ),
            const Gap(defaultPadding),
            ElevatedButton(
              onPressed: _canResend && !_isResending ? _resendOtp : null,
              child: _isResending
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      _canResend ? 'Resend OTP' : 'Resend in $_cooldownSec s',
                    ),
            ),
            const Gap(defaultPadding),
            ElevatedButton(
              onPressed: !_isLoading ? _verifyOtp : null,
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
