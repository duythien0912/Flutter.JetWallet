import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/notifiers/user_info_notifier/user_info_notipod.dart';
import '../../../../../../shared/providers/service_providers.dart';
import '../../helper/protection_level.dart';

class SecurityProtection extends HookWidget {
  const SecurityProtection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userInfo = useProvider(userInfoNotipod);
    final level = protectionLevel(userInfo, context);
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.bottomLeft,
          height: 40.0,
          child: Text(
            '${level.name} ${intl.securityProtection_protectionLevel}',
            style: sSubtitle3Style.copyWith(
              color: colors.grey1,
            ),
          ),
        ),
        const SpaceH20(),
        SimpleAccountProtectionIndicator(
          indicatorColor: level.color,
        ),
      ],
    );
  }
}
