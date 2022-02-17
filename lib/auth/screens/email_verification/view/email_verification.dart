import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../shared/components/pin_code_field.dart';
import '../../../../shared/helpers/analytics.dart';
import '../../../../shared/helpers/open_email_app.dart';
import '../../../../shared/notifiers/logout_notifier/logout_notipod.dart';
import '../../../../shared/notifiers/timer_notifier/timer_notipod.dart';
import '../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../../shared/notifiers/auth_info_notifier/auth_info_notipod.dart';
import '../notifier/email_verification_notipod.dart';
import '../notifier/email_verification_state.dart';

class EmailVerification extends HookWidget {
  const EmailVerification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          title: 'Email verification',
          onBackButtonTap: () => logoutN.logout(),
        ),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SpaceH7(),
                  Text(
                    'Enter the code we have sent to your email',
                    style: sBodyText1Style.copyWith(
                      color: colors.grey1,
                    ),
                  ),
                  Text(
                    authInfo.email,
                    style: sBodyText1Style,
                  ),
                  const SpaceH17(),
                  SClickableLinkText(
                    text: 'Open Email App',
                    onTap: () => openEmailApp(context),
                  ),
                  const Spacer(),
                  PinCodeField(
                    controller: verification.controller,
                    length: emailVerificationCodeLength,
                    onCompleted: (_) {
                      loader.value.startLoading();
                      verificationN.verifyCode();
                    },
                    autoFocus: true,
                    pinError: pinError.value,
                  ),
                  const Spacer(),
                  SResendButton(
                    active: !verification.isResending,
                    timer: showResend.value ? 0 : timer,
                    onTap: () {
                      verificationN.resendCode(
                        onSuccess: () {
                          timerN.refreshTimer();
                          showResend.value = false;
                        },
                      );
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
