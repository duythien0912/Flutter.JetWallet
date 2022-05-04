import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../shared/helpers/analytics.dart';
import '../../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../../../shared/helpers/navigator_push_replacement.dart';
import '../../../model/kyc_operation_status_model.dart';
import '../../../notifier/choose_documents/choose_documents_notipod.dart';
import '../../../notifier/upload_kyc_documents/upload_kyc_documents_notipod.dart';
import '../../../notifier/upload_kyc_documents/upload_kyc_documents_state.dart';
import '../kyc_selfie/kyc_selfie.dart';
import 'components/create_kyc_banners_list.dart';
import 'components/document_page_view.dart';
import 'components/page_indicator.dart';

class UploadKycDocuments extends HookWidget {
  const UploadKycDocuments({Key? key}) : super(key: key);

  static void push({
    required BuildContext context,
  }) {
    navigatorPush(
      context,
      const UploadKycDocuments(),
    );
  }

  static void pushReplacement(BuildContext context) {
    navigatorPushReplacement(
      context,
      const UploadKycDocuments(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = useProvider(uploadKycDocumentsNotipod);
    final notifier = useProvider(uploadKycDocumentsNotipod.notifier);
    final colors = useProvider(sColorPod);
    final loader = useValueNotifier(StackLoaderNotifier());
    final loaderSuccess = useValueNotifier(StackLoaderNotifier());
    final activeDocument =
        useProvider(chooseDocumentsNotipod.notifier).getActiveDocument();

    final _banners = createKycBannersList(
      documentFirstSide: state.documentFirstSide,
      documentSecondSide: state.documentSecondSide,
      colors: colors,
      notifier: notifier,
    );

    analytics(
      () =>
          sAnalytics.assetView(KycSource.kycUploadIdentityDocumentView.name),
    );

    return ProviderListener<UploadKycDocumentsState>(
      provider: uploadKycDocumentsNotipod,
      onChange: (context, state) {
        state.union.maybeWhen(
          error: (error) {
            loader.value.finishLoading();
          },
          done: () {
            loaderSuccess.value.startLoading();
            Timer(const Duration(seconds: 2), () {
              KycSelfie.pushReplacement(context: context);
            });
          },
          orElse: () {},
        );
      },
      child: SPageFrame(
        loading: loader.value,
        loadSuccess: loaderSuccess.value,
        header: SPaddingH24(
          child: SSmallHeader(
            title: 'Upload ${stringKycDocumentType(activeDocument.document)}',
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            (state.numberSide == 0)
                                ? 'Front side'
                                : 'Back side',
                            style: sSubtitle2Style,
                          ),
                        ],
                      ),
                      const SpaceH16(),
                      DocumentPageView(
                        pageController: state.pageViewController,
                        onPageChanged: (int index) {
                          notifier.changeDocumentSide(index);
                        },
                        itemCount: _documentPageViewCount(
                          activeDocument.document,
                        ),
                        banners: _banners,
                      ),
                      const SpaceH18(),
                      PageIndicator(
                        documentType: activeDocument.document,
                      ),
                      const Spacer(),
                      const SpaceH10(),
                      const SPaddingH24(
                        child: SDocumentsRecommendations(),
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
                  await notifier.documentPageViewLogic(
                    activeDocument.document,
                    loader,
                  );
                },
                name: notifier.buttonName(),
                active: notifier.activeScanButton(),
                icon: state.buttonIcon
                    ? const SArrowUpIcon()
                    : const SWhitePhotoIcon(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _documentPageViewCount(KycDocumentType document) {
    return (document != KycDocumentType.passport) ? 2 : 1;
  }
}
