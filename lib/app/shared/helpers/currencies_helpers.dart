import 'package:decimal/decimal.dart';

import '../models/currency_model.dart';

/// Used for [BUY] and [SELL] features \
/// Always provide newList to avoid unexpected behaviour
void sortCurrencies(List<CurrencyModel> currencies) {
  // If baseBalance of 2 assets are equal, compare by assetBalance
  currencies.sort((a, b) {
    final compare = b.baseBalance.compareTo(a.baseBalance);
    if (compare != 0) return compare;
    return b.assetBalance.compareTo(a.assetBalance);
  });
}

/// Used for [Convert] feature
/// Always provide a copy of List to avoid unexpected behaviour
void sortCurrenciesByWeight(List<CurrencyModel> currencies) {
  currencies.sort((a, b) {
    final compare = b.weight.compareTo(a.weight);
    if (compare != 0) return compare;
    return b.weight.compareTo(a.weight);
  });
}

List<CurrencyModel> currenciesWithBalance(List<CurrencyModel> currencies) {
  final list = <CurrencyModel>[];

  if (currencies.isNotEmpty) {
    for (final element in currencies) {
      if (element.baseBalance != Decimal.zero) {
        list.add(element);
      }
    }
  }

  return list;
}

List<CurrencyModel> currenciesWithoutBalance(List<CurrencyModel> currencies) {
  final list = <CurrencyModel>[];

  if (currencies.isNotEmpty) {
    for (final element in currencies) {
      if (element.baseBalance == Decimal.zero) {
        list.add(element);
      }
    }
  }

  return list;
}

/// Used for [BUY] feature \
/// Always provide newList to avoid unexpected behaviour
void removeEmptyCurrenciesFrom(List<CurrencyModel> currencies) {
  currencies.removeWhere((element) => element.assetBalance == Decimal.zero);
}

/// Used for [BUY] and [SELL] features \
/// Always provide newList to avoid unexpected behaviour
void removeCurrencyFrom(
  List<CurrencyModel> currencies,
  CurrencyModel currency,
) {
  currencies.removeWhere((element) => element.symbol == currency.symbol);
}
