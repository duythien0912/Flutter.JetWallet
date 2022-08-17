import 'dart:io';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../shared/notifiers/timer_notifier/timer_notipod.dart';
import '../../../helpers/navigate_to_router.dart';
import '../../../helpers/navigator_push.dart';
import '../../../helpers/widget_size_from.dart';
import '../../../providers/device_size/device_size_pod.dart';
import '../../../providers/service_providers.dart';
import 'components/progress_bar.dart';
import 'components/success_animation.dart';

class SuccessScreen extends HookWidget {
  const SuccessScreen({
    Key? key,
    this.onSuccess,
    this.primaryText,
    this.secondaryText,
    this.specialTextWidget,
    this.showActionButton = false,
    this.showProgressBar = false,
    this.buttonText,
    required this.time,
  }) : super(key: key);

  // Triggered when SuccessScreen is done
  final Function(BuildContext)? onSuccess;
  final String? primaryText;
  final String? secondaryText;
  final String? buttonText;
  final Widget? specialTextWidget;
  final int time;
  final bool showProgressBar;
  final bool showActionButton;

  static void push({
    Key? key,
    Function()? then,
    Function(BuildContext)? onSuccess,
    String? primaryText,
    String? secondaryText,
    Widget? specialTextWidget,
    int time = 3,
    bool showActionButton = false,
    bool showProgressBar = false,
    String? buttonText,
    required BuildContext context,
  }) {
    log('+++++++++');
    log('$onSuccess');
    log('$primaryText');
    log('$secondaryText');
    log('$specialTextWidget');
    log('$showActionButton');
    log('$showProgressBar');
    log('$buttonText');
    log('$time');
    navigatorPush(
      context,
      SuccessScreen(
        onSuccess: onSuccess,
        primaryText: primaryText,
        secondaryText: secondaryText,
        specialTextWidget: specialTextWidget,
        time: time,
        showActionButton: showActionButton,
        showProgressBar: showProgressBar,
        buttonText: buttonText,
      ),
      then,
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = useProvider(deviceSizePod);
    final colors = useProvider(sColorPod);
    final intl = useProvider(intlPod);
    final showBottomSpace = (Platform.isAndroid ||
        widgetSizeFrom(deviceSize) == SWidgetSize.small) &&
        (showProgressBar || showActionButton);
    log('------------');
    log('$onSuccess');
    log('$primaryText');
    log('$secondaryText');
    log('$specialTextWidget');
    log('$showActionButton');
    log('$showProgressBar');
    log('$buttonText');
    log('$time');

    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: ProviderListener<int>(
        provider: timerNotipod(time),
        onChange: (context, value) {
          if (value == 0) {
            if (onSuccess == null) {
              navigateToRouter(context.read);
            } else {
              onSuccess?.call(context);
            }
          }
        },
        child: SPageFrameWithPadding(
          child: Stack(
            children: [
              Column(
                children: [
                  Row(), // to expand Column in the cross axis
                  const SpaceH86(),
                  SuccessAnimation(
                    widgetSize: widgetSizeFrom(deviceSize),
                  ),
                  Baseline(
                    baseline: 136.0,
                    baselineType: TextBaseline.alphabetic,
                    child: Text(
                      primaryText ?? intl.successScreen_success,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: sTextH2Style,
                    ),
                  ),
                  if (secondaryText != null)
                    Baseline(
                      baseline: 31.4,
                      baselineType: TextBaseline.alphabetic,
                      child: Text(
                        secondaryText!,
                        maxLines: 10,
                        textAlign: TextAlign.center,
                        style: sBodyText1Style.copyWith(
                          color: colors.grey1,
                        ),
                      ),
                    ),
                  if (specialTextWidget != null) specialTextWidget!,
                  Positioned(
                    bottom: 24,
                    child: Column(
                      children: [
                        if (showProgressBar)
                          const ProgressBar(time: 5),
                        if (showActionButton)
                          SSecondaryButton1(
                            active: true,
                            name: intl.previewBuyWithUmlimint_saveCard,
                            icon: Container(
                              margin: const EdgeInsets.only(
                                top: 32,
                              ),
                              child: SActionBuyIcon(
                                color: colors.black,
                              ),
                            ),
                            onTap: () {},
                          ),
                        if (showBottomSpace)
                          const SpaceH24(),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
