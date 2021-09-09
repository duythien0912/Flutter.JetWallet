import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../../service/services/blockchain/model/withdraw/withdraw_request_model.dart';
import '../../../../../../service/shared/models/server_reject_exception.dart';
import '../../../../../../shared/components/result_screens/failure_screens/failure_screen.dart';
import '../../../../../../shared/components/result_screens/failure_screens/no_response_from_server.dart';
import '../../../../../../shared/helpers/navigate_to_router.dart';
import '../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../../shared/logging/levels.dart';
import '../../../../../../shared/providers/other/navigator_key_pod.dart';
import '../../../../../../shared/providers/service_providers.dart';
import '../../../../../screens/navigation/provider/navigation_stpod.dart';
import '../../../../models/currency_model.dart';
import '../../view/screens/withdrawal_amount.dart';
import '../../view/screens/withdrawal_confirm.dart';
import '../withdrawal_amount_notifier/withdrawal_amount_notipod.dart';
import 'withdrawal_preview_state.dart';

/// Performs withdrawal operation and process response
class WithdrawalPreviewNotifier extends StateNotifier<WithdrawalPreviewState> {
  WithdrawalPreviewNotifier(
    this.read,
    this.currency,
  ) : super(const WithdrawalPreviewState()) {
    final amount = read(withdrawalAmountNotipod(currency));

    state = state.copyWith(
      tag: amount.tag,
      address: amount.address,
      amount: amount.amount,
    );

    _context = read(navigatorKeyPod).currentContext!;
  }

  final Reader read;
  final CurrencyModel currency;

  late BuildContext _context;

  static final _logger = Logger('WithdrawalPreviewNotifier');

  Future<void> withdraw() async {
    _logger.log(notifier, 'withdraw');

    state = state.copyWith(loading: true);

    try {
      final model = WithdrawRequestModel(
        requestId: DateTime.now().microsecondsSinceEpoch.toString(),
        assetSymbol: currency.symbol,
        amount: double.parse(state.amount), // TODO - fee
        toAddress: state.address,
      );

      final response = await read(blockchainServicePod).withdraw(model);

      _updateOperationId(response.operationId);

      _showWithdrawConfirm();
    } on ServerRejectException catch (error) {
      _logger.log(stateFlow, 'withdraw', error.cause);

      _showFailureScreen(error);
    } catch (error) {
      _logger.log(stateFlow, 'withdraw', error);

      _showNoResponseScreen();
    }

    state = state.copyWith(loading: false);
  }

  void _updateOperationId(String value) {
    state = state.copyWith(operationId: value);
  }

  void _showWithdrawConfirm() {
    navigatorPush(
      _context,
      WithdrawalConfirm(
        currency: currency,
      ),
    );
  }

  void _showNoResponseScreen() {
    navigatorPush(
      _context,
      NoResponseFromServer(
        description: 'Failed to place Order',
        onOk: () {
          read(navigationStpod).state = 1; // Portfolio
          navigateToRouter(read(navigatorKeyPod));
        },
      ),
    );
  }

  void _showFailureScreen(ServerRejectException error) {
    navigatorPush(
      _context,
      FailureScreen(
        description: error.cause,
        firstButtonName: 'Edit Order',
        onFirstButton: () {
          Navigator.pushAndRemoveUntil(
            _context,
            MaterialPageRoute(
              builder: (_) => WithdrawalAmount(currency: currency),
            ),
            (route) => route.isFirst,
          );
        },
        secondButtonName: 'Close',
        onSecondButton: () => navigateToRouter(read(navigatorKeyPod)),
      ),
    );
  }
}
