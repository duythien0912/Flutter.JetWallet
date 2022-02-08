import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../screens/market/model/market_item_model.dart';
import '../../../../../screens/market/provider/market_items_pod.dart';
import '../../../../helpers/formatting/formatting.dart';
import '../../../../providers/base_currency_pod/base_currency_model.dart';
import '../../../../providers/base_currency_pod/base_currency_pod.dart';
import '../../../chart/notifier/chart_notipod.dart';
import '../../../chart/notifier/chart_state.dart';
import '../../../wallet/helper/market_item_from.dart';

class AssetPrice extends HookWidget {
  const AssetPrice({
    Key? key,
    required this.assetId,
    required this.instrumentId,
  }) : super(key: key);

  final String assetId;
  final String instrumentId;

  @override
  Widget build(BuildContext context) {
    final marketItem = marketItemFrom(
      useProvider(marketItemsPod),
      assetId,
    );
    final chart = useProvider(chartNotipod(instrumentId));
    final baseCurrency = useProvider(baseCurrencyPod);

    return SizedBox(
      height: 40,
      child: Baseline(
        baseline: 40.5,
        baselineType: TextBaseline.alphabetic,
        child: Text(
          _price(
            marketItem,
            chart,
            baseCurrency,
          ),
          style: sTextH2Style,
        ),
      ),
    );
  }

  String _price(
    MarketItemModel marketItem,
    ChartState chart,
    BaseCurrencyModel baseCurrency,
  ) {
    if (chart.selectedCandle != null) {
      return marketFormat(
        prefix: baseCurrency.prefix,
        // TODO migrate candles to decimal
        decimal: Decimal.parse(chart.selectedCandle!.close.toString()),
        accuracy: marketItem.priceAccuracy,
        symbol: baseCurrency.symbol,
      );
    } else {
      return marketFormat(
        prefix: baseCurrency.prefix,
        decimal: marketItem.lastPrice,
        accuracy: marketItem.priceAccuracy,
        symbol: baseCurrency.symbol,
      );
    }
  }
}
