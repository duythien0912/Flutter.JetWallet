import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:universal_io/io.dart';

import '../../../../shared/components/pin_code_field.dart';
import '../../../../shared/helpers/analytics.dart';
import '../../../../shared/helpers/open_email_app.dart';
import '../../../../shared/notifiers/logout_notifier/logout_notipod.dart';
import '../../../../shared/notifiers/timer_notifier/timer_notipod.dart';
import '../../../../shared/providers/service_providers.dart';
import '../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../../shared/notifiers/auth_info_notifier/auth_info_notipod.dart';
import '../notifier/email_verification_notipod.dart';
import '../notifier/email_verification_state.dart';

class EmailVerification extends StatefulHookWidget {
  const EmailVerification({Key? key}) : super(key: key);

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification>
    with WidgetsBindingObserver {
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    focusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read(emailVerificationNotipod.notifier).pasteCode();

      if (mounted && Platform.isAndroid) {
        // Workaround to fix bug related to Flutter framework.
        // When app goes to background and comes back,
        // the keyboard is not showing
        // Reproducible only on Android. But even this fix has it flaws.
        // When I half-collapse app and coming back keyboard can't be accessed
        // because this half-collapse doesn't trigger app to go to background,
        // hence, code below won't be executed
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          final verification = context.read(emailVerificationNotipod);
          await Future.delayed(const Duration(milliseconds: 200));
          if (verification.controller.value.text.length !=
              emailVerificationCodeLength) {
            if (focusNode.hasFocus) {
              focusNode.unfocus();
              Future.delayed(
                const Duration(microseconds: 1),
                () => focusNode.requestFocus(),
              );
            } else {
              focusNode.requestFocus();
            }
          }
        });
      }
    } else if (state == AppLifecycleState.paused) {
      if (focusNode.hasFocus) {
        focusNode.unfocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);
    final timer = useProvider(timerNotipod(emailResendCountdown));
    final timerN = useProvider(timerNotipod(emailResendCountdown).notifier);
    final logoutN = useProvider(logoutNotipod.notifier);
    final verification = useProvider(emailVerificationNotipod);
    final verificationN = useProvider(emailVerificationNotipod.notifier);
    final authInfo = useProvider(authInfoNotipod);
    final showResend = useState(authInfo.showResendButton);
    final notificationN = useProvider(sNotificationNotipod.notifier);
    final pinError = useValueNotifier(StandardFieldErrorNotifier());
    final loader = useValueNotifier(StackLoaderNotifier());

    focusNode.addListener(() {
      if (focusNode.hasFocus &&
          verification.controller.value.text.length ==
              emailVerificationCodeLength &&
          pinError.value.value) {
        verification.controller.clear();
      }
    });

    analytics(() => sAnalytics.emailVerificationView());

    return ProviderListener<EmailVerificationState>(
      provider: emailVerificationNotipod,
      onChange: (context, state) {
        state.union.maybeWhen(
          error: (Object? error) {
            loader.value.finishLoading();
            pinError.value.enableError();
            notificationN.showError(
              error.toString(),
              id: 1,
            );
          },
          orElse: () {},
        );
      },
      child: SPageFrameWithPadding(
        loading: loader.value,
        header: SBigHeader(
          title: intl.emailVerification_emailVerification,
          onBackButtonTap: () => logoutN.logout(),
        ),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SpaceH7(),
                  FittedBox(
                    child: Text(
                      intl.emailVerification_enterCode,
                      style: sBodyText1Style.copyWith(
                        color: colors.grey1,
                      ),
                    ),
                  ),
                  Text(
                    authInfo.email,
                    style: sBodyText1Style,
                  ),
                  const SpaceH17(),
                  SClickableLinkText(
                    text: intl.emailVerification_openEmail,
                    onTap: () => openEmailApp(context),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onLongPress: () => verificationN.pasteCode(),
                    onDoubleTap: () => verificationN.pasteCode(),
                    onTap: () {
                      focusNode.unfocus();

                      Future.delayed(const Duration(microseconds: 100), () {
                        if (!focusNode.hasFocus) {
                          focusNode.requestFocus();
                        }
                      });
                    },
                    // AbsorbPointer needed to avoid TextField glitch onTap
                    // when it's focused
                    child: AbsorbPointer(
                      child: PinCodeField(
                        focusNode: focusNode,
                        controller: verification.controller,
                        length: emailVerificationCodeLength,
                        onCompleted: (_) {
                          loader.value.startLoading();
                          verificationN.verifyCode();
                        },
                        autoFocus: true,
                        onChanged: (_) {
                          pinError.value.disableError();
                        },
                        pinError: pinError.value,
                      ),
                    ),
                  ),
                  const Spacer(),
                  SResendButton(
                    active: !verification.isResending,
                    timer: showResend.value ? 0 : timer,
                    onTap: () {
                      verification.controller.clear();

                      verificationN.resendCode(
                        onSuccess: () {
                          timerN.refreshTimer();
                          showResend.value = false;
                        },
                      );
                    },
                    text1: intl.emailVerification_youCanResendIn,
                    text2: intl.emailVerification_seconds,
                    text3: intl.emailVerification_didntReceiveTheCode,
                    textResend: intl.emailVerification_resend,
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
