import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/providers/service_providers.dart';
import '../../../helpers/formatting/formatting.dart';
import '../../../helpers/price_accuracy.dart';
import '../model/preview_convert_input.dart';
import '../notifier/preview_buy_with_asset_notifier/preview_convert_notipod.dart';
import '../notifier/preview_buy_with_asset_notifier/preview_convert_state.dart';
import '../notifier/preview_buy_with_asset_notifier/preview_convert_union.dart';

class PreviewConvert extends StatefulHookWidget {
  const PreviewConvert({
    Key? key,
    required this.input,
  }) : super(key: key);

  final PreviewConvertInput input;

  @override
  State<PreviewConvert> createState() => _PreviewConvertState();
}

class _PreviewConvertState extends State<PreviewConvert>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this);

    final notifier = context.read(
      previewConvertNotipod(widget.input).notifier,
    );
    notifier.updateTimerAnimation(_animationController);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final state = useProvider(previewConvertNotipod(widget.input));
    final notifier = useProvider(
      previewConvertNotipod(widget.input).notifier,
    );
    final loader = useValueNotifier(StackLoaderNotifier());

    final from = widget.input.fromCurrency;
    final to = widget.input.toCurrency;

    final accuracy = priceAccuracy(context.read, from.symbol, to.symbol);

    return ProviderListener<PreviewConvertState>(
      provider: previewConvertNotipod(widget.input),
      onChange: (_, value) {
        if (value.union is ExecuteLoading) {
          loader.value.startLoading();
        } else {
          if (loader.value.value) {
            loader.value.finishLoading();
          }
        }
      },
      child: SPageFrameWithPadding(
        loading: loader.value,
        header: SMegaHeader(
          crossAxisAlignment: CrossAxisAlignment.center,
          title: notifier.previewHeader,
          onBackButtonTap: () {
            notifier.cancelTimer();
            Navigator.pop(context);
          },
        ),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  SActionConfirmIconWithAnimation(
                    iconUrl: widget.input.toCurrency.iconUrl,
                  ),
                  const Spacer(),
                  SActionConfirmText(
                    name: intl.previewConvert_youPay,
                    contentLoading: state.union is QuoteLoading &&
                        widget.input.toAssetEnabled,
                    value: volumeFormat(
                      prefix: from.prefixSymbol,
                      accuracy: from.accuracy,
                      decimal: state.fromAssetAmount ?? Decimal.zero,
                      symbol: from.symbol,
                    ),
                  ),
                  SActionConfirmText(
                    name: intl.previewConvert_youGet,
                    baseline: 35.0,
                    contentLoading: state.union is QuoteLoading &&
                        !widget.input.toAssetEnabled,
                    value: '≈ ${volumeFormat(
                      prefix: to.prefixSymbol,
                      accuracy: to.accuracy,
                      decimal: state.toAssetAmount ?? Decimal.zero,
                      symbol: to.symbol,
                    )}',
                  ),
                  SActionConfirmText(
                    name: intl.fee,
                    baseline: 35.0,
                    contentLoading: state.union is QuoteLoading &&
                        !widget.input.toAssetEnabled,
                    value: '${state.feePercent}%',
                  ),
                  SActionConfirmText(
                    name: intl.previewConvert_exchangeRate,
                    baseline: 34.0,
                    contentLoading: state.union is QuoteLoading,
                    timerLoading: state.union is QuoteLoading,
                    animation: state.timerAnimation,
                    value: '${volumeFormat(
                      prefix: from.prefixSymbol,
                      accuracy: from.accuracy,
                      decimal: Decimal.one,
                      symbol: from.symbol,
                    )} = \n'
                        '${volumeFormat(
                      prefix: to.prefixSymbol,
                      accuracy: accuracy,
                      decimal: state.price ?? Decimal.zero,
                      symbol: to.symbol,
                    )}',
                  ),
                  const SpaceH36(),
                  if (state.connectingToServer) ...[
                    const SActionConfirmAlert(),
                    const SpaceH20(),
                  ],
                  SPrimaryButton2(
                    active: state.union is QuoteSuccess,
                    name: intl.previewConvert_confirm,
                    onTap: () {
                      sAnalytics.convertConfirm(
                        sourceCurrency: widget.input.fromCurrency.description,
                        sourceAmount: widget.input.fromAmount,
                        destinationCurrency:
                          widget.input.toCurrency.description,
                        destinationAmount: widget.input.toAmount,
                      );
                      notifier.executeQuote();
                    },
                  ),
                  const SpaceH24(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
