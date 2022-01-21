import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../service/services/signal_r/model/asset_model.dart';
import '../../../../../../screens/market/model/market_item_model.dart';
import '../../../../../helpers/format_currency_amount.dart';
import '../../../../../models/currency_model.dart';
import '../../../../../providers/base_currency_pod/base_currency_pod.dart';
import '../../../../../providers/currencies_pod/currencies_pod.dart';
import '../../../../transaction_history/view/transaction_hisotry.dart';
import '../../../../wallet/helper/navigate_to_wallet.dart';
import '../../../../wallet/notifier/operation_history_notipod.dart';
import '../../../helper/currency_from.dart';
import 'components/balance_action_buttons.dart';

class BalanceBlock extends HookWidget {
  const BalanceBlock({
    Key? key,
    required this.marketItem,
  }) : super(key: key);

  final MarketItemModel marketItem;

  @override
  Widget build(BuildContext context) {
    final baseCurrency = useProvider(baseCurrencyPod);
    final currency = currencyFrom(
      useProvider(currenciesPod),
      marketItem.associateAsset,
    );
    final transactionHistory = useProvider(
      operationHistoryNotipod(
        marketItem.id,
      ),
    );

    return SizedBox(
      height: 156,
      child: Column(
        children: [
          const SDivider(),
          SWalletItem(
            decline: marketItem.dayPercentChange.isNegative,
            icon: SNetworkSvg24(
              url: marketItem.iconUrl,
            ),
            primaryText: '${marketItem.name} wallet',
            amount: formatCurrencyAmount(
              prefix: baseCurrency.prefix,
              value: marketItem.baseBalance,
              symbol: baseCurrency.symbol,
              accuracy: baseCurrency.accuracy,
            ),
            secondaryText: '${marketItem.assetBalance} ${marketItem.id}',
            onTap: () {
              onMarketItemTap(
                context: context,
                marketItem: marketItem,
                currency: currency,
                isIndexTransactionEmpty:
                    transactionHistory.operationHistoryItems.isEmpty,
              );
            },
            removeDivider: true,
            leftBlockTopPadding: _leftBlockTopPadding(),
            balanceTopMargin: 16,
            height: 75,
            showSecondaryText: !marketItem.isBalanceEmpty,
          ),
          BalanceActionButtons(
            marketItem: marketItem,
          ),
          const SpaceH24(),
        ],
      ),
    );
  }

  double _leftBlockTopPadding() {
    if (marketItem.isBalanceEmpty) {
      return 26;
    } else {
      return 16;
    }
  }

  void onMarketItemTap({
    required BuildContext context,
    required MarketItemModel marketItem,
    required CurrencyModel currency,
    required bool isIndexTransactionEmpty,
  }) {
    if (marketItem.type == AssetType.indices) {
      if (!isIndexTransactionEmpty) {
        TransactionHistory.push(
          context: context,
          assetName: marketItem.name,
          assetId: marketItem.id,
        );
      }
    } else {
      navigateToWallet(context, currency);
    }
  }
}
