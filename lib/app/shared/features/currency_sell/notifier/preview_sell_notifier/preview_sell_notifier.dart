import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/swap/model/execute_quote/execute_quote_request_model.dart';
import 'package:simple_networking/services/swap/model/get_quote/get_quote_request_model.dart';
import 'package:simple_networking/shared/models/server_reject_exception.dart';

import '../../../../../../../../shared/providers/service_providers.dart';
import '../../../../../../shared/components/result_screens/failure_screen/failure_screen.dart';
import '../../../../../../shared/components/result_screens/success_screen/success_screen.dart';
import '../../../../../../shared/helpers/navigate_to_router.dart';
import '../../../../../../shared/logging/levels.dart';
import '../../../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../../../../screens/navigation/provider/navigation_stpod.dart';
import '../../../../components/quote_updated_dialog.dart';
import '../../model/preview_sell_input.dart';
import '../../view/currency_sell.dart';
import 'preview_sell_state.dart';
import 'preview_sell_union.dart';

class PreviewSellNotifier extends StateNotifier<PreviewSellState> {
  PreviewSellNotifier(
    this.input,
    this.read,
  ) : super(const PreviewSellState()) {
    _context = read(sNavigatorKeyPod).currentContext!;
    _updateFrom(input);
    requestQuote();
  }

  final Reader read;
  final PreviewSellInput input;

  Timer _timer = Timer(Duration.zero, () {});
  late BuildContext _context;

  static final _logger = Logger('PreviewBuyWithAssetNotifier');

  void _updateFrom(PreviewSellInput input) {
    state = state.copyWith(
      fromAssetAmount: Decimal.parse(input.amount),
      fromAssetSymbol: input.fromCurrency.symbol,
      toAssetSymbol: input.toCurrency.symbol,
    );
  }

  Future<void> requestQuote() async {
    _logger.log(notifier, 'requestQuote');

    state = state.copyWith(union: const QuoteLoading());

    final model = GetQuoteRequestModel(
      fromAssetAmount: state.fromAssetAmount,
      fromAssetSymbol: state.fromAssetSymbol!,
      toAssetSymbol: state.toAssetSymbol!,
    );

    try {
      final intl = read(intlPod);
      final response = await read(swapServicePod).getQuote(
        model,
        intl.localeName,
      );

      state = state.copyWith(
        operationId: response.operationId,
        price: response.price,
        fromAssetSymbol: response.fromAssetSymbol,
        toAssetSymbol: response.toAssetSymbol,
        fromAssetAmount: response.fromAssetAmount,
        toAssetAmount: response.toAssetAmount,
        union: const QuoteSuccess(),
        connectingToServer: false,
        feePercent: response.feePercent,
      );

      _refreshTimerAnimation(response.expirationTime);
      _refreshTimer(response.expirationTime);
    } on ServerRejectException catch (error) {
      _logger.log(stateFlow, 'requestQuote', error.cause);

      _showFailureScreen(error);
    } catch (error) {
      _logger.log(stateFlow, 'requestQuote', error);

      state = state.copyWith(
        union: const QuoteLoading(),
        connectingToServer: true,
      );

      _refreshTimer(quoteRetryInterval);
    }
  }

  Future<void> executeQuote() async {
    _logger.log(notifier, 'executeQuote');

    state = state.copyWith(union: const ExecuteLoading());

    final intl = read(intlPod);

    try {
      final model = ExecuteQuoteRequestModel(
        operationId: state.operationId!,
        price: state.price!,
        fromAssetSymbol: state.fromAssetSymbol!,
        toAssetSymbol: state.toAssetSymbol!,
        fromAssetAmount: state.fromAssetAmount,
        toAssetAmount: state.toAssetAmount,
      );

      final response = await read(swapServicePod).executeQuote(
        model,
        intl.localeName,
      );

      if (response.isExecuted) {
        _timer.cancel();
        sAnalytics.sellSuccess();
        _showSuccessScreen();
      } else {
        state = state.copyWith(union: const QuoteSuccess());
        _timer.cancel();
        if (!mounted) return;
        showQuoteUpdatedDialog(
          context: _context,
          onPressed: () => requestQuote(),
        );
      }
    } on ServerRejectException catch (error) {
      _logger.log(stateFlow, 'executeQuote', error.cause);

      _timer.cancel();
      _showFailureScreen(error);
    } catch (error) {
      _logger.log(stateFlow, 'executeQuote', error);

      _timer.cancel();
      _showNoResponseScreen();
    }
  }

  void cancelTimer() {
    _logger.log(notifier, 'cancelTimer');

    _timer.cancel();
  }

  /// Will be triggered during initState of the parent widget
  void updateTimerAnimation(AnimationController controller) {
    state = state.copyWith(timerAnimation: controller);
  }

  /// Will be triggered only when timerAnimation is not Null
  void _refreshTimerAnimation(int duration) {
    state.timerAnimation!.duration = Duration(seconds: duration);
    state.timerAnimation!.countdown();
  }

  void _refreshTimer(int initial) {
    _timer.cancel();
    state = state.copyWith(timer: initial);

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (state.timer == 0) {
          timer.cancel();
          requestQuote();
        } else {
          state = state.copyWith(
            timer: state.timer - 1,
          );
        }
      },
    );
  }

  void _showSuccessScreen() {
    final intl = read(intlPod);

    return SuccessScreen.push(
      context: _context,
      secondaryText: intl.previewSell_orderProcessing,
      then: () {
        read(navigationStpod).state = 1;
      },
    );
  }

  void _showNoResponseScreen() {
    final intl = read(intlPod);

    return FailureScreen.push(
      context: _context,
      primaryText: intl.showNoResponseScreen_text,
      secondaryText: intl.showNoResponseScreen_text2,
      primaryButtonName: intl.serverCode0_ok,
      onPrimaryButtonTap: () {
        read(navigationStpod).state = 1; // Portfolio
        navigateToRouter(read);
      },
    );
  }

  void _showFailureScreen(ServerRejectException error) {
    final intl = read(intlPod);

    return FailureScreen.push(
      context: _context,
      primaryText: intl.previewSell_failure,
      secondaryText: error.cause,
      primaryButtonName: intl.previewSell_editOrder,
      onPrimaryButtonTap: () {
        Navigator.pushAndRemoveUntil(
          _context,
          MaterialPageRoute(
            builder: (_) => CurrencySell(
              currency: input.fromCurrency,
            ),
          ),
          (route) => route.isFirst,
        );
      },
      secondaryButtonName: intl.previewSell_close,
      onSecondaryButtonTap: () => navigateToRouter(read),
    );
  }

  String get previewHeader {
    final intl = read(intlPod);

    return '${intl.previewSell_confirmSell}'
        ' ${input.fromCurrency.description}';
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
