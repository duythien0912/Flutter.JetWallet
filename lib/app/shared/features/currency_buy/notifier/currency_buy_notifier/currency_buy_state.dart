import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/circle/model/circle_card.dart';
import 'package:simple_networking/services/signal_r/model/asset_payment_methods.dart';
import 'package:simple_networking/services/signal_r/model/card_limits_model.dart';
import 'package:simple_networking/services/swap/model/get_quote/get_quote_request_model.dart';

import '../../../../helpers/formatting/formatting.dart';
import '../../../../helpers/input_helpers.dart';
import '../../../../models/currency_model.dart';
import '../../../../providers/base_currency_pod/base_currency_model.dart';
import '../../model/formatted_circle_card.dart';

part 'currency_buy_state.freezed.dart';

@freezed
class CurrencyBuyState with _$CurrencyBuyState {
  const factory CurrencyBuyState({
    CardLimitsModel? cardLimit,
    Decimal? targetConversionPrice,
    BaseCurrencyModel? baseCurrency,
    CircleCard? pickedCircleCard,
    FormattedCircleCard? selectedCircleCard,
    PaymentMethod? selectedPaymentMethod,
    CurrencyModel? selectedCurrency,
    SKeyboardPreset? selectedPreset,
    String? tappedPreset,
    String? paymentMethodInputError,
    @Default(RecurringBuysType.oneTimePurchase)
        RecurringBuysType recurringBuyType,
    @Default('0') String inputValue,
    @Default('0') String targetConversionValue,
    @Default('0') String baseConversionValue,
    @Default(false) bool inputValid,
    @Default([]) List<CurrencyModel> currencies,
    @Default([]) List<CircleCard> circleCards,
    @Default(InputError.none) InputError inputError,
    required StackLoaderNotifier loader,
  }) = _CurrencyBuyState;

  const CurrencyBuyState._();

  String get preset1Name {
    if (selectedPaymentMethod != null) {
      return '\$50';
    } else {
      return '25%';
    }
  }

  String get preset2Name {
    if (selectedPaymentMethod != null) {
      return '\$100';
    } else {
      return '50%';
    }
  }

  String get preset3Name {
    if (selectedPaymentMethod != null) {
      return '\$500';
    } else {
      return 'MAX';
    }
  }

  bool get isInputErrorActive {
    if (inputError.isActive) {
      return true;
    } else {
      if (paymentMethodInputError != null) {
        return true;
      } else {
        return false;
      }
    }
  }

  String get inputErrorValue {
    if (paymentMethodInputError != null) {
      return paymentMethodInputError!;
    } else {
      return inputError.value();
    }
  }

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
    final target = volumeFormat(
      decimal: Decimal.parse(targetConversionValue),
      symbol: currency.symbol,
      prefix: currency.prefixSymbol,
      accuracy: currency.accuracy,
    );

    final base = volumeFormat(
      accuracy: baseCurrency!.accuracy,
      prefix: baseCurrency!.prefix,
      decimal: Decimal.parse(baseConversionValue),
      symbol: baseCurrency!.symbol,
    );

    if (selectedPaymentMethod?.type == PaymentMethodType.simplex) {
      return '';
    }

    if (selectedCurrency == null) {
      return '≈ $target';
    } else if (selectedCurrency!.symbol == baseCurrency!.symbol) {
      return '≈ $target';
    } else {
      return '≈ $target ($base)';
    }
  }

  bool get isOneTimePurchaseOnly {
    final cond1 = selectedPaymentMethod?.type == PaymentMethodType.simplex;
    final cond2 = selectedPaymentMethod?.type == PaymentMethodType.circleCard;
    final cond3 = selectedPaymentMethod?.type == PaymentMethodType.unlimintCard;

    return cond1 || cond2 || cond3;
  }
}
