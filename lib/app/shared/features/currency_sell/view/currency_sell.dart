import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../service/services/signal_r/model/asset_model.dart';
import '../../../../../shared/helpers/navigator_push.dart';
import '../../../helpers/format_currency_string_amount.dart';
import '../../../helpers/input_helpers.dart';
import '../../../models/currency_model.dart';
import '../../../providers/converstion_price_pod/conversion_price_input.dart';
import '../../../providers/converstion_price_pod/conversion_price_pod.dart';
import '../model/preview_sell_input.dart';
import '../notifier/currency_sell_notifier/currency_sell_notipod.dart';
import 'preview_sell.dart';

class CurrencySell extends HookWidget {
  const CurrencySell({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final state = useProvider(currencySellNotipod(currency));
    final notifier = useProvider(currencySellNotipod(currency).notifier);
    useProvider(
      conversionPriceFpod(
        ConversionPriceInput(
          baseAssetSymbol: currency.symbol,
          quotedAssetSymbol: state.selectedCurrencySymbol,
          then: notifier.updateTargetConversionPrice,
        ),
      ),
    );

    void _showAssetSelector() {
      sShowBasicModalBottomSheet(
        scrollable: true,
        pinned: const SBottomSheetHeader(
          name: 'For',
        ),
        children: [
          for (final currency in state.currencies)
            if (currency.type == AssetType.crypto)
              SAssetItem(
                isSelected: currency == state.selectedCurrency,
                icon: SNetworkSvg24(
                  color: currency == state.selectedCurrency
                      ? colors.blue
                      : colors.black,
                  url: currency.iconUrl,
                ),
                name: currency.description,
                amount: currency.formatBaseBalance(
                  state.baseCurrency!,
                ),
                description: currency.formattedAssetBalance,
                onTap: () => Navigator.pop(context, currency),
              )
            else
              SFiatItem(
                isSelected: currency == state.selectedCurrency,
                icon: SNetworkSvg24(
                  color: currency == state.selectedCurrency
                      ? colors.blue
                      : colors.black,
                  url: currency.iconUrl,
                ),
                name: currency.description,
                amount: currency.formatBaseBalance(
                  state.baseCurrency!,
                ),
                onTap: () => Navigator.pop(context, currency),
              ),
          const SpaceH40(),
        ],
        context: context,
        then: (value) {
          if (value is CurrencyModel) {
            if (value != state.selectedCurrency) {
              if (value.symbol != state.baseCurrency!.symbol) {
                notifier.updateTargetConversionPrice(null);
              }
              notifier.updateSelectedCurrency(value);
            }
          }
        },
      );
    }

    return SPageFrame(
      header: SPaddingH24(
        child: SSmallHeader(
          title: 'Sell ${currency.description}',
        ),
      ),
      child: Column(
        children: [
          SActionPriceField(
            price: formatCurrencyStringAmount(
              prefix: currency.prefixSymbol,
              value: state.inputValue,
              symbol: currency.symbol,
            ),
            helper: state.conversionText(),
            error: state.inputError.value,
            isErrorActive: state.inputError.isActive,
          ),
          SBaselineChild(
            baseline: 24.0,
            child: Text(
              'Available: ${currency.formattedAssetBalance}',
              style: sSubtitle3Style.copyWith(
                color: colors.grey2,
              ),
            ),
          ),
          const Spacer(),
          const SpaceH4(),
          if (state.selectedCurrency == null)
            SPaymentSelectDefault(
              icon: const SActionWithdrawIcon(),
              name: 'Choose destination',
              onTap: () => _showAssetSelector(),
            )
          else if (state.selectedCurrency!.type == AssetType.crypto)
            SPaymentSelectAsset(
              icon: SNetworkSvg24(
                url: state.selectedCurrency!.iconUrl,
              ),
              name: state.selectedCurrency!.description,
              amount: state.selectedCurrency!.formatBaseBalance(
                state.baseCurrency!,
              ),
              description: state.selectedCurrency!.formattedAssetBalance,
              onTap: () => _showAssetSelector(),
            )
          else
            SPaymentSelectFiat(
              icon: SNetworkSvg24(
                url: state.selectedCurrency!.iconUrl,
              ),
              name: state.selectedCurrency!.description,
              amount: state.selectedCurrency!.formatBaseBalance(
                state.baseCurrency!,
              ),
              onTap: () => _showAssetSelector(),
            ),
          const SpaceH20(),
          SNumericKeyboardAmount(
            preset1Name: '25%',
            preset2Name: '50%',
            preset3Name: 'MAX',
            selectedPreset: state.selectedPreset,
            onPresetChanged: (preset) {
              notifier.selectPercentFromBalance(preset);
            },
            onKeyPressed: (value) {
              notifier.updateInputValue(value);
            },
            buttonType: SButtonType.primary2,
            submitButtonActive: state.inputValid,
            submitButtonName: 'Preview Sell',
            onSubmitPressed: () {
              navigatorPush(
                context,
                PreviewSell(
                  input: PreviewSellInput(
                    amount: state.inputValue,
                    fromCurrency: currency,
                    toCurrency: state.selectedCurrency!,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
