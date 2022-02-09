import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../providers/base_currency_pod/base_currency_pod.dart';
import '../../../providers/currencies_pod/currencies_pod.dart';
import 'components/withdraw_options.dart';

void showWithdrawAction(BuildContext context) {
  Navigator.pop(context);
  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    pinned: const SBottomSheetHeader(
      name: 'Choose asset to withdraw',
    ),
    children: [const _ActionWithdraw()],
  );
}

class _ActionWithdraw extends HookWidget {
  const _ActionWithdraw({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final baseCurrency = useProvider(baseCurrencyPod);
    final currencies = useProvider(currenciesPod);

    return Column(
      children: [
        for (final currency in currencies)
          if (currency.isAssetBalanceNotEmpty)
            if (currency.supportsAtLeastOneWithdrawalMethod)
              SWalletItem(
                decline: currency.dayPercentChange.isNegative,
                icon: SNetworkSvg24(
                  url: currency.iconUrl,
                ),
                primaryText: currency.description,
                amount: currency.volumeBaseBalance(baseCurrency),
                secondaryText: currency.volumeAssetBalance,
                onTap: () {
                  showWithdrawOptions(context, currency);
                },
              ),
      ],
    );
  }
}
