import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../../shared/helpers/widget_size_from.dart';
import '../../../../../shared/providers/device_size/device_size_pod.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../../../components/network_bottom_sheet/show_network_bottom_sheet.dart';
import '../../../models/currency_model.dart';
import '../../kyc/model/kyc_operation_status_model.dart';
import '../../kyc/notifier/kyc/kyc_notipod.dart';
import '../notifier/crypto_deposit_notipod.dart';
import '../provider/crypto_deposit_disclaimer_fpod.dart';
import 'components/crypto_deposit_with_address.dart';
import 'components/crypto_deposit_with_address_and_tag/crypto_deposit_with_address_and_tag.dart';
import 'components/deposit_info.dart';
import 'components/show_deposit_disclaimer.dart';

class CryptoDeposit extends HookWidget {
  const CryptoDeposit({
    Key? key,
    required this.header,
    required this.currency,
  }) : super(key: key);

  final String header;
  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    final pageController = PageController(viewportFraction: 0.9);
    final controller = useScrollController();
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);
    final canTapShare = useState(true);
    final deviceSize = useProvider(deviceSizePod);
    useProvider(
      cryptoDepositDisclaimerFpod(currency.symbol).select((_) {}),
    );
    final deposit = useProvider(cryptoDepositNotipod(currency));
    final depositN = useProvider(
      cryptoDepositNotipod(currency).notifier,
    );
    final kycState = useProvider(kycNotipod);
    final kycAlertHandler = useProvider(
      kycAlertHandlerPod(context),
    );
    final showAlert = kycState.withdrawalStatus !=
        kycOperationStatus(KycStatus.allowed);

    Widget slidesControllers () {
      return Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: SmoothPageIndicator(
            controller: pageController,
            count: 2,
            effect: ScrollingDotsEffect(
              spacing: 2,
              radius: 4,
              dotWidth: 24,
              dotHeight: 2,
              maxVisibleDots: 11,
              activeDotScale: 1,
              dotColor: colors.black.withOpacity(0.3),
              activeDotColor: colors.black,
            ),
          ),
        ),
      );
    }

    Widget? alertWidget () {
      if (showAlert) {
        return GestureDetector(
          onTap: () {
            sShowAlertPopup(
              context,
              primaryText: intl.actionBuy_alertPopup,
              primaryButtonName: intl.actionBuy_goToKYC,
              onPrimaryButtonTap: () {
                kycAlertHandler.handle(
                  status: kycState.withdrawalStatus,
                  kycVerified: kycState,
                  isProgress: kycState.verificationInProgress,
                  currentNavigate: () {},
                  size: widgetSizeFrom(deviceSize),
                );
              },
              secondaryButtonName: intl.actionBuy_gotIt,
              onSecondaryButtonTap: () {
                Navigator.pop(context);
              },
              size: widgetSizeFrom(deviceSize),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SErrorIcon(
                color: colors.green,
              ),
              const SpaceW10(),
              Text(
                intl.actionBuy_kycRequired,
                style: sCaptionTextStyle.copyWith(
                  color: colors.grey2,
                ),
              ),
            ],
          ),
        );
      }
      return null;
    }

    return ProviderListener<AsyncValue<CryptoDepositDisclaimer>>(
      provider: cryptoDepositDisclaimerFpod(currency.symbol),
      onChange: (context, asyncValue) {
        asyncValue.whenData((value) {
          if (value == CryptoDepositDisclaimer.notAccepted) {
            showDepositDisclaimer(
              slidesControllers: slidesControllers(),
              context: context,
              controller: pageController,
              assetSymbol: currency.symbol,
              screenTitle: header,
              kycAlertHandler: kycAlertHandler,
              kycState: kycState,
              onDismiss: currency.isSingleNetwork
                  ? null
                  : () => showNetworkBottomSheet(
                        context,
                        deposit.network,
                        currency.depositBlockchains,
                        currency.iconUrl,
                        depositN.setNetwork,
                      ),
              size: widgetSizeFrom(deviceSize),
            );
          } else {
            if (!currency.isSingleNetwork) {
              showNetworkBottomSheet(
                context,
                deposit.network,
                currency.depositBlockchains,
                currency.iconUrl,
                depositN.setNetwork,
              );
            }
          }
        });
      },
      child: SPageFrame(
        header: SPaddingH24(
          child: SSmallHeader(
            title: '$header ${currency.description}',
          ),
        ),
        bottomNavigationBar: SizedBox(
          height: 104,
          child: Column(
            children: [
              const SDivider(),
              const SpaceH23(),
              SPaddingH24(
                child: SPrimaryButton2(
                  icon: SShareIcon(
                    color: colors.white,
                  ),
                  active: true,
                  name: intl.cryptoDeposit_share,
                  onTap: () {
                    if (canTapShare.value) {
                      canTapShare.value = false;
                      Timer(
                        const Duration(
                          seconds: 1,
                        ),
                        () => canTapShare.value = true,
                      );
                      sAnalytics.receiveShare(asset: currency.description);
                      Share.share(
                        '${intl.cryptoDeposit_my} ${currency.symbol}'
                            ' ${intl.cryptoDeposit_address}: '
                        '${deposit.address} '
                        '${deposit.tag != null ? ', ${intl.tag}: '
                            '${deposit.tag}' : ''}',
                      );
                    }
                  },
                ),
              ),
              const SpaceH24(),
            ],
          ),
        ),
        child: ListView(
          controller: controller,
          padding: EdgeInsets.zero,
          children: [
            DepositInfo(),
            Container(
              height: 88.0,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              child: InkWell(
                highlightColor: colors.grey5,
                splashColor: Colors.transparent,
                onTap: currency.isSingleNetwork
                    ? null
                    : () => showNetworkBottomSheet(
                          context,
                          deposit.network,
                          currency.depositBlockchains,
                          currency.iconUrl,
                          depositN.setNetwork,
                        ),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: colors.grey3,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 5,
                        ),
                        child: Text(
                          intl.cryptoDeposit_network,
                          style: sCaptionTextStyle.copyWith(
                            color: colors.grey2,
                          ),
                        ),
                      ),
                      if (deposit.network.description.isEmpty)
                        const Padding(
                          padding: EdgeInsets.only(
                            top: 24,
                          ),
                          child: SSkeletonTextLoader(
                            height: 16,
                            width: 80,
                          ),
                        ),
                      if (deposit.network.description.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 17,
                          ),
                          child: Text(
                            deposit.network.description,
                            style: sSubtitle2Style,
                          ),
                        ),
                      if (!currency.isSingleNetwork)
                        const Positioned(
                          right: 0,
                          top: 0,
                          bottom: 0,
                          child: SAngleDownIcon(),
                        )
                    ],
                  ),
                ),
              ),
            ),
            const SDivider(),
            if (deposit.tag != null)
              CryptoDepositWithAddressAndTag(
                currency: currency,
                scrollController: controller,
                alert: alertWidget(),
                showAlert: showAlert,
              )
            else
              CryptoDepositWithAddress(
                currency: currency,
                alert: alertWidget(),
                showAlert: showAlert,
              ),
          ],
        ),
      ),
    );
  }
}
