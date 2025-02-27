import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/signal_r/model/asset_model.dart';

import '../../../../../../../shared/providers/service_providers.dart';
import '../../../../../helpers/input_helpers.dart';
import '../../../../../models/currency_model.dart';
import '../../../../../providers/base_currency_pod/base_currency_pod.dart';
import 'components/convert_amount_cursor.dart';
import 'components/convert_auto_size_amount.dart';
import 'components/convert_dropdown_button.dart';

class ConvertRow extends HookWidget {
  const ConvertRow({
    Key? key,
    this.fromAsset = false,
    this.inputError,
    required this.value,
    required this.onTap,
    required this.enabled,
    required this.currency,
    required this.assetWithBalance,
    required this.assetWithoutBalance,
    required this.onDropdown,
  }) : super(key: key);

  final bool fromAsset;
  final InputError? inputError;
  final String value;
  final Function() onTap;
  final bool enabled;
  final CurrencyModel currency;
  final List<CurrencyModel> assetWithBalance;
  final List<CurrencyModel> assetWithoutBalance;
  final Function(CurrencyModel?) onDropdown;

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);
    final baseCurrency = useProvider(baseCurrencyPod);
    final cursorAnimation = useAnimationController(
      duration: const Duration(milliseconds: 1000),
    )..repeat();

    useListenable(cursorAnimation);

    void _showDropdownSheet() {
      sShowBasicModalBottomSheet(
        context: context,
        scrollable: true,
        pinned: SBottomSheetHeader(
          name: fromAsset ? intl.from : intl.to1,
        ),
        children: [
          for (final item in assetWithBalance)
            SAssetItem(
              isSelected: currency == item,
              icon: SNetworkSvg24(
                url: item.iconUrl,
                color: _iconColor(item, context),
              ),
              name: item.description,
              description: item.symbol,
              amount: item.volumeBaseBalance(baseCurrency),
              divider: item != assetWithBalance.last,
              onTap: () {
                if (currency == item) {
                  Navigator.pop(context);
                } else {
                  Navigator.pop(context, item);
                }
              },
            ),
          for (final item in assetWithoutBalance)
            SAssetItem(
              isSelected: currency == item,
              icon: SNetworkSvg24(
                url: item.iconUrl,
                color: _iconColor(item, context),
              ),
              name: item.description,
              description: item.symbol,
              amount: item.volumeBaseBalance(baseCurrency),
              divider: item != assetWithoutBalance.last,
              onTap: () {
                if (currency == item) {
                  Navigator.pop(context);
                } else {
                  Navigator.pop(context, item);
                }
              },
            ),
        ],
        then: (value) {
          if (value is CurrencyModel) {
            onDropdown(value);
          }
        },
      );
    }

    return SPaddingH24(
      child: Stack(
        children: [
          SizedBox(
            height: 88.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SpaceH22(),
                Baseline(
                  baseline: 20.0,
                  baselineType: TextBaseline.alphabetic,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      ConvertDropdownButton(
                        onTap: () => _showDropdownSheet(),
                        currency: currency,
                      ),
                      ConvertAutoSizeAmount(
                        onTap: onTap,
                        value: value,
                        enabled: enabled,
                      ),
                      if (enabled) ...[
                        if (cursorAnimation.value > 0.5)
                          const ConvertAmountCursor()
                        else
                          const ConvertAmountCursorPlaceholder()
                      ] else
                        const ConvertAmountCursorPlaceholder()
                    ],
                  ),
                ),
                Baseline(
                  baseline: 16.0,
                  baselineType: TextBaseline.alphabetic,
                  child: Row(
                    children: [
                      const SpaceW34(),
                      if (inputError == null || inputError == InputError.none)
                        Text(
                          '${intl.convertRow_available}:'
                              ' ${currency.volumeAssetBalance}',
                          maxLines: 1,
                          style: sBodyText2Style.copyWith(
                            color: colors.grey2,
                          ),
                        )
                      else ...[
                        const Spacer(),
                        Text(
                          inputError!.value(),
                          maxLines: 1,
                          style: sSubtitle3Style.copyWith(
                            color: colors.red,
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color? _iconColor(CurrencyModel item, BuildContext context) {
    final colors = context.read(sColorPod);

    if (item.type == AssetType.indices) {
      return null;
    }
    if (currency == item) {
      return colors.blue;
    } else {
      return colors.black;
    }
  }
}
