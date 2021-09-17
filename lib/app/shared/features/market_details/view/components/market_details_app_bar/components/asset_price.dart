import 'package:charts/entity/resolution_string_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../../screens/market/model/market_item_model.dart';
import '../../../../../../../screens/market/provider/market_items_pod.dart';
import '../../../../../chart/notifier/chart_notipod.dart';
import '../../../../../chart/notifier/chart_state.dart';
import '../../../../../wallet/helper/market_item_from.dart';
import '../../../../helper/average_period_price.dart';

class AssetPrice extends HookWidget {
  const AssetPrice({
    Key? key,
    required this.assetId,
  }) : super(key: key);

  final String assetId;

  @override
  Widget build(BuildContext context) {
    final marketItem = marketItemFrom(
      useProvider(marketItemsPod),
      assetId,
    );
    final chart = useProvider(chartNotipod);

    return Text(
      _price(
        marketItem,
        chart,
      ),
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 35.sp,
        color: Colors.grey[800],
      ),
    );
  }

  String _price(
    MarketItemModel marketItem,
    ChartState chart,
  ) {
    if (chart.selectedCandle != null) {
      return averagePeriodPrice(
        chart: chart,
        selectedCandle: chart.selectedCandle,
      );
    } else {
      if (chart.resolution != Period.day) {
        return averagePeriodPrice(chart: chart);
      } else {
        return '\$${marketItem.lastPrice}';
      }
    }
  }
}
