import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../../auth/shared/components/password_validation/password_validation.dart';
import '../../../../../../../../auth/shared/notifiers/credentials_notifier/credentials_notipod.dart';
import '../../../../../../../../shared/components/result_screens/success_screen/success_screen.dart';
import '../../../../notifier/change_password_notifier/change_password_notipod.dart';
import '../../../../notifier/change_password_notifier/change_password_state.dart';

class SetNewPassword extends HookWidget {
  const SetNewPassword({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final changePassword = useProvider(changePasswordNotipod);
    final credentials = useProvider(credentialsNotipod);
    final credentialsN = useProvider(credentialsNotipod.notifier);
    final changePasswordN = useProvider(changePasswordNotipod.notifier);
    final colors = useProvider(sColorPod);
    final notificationQueueN = useProvider(sNotificationQueueNotipod.notifier);
    final loading = useValueNotifier(StackLoaderNotifier());

    return ProviderListener<ChangePasswordState>(
      provider: changePasswordNotipod,
      onChange: (context, state) {
        state.union.when(
          error: (error) {
            loading.value.finishLoading();
            sShowErrorNotification(
              notificationQueueN,
              '$error',
            );
            Navigator.pop(context);
          },
          input: () {},
          done: () {
            SuccessScreen.push(
              context: context,
              secondaryText: 'New password set',
            );
          },
        );
      },
      child: SPageFrame(
        color: colors.grey5,
        header: SPaddingH24(
          child: SSmallHeader(
            title: 'Create a password',
            onBackButtonTap: () => Navigator.of(context).pop(),
          ),
        ),
        loading: loading.value,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: colors.white,
              child: SPaddingH24(
                child: SStandardFieldObscure(
                  onChanged: (String password) {
                    changePasswordN.setNewPassword(password);
                    credentialsN.updateAndValidatePassword(password);
                  },
                  labelText: 'Create a new Password',
                  autofocus: true,
                ),
              ),
            ),
            SPaddingH24(
              child: PasswordValidation(
                password: credentials.password,
              ),
            ),
            const Spacer(),
            SPaddingH24(
              child: SPrimaryButton2(
                active: changePassword.isNewPasswordButtonActive,
                name: 'Set new password',
                onTap: () {
                  loading.value.startLoading();
                  changePasswordN.confirmNewPassword();
                },
              ),
            ),
            const SpaceH24(),
          ],
        ),
      ),
    );
  }
}
