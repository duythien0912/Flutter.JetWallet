import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../screens/market/model/currency_model.dart';

part 'currency_buy_state.freezed.dart';

@freezed
class CurrencyBuyState with _$CurrencyBuyState {
  const factory CurrencyBuyState({
    double? targetConversionPrice,
    double? baseConversionPrice,
    CurrencyModel? selectedCurrency,
    @Default('') String inputValue,
    @Default('0') String targetConversionValue,
    @Default('0') String baseConversionValue,
    @Default(false) bool inputValid,
    @Default([]) List<CurrencyModel> currencies,
  }) = _CurrencyBuyState;
}
