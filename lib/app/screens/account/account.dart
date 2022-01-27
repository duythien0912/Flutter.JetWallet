import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../auth/shared/notifiers/auth_info_notifier/auth_info_notipod.dart';
import '../../../shared/components/loaders/loader.dart';
import '../../../shared/components/log_out_option.dart';
import '../../../shared/helpers/navigator_push.dart';
import '../../../shared/helpers/show_plain_snackbar.dart';
import '../../../shared/notifiers/logout_notifier/logout_notipod.dart';
import '../../../shared/notifiers/logout_notifier/logout_union.dart';
import '../../../shared/notifiers/user_info_notifier/user_info_notipod.dart';
import '../../../shared/providers/flavor_pod.dart';
import '../../shared/features/about_us/about_us.dart';
import '../../shared/features/account_security/view/account_security.dart';
import '../../shared/features/profile_details/view/profile_details.dart';
import '../../shared/features/sms_autheticator/sms_authenticator.dart';
import '../../shared/features/support/support.dart';
import '../../shared/features/transaction_history/view/transaction_hisotry.dart';

class Account extends HookWidget {
  const Account();

  @override
  Widget build(BuildContext context) {
    final flavor = useProvider(flavorPod);
    final logout = useProvider(logoutNotipod);
    final logoutN = useProvider(logoutNotipod.notifier);
    final authInfo = useProvider(authInfoNotipod);
    final userInfo = useProvider(userInfoNotipod);

    return ProviderListener<LogoutUnion>(
      provider: logoutNotipod,
      onChange: (context, union) {
        union.when(
          result: (error, st) {
            if (error != null) {
              showPlainSnackbar(context, '$error');
            }
          },
          loading: () {},
        );
      },
      child: logout.when(
        result: (_, __) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SPaddingH24(
                child: SimpleAccountCategoryHeader(
                  userEmail: authInfo.email,
                ),
              ),
              const SpaceH20(),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    SAccountBannerList(
                      kycPassed: userInfo.kycPassed,
                      twoFaEnabled: userInfo.twoFaEnabled,
                      phoneVerified: userInfo.phoneVerified,
                      onTwoFaBannerTap: () => SmsAuthenticator.push(context),
                      onChatBannerTap: () {},
                    ),
                    const SpaceH20(),
                    Column(
                      children: <Widget>[
                        SimpleAccountCategoryButton(
                          title: 'Profile details',
                          icon: const SProfileDetailsIcon(),
                          isSDivider: true,
                          onTap: () {
                            navigatorPush(context, const ProfileDetails());
                          },
                        ),
                        SimpleAccountCategoryButton(
                          title: 'Security',
                          icon: const SSecurityIcon(),
                          isSDivider: true,
                          onTap: () {
                            navigatorPush(context, const AccountSecurity());
                          },
                        ),
                        SimpleAccountCategoryButton(
                          title: 'History',
                          icon: const SIndexHistoryIcon(),
                          isSDivider: true,
                          onTap: () => TransactionHistory.push(
                            context: context,
                          ),
                        ),
                        SimpleAccountCategoryButton(
                          title: 'Notifications',
                          icon: const SNotificationsIcon(),
                          isSDivider: true,
                          onTap: () {},
                        ),
                        if (flavor == Flavor.dev)
                          SimpleAccountCategoryButton(
                            title: 'Support',
                            icon: const SSupportIcon(),
                            isSDivider: true,
                            onTap: () {
                              navigatorPush(context, const Support());
                            },
                          ),
                        SimpleAccountCategoryButton(
                          title: 'FAQ',
                          icon: const SFaqIcon(),
                          isSDivider: true,
                          onTap: () {},
                        ),
                        SimpleAccountCategoryButton(
                          title: 'About us',
                          icon: const SAboutUsIcon(),
                          isSDivider: false,
                          onTap: () {
                            navigatorPush(context, const AboutUs());
                          },
                        ),
                      ],
                    ),
                    const SpaceH20(),
                    const SDivider(),
                    const SpaceH20(),
                    LogOutOption(
                      name: 'Log out',
                      onTap: () => logoutN.logout(),
                    ),
                    const SpaceH20(),
                    const SDivider(),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Loader(),
      ),
    );
  }
}
