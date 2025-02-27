import 'package:auto_size_text/auto_size_text.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/operation_history/model/operation_history_response_model.dart';

import '../../../../../../../../../../models/currency_model.dart';
import '../../../../../../../../../../providers/currencies_with_hidden_pod/currencies_with_hidden_pod.dart';
import '../../../../../../../../../market_details/helper/currency_from_all.dart';
import '../../../../../../../../../recurring/helper/recurring_buys_operation_name.dart';
import '../../../../../../../../helper/format_date_to_hm.dart';
import '../../../../../../../../helper/is_operation_support_copy.dart';
import '../../../../../../../../helper/operation_name.dart';

class CommonTransactionDetailsBlock extends HookWidget {
  const CommonTransactionDetailsBlock({
    Key? key,
    required this.transactionListItem,
  }) : super(key: key);

  final OperationHistoryItem transactionListItem;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final currency = currencyFromAll(
      useProvider(currenciesWithHiddenPod),
      transactionListItem.assetId,
    );

    return Column(
      children: [
        if (transactionListItem.operationType == OperationType.recurringBuy)
          SPaddingH24(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SIconButton(
                  onTap: () => Navigator.pop(context),
                  defaultIcon: const SBackIcon(),
                  pressedIcon: const SBackPressedIcon(),
                ),
                const SpaceW12(),
                Expanded(
                  child: Text(
                    _transactionHeader(transactionListItem, currency, context),
                    style: sTextH5Style,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  ),
                ),
                const SpaceW12(),
                const _IconPlaceholder(),
              ],
            ),
          ),
        if (transactionListItem.operationType != OperationType.recurringBuy)
          Text(
            _transactionHeader(transactionListItem, currency, context),
            style: sTextH5Style,
          ),
        const SpaceH67(),
        SPaddingH24(
          child: AutoSizeText(
            '${operationAmount(transactionListItem)} ${currency.symbol}',
            textAlign: TextAlign.center,
            minFontSize: 4.0,
            maxLines: 1,
            strutStyle: const StrutStyle(
              height: 1.20,
              fontSize: 40.0,
              fontFamily: 'Gilroy',
            ),
            style: TextStyle(
              height: 1.20,
              fontSize: 40.0,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w600,
              color: colors.black,
            ),
          ),
        ),
        if (transactionListItem.status == Status.completed)
          Text(
            convertToUsd(
              transactionListItem.assetPriceInUsd,
              operationAmount(transactionListItem),
            ),
            style: sBodyText2Style.copyWith(
              color: colors.grey2,
            ),
          ),
        Text(
          '${formatDateToDMY(transactionListItem.timeStamp)} '
          '- ${formatDateToHm(transactionListItem.timeStamp)}',
          style: sBodyText2Style.copyWith(
            color: colors.grey2,
          ),
        ),
        if (isOperationSupportCopy(transactionListItem))
          const SpaceH8()
        else
          const SpaceH72(),
      ],
    );
  }

  String _transactionHeader(
    OperationHistoryItem transactionListItem,
    CurrencyModel currency,
    BuildContext context,
  ) {
    if (transactionListItem.operationType == OperationType.simplexBuy) {
      return '${operationName(OperationType.buy, context)} '
          '${currency.description} - '
          '${operationName(transactionListItem.operationType, context)}';
    } else if (transactionListItem.operationType ==
        OperationType.recurringBuy) {
      return '${recurringBuysOperationByString(
        transactionListItem.recurringBuyInfo!.scheduleType ?? '',
        context,
      )} ${operationName(transactionListItem.operationType, context)}';
    } else if (transactionListItem.operationType ==
        OperationType.earningDeposit || transactionListItem.operationType ==
        OperationType.earningWithdrawal) {
      if (transactionListItem.earnInfo?.totalBalance !=
          transactionListItem.balanceChange.abs() &&
          transactionListItem.operationType == OperationType.earningDeposit) {
        return operationName(
          transactionListItem.operationType,
          context,
          isToppedUp: true,
        );
      }
      return operationName(transactionListItem.operationType, context);
    } else {
      return operationName(transactionListItem.operationType, context);
    }
  }

  String convertToUsd(Decimal assetPriceInUsd, Decimal balance) {
    final usd = assetPriceInUsd * balance;
    if (usd < Decimal.zero) {
      final plusValue = usd.toString().split('-').last;
      return '≈ \$${Decimal.parse(plusValue).toStringAsFixed(2)}';
    }
    return '≈ \$${usd.toStringAsFixed(2)}';
  }

  Decimal operationAmount(OperationHistoryItem transactionListItem) {
    if (transactionListItem.operationType == OperationType.withdraw) {
      return transactionListItem.withdrawalInfo!.withdrawalAmount;
    }
    return transactionListItem.balanceChange;
  }
}

class _IconPlaceholder extends StatelessWidget {
  const _IconPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 24.0,
      height: 24.0,
    );
  }
}
