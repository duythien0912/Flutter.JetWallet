import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/operation_history/model/operation_history_response_model.dart';

import '../../../../../../../../../../../shared/providers/service_providers.dart';
import '../../../../../../../../../helpers/formatting/formatting.dart';
import '../../../../../../../../../helpers/price_accuracy.dart';
import '../../../../../../../../../helpers/short_address_form.dart';
import '../../../../../../../../../models/currency_model.dart';
import '../../../../../../../../../providers/currencies_pod/currencies_pod.dart';
import '../../../../../../../../market_details/helper/currency_from.dart';
import 'components/transaction_details_item.dart';
import 'components/transaction_details_value_text.dart';

class BuySellDetails extends HookWidget {
  const BuySellDetails({
    Key? key,
    required this.transactionListItem,
    required this.onCopyAction,
  }) : super(key: key);

  final OperationHistoryItem transactionListItem;
  final Function(String) onCopyAction;

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final currencies = useProvider(currenciesPod);

    final buyCurrency = currencyFrom(
      currencies,
      transactionListItem.swapInfo!.buyAssetId,
    );

    final sellCurrency = currencyFrom(
      currencies,
      transactionListItem.swapInfo!.sellAssetId,
    );

    String _rateFor(
      CurrencyModel currency1,
      CurrencyModel currency2,
    ) {
      final accuracy = priceAccuracy(
        context.read,
        currency1.symbol,
        currency2.symbol,
      );

      final base = volumeFormat(
        prefix: currency1.prefixSymbol,
        decimal: transactionListItem.swapInfo!.baseRate,
        accuracy: currency1.accuracy,
        symbol: currency1.symbol,
      );

      final quote = volumeFormat(
        prefix: currency2.prefixSymbol,
        decimal: transactionListItem.swapInfo!.quoteRate,
        accuracy: accuracy,
        symbol: currency2.symbol,
      );

      return '$base = $quote';
    }

    return SPaddingH24(
      child: Column(
        children: [
          TransactionDetailsItem(
            text: '${intl.transaction} ID',
            value: Row(
              children: [
                TransactionDetailsValueText(
                  text: shortAddressForm(transactionListItem.operationId),
                ),
                const SpaceW10(),
                SIconButton(
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(
                        text: transactionListItem.operationId,
                      ),
                    );

                    onCopyAction('${intl.transaction} ID');
                  },
                  defaultIcon: const SCopyIcon(),
                  pressedIcon: const SCopyPressedIcon(),
                ),
              ],
            ),
          ),
          const SpaceH14(),
          if (transactionListItem.operationType == OperationType.buy) ...[
            TransactionDetailsItem(
              text: intl.withText,
              value: TransactionDetailsValueText(
                text: volumeFormat(
                  prefix: sellCurrency.prefixSymbol,
                  decimal: transactionListItem.swapInfo!.sellAmount,
                  accuracy: sellCurrency.accuracy,
                  symbol: sellCurrency.symbol,
                ),
              ),
            ),
            const SpaceH14(),
            TransactionDetailsItem(
              text: intl.fee,
              value: TransactionDetailsValueText(
                text: _feeValue(transactionListItem),
              ),
            ),
            const SpaceH14(),
            TransactionDetailsItem(
              text: intl.buySellDetails_rate,
              value: TransactionDetailsValueText(
                text: _rateFor(buyCurrency, sellCurrency),
              ),
            ),
          ],
          if (transactionListItem.operationType == OperationType.sell) ...[
            TransactionDetailsItem(
              text: intl.buySellDetails_forText,
              value: TransactionDetailsValueText(
                text: volumeFormat(
                  prefix: buyCurrency.prefixSymbol,
                  decimal: transactionListItem.swapInfo!.buyAmount,
                  accuracy: buyCurrency.accuracy,
                  symbol: buyCurrency.symbol,
                ),
              ),
            ),
            const SpaceH14(),
            TransactionDetailsItem(
              text: intl.fee,
              value: TransactionDetailsValueText(
                text: _feeValue(transactionListItem),
              ),
            ),
            const SpaceH14(),
            TransactionDetailsItem(
              text: intl.buySellDetails_rate,
              value: TransactionDetailsValueText(
                text: _rateFor(sellCurrency, buyCurrency),
              ),
            ),
            const SpaceH40(),
          ],
        ],
      ),
    );
  }

  String _feeValue(OperationHistoryItem transactionListItem) {
    if (transactionListItem.swapInfo != null) {
      if (transactionListItem.swapInfo!.feeAmount > Decimal.zero) {
        return '${transactionListItem.swapInfo!.feeAmount}'
            ' ${transactionListItem.swapInfo!.feeAsset}';
      } else {
        return '0 ${transactionListItem.swapInfo!.feeAsset}';
      }
    } else {
      return '0';
    }
  }
}
