import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../../../shared/providers/service_providers.dart';
import '../../../../../../../components/dial_code_item.dart';
import '../../../../../../../helpers/country_code_by_user_register.dart';
import '../../../../../notifier/send_by_phone_input_notifier/send_by_phone_input_notipod.dart';

void showDialCodePicker(BuildContext context) {
  context.read(sendByPhoneInputNotipod.notifier).initDialCodeSearch();

  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    pinned: const _SearchPinned(),
    expanded: true,
    removeBarPadding: true,
    removePinnedPadding: true,
    children: [
      const _DialCodes(),
      const SpaceH24(),
    ],
  );
}

class _SearchPinned extends HookWidget {
  const _SearchPinned({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final notifier = useProvider(sendByPhoneInputNotipod.notifier);

    return SStandardField(
      autofocus: true,
      labelText: intl.showDialCodePicker_searchCountry,
      onChanged: (value) {
        notifier.updateDialCodeSearch(value);
      },
    );
  }
}

class _DialCodes extends HookWidget {
  const _DialCodes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = useProvider(sendByPhoneInputNotipod);
    final notifier = useProvider(sendByPhoneInputNotipod.notifier);
    final userCountryCode = state.sortedDialCodes.where(
      (element) => element.countryCode ==
          countryCodeByUserRegister(context.read)?.countryCode,
    ).toList();

    return Column(
      children: [
        if (userCountryCode.isNotEmpty)
          DialCodeItem(
            dialCode: userCountryCode[0],
            active: state.activeDialCode?.isoCode == userCountryCode[0].isoCode,
            onTap: () {
              sAnalytics.changeCountryCode(userCountryCode[0].countryName);
              notifier.pickDialCodeFromSearch(userCountryCode[0]);
              Navigator.pop(context);
            },
          ),
        for (final code in state.sortedDialCodes)
          if (code.countryCode !=
              countryCodeByUserRegister(context.read)?.countryCode)
            DialCodeItem(
              dialCode: code,
              active: state.activeDialCode?.isoCode == code.isoCode,
              onTap: () {
                sAnalytics.changeCountryCode(code.countryName);
                notifier.pickDialCodeFromSearch(code);
                Navigator.pop(context);
              },
            ),
      ],
    );
  }
}
