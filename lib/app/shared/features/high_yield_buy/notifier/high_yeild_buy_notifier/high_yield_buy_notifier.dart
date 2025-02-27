import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/high_yield/model/calculate_earn_offer_apy/calculate_earn_offer_apy_request_model.dart';
import 'package:simple_networking/shared/models/server_reject_exception.dart';

import '../../../../../../../shared/logging/levels.dart';
import '../../../../../../shared/providers/service_providers.dart';
import '../../../../helpers/calculate_base_balance.dart';
import '../../../../helpers/currencies_helpers.dart';
import '../../../../helpers/input_helpers.dart';
import '../../../../helpers/truncate_zeros_from.dart';
import '../../../../models/currency_model.dart';
import '../../../../models/selected_percent.dart';
import '../../../../providers/base_currency_pod/base_currency_pod.dart';
import '../../../../providers/currencies_pod/currencies_pod.dart';
import '../../model/high_yield_buy_input.dart';
import 'high_yield_buy_state.dart';

class HighYieldBuyNotifier extends StateNotifier<HighYieldBuyState> {
  HighYieldBuyNotifier(this.read, this.input)
      : super(const HighYieldBuyState()) {
    _initCurrencies();
    _initBaseCurrency();
    updateSelectedCurrency(input.currency);
    calculateEarnOfferApy();

    _timer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
      if (state.updateApy) {
        state = state.copyWith(
          updateApy: false,
          updatingNow: true,
        );
        calculateEarnOfferApy();
      }
    });
  }

  final Reader read;
  final HighYieldBuyInput input;
  Timer _timer = Timer(Duration.zero, () {});

  static final _logger = Logger('HighYieldBuyNotifier');

  void _initCurrencies() {
    final currencies = List<CurrencyModel>.from(
      read(currenciesPod),
    );
    sortCurrencies(currencies);
    removeCurrencyFrom(currencies, input.currency);
    state = state.copyWith(currencies: currencies);
  }

  void _initBaseCurrency() {
    state = state.copyWith(
      baseCurrency: read(baseCurrencyPod),
    );
  }

  void tapPreset(String presetName) {
    state = state.copyWith(tappedPreset: presetName);
  }

  void updateSelectedCurrency(CurrencyModel? currency) {
    _logger.log(notifier, 'updateSelectedCurrency');

    state = state.copyWith(selectedCurrency: currency);
    _validateInput();
  }

  void selectPercentFromBalance(SKeyboardPreset preset, {bool topUp = false}) {
    _logger.log(notifier, 'selectPercentFromBalance');

    _updateSelectedPreset(preset);

    final percent = _percentFromPreset(preset);
    final maxAvailable = Decimal.parse('${input.earnOffer.maxAmount.toDouble()
        - input.earnOffer.amount.toDouble()}',);
    final percentageOfAll = valueBasedOnSelectedPercent(
      selected: percent,
      currency: input.currency,
    );

    final value = Decimal.parse(percentageOfAll) > maxAvailable
        ? maxAvailable
        : percentageOfAll;

    _updateInputValue(
      valueAccordingToAccuracy('$value', input.currency.accuracy),
    );
    if (state.inputError == InputError.amountTooLarge ||
        state.inputError == InputError.amountTooLow) {
      _updateInputValid(false);
    } else {
      _validateInput();
    }

    _calculateTargetConversion();
    _calculateBaseConversion();
  }

  void _updateSelectedPreset(SKeyboardPreset preset) {
    state = state.copyWith(selectedPreset: preset);
  }

  SelectedPercent _percentFromPreset(SKeyboardPreset preset) {
    if (preset == SKeyboardPreset.preset1) {
      return SelectedPercent.pct25;
    } else if (preset == SKeyboardPreset.preset2) {
      return SelectedPercent.pct50;
    } else {
      return SelectedPercent.pct100;
    }
  }

  void _updateInputValue(String value) {
    state = state.copyWith(
      inputValue: value,
      updateApy: true,
    );
  }

  void updateInputValue(String value) {
    _logger.log(notifier, 'updateInputValue');
    _validateInput();

    _updateInputValue(
      responseOnInputAction(
        oldInput: state.inputValue,
        newInput: value,
        accuracy: input.currency.accuracy,
      ),
    );
    if (state.inputError == InputError.amountTooLarge ||
        state.inputError == InputError.amountTooLow) {
      _updateInputValid(false);
    } else {
      _validateInput();
    }
    _calculateTargetConversion();
    _calculateBaseConversion();
    _clearPercent();
  }

  void _clearPercent() {
    state = state.copyWith(selectedPreset: null);
  }

  Future<void> calculateEarnOfferApy() async {
    _logger.log(notifier, 'calculateEarnOfferApy');

    final model = CalculateEarnOfferApyRequestModel(
      offerId: input.earnOffer.offerId,
      assetSymbol: state.baseCurrency?.symbol ?? 'USD',
      amount: Decimal.parse(
        state.inputValue == '0'
            ? '0.0000000000001'
            : state.inputValue,
      ),
    );

    try {
      final response = await read(highYieldServicePod).calculateEarnOfferApy(
        model,
        read(intlPod).localeName,
      );

      state = state.copyWith(
        offerId: response.offerId ?? '',
        tiers: response.tiers ?? [],
        amount: response.amount,
        apy: response.apy,
        currentApy: response.currentApy,
        currentBalance: response.currentBalance,
        expectedYearlyProfit: response.expectedYearlyProfit,
        expectedYearlyProfitBaseAsset: response.expectedYearlyProfitBaseAsset,
        amountTooLarge: response.amountTooLarge,
        maxSubscribeAmount: response.maxSubscribeAmount,
        amountTooLow: response.amountTooLow,
        minSubscribeAmount: response.minSubscribeAmount,
        error: false,
        updateApy: false,
        updatingNow: false,
      );

      if (Decimal.parse(state.inputValue) > Decimal.zero) {
        if (response.amountTooLarge) {
          _updateInputError(InputError.amountTooLarge);
          _updateInputValid(false);
        } else if (response.amountTooLow) {
          _updateInputError(InputError.amountTooLow);
          _updateInputValid(false);
        } else {
          _updateInputError(InputError.none);
          _updateInputValid(true);
          _validateInput();
        }
      }
    } on ServerRejectException catch (error) {
      _logger.log(stateFlow, 'calculateEarnOfferApy', error.cause);

      state = state.copyWith(
        error: true,
        updateApy: true,
      );
    } catch (error) {
      _logger.log(stateFlow, 'calculateEarnOfferApy', error);

      state = state.copyWith(
        error: true,
        updateApy: true,
      );
    }
  }

  void updateTargetConversionPrice(Decimal? price) {
    _logger.log(notifier, 'updateTargetConversionPrice');

    // needed to calculate conversion while switching between assets
    _calculateTargetConversion(price);
    state = state.copyWith(targetConversionPrice: price);
  }

  void _updateTargetConversionValue(String value) {
    state = state.copyWith(targetConversionValue: value);
  }

  void _calculateTargetConversion([Decimal? newPrice]) {
    if ((state.targetConversionPrice != null || newPrice != null) &&
        state.inputValue.isNotEmpty) {
      final amount = Decimal.parse(state.inputValue);
      final price = newPrice ?? state.targetConversionPrice!;
      final accuracy = state.selectedCurrencyAccuracy;

      final conversion = amount * price;

      _updateTargetConversionValue(
        truncateZerosFrom(
          conversion.toStringAsFixed(accuracy),
        ),
      );
    } else {
      _updateTargetConversionValue(zero);
    }
  }

  void _updateBaseConversionValue(String value) {
    state = state.copyWith(baseConversionValue: value);
  }

  void _calculateBaseConversion() {
    if (state.inputValue.isNotEmpty) {
      final baseValue = calculateBaseBalanceWithReader(
        read: read,
        assetSymbol: input.currency.symbol,
        assetBalance: Decimal.parse(state.inputValue),
      );

      _updateBaseConversionValue(
        truncateZerosFrom(baseValue.toString()),
      );
    } else {
      _updateBaseConversionValue(zero);
    }
  }

  void _updateInputValid(bool value) {
    state = state.copyWith(inputValid: value);
  }

  void _updateInputError(InputError error) {
    state = state.copyWith(inputError: error);
  }

  void _validateInput() {
    final error = onTradeInputErrorHandler(
      state.inputValue,
      input.currency,
    );

    if (state.selectedCurrency == null) {
      _updateInputValid(false);
    } else {
      if (error == InputError.none) {
        _updateInputValid(
          isInputValid(state.inputValue),
        );
      } else {
        _updateInputValid(false);
      }
    }

    _updateInputError(error);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
