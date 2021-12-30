import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../router/notifier/startup_notifier/startup_notipod.dart';
import '../../../../service/services/validation/model/send_email_verification_code_request_model.dart';
import '../../../../service/services/validation/model/verify_email_verification_code_request_model.dart';
import '../../../../service/shared/models/server_reject_exception.dart';
import '../../../../shared/components/result_screens/success_screen/success_screen.dart';
import '../../../../shared/helpers/device_type.dart';
import '../../../../shared/helpers/refresh_token.dart';
import '../../../../shared/logging/levels.dart';
import '../../../../shared/providers/service_providers.dart';
import '../../../shared/notifiers/auth_info_notifier/auth_info_notipod.dart';
import '../view/components/email_confirmed_success_text.dart';
import 'email_verification_state.dart';
import 'email_verification_union.dart';

class EmailVerificationNotifier extends StateNotifier<EmailVerificationState> {
  EmailVerificationNotifier(
    this.read,
  ) : super(
          EmailVerificationState(
            controller: TextEditingController(),
          ),
        ) {
    _context = read(sNavigatorKeyPod).currentContext!;
    _updateEmail(read(authInfoNotipod).email);
  }

  final Reader read;

  late BuildContext _context;

  static final _logger = Logger('EmailVerificationNotifier');

  void updateCode(String? code) {
    _logger.log(notifier, 'updateCode');

    state.controller.text = code ?? '';
  }

  Future<void> resendCode({required Function() onSuccess}) async {
    _logger.log(notifier, 'resendCode');

    _updateIsResending(true);

    try {
      final model = SendEmailVerificationCodeRequestModel(
        language: read(intlPod).localeName,
        deviceType: deviceType,
      );

      await read(validationServicePod).sendEmailVerificationCode(model);

      if (!mounted) return;
      _updateIsResending(false);
      onSuccess();
    } catch (e) {
      _logger.log(stateFlow, 'sendCode', e);
      _updateIsResending(false);
      sShowErrorNotification(
        read(sNotificationQueueNotipod.notifier),
        'Failed to resend. Try again!',
      );
    }
  }

  Future<void> verifyCode() async {
    _logger.log(notifier, 'verifyCode');

    state = state.copyWith(union: const Loading());

    try {
      final model = VerifyEmailVerificationCodeRequestModel(
        code: state.controller.text,
      );

      await read(validationServicePod).verifyEmailVerificationCode(model);

      // Needed force refresh after successful emailVerification
      await refreshToken(read);

      state = state.copyWith(union: const Input());

      if (!mounted) return;

      SuccessScreen.push(
        context: _context,
        specialTextWidget: EmailConfirmedSuccessText(
          email: state.email,
        ),
      );

      read(startupNotipod.notifier).emailVerified();
    } on ServerRejectException catch (error) {
      _logger.log(stateFlow, 'verifyCode', error.cause);

      state = state.copyWith(union: Error(error.cause));
    } catch (error) {
      _logger.log(stateFlow, 'verifyCode', error);

      state = state.copyWith(union: Error(error));
    }
  }

  void _updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void _updateIsResending(bool value) {
    state = state.copyWith(isResending: value);
  }
}
