import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../auth/screens/email_verification/notifier/email_verification_notipod.dart';
import '../../../auth/screens/login/login.dart';
import '../../../auth/screens/reset_password/view/reset_password.dart';
import '../../../router/provider/authorized_stpod/authorized_stpod.dart';
import '../../../router/provider/authorized_stpod/authorized_union.dart';
import '../../helpers/navigator_push.dart';
import '../../notifiers/logout_notifier/logout_notipod.dart';
import '../other/navigator_key_pod.dart';
import '../service_providers.dart';

const _code = 'jw_code';
const _token = 'jw_token';
const _command = 'jw_command';
const _confirmEmail = 'ConfirmEmail';
const _forgotPassword = 'ForgotPassword';
const _login = 'Login';
const _confirmWithdraw = 'jw_withdrawal_email_confirm';

final dynamicLinkPod = Provider<void>(
  (ref) {
    final service = ref.watch(dynamicLinkServicePod);
    final navigatorKey = ref.watch(navigatorKeyPod);
    final authorized = ref.watch(authorizedStpod);

    service.initDynamicLinks(
      handler: (link) {
        final parameters = link.queryParameters;
        final command = parameters[_command];

        if (command == _confirmEmail) {
          if (authorized.state is EmailVerification) {
            final notifier = ref.read(emailVerificationNotipod.notifier);

            notifier.updateCode(parameters[_code]);
          }
        } else if (command == _login) {
          ref.read(logoutNotipod.notifier).logout();

          navigatorPush(navigatorKey.currentContext!, const Login());
        } else if (command == _forgotPassword) {
          navigatorPush(
            navigatorKey.currentContext!,
            ResetPassword(
              token: parameters[_token]!,
            ),
          );
        } else if (command == _confirmWithdraw) {
          return;
        } else {
          navigatorPush(
            navigatorKey.currentContext!,
            _UndefinedDeepLink(
              deepLinkParameters: parameters,
            ),
          );
        }
      },
    );
  },
  name: 'dynamicLinkPod',
);

class _UndefinedDeepLink extends StatelessWidget {
  const _UndefinedDeepLink({
    Key? key,
    required this.deepLinkParameters,
  }) : super(key: key);

  final Map<String, String> deepLinkParameters;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Undefined Deep Link',
        ),
      ),
      body: Center(
        child: Column(
          children: [
            for (final parameter in deepLinkParameters.entries)
              Text('${parameter.key}: ${parameter.value}')
          ],
        ),
      ),
    );
  }
}
