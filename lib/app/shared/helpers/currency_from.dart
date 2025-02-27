import 'package:decimal/decimal.dart';

import '../models/currency_model.dart';

CurrencyModel currencyFrom(List<CurrencyModel> currencies, String symbol) {
  return currencies.firstWhere(
    (e) => e.symbol == symbol,
    orElse: () {
      return CurrencyModel(
        symbol: symbol,
        accuracy: 8,
        assetBalance: Decimal.zero,
        baseBalance: Decimal.zero,
        currentPrice: Decimal.zero,
        dayPriceChange: Decimal.zero,
        assetTotalEarnAmount: Decimal.zero,
        baseTotalEarnAmount: Decimal.zero,
        assetCurrentEarnAmount: Decimal.zero,
        baseCurrentEarnAmount: Decimal.zero,
        cardReserve: Decimal.zero,
        depositInProcess: Decimal.zero,
        earnInProcessTotal: Decimal.zero,
        buysInProcessTotal: Decimal.zero,
        transfersInProcessTotal: Decimal.zero,
        earnInProcessCount: 0,
        buysInProcessCount: 0,
        transfersInProcessCount: 0,
        apy: Decimal.zero,
        apr: Decimal.zero,
      );
    },
  );
}
