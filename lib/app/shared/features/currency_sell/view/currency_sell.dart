import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/signal_r/model/asset_model.dart';

import '../../../../../shared/helpers/navigator_push.dart';
import '../../../../../shared/helpers/widget_size_from.dart';
import '../../../../../shared/providers/device_size/device_size_pod.dart';
import '../../../../../shared/providers/service_providers.dart';
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
    final deviceSize = useProvider(deviceSizePod);
    final intl = useProvider(intlPod);
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

    final assetWithBalance = <CurrencyModel>[];
    final assetWithOutBalance = <CurrencyModel>[];

    for (final currency in state.currencies) {
      if (currency.baseBalance != Decimal.zero) {
        assetWithBalance.add(currency);
      } else {
        assetWithOutBalance.add(currency);
      }
    }

    void _showAssetSelector(BuildContext context) {
      final intl = context.read(intlPod);
      sAnalytics.sellForView();

      sShowBasicModalBottomSheet(
        scrollable: true,
        pinned: SBottomSheetHeader(
          name: intl.currencySell_forText,
        ),
        children: [
          for (final currency in assetWithBalance)
            SAssetItem(
              isSelected: currency == state.selectedCurrency,
              icon: (currency.type == AssetType.indices)
                  ? SNetworkSvg24(
                      url: currency.iconUrl,
                    )
                  : SNetworkSvg24(
                      color: currency == state.selectedCurrency
                          ? colors.blue
                          : colors.black,
                      url: currency.iconUrl,
                    ),
              name: currency.description,
              amount: currency.volumeBaseBalance(
                state.baseCurrency!,
              ),
              description: currency.volumeAssetBalance,
              onTap: () => Navigator.pop(context, currency),
              divider: currency != assetWithBalance.last,
            ),
          for (final currency in assetWithOutBalance)
            SAssetItem(
              isSelected: currency == state.selectedCurrency,
              icon: (currency.type == AssetType.indices)
                  ? SNetworkSvg24(
                      url: currency.iconUrl,
                    )
                  : SNetworkSvg24(
                      color: currency == state.selectedCurrency
                          ? colors.blue
                          : colors.black,
                      url: currency.iconUrl,
                    ),
              name: currency.description,
              amount: currency.volumeBaseBalance(
                state.baseCurrency!,
              ),
              description: currency.volumeAssetBalance,
              onTap: () => Navigator.pop(context, currency),
              divider: currency != assetWithOutBalance.last,
              removeDivider: currency == assetWithOutBalance.last,
            ),
          const SpaceH40(),
        ],
        context: context,
        then: (value) {
          sAnalytics.sellCloseFor();
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
          title: '${intl.currencySell_sell} ${currency.description}',
        ),
      ),
      child: Column(
        children: [
          deviceSize.when(
            small: () => const SizedBox(),
            medium: () => const Spacer(),
          ),
          Baseline(
            baseline: deviceSize.when(
              small: () => 32,
              medium: () => 9,
            ),
            baselineType: TextBaseline.alphabetic,
            child: SActionPriceField(
              widgetSize: widgetSizeFrom(deviceSize),
              price: formatCurrencyStringAmount(
                prefix: currency.prefixSymbol,
                value: state.inputValue,
                symbol: currency.symbol,
              ),
              helper: state.conversionText(),
              error: state.inputError.value(),
              isErrorActive: state.inputError.isActive,
            ),
          ),
          Baseline(
            baseline: deviceSize.when(
              small: () => -36,
              medium: () => 19,
            ),
            baselineType: TextBaseline.alphabetic,
            child: Text(
              '${intl.currencySell_available}: ${currency.volumeAssetBalance}',
              style: sSubtitle3Style.copyWith(
                color: colors.grey2,
              ),
            ),
          ),
          const Spacer(),
          if (state.selectedCurrency == null)
            SPaymentSelectDefault(
              widgetSize: widgetSizeFrom(deviceSize),
              icon: const SActionWithdrawIcon(),
              name: intl.currencySell_chooseDestination,
              onTap: () {
                sAnalytics.sellChooseDestination();
                _showAssetSelector(context);
              },
            )
          else if (state.selectedCurrency!.type == AssetType.crypto)
            SPaymentSelectAsset(
              widgetSize: widgetSizeFrom(deviceSize),
              icon: SNetworkSvg24(
                url: state.selectedCurrency!.iconUrl,
              ),
              name: state.selectedCurrency!.description,
              amount: state.selectedCurrency!.volumeBaseBalance(
                state.baseCurrency!,
              ),
              description: state.selectedCurrency!.volumeAssetBalance,
              onTap: () => _showAssetSelector(context),
            )
          else
            SPaymentSelectFiat(
              widgetSize: widgetSizeFrom(deviceSize),
              icon: SNetworkSvg24(
                url: state.selectedCurrency!.iconUrl,
              ),
              name: state.selectedCurrency!.description,
              amount: state.selectedCurrency!.volumeBaseBalance(
                state.baseCurrency!,
              ),
              onTap: () => _showAssetSelector(context),
            ),
          deviceSize.when(
            small: () => const Spacer(),
            medium: () => const SpaceH20(),
          ),
          SNumericKeyboardAmount(
            widgetSize: widgetSizeFrom(deviceSize),
            preset1Name: '25%',
            preset2Name: '50%',
            preset3Name: intl.max,
            selectedPreset: state.selectedPreset,
            onPresetChanged: (preset) {
              notifier.tapPreset(
                preset.index == 0
                    ? '25%'
                    : preset.index == 1
                    ? '50%'
                    : 'Max',
              );
              notifier.selectPercentFromBalance(preset);
            },
            onKeyPressed: (value) {
              notifier.updateInputValue(value);
            },
            buttonType: SButtonType.primary2,
            submitButtonActive: state.inputValid,
            submitButtonName: intl.currencySell_previewSell,
            onSubmitPressed: () {
              sAnalytics.sellTapPreview(
                sourceCurrency: currency.description,
                sourceAmount: state.inputValue,
                destinationCurrency: state.selectedCurrency!.description,
                destinationAmount: state.conversionText(),
                sellPercentage: state.tappedPreset ?? '',
              );
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
