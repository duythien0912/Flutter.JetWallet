import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/operation_history/model/operation_history_request_model.dart';
import 'package:simple_networking/services/operation_history/model/operation_history_response_model.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/providers/service_providers.dart';
import 'operation_history_state.dart';
import 'operation_history_union.dart';

class OperationHistoryNotifier extends StateNotifier<OperationHistoryState> {
  OperationHistoryNotifier({
    required this.read,
    required this.assetId,
  }) : super(
          const OperationHistoryState(
            operationHistoryItems: [],
          ),
        );

  final Reader read;
  final String? assetId;

  static final _logger = Logger('OperationHistoryNotifier');

  Future<void> initOperationHistory() async {
    _logger.log(notifier, 'initOperationHistory');

    try {
      final operationHistory = await _requestOperationHistory(
        OperationHistoryRequestModel(
          assetId: assetId,
          batchSize: 20,
        ),
      );

      _updateOperationHistory(operationHistory.operationHistory);
    } catch (e) {
      _logger.log(stateFlow, 'initOperationHistory', e);

      final intl = read(intlPod);
      read(sNotificationNotipod.notifier).showError(
        intl.something_went_wrong,
        id: 1,
      );

      state = state.copyWith(union: const Error());
    }
  }

  Future<void> operationHistory(String? assetId) async {
    _logger.log(notifier, 'operationHistory');

    try {
      final operationHistory = await _requestOperationHistory(
        OperationHistoryRequestModel(
          assetId: assetId,
          batchSize: 20,
          lastDate: state.operationHistoryItems.last.timeStamp,
        ),
      );

      _updateOperationHistory(operationHistory.operationHistory);
    } catch (e) {
      _logger.log(stateFlow, 'operationHistory', e);

      final intl = read(intlPod);
      read(sNotificationNotipod.notifier).showError(
        intl.something_went_wrong,
        id: 2,
      );

      state = state.copyWith(union: const Error());
    }
  }

  void _updateOperationHistory(List<OperationHistoryItem> items) {
    if (items.isEmpty) {
      state = state.copyWith(
        nothingToLoad: true,
        union: const Loaded(),
      );
    } else {
      state = state.copyWith(
        operationHistoryItems: state.operationHistoryItems +
            _filterUnusedOperationTypeItemsFrom(items),
        union: const Loaded(),
      );
    }
  }

  Future<OperationHistoryResponseModel> _requestOperationHistory(
    OperationHistoryRequestModel model,
  ) {
    state = state.copyWith(union: const Loading());
    final intl = read(intlPod);

    return read(operationHistoryServicePod).operationHistory(
      model,
      intl.localeName,
    );
  }
}

// TODO(Vova): remove when all types will be properly sorted on the backend.
List<OperationHistoryItem> _filterUnusedOperationTypeItemsFrom(
  List<OperationHistoryItem> items,
) {
  final filteredItems = items
      .where(
    (item) =>
        item.operationType == OperationType.deposit ||
        item.operationType == OperationType.withdraw ||
        item.operationType == OperationType.swap ||
        item.operationType == OperationType.transferByPhone ||
        item.operationType == OperationType.receiveByPhone ||
        item.operationType == OperationType.paidInterestRate ||
        item.operationType == OperationType.feeSharePayment ||
        item.operationType == OperationType.rewardPayment ||
        item.operationType == OperationType.simplexBuy ||
        item.operationType == OperationType.recurringBuy ||
        item.operationType == OperationType.earningDeposit ||
        item.operationType == OperationType.earningWithdrawal ||
        item.operationType == OperationType.cryptoInfo,
  )
      .map((item) {
    if (item.operationType == OperationType.swap) {
      return item.copyWith(
        operationType:
            item.swapInfo!.isSell ? OperationType.sell : OperationType.buy,
      );
    } else {
      return item;
    }
  }).toList();

  return filteredItems;
}
