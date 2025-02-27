import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../shared/constants.dart';
import '../../../../../../../shared/helpers/analytics.dart';
import '../../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../../../shared/providers/device_size/device_size_pod.dart';
import '../../../../../../../shared/providers/service_providers.dart';
import '../../../notifier/camera_permission/camera_permission_notipod.dart';
import '../../../notifier/camera_permission/camera_permission_state.dart';

class AllowCamera extends StatefulHookWidget {
  const AllowCamera({
    Key? key,
    required this.permissionDescription,
    required this.then,
  }) : super(key: key);

  final String permissionDescription;
  final void Function() then;

  static void push({
    required BuildContext context,
    required String permissionDescription,
    required void Function() then,
  }) {
    navigatorPush(
      context,
      AllowCamera(
        permissionDescription: permissionDescription,
        then: then,
      ),
    );
  }

  @override
  State<AllowCamera> createState() => _AllowCameraState();
}

class _AllowCameraState extends State<AllowCamera> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final state = context.read(cameraPermissionNotipod);
      final notifier = context.read(cameraPermissionNotipod.notifier);

      // If returned from Settings check whether user enabled permission or not
      if (state.userLocation == UserLocation.settings) {
        notifier.handleCameraPermissionAfterSettingsChange(
          context,
          widget.then,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);
    final state = useProvider(cameraPermissionNotipod);
    final notifier = useProvider(cameraPermissionNotipod.notifier);

    final deviceSize = useProvider(deviceSizePod);
    final size = MediaQuery.of(context).size;

    analytics(() => sAnalytics.kycAllowCameraView());
    _sendEvent(state);
    return SPageFrameWithPadding(
      header: deviceSize.when(
        small: () {
          return SSmallHeader(
            title: _headerTitle(state.permissionDenied, context),
          );
        },
        medium: () {
          return SMegaHeader(
            titleAlign: TextAlign.left,
            title: _headerTitle(state.permissionDenied, context),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          bottom: 24,
          top: 40,
          left: 24,
          right: 24,
        ),
        child: SPrimaryButton2(
          active: true,
          onTap: () async {
            if(state.permissionDenied){
              sAnalytics.kycTapOnGoToSettings();
            }else{
              sAnalytics.kycTapOnEnableCamera();
            }
            await notifier.handleCameraPermission(context);
          },
          name: state.permissionDenied
              ? intl.allowCamera_goToSettings
              : intl.allowCamera_enableCamera,
        ),
      ),
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Image.asset(
                  allowCameraAsset,
                  height: size.width * 0.6,
                ),
                const Spacer(),
                if (!state.permissionDenied)
                  Baseline(
                    baseline: 48,
                    baselineType: TextBaseline.alphabetic,
                    child: Text(
                      '${intl.allowCamera_text1}.',
                      maxLines: 3,
                      style: sBodyText1Style.copyWith(
                        color: colors.grey1,
                      ),
                    ),
                  ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Baseline(
                        baseline: 48,
                        baselineType: TextBaseline.alphabetic,
                        child: Text(
                          widget.permissionDescription,
                          maxLines: 3,
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
        ],
      ),
    );
  }

  String _headerTitle(bool status, BuildContext context) {
    final intl = context.read(intlPod);

    if (status) {
      return intl.allowCamera_headerTitle1;
    } else {
      return intl.allowCamera_headerTitle2;
    }
  }
  void _sendEvent(CameraPermissionState state){
    if(state.permissionDenied){
      sAnalytics.kycGiveCameraPermission();
    }else{
      sAnalytics.kycAllowCamera();
    }

  }
}
