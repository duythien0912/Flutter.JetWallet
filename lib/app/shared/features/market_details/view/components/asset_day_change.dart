import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../screens/market/model/market_item_model.dart';
import '../../../../providers/base_currency_pod/base_currency_model.dart';
import '../../../../providers/base_currency_pod/base_currency_pod.dart';
import '../../../chart/notifier/asset_chart_input_stpod.dart';
import '../../../chart/notifier/chart_notipod.dart';
import '../../../chart/notifier/chart_state.dart';
import '../../helper/period_change.dart';

class AssetDayChange extends HookWidget {
  const AssetDayChange({
    Key? key,
    required this.marketItem,
  }) : super(key: key);

  final MarketItemModel marketItem;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final chart = useProvider(
      chartNotipod(
        useProvider(assetChartInputStpod(marketItem)).state,
      ),
    );
    final baseCurrency = useProvider(baseCurrencyPod);
    final periodChange = _periodChange(chart, marketItem, baseCurrency);

    return SizedBox(
      height: 24,
      child: Baseline(
        baseline: 24,
        baselineType: TextBaseline.alphabetic,
        child: Text(
          periodChange,
          style: sSubtitle3Style.copyWith(
            color: periodChange.contains('-') ? colors.red : colors.green,
          ),
        ),
      ),
    );
  }

  String _periodChange(
    ChartState chart,
    MarketItemModel marketItem,
    BaseCurrencyModel baseCurrency,
  ) {
    if (chart.selectedCandle != null) {
      return periodChange(
        chart: chart,
        selectedCandle: chart.selectedCandle,
        baseCurrency: baseCurrency,
        marketItem: marketItem,
      );
    } else {
      return periodChange(
        chart: chart,
        baseCurrency: baseCurrency,
        marketItem: marketItem,
      );
    }
  }
}
