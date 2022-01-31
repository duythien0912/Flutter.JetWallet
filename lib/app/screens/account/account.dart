import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../auth/shared/notifiers/auth_info_notifier/auth_info_notipod.dart';
import '../../../shared/components/loaders/loader.dart';
import '../../../shared/helpers/navigator_push.dart';
import '../../../shared/helpers/show_plain_snackbar.dart';
import '../../../shared/notifiers/logout_notifier/logout_notipod.dart';
import '../../../shared/notifiers/logout_notifier/logout_union.dart';
import '../../../shared/notifiers/user_info_notifier/user_info_notipod.dart';
import '../../../shared/providers/flavor_pod.dart';
import '../../../shared/providers/service_providers.dart';
import '../../shared/features/about_us/about_us.dart';
import '../../shared/features/account_security/view/account_security.dart';
import '../../shared/features/kyc/model/kyc_operation_status_model.dart';
import '../../shared/features/kyc/notifier/kyc/kyc_notipod.dart';
import '../../shared/features/profile_details/view/profile_details.dart';
import '../../shared/features/sms_autheticator/sms_authenticator.dart';
import '../../shared/features/support/support.dart';
import '../../shared/features/transaction_history/view/transaction_hisotry.dart';
import 'components/account_banner_list.dart';
import 'components/log_out_option.dart';

class Account extends HookWidget {
  const Account();

  @override
  Widget build(BuildContext context) {
    final flavor = useProvider(flavorPod);
    final logout = useProvider(logoutNotipod);
    final logoutN = useProvider(logoutNotipod.notifier);
    final authInfo = useProvider(authInfoNotipod);
    final userInfo = useProvider(userInfoNotipod);

    final kycState = useProvider(kycNotipod);
    final kycAlertHandler = useProvider(
      kycAlertHandlerPod(context),
    );

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
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    const SpaceH20(),
                    AccountBannerList(
                      kycPassed: _checkKycPassed(
                        kycState.depositStatus,
                        kycState.sellStatus,
                        kycState.withdrawalStatus,
                      ),
                      verificationInProgress: kycState.inVerificationProgress,
                      twoFaEnabled: userInfo.twoFaEnabled,
                      phoneVerified: userInfo.phoneVerified,
                      onTwoFaBannerTap: () => SmsAuthenticator.push(context),
                      onChatBannerTap: () {},
                      onKycBannerTap: () {
                        kycAlertHandler.handle(
                          status: kycState.depositStatus,
                          kycVerified: kycState,
                          isProgress: kycState.verificationInProgress,
                          currentNavigate: () {},
                        );
                      },
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

  bool _checkKycPassed(
      int depositStatus,
      int sellStatus,
      int withdrawalStatus,
      ) {
    if (depositStatus == kycOperationStatus(KycOperationStatus.kycRequired) ||
        depositStatus ==
            kycOperationStatus(KycOperationStatus.allowedWithKycAlert)) {
      return false;
    }

    if (sellStatus == kycOperationStatus(KycOperationStatus.kycRequired) ||
        sellStatus ==
            kycOperationStatus(KycOperationStatus.allowedWithKycAlert)) {
      return false;
    }

    if (withdrawalStatus ==
        kycOperationStatus(KycOperationStatus.kycRequired) ||
        withdrawalStatus ==
            kycOperationStatus(KycOperationStatus.allowedWithKycAlert)) {
      return false;
    }
    return true;
  }
}
