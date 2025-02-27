import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../simple_kit.dart';
import '../../../colors/view/simple_colors_light.dart';

class SAddressFieldWithCopy extends HookWidget {
  const SAddressFieldWithCopy({
    Key? key,
    this.realValue,
    this.onTap,
    this.then,
    this.actionIcon,
    this.valueLoading = false,
    required this.header,
    required this.value,
    required this.afterCopyText,
  }) : super(key: key);

  final String? realValue;
  final Function()? onTap;
  final Function()? then;
  final Widget? actionIcon;
  final bool valueLoading;
  final String header;
  final String value;
  final String afterCopyText;

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 200),
      reverseDuration: const Duration(milliseconds: 200),
    );

    final scaleAnimation = Tween(
      begin: 0.0,
      end: -64.0,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      ),
    );

    final translateOffset = Offset(0, scaleAnimation.value);

    useListenable(animationController);

    void _onCopyAction() {
      Clipboard.setData(
        ClipboardData(
          text: realValue ?? value,
        ),
      );
      animationController.forward().then(
        (_) async {
          await Future.delayed(const Duration(seconds: 2));
          await animationController.animateBack(0);
        },
      );

      then?.call();
    }

    return Stack(
      children: [
        Transform.translate(
          offset: translateOffset,
          child: Container(
            color: SColorsLight().greenLight,
            height: 64.0,
            width: double.infinity,
            child: Center(
              child: Text(
                afterCopyText,
                style: sBodyText1Style.copyWith(
                  color: SColorsLight().green,
                ),
              ),
            ),
          ),
        ),
        Material(
          color: SColorsLight().white,
          child: InkWell(
            highlightColor: SColorsLight().grey4,
            splashColor: Colors.transparent,
            onTap: valueLoading ? null : onTap,
            onLongPress: valueLoading ? null : () => _onCopyAction(),
            child: SPaddingH24(
              child: SizedBox(
                height: 88.0,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SpaceH22(),
                          Text(
                            header,
                            style: sCaptionTextStyle.copyWith(
                              color: SColorsLight().grey2,
                            ),
                          ),
                          const SpaceH4(),
                          if (valueLoading)
                            const SSkeletonTextLoader(
                              height: 16,
                              width: 80,
                            )
                          else
                            Baseline(
                              baseline: 16.0,
                              baselineType: TextBaseline.alphabetic,
                              child: Text(
                                _shortReferralLink(value),
                                style: sSubtitle2Style,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SpaceW10(),
                    SIconButton(
                      onTap: valueLoading ? null : () => _onCopyAction(),
                      defaultIcon: const SCopyIcon(),
                      pressedIcon: const SCopyPressedIcon(),
                    ),
                    if (actionIcon != null) ...[
                      const SpaceW20(),
                      SIconButton(
                        onTap: valueLoading ? null : onTap,
                        defaultIcon: actionIcon!,
                      ),
                    ]
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _shortReferralLink(String referralLink) {
    return referralLink.split('https://').last;
  }
}
