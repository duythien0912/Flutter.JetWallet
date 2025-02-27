import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/components/pin_code_field.dart';
import '../../../../../shared/components/texts/resend_in_text.dart';
import '../../../../../shared/components/texts/resend_rich_text.dart';
import '../../../../../shared/components/texts/verification_description_text.dart';
import '../../../../../shared/helpers/navigator_push.dart';
import '../../../../../shared/helpers/navigator_push_replacement.dart';
import '../../../../../shared/notifiers/timer_notifier/timer_notipod.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../../../screens/account/components/crisp.dart';
import '../notifier/phone_verification_notipod.dart';

const codeLength = 4;

class PhoneVerificationArgs {
  PhoneVerificationArgs({
    this.showChangeTextAlert = false,
    this.sendCodeOnInitState = true,
    required this.phoneNumber,
    required this.onVerified,
  });

  final bool sendCodeOnInitState;
  final bool showChangeTextAlert;
  final String phoneNumber;
  final void Function() onVerified;
}

/// Called in 2 cases:
/// 1. when we need to verfiy user before change number flow
/// 2. when we need to verify a new number from change number flow
class PhoneVerification extends HookWidget {
  const PhoneVerification({
    Key? key,
    required this.args,
  }) : super(key: key);

  final PhoneVerificationArgs args;

  static void push({
    required BuildContext context,
    required PhoneVerificationArgs args,
  }) {
    navigatorPush(
      context,
      PhoneVerification(
        args: args,
      ),
    );
  }

  static void pushReplacement({
    required BuildContext context,
    required PhoneVerificationArgs args,
  }) {
    navigatorPushReplacement(
      context,
      PhoneVerification(
        args: args,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final phone = useProvider(phoneVerificationNotipod(args));
    final phoneN = useProvider(phoneVerificationNotipod(args).notifier);
    // TODO add phoneVerificationCountdown
    final timer = useProvider(timerNotipod(emailResendCountdown));
    final timerN = useProvider(timerNotipod(emailResendCountdown).notifier);
    final colors = useProvider(sColorPod);
    final focusNode = useFocusNode();

    focusNode.addListener(() {
      if (focusNode.hasFocus &&
          phone.controller.value.text.length == codeLength &&
          phone.pinFieldError!.value) {
        phone.controller.clear();
      }
    });

    return SPageFrame(
      loaderText: intl.phoneVerification_pleaseWait,
      loading: phone.loader,
      header: SPaddingH24(
        child: SSmallHeader(
          title: intl.phoneVerification_phoneConfirmation,
          onBackButtonTap: () => Navigator.pop(context),
        ),
      ),
      child: SPaddingH24(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SpaceH10(),
            VerificationDescriptionText(
              text: '${intl.phoneVerification_enterSmsCode} ',
              boldText: phone.phoneNumber,
            ),
            const SpaceH18(),
            if (args.showChangeTextAlert) ...[
              RichText(
                text: TextSpan(
                  style: sBodyText1Style.copyWith(
                    color: colors.grey1,
                  ),
                  children: [
                    TextSpan(
                      text: intl.phoneVerification_pleaseContact,
                    ),
                    TextSpan(
                      text: ' ${intl.phoneVerification_support}',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Crisp.push(
                            context,
                            intl.crispSendMessage_hi,
                          );
                        },
                      style: sBodyText1Style.copyWith(
                        color: colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ] else
              SClickableLinkText(
                text: intl.phoneVerification_changeNumber,
                onTap: () => Navigator.pop(context),
              ),
            const SpaceH18(),
            GestureDetector(
              onLongPress: () => phoneN.pasteCode(),
              onDoubleTap: () => phoneN.pasteCode(),
              onTap: () {
                focusNode.unfocus();

                Future.delayed(const Duration(microseconds: 100), () {
                  if (!focusNode.hasFocus) {
                    focusNode.requestFocus();
                  }
                });
              },
              child: AbsorbPointer(
                child: PinCodeField(
                  focusNode: focusNode,
                  length: codeLength,
                  controller: phone.controller,
                  autoFocus: true,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  onCompleted: (_) => phoneN.verifyCode(),
                  onChanged: (_) {
                    phone.pinFieldError!.disableError();
                  },
                  pinError: phone.pinFieldError!,
                ),
              ),
            ),

            /// TODO update legacy resend
            if (timer > 0 && !phone.showResend)
              ResendInText(
                text: '${intl.phoneVerification_youCanResendIn} $timer'
                    ' ${intl.phoneVerification_seconds}',
              )
            else ...[
              ResendRichText(
                onTap: () async {
                  await phoneN.sendCode();
                  timerN.refreshTimer();
                  phoneN.updateShowResend(
                    showResend: false,
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
