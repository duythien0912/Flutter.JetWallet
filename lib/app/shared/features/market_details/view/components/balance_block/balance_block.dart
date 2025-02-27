import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/signal_r/model/asset_model.dart';

import '../../../../../../../shared/providers/service_providers.dart';
import '../../../../../../screens/market/model/market_item_model.dart';
import '../../../../../helpers/formatting/formatting.dart';
import '../../../../../models/currency_model.dart';
import '../../../../../providers/base_currency_pod/base_currency_pod.dart';
import '../../../../../providers/currencies_pod/currencies_pod.dart';
import '../../../../recurring/notifier/recurring_buys_notipod.dart';
import '../../../../transaction_history/view/transaction_hisotry.dart';
import '../../../../wallet/helper/navigate_to_wallet.dart';
import '../../../../wallet/notifier/operation_history_notipod.dart';
import '../../../helper/currency_from.dart';
import '../../../helper/swap_words.dart';
import 'components/balance_action_buttons.dart';

class BalanceBlock extends HookWidget {
  const BalanceBlock({
    Key? key,
    required this.marketItem,
  }) : super(key: key);

  final MarketItemModel marketItem;

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final baseCurrency = useProvider(baseCurrencyPod);
    final currency = currencyFrom(
      useProvider(currenciesPod),
      marketItem.associateAsset,
    );
    final transactionHistory = useProvider(
      operationHistoryNotipod(
        marketItem.symbol,
      ),
    );
    final recurringNotifier = useProvider(recurringBuysNotipod.notifier);
    final languageCode = Localizations.localeOf(context).languageCode;
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
            primaryText: sortWordDependingLang(
               text: marketItem.name,
                swappedText :intl.balanceBlock_wallet,
                languageCode: languageCode,
            isCapitalize: true,),
            isRecurring: recurringNotifier.activeOrPausedType(currency.symbol),
            amount: volumeFormat(
              prefix: baseCurrency.prefix,
              decimal: marketItem.baseBalance,
              symbol: baseCurrency.symbol,
              accuracy: baseCurrency.accuracy,
            ),
            secondaryText: volumeFormat(
              prefix: marketItem.prefixSymbol,
              decimal: marketItem.assetBalance,
              symbol: marketItem.symbol,
              accuracy: marketItem.assetAccuracy,
            ),
            onTap: () {
              sAnalytics.walletAssetView(
                Source.assetScreen,
                currency.description,
              );

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
            rightBlockTopPadding: 16,
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
          assetSymbol: marketItem.symbol,
        );
      }
    } else {
      navigateToWallet(context, currency);
    }
  }
}
