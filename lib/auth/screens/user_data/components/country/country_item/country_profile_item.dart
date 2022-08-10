import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../app/shared/components/flag_item.dart';
import 'country_profile_name.dart';
import 'country_profile_warning.dart';

class CountryProfileItem extends HookWidget {
  const CountryProfileItem({
    Key? key,
    required this.onTap,
    required this.countryCode,
    required this.countryName,
    required this.isBlocked,
  }) : super(key: key);

  final Function() onTap;
  final String countryCode;
  final String countryName;
  final bool isBlocked;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);

    return InkWell(
      highlightColor: colors.grey5,
      splashColor: Colors.transparent,
      onTap: onTap,
      child: SPaddingH24(
        child: SizedBox(
          height: 64.0,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      top: 20.0,
                    ),
                    child: FlagItem(
                      countryCode: countryCode,
                    ),
                  ),
                  CountryProfileName(
                    countryName: countryName,
                    isBlocked: isBlocked,
                  ),
                  const Spacer(),
                  Visibility(
                    visible: isBlocked,
                    child: const CountryProfileWarning(),
                  )
                ],
              ),
              const Spacer(),
              const SDivider()
            ],
          ),
        ),
      ),
    );
  }
}
