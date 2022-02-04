import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../../shared/features/market_details/view/market_details.dart';
import '../../../../../../shared/helpers/formatting/formatting.dart';
import '../../../../../../shared/providers/base_currency_pod/base_currency_pod.dart';
import '../../../../model/market_item_model.dart';

class MarketList extends HookWidget {
  const MarketList({
    Key? key,
    required this.items,
  }) : super(key: key);

  final List<MarketItemModel> items;

  @override
  Widget build(BuildContext context) {
    final baseCurrency = useProvider(baseCurrencyPod);

    return ListView.builder(
      itemCount: items.length,
      padding: const EdgeInsets.only(bottom: 66),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        final item = items[index];

        return SMarketItem(
          icon: SNetworkSvg24(
            url: item.iconUrl,
          ),
          name: item.name,
          price: marketFormat(
            prefix: baseCurrency.prefix,
            decimal: item.lastPrice,
            symbol: baseCurrency.symbol,
            accuracy: item.priceAccuracy,
          ),
          ticker: item.symbol,
          last: item == items.last,
          percent: item.dayPercentChange,
          onTap: () {
            navigatorPush(
              context,
              MarketDetails(
                marketItem: item,
              ),
            );
          },
        );
      },
    );
  }
}
