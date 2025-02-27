import 'package:flutter/material.dart';

import '../../../simple_kit.dart';
import 'components/simple_policy_rich_text.dart';

class SPolicyCheckbox extends StatelessWidget {
  const SPolicyCheckbox({
    Key? key,
    required this.firstText,
    required this.userAgreementText,
    required this.betweenText,
    required this.privacyPolicyText,
    required this.isChecked,
    required this.onCheckboxTap,
    required this.onUserAgreementTap,
    required this.onPrivacyPolicyTap,
  }) : super(key: key);

  final String firstText;
  final String userAgreementText;
  final String betweenText;
  final String privacyPolicyText;
  final bool isChecked;
  final Function() onCheckboxTap;
  final Function() onUserAgreementTap;
  final Function() onPrivacyPolicyTap;

  @override
  Widget build(BuildContext context) {
    late Widget icon;

    if (isChecked) {
      icon = const SCheckboxSelectedIcon();
    } else {
      icon = const SCheckboxIcon();
    }

    return SizedBox(
      height: 77.0,
      child: Row(
        children: [
          Column(
            children: [
              const SpaceH21(),
              SIconButton(
                onTap: onCheckboxTap,
                defaultIcon: icon,
                pressedIcon: icon,
              ),
            ],
          ),
          const SpaceW10(),
          Expanded(
            child: Column(
              children: [
                const SpaceH25(),
                SimplePolicyRichText(
                  firstText: firstText,
                  userAgreementText: userAgreementText,
                  onUserAgreementTap: onUserAgreementTap,
                  betweenText: betweenText,
                  privacyPolicyText: privacyPolicyText,
                  onPrivacyPolicyTap: onPrivacyPolicyTap,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
