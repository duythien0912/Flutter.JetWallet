import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../../shared/providers/device_size/device_size_pod.dart';
import '../../../../../../../../shared/providers/service_providers.dart';
import '../../../../../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../../../../../helpers/format_currency_string_amount.dart';
import '../../../../../../helpers/formatting/base/volume_format.dart';
import '../../../../../../providers/base_currency_pod/base_currency_pod.dart';
import '../../../../model/preview_buy_with_circle_input.dart';
import '../../../../notifier/preview_buy_with_circle_notifier/preview_buy_with_circle_notipod.dart';

class PreviewBuyWithCircle extends HookWidget {
  const PreviewBuyWithCircle({
    Key? key,
    required this.input,
  }) : super(key: key);

  final PreviewBuyWithCircleInput input;

  @override
  Widget build(BuildContext context) {
    late Widget icon;
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);
    final deviceSize = useProvider(deviceSizePod);
    final baseCurrency = useProvider(baseCurrencyPod);
    final state = useProvider(previewBuyWithCircleNotipod(input));
    final notifier = useProvider(previewBuyWithCircleNotipod(input).notifier);
    useValueListenable(state.loader);
    final title =
        '${intl.previewBuyWithAsset_confirm} ${intl.previewBuyWithCircle_buy} '
        '${input.currency.description}';

    if (state.isChecked) {
      icon = const SCheckboxSelectedIcon();
    } else {
      icon = const SCheckboxIcon();
    }

    return SPageFrameWithPadding(
      loading: state.loader,
      header: deviceSize.when(
        small: () {
          return SSmallHeader(
            title: title,
          );
        },
        medium: () {
          return SMegaHeader(
            title: title,
          );
        },
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Column(
            children: [
              deviceSize.when(
                small: () => const SpaceH8(),
                medium: () => const SpaceH3(),
              ),
              Center(
                child: SActionConfirmIconWithAnimation(
                  iconUrl: input.currency.iconUrl,
                ),
              ),
              // const Spacer(),
              SActionConfirmText(
                name: intl.previewBuyWithCircle_payFrom,
                value: '${state.card?.network} •••• ${state.card?.last4}',
              ),
              SActionConfirmText(
                name: intl.previewBuyWithCircle_creditCardFee,
                contentLoading: state.loader.value,
                value: volumeFormat(
                  prefix: baseCurrency.prefix,
                  decimal: state.depositFeeAmount ?? Decimal.zero,
                  accuracy: baseCurrency.accuracy,
                  symbol: baseCurrency.symbol,
                ),
                maxValueWidth: 140,
              ),
              SActionConfirmText(
                name: intl.previewBuyWithCircle_transactionFee,
                contentLoading: state.loader.value,
                value: volumeFormat(
                  prefix: input.currency.prefixSymbol,
                  decimal: state.tradeFeeAmount ?? Decimal.zero,
                  accuracy: input.currency.accuracy,
                  symbol: input.currency.symbol,
                ),
                maxValueWidth: 140,
              ),
              SActionConfirmText(
                name: intl.previewBuyWithCircle_youWillGet,
                contentLoading: state.loader.value,
                value: '≈ ${volumeFormat(
                  prefix: input.currency.prefixSymbol,
                  symbol: input.currency.symbol,
                  accuracy: input.currency.accuracy,
                  decimal: state.buyAmount ?? Decimal.zero,
                )}',
              ),
              SActionConfirmText(
                name: intl.previewBuyWithCircle_rate,
                contentLoading: state.loader.value,
                value: '≈ ${volumeFormat(
                  prefix: baseCurrency.prefix,
                  symbol: baseCurrency.symbol,
                  accuracy: baseCurrency.accuracy,
                  decimal: state.rate ?? Decimal.zero,
                )}',
              ),
              const SpaceH20(),
              Text(
                intl.previewBuyWithCircle_description,
                maxLines: 3,
                style: sCaptionTextStyle.copyWith(
                  color: colors.grey3,
                ),
              ),
              const SpaceH24(),
              const SDivider(),
              SActionConfirmText(
                name: intl.previewBuyWithCircle_youWillPay,
                contentLoading: state.loader.value,
                valueColor: colors.blue,
                value: volumeFormat(
                  prefix: baseCurrency.prefix,
                  symbol: baseCurrency.symbol,
                  accuracy: baseCurrency.accuracy,
                  decimal: state.amountToPay!,
                ),
              ),
              const SpaceH20(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      SIconButton(
                        onTap: () {
                          notifier.checkSetter();
                        },
                        defaultIcon: icon,
                        pressedIcon: icon,
                      ),
                    ],
                  ),
                  const SpaceW10(),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 82,
                    child: RichText(
                      text: TextSpan(
                        text: '${intl.previewBuyWithCircle_disclaimer} '
                            '$paymentDelayDays '
                            '${intl.previewBuyWithCircle_disclaimerEnd}',
                        style: sCaptionTextStyle.copyWith(
                          color: colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SpaceH16(),
              SPrimaryButton2(
                active: !state.loader.value && state.isChecked,
                name: intl.previewBuyWithAsset_confirm,
                onTap: () {
                  sAnalytics.tapConfirmBuy(
                    assetName: input.currency.description,
                    paymentMethod: 'circleCard',
                    amount: formatCurrencyStringAmount(
                      prefix: baseCurrency.prefix,
                      value: input.amount,
                      symbol: baseCurrency.symbol,
                    ),
                    frequency: RecurringFrequency.oneTime,
                  );
                  notifier.onConfirm();
                },
              ),
              const SpaceH24(),
            ],
          ),
        ],
      ),
    );
  }
}
