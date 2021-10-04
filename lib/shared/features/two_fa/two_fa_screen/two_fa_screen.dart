import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../components/page_frame/page_frame.dart';
import '../../../components/security_divider.dart';
import '../../../components/security_option.dart';
import '../../../helpers/navigator_push.dart';
import '../../../notifiers/user_info_notifier/user_info_notipod.dart';
import '../../phone_verification/model/phone_verification_trigger_union.dart';
import '../../phone_verification/phone_verification_enter/view/phone_verification_enter.dart';
import '../two_fa_phone/model/two_fa_phone_trigger_union.dart';
import '../two_fa_phone/view/two_fa_phone.dart';
import 'components/show_sms_auth_warning.dart';

class TwoFaScreen extends HookWidget {
  const TwoFaScreen({Key? key}) : super(key: key);

  static void push(BuildContext context) {
    navigatorPush(context, const TwoFaScreen());
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = useProvider(userInfoNotipod);

    return PageFrame(
      header: '2-Factor-authentication',
      onBackButton: () => Navigator.pop(context),
      child: Column(
        children: [
          SecurityOption(
            name: 'SMS Authenticator',
            icon: Icons.sms,
            switchValue: userInfo.twoFaEnabled,
            onSwitchChanged: (value) {
              if (userInfo.twoFaEnabled) {
                showSmsAuthWarning(context);
              } else {
                if (userInfo.phoneVerified) {
                  TwoFaPhone.push(
                    context,
                    const TwoFaPhoneTriggerUnion.security(
                      fromDialog: false,
                    ),
                  );
                } else {
                  PhoneVerificationEnter.push(
                    context,
                    const PhoneVerificationTriggerUnion.security(),
                  );
                }
              }
            },
          ),
          const SecurityDivider(),
        ],
      ),
    );
  }
}
