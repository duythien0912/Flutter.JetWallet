import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../shared/components/loader.dart';
import '../../shared/components/spacers.dart';
import '../state/notifiers/authentication_notifier/union/authentication_union.dart';
import '../state/providers/auth_screen_stpod.dart';
import '../state/providers/authentication_notipod.dart';
import '../state/providers/credentials_notipod.dart';
import 'components/app_version_text.dart';
import 'components/auth_button.dart';
import 'components/auth_divider.dart';
import 'components/auth_frame.dart';
import 'components/auth_switch.dart';
import 'components/checkmark.dart';
import 'components/text_fields/email_text_field.dart';
import 'components/text_fields/password_text_field.dart';

class Authentication extends HookWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final credentials = useProvider(credentialsNotipod);
    final authScreen = useProvider(authScreenStpod);
    final auth = useProvider(authenticationNotipod);

    return ProviderListener<AuthenticationUnion>(
      provider: authenticationNotipod,
      onChange: (context, union) {
        union.when(
          input: (e, st) {
            if (e != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(e.toString())),
              );
            }
          },
          loading: () {},
        );
      },
      child: AuthFrame(
        child: auth.when(
          input: (_, __) {
            return ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                Checkmark(),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Form(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        EmailTextField(
                          controller: credentials.emailController,
                        ),
                        AuthDivider(),
                        PasswordTextField(
                          controller: credentials.passwordController,
                        ),
                        AuthDivider(),
                        if (authScreen.state == AuthScreen.signUp) ...[
                          PasswordTextField(
                            controller: credentials.repeatPasswordController,
                            isRepeat: true,
                          ),
                          AuthDivider(),
                        ]
                      ],
                    ),
                  ),
                ),
                SpaceH15(),
                const AuthButton(),
                SpaceH15(),
                const AuthSwitch(),
                SpaceH15(),
                const AppVersionText(),
              ],
            );
          },
          loading: () => Loader(),
        ),
      ),
    );
  }
}
