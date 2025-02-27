import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/phone_verification/model/phone_verification/phone_verification_request_model.dart';
import 'package:simple_networking/services/phone_verification/model/phone_verification_verify/phone_verification_verify_request_model.dart';
import 'package:simple_networking/shared/models/server_reject_exception.dart';

import '../../../../../shared/helpers/decompose_phone_number.dart';
import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../view/phone_verification.dart';
import 'phone_verification_state.dart';

class PhoneVerificationNotifier extends StateNotifier<PhoneVerificationState> {
  PhoneVerificationNotifier(
    this.read,
    this.args,
  ) : super(
          PhoneVerificationState(
            loader: StackLoaderNotifier(),
            pinFieldError: StandardFieldErrorNotifier(),
            controller: TextEditingController(),
          ),
        ) {
    _initState();
  }

  final Reader read;
  final PhoneVerificationArgs args;

  static final _logger = Logger('PhoneVerificationNotifier');

  void _initState() {
    _updatePhoneNumber(args.phoneNumber);
    if (args.sendCodeOnInitState) {
      sendCode();
    }
  }

  void updateShowResend({required bool showResend}) {
    _logger.log(notifier, 'updateShowResend');

    state = state.copyWith(showResend: showResend);
  }

  Future<void> sendCode() async {
    await _requestTemplate(
      requestName: 'sendCode',
      body: () async {
        final number = await decomposePhoneNumber(
          state.phoneNumber,
        );

        final model = PhoneVerificationRequestModel(
          locale: read(intlPod).localeName,
          phoneBody: number.body,
          phoneCode: '+${number.dialCode}',
          phoneIso: number.isoCode,
        );

        final intl = read(intlPod);
        await read(phoneVerificationServicePod).request(model, intl.localeName);
      },
    );
  }

  Future<void> verifyCode() async {
    state.loader!.startLoading();

    await _requestTemplate(
      requestName: 'verifyCode',
      body: () async {
        final number = await decomposePhoneNumber(
          state.phoneNumber,
        );

        final model = PhoneVerificationVerifyRequestModel(
          code: state.controller.text,
          phoneBody: number.body,
          phoneCode: '+${number.dialCode}',
          phoneIso: number.isoCode,
        );

        final intl = read(intlPod);
        await read(phoneVerificationServicePod).verify(model, intl.localeName);

        if (!mounted) return;
        args.onVerified();
      },
    );

    state.loader!.finishLoading();
  }

  Future<void> pasteCode() async {
    _logger.log(notifier, 'pasteCode');

    final data = await Clipboard.getData('text/plain');
    final code = data?.text?.trim() ?? '';

    if (code.length == 4) {
      try {
        int.parse(code);
        state.controller.text = code;
      } catch (e) {
        return;
      }
    }
  }

  Future<void> _requestTemplate({
    required String requestName,
    required Future<void> Function() body,
  }) async {
    _logger.log(notifier, requestName);

    try {
      await body();
    } on ServerRejectException catch (e) {
      _logger.log(stateFlow, requestName, e);

      sAnalytics.kycPhoneConfirmFailed(e.cause);
      read(sNotificationNotipod.notifier).showError(
        e.cause,
        id: 1,
      );
    } catch (e) {
      _logger.log(stateFlow, requestName, e);

      final intl = read(intlPod);

      sAnalytics.kycPhoneConfirmFailed(
        intl.something_went_wrong,
      );
      read(sNotificationNotipod.notifier).showError(
        intl.something_went_wrong,
        id: 2,
      );
    }
  }

  void _updatePhoneNumber(String? number) {
    state = state.copyWith(phoneNumber: number ?? '');
  }
}
