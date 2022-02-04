import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../helpers/formatting/formatting.dart';
import '../../../../helpers/input_helpers.dart';
import '../../../../models/currency_model.dart';
import '../../../../providers/base_currency_pod/base_currency_model.dart';

part 'currency_buy_state.freezed.dart';

@freezed
class CurrencyBuyState with _$CurrencyBuyState {
  const factory CurrencyBuyState({
    Decimal? targetConversionPrice,
    BaseCurrencyModel? baseCurrency,
    CurrencyModel? selectedCurrency,
    SKeyboardPreset? selectedPreset,
    @Default('0') String inputValue,
    @Default('0') String targetConversionValue,
    @Default('0') String baseConversionValue,
    @Default(false) bool inputValid,
    @Default([]) List<CurrencyModel> currencies,
    @Default(InputError.none) InputError inputError,
  }) = _CurrencyBuyState;

  const CurrencyBuyState._();

  String get selectedCurrencySymbol {
    if (selectedCurrency == null) {
      return baseCurrency!.symbol;
    } else {
      return selectedCurrency!.symbol;
    }
  }

  int get selectedCurrencyAccuracy {
    if (selectedCurrency == null) {
      return baseCurrency!.accuracy;
    } else {
      return selectedCurrency!.accuracy;
    }
  }

  String conversionText(CurrencyModel currency) {
    final target = marketFormat(
      decimal: Decimal.parse(targetConversionValue),
      symbol: currency.symbol,
      prefix: currency.prefixSymbol,
      accuracy: currency.accuracy,
    );

    final base = marketFormat(
      accuracy: baseCurrency!.accuracy,
      prefix: baseCurrency!.prefix,
      decimal: Decimal.parse(baseConversionValue),
      symbol: baseCurrency!.symbol,
    );

    if (selectedCurrency == null) {
      return '≈ $target';
    } else if (selectedCurrency!.symbol == baseCurrency!.symbol) {
      return '≈ $target';
    } else {
      return '≈ $target ($base)';
    }
  }
}
