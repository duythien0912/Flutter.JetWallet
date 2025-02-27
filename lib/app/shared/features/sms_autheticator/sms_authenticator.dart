import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../shared/features/two_fa_phone/model/two_fa_phone_trigger_union.dart';
import '../../../../shared/features/two_fa_phone/view/two_fa_phone.dart';
import '../../../../shared/helpers/navigator_push.dart';
import '../../../../shared/notifiers/user_info_notifier/user_info_notipod.dart';
import '../../../../shared/providers/service_providers.dart';
import '../set_phone_number/view/set_phone_number.dart';

class SmsAuthenticator extends HookWidget {
  const SmsAuthenticator({Key? key}) : super(key: key);

  static void push(BuildContext context) {
    navigatorPush(context, const SmsAuthenticator());
  }

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final userInfo = useProvider(userInfoNotipod);

    return SPageFrame(
      header: SPaddingH24(
        child: SSmallHeader(
          title: intl.smsAuth_headerTitle,
          onBackButtonTap: () => Navigator.pop(context),
        ),
      ),
      child: Column(
        children: [
          SimpleAccountCategoryButton(
            title: intl.smsAuth_headerTitle,
            icon: const SLockIcon(),
            isSDivider: false,
            switchValue: userInfo.twoFaEnabled,
            onSwitchChanged: (value) {
              if (userInfo.twoFaEnabled) {
                TwoFaPhone.push(
                  context,
                  const Security(
                    fromDialog: true,
                  ),
                );
              } else {
                if (userInfo.phoneVerified) {
                  TwoFaPhone.push(
                    context,
                    const TwoFaPhoneTriggerUnion.security(
                      fromDialog: false,
                    ),
                  );
                } else {
                  SetPhoneNumber.push(
                    context: context,
                    successText: intl.kycAlertHandler_factorVerificationEnabled,
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
