import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/providers/device_size/device_size_pod.dart';
import '../../../../../../shared/providers/service_providers.dart';
import '../../../../helpers/short_address_form.dart';
import '../../helper/user_will_receive.dart';
import '../../model/withdrawal_model.dart';
import '../../notifier/withdrawal_preview_notifier/withdrawal_preview_notipod.dart';
import '../../notifier/withdrawal_preview_notifier/withdrawal_preview_state.dart';

class WithdrawalPreview extends HookWidget {
  const WithdrawalPreview({
    Key? key,
    required this.withdrawal,
    required this.network,
  }) : super(key: key);

  final WithdrawalModel withdrawal;
  final String network;

  @override
  Widget build(BuildContext context) {
    final deviceSize = useProvider(deviceSizePod);
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);
    final state = useProvider(withdrawalPreviewNotipod(withdrawal));
    final notifier = useProvider(withdrawalPreviewNotipod(withdrawal).notifier);
    final loader = useValueNotifier(StackLoaderNotifier());

    final currency = withdrawal.currency;
    final verb = withdrawal.dictionary.verb;

    return ProviderListener<WithdrawalPreviewState>(
      provider: withdrawalPreviewNotipod(withdrawal),
      onChange: (_, state) {
        if (state.loading) {
          loader.value.startLoading();
        } else {
          loader.value.finishLoading();
        }
      },
      child: SPageFrameWithPadding(
        loading: loader.value,
        header: deviceSize.when(
          small: () {
            return SSmallHeader(
              title: '${intl.withdrawalPreview_confirm} $verb'
                  ' ${currency.description}',
            );
          },
          medium: () {
            return SMegaHeader(
              title: '${intl.withdrawalPreview_confirm} $verb'
                  ' ${currency.description}',
            );
          },
        ),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  SActionConfirmIconWithAnimation(
                    iconUrl: currency.iconUrl,
                  ),
                  const Spacer(),
                  SActionConfirmText(
                    name: '$verb ${intl.to}',
                    value: shortAddressForm(state.address),
                  ),
                  SActionConfirmText(
                    name: intl.withdrawalPreview_youWillSend,
                    baseline: 36.0,
                    value: userWillreceive(
                      currency: currency,
                      amount: state.amount,
                      addressIsInternal: state.addressIsInternal,
                      network: network,
                    ),
                  ),
                  SActionConfirmText(
                    name: intl.fee,
                    baseline: 35.0,
                    value: state.addressIsInternal
                        ? intl.noFee
                        : currency.withdrawalFeeWithSymbol(network),
                  ),
                  const SBaselineChild(
                    baseline: 34.0,
                    child: SDivider(),
                  ),
                  SActionConfirmText(
                    name: intl.withdrawalPreview_total,
                    value: '${state.amount} ${currency.symbol}',
                    valueColor: colors.blue,
                  ),
                  const SpaceH36(),
                  SPrimaryButton2(
                    active: !state.loading,
                    name: intl.withdrawalPreview_confirm,
                    onTap: () {
                      sAnalytics.sendConfirm(
                        currency: currency.symbol,
                        amount: state.amount,
                        type: 'By wallet',
                      );
                      notifier.withdraw();
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
