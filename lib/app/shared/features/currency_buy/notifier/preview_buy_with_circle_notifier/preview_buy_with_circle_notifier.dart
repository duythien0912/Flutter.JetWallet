import 'dart:async';
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:openpgp/openpgp.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/circle/model/create_payment/create_payment_request_model.dart';
import 'package:simple_networking/services/circle/model/create_payment/create_payment_response_model.dart';
import 'package:simple_networking/services/circle/model/payment_info/payment_info_request_model.dart';
import 'package:simple_networking/services/circle/model/payment_info/payment_info_response_model.dart';
import 'package:simple_networking/services/circle/model/payment_preview/payment_preview_request_model.dart';
import 'package:simple_networking/shared/models/server_reject_exception.dart';
import 'package:uuid/uuid.dart';

import '../../../../../../shared/components/result_screens/failure_screen/failure_screen.dart';
import '../../../../../../shared/helpers/navigate_to_router.dart';
import '../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../../shared/logging/levels.dart';
import '../../../../../../shared/providers/service_providers.dart';
import '../../model/preview_buy_with_circle_input.dart';
import '../../view/screens/preview_buy_with_circle/circle_web_view/circle_web_view.dart';
import 'preview_buy_with_circle_state.dart';

class PreviewBuyWithCircleNotifier
    extends StateNotifier<PreviewBuyWithCircleState> {
  PreviewBuyWithCircleNotifier(
    this.input,
    this.read,
  ) : super(PreviewBuyWithCircleState(loader: StackLoaderNotifier())) {
    _context = read(sNavigatorKeyPod).currentContext!;
    _intl = read(intlPod);
    _initState();
    _requestPreview();
  }

  final Reader read;
  final PreviewBuyWithCircleInput input;

  late BuildContext _context;
  late AppLocalizations _intl;

  static final _logger = Logger('PreviewBuyWithCircleNotifier');

  void _initState() {
    state = state.copyWith(
      amountToGet: Decimal.parse(input.amount),
      amountToPay: Decimal.parse(input.amount),
      card: input.card,
    );
  }

  Future<void> _requestPreview() async {
    state.loader.startLoadingImmediately();

    final model = PaymentPreviewRequestModel(
      cardId: state.card!.id,
      amount: Decimal.parse(input.amount),
      currencySymbol: input.currency.symbol,
    );

    try {
      final response = await read(circleServicePod).paymentPreview(
        model,
        _intl.localeName,
      );

      state = state.copyWith(
        amountToPay: response.amount,
        currencySymbol: response.currencySymbol,
        feeAmount: response.feeAmount,
        feePercentage: response.feePercentage,
      );
    } on ServerRejectException catch (error) {
      _logger.log(stateFlow, 'requestPreview', error.cause);

      _showFailureScreen(error.cause);
    } catch (error) {
      _logger.log(stateFlow, 'requestPreview', error);

      _showFailureScreen(_intl.something_went_wrong);
    } finally {
      state.loader.finishLoading();
    }
  }

  Future<void> createPayment() async {
    _logger.log(notifier, 'createPayment');

    state.loader.startLoadingImmediately();

    await _requestPayment(() async {
      await _requestPaymentInfo((url) {
        if (!mounted) return;
        navigatorPush(_context, CircleWebView(url));
        state.loader.finishLoadingImmediately();
      });
    });
  }

  Future<void> _requestPayment(void Function() onSuccess) async {
    _logger.log(notifier, '_requestPayment');

    try {
      final encryption =
          await read(circleServicePod).encryptionKey(_intl.localeName);

      final base64Decoded = base64Decode(encryption.encryptionKey);
      final utf8Decoded = utf8.decode(base64Decoded);
      final encrypted = await OpenPGP.encrypt('{${state.cvv}}', utf8Decoded);
      final utf8Encoded = utf8.encode(encrypted);
      final base64Encoded = base64Encode(utf8Encoded);

      final model = CreatePaymentRequestModel(
        requestGuid: const Uuid().v4(),
        keyId: encryption.keyId,
        cardId: state.card!.id,
        amount: state.amountToPay!,
        currencySymbol: state.currencySymbol,
        encryptedData: base64Encoded,
      );

      final response = await read(circleServicePod).createPayment(
        model,
        _intl.localeName,
      );

      if (response.status == CirclePaymentStatus.ok) {
        state = state.copyWith(depositId: response.depositId);
        onSuccess();
      } else {
        throw ServerRejectException(response.status.toString());
      }
    } on ServerRejectException catch (error) {
      _logger.log(stateFlow, '_requestPayment', error.cause);

      _showFailureScreen(error.cause);
    } catch (error) {
      _logger.log(stateFlow, '_requestPayment', error);

      _showFailureScreen(_intl.something_went_wrong);
    }
  }

  Future<void> _requestPaymentInfo(void Function(String) onSuccess) async {
    _logger.log(notifier, '_requestPaymentInfo');

    try {
      final model = PaymentInfoRequestModel(
        depositId: state.depositId,
      );

      final response = await read(circleServicePod).paymentInfo(
        model,
        _intl.localeName,
      );

      if (response.status == PaymentStatus.confirmed) {
        onSuccess(response.redirectUrl);
      } else {
        throw ServerRejectException(response.status.toString());
      }
    } on ServerRejectException catch (error) {
      _logger.log(stateFlow, '_requestPaymentInfo', error.cause);

      _showFailureScreen(error.cause);
    } catch (error) {
      _logger.log(stateFlow, '_requestPaymentInfo', error);

      _showFailureScreen(_intl.something_went_wrong);
    }
  }

  // void _showSuccessScreen() {
  //   final intl = read(intlPod);

  //   return SuccessScreen.push(
  //     context: _context,
  //     secondaryText: intl.previewBuyWithAsset_orderProcessing,
  //     then: () {
  //       read(navigationStpod).state = 1;
  //     },
  //   );
  // }

  // void _showNoResponseScreen() {
  //   final intl = read(intlPod);

  //   return FailureScreen.push(
  //     context: _context,
  //     primaryText: intl.showNoResponseScreen_text,
  //     secondaryText: intl.showNoResponseScreen_text2,
  //     primaryButtonName: intl.serverCode0_ok,
  //     onPrimaryButtonTap: () {
  //       read(navigationStpod).state = 1; // Portfolio
  //       navigateToRouter(read);
  //     },
  //   );
  // }

  void _showFailureScreen(String error) {
    final intl = read(intlPod);

    return FailureScreen.push(
      context: _context,
      primaryText: intl.previewBuyWithAsset_failure,
      secondaryText: error,
      primaryButtonName: intl.previewBuyWithAsset_editOrder,
      onPrimaryButtonTap: () {
        Navigator.pop(_context);
        Navigator.pop(_context);
      },
      secondaryButtonName: intl.previewBuyWithAsset_close,
      onSecondaryButtonTap: () => navigateToRouter(read),
    );
  }
}
