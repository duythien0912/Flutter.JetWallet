import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_networking/services/operation_history/model/operation_history_response_model.dart';

import '../../../../../shared/providers/service_providers.dart';

String operationName(
  OperationType type,
  BuildContext context, {
  bool? isToppedUp,
}) {
  final intl = context.read(intlPod);

  switch (type) {
    case OperationType.deposit:
      return intl.operationName_deposit;
    case OperationType.withdraw:
      return intl.operationName_withdrawal;
    case OperationType.transferByPhone:
      return intl.operationName_transferByPhone;
    case OperationType.receiveByPhone:
      return intl.operationName_receiveByPhone;
    case OperationType.buy:
      return intl.operationName_buy;
    case OperationType.sell:
      return intl.operationName_sell;
    case OperationType.paidInterestRate:
      return intl.operationName_interestRate;
    case OperationType.feeSharePayment:
      return intl.operationName_feeSharePayment;
    case OperationType.swap:
      return intl.operationName_swap;
    case OperationType.withdrawalFee:
      return intl.operationName_withdrawalFee;
    case OperationType.rewardPayment:
      return intl.operationName_rewardPayment;
    case OperationType.simplexBuy:
      return intl.operationName_simplex;
    case OperationType.recurringBuy:
      return intl.account_recurringBuy;
    case OperationType.earningDeposit:
      return isToppedUp != null
          ? intl.operationName_topped_up
          : intl.operationName_subscribed_to_earn;
    case OperationType.cryptoInfo:
      return intl.operationName_buyWithCard;
    case OperationType.earningWithdrawal:
      return intl.operationName_return_from_earn;
    case OperationType.unknown:
      return 'Unknown';
  }
}
