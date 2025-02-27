import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../shared/helpers/analytics.dart';
import '../../../../../../../shared/helpers/navigate_to_router.dart';
import '../../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../../../shared/helpers/navigator_push_replacement.dart';
import '../../../../../../../shared/providers/service_providers.dart';
import '../../../model/kyc_operation_status_model.dart';
import '../../../notifier/kyc/kyc_notipod.dart';
import '../../../notifier/kyc_selfie/kyc_selfie_notipod.dart';
import '../../../notifier/kyc_selfie/kyc_selfie_state.dart';
import 'components/empty_selfie_box.dart';
import 'components/selfie_box.dart';
import 'components/success_kys_screen.dart';

class KycSelfie extends HookWidget {
  const KycSelfie({Key? key}) : super(key: key);

  static void pushReplacement({
    required BuildContext context,
  }) {
    navigatorPushReplacement(
      context,
      const KycSelfie(),
    );
  }

  static void push({
    required BuildContext context,
  }) {
    navigatorPush(
      context,
      const KycSelfie(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final state = useProvider(kycSelfieNotipod);
    final notifier = useProvider(kycSelfieNotipod.notifier);
    final colors = useProvider(sColorPod);
    final loader = useValueNotifier(StackLoaderNotifier());
    final loaderSuccess = useValueNotifier(StackLoaderNotifier());
    final kycN = useProvider(kycNotipod.notifier);

    analytics(() => sAnalytics.kycSelfieView());

    return ProviderListener<KycSelfieState>(
      provider: kycSelfieNotipod,
      onChange: (context, state) {
        state.union.maybeWhen(
          error: (error) {
            loader.value.finishLoading();
          },
          done: () {
            kycN.updateKycStatus();
            navigateToRouter(context.read);
            Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute(
                builder: (_) => SuccessKycScreen(
                  primaryText:
                      intl.kycAlertHandler_showVerifyingAlertPrimaryText,
                  secondaryText:
                      '${intl.kycSelfie_successKycScreenSecondaryText}.',
                ),
              ),
              (route) => route.isFirst,
            );
          },
          orElse: () {},
        );
      },
      child: SPageFrame(
        loaderText: (loaderSuccess.value.value)
            ? intl.kycSelfie_done
            : intl.kycSelfie_pleaseWait,
        loading: loader.value,
        loadSuccess: loaderSuccess.value,
        header: SPaddingH24(
          child: SSmallHeader(
            title: intl.kycDocumentType_selfieImage,
          ),
        ),
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    children: [
                      const Spacer(),
                      if (state.selfie == null)
                        SPaddingH24(
                          child: EmptySelfieBox(
                            colors: colors,
                          ),
                        ),
                      if (state.selfie != null) const SelfieBox(),
                      const Spacer(),
                      SPaddingH24(
                        child: Row(
                          children: [
                            Text(
                              '${intl.kycSelfie_compareWithYourDocument}.',
                              style: sBodyText1Style,
                            ),
                          ],
                        ),
                      ),
                      SPaddingH24(
                        child: Row(
                          children: [
                            Baseline(
                              baseline: 48,
                              baselineType: TextBaseline.alphabetic,
                              child: Text(
                                '${intl.kycSelfie_selfieShouldClearly}:',
                                style: sBodyText1Style,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SPaddingH24(
                        child: Stack(
                          children: [
                            Positioned(
                              top: 24,
                              child: Container(
                                height: 3,
                                width: 6,
                                margin: const EdgeInsets.only(right: 10.0),
                                color: colors.grey1,
                              ),
                            ),
                            Row(
                              children: [
                                const SpaceW16(),
                                Flexible(
                                  child: Baseline(
                                    baseline: 30,
                                    baselineType: TextBaseline.alphabetic,
                                    child: Text(
                                      '${intl.kycSelfie_faceForwardAndMakeSure}'
                                      '${intl.kycSelfie_clearlyVisible}',
                                      maxLines: 2,
                                      style: sBodyText1Style.copyWith(
                                        color: colors.grey1,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SPaddingH24(
                        child: Row(
                          children: [
                            Container(
                              height: 3,
                              width: 6,
                              margin: const EdgeInsets.only(right: 10.0),
                              color: colors.grey1,
                            ),
                            SizedBox(
                              height: 30,
                              child: Text(
                                intl.kycSelfie_removeYourGlasses,
                                maxLines: 3,
                                style: sBodyText1Style.copyWith(
                                  color: colors.grey1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SpaceH120(),
                    ],
                  ),
                ),
              ],
            ),
            SFloatingButtonFrame(
              button: SPrimaryButton2(
                onTap: () async {
                  if (state.isSelfieNotEmpty) {
                    loader.value.startLoading();

                    await notifier.uploadDocuments(
                      kycDocumentTypeInt(KycDocumentType.selfieImage),
                    );
                  } else {
                    await notifier.pickedImage();
                  }
                },
                name: (state.isSelfieNotEmpty)
                    ? intl.kycDocumentType_uploadPhoto
                    : intl.kycDocumentType_selfieImage,
                active: true,
                icon: (state.isSelfieNotEmpty)
                    ? const SArrowUpIcon()
                    : const SSelfieIcon(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
