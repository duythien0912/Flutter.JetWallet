import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../../shared/features/market_details/view/market_details.dart';
import '../../../../../../shared/helpers/formatting/formatting.dart';
import '../../../../../../shared/providers/base_currency_pod/base_currency_pod.dart';
import '../../../../notifier/watchlist/watchlist_notipod.dart';
import '../../../../provider/market_watchlist_items_pod.dart';

class MarketReorderableList extends HookWidget {
  const MarketReorderableList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = useProvider(marketWatchlistItemsPod);
    final notifier = useProvider(watchlistIdsNotipod.notifier);
    final baseCurrency = useProvider(baseCurrencyPod);
    final colors = useProvider(sColorPod);

    return ColoredBox(
      color: colors.white,
      child: ReorderableListView.builder(
        itemCount: items.length,
        padding: const EdgeInsets.only(bottom: 66),
        itemBuilder: (context, index) {
          final item = items[index];

          return SMarketItem(
            key: Key(
              '${items[index].weight}',
            ),
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
        onReorder: (int oldIndex, int newIndex) {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }

          notifier.changePosition(oldIndex, newIndex);
        },
      ),
    );
  }
}
