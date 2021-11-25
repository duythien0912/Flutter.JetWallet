import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../service/services/signal_r/model/asset_model.dart';
import '../../../helpers/format_currency_amount.dart';
import '../../../providers/base_currency_pod/base_currency_pod.dart';
import '../../../providers/currencies_pod/currencies_pod.dart';
import 'components/send_options.dart';

void showSendAction(BuildContext context) {
  Navigator.pop(context);
  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    maxHeight: 664.h,
    pinned: const SBottomSheetHeader(
      name: 'Choose asset to send',
    ),
    children: [const _ActionSend()],
  );
}

class _ActionSend extends HookWidget {
  const _ActionSend({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final baseCurrency = useProvider(baseCurrencyPod);

    return Column(
      children: [
        for (final currency in context.read(currenciesPod))
          if (currency.isAssetBalanceNotEmpty &&
              currency.type == AssetType.crypto)
            SWalletItem(
              decline: currency.dayPercentChange.isNegative,
              icon: NetworkSvgW24(
                url: currency.iconUrl,
              ),
              primaryText: currency.description,
              amount: formatCurrencyAmount(
                prefix: baseCurrency.prefix,
                value: currency.baseBalance,
                symbol: baseCurrency.symbol,
                accuracy: baseCurrency.accuracy,
              ),
              secondaryText: '${currency.assetBalance} ${currency.symbol}',
              onTap: () {
                showSendOptions(context, currency);
              },
            ),
      ],
    );
  }
}
