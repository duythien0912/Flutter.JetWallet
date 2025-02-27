import 'package:flutter/material.dart';

import '../../../../colors/view/simple_colors_light.dart';
import '../base/simple_base_primary_button.dart';

class SimpleLightPrimaryButton3 extends StatelessWidget {
  const SimpleLightPrimaryButton3({
    Key? key,
    this.icon,
    required this.active,
    required this.name,
    required this.onTap,
  }) : super(key: key);

  final Widget? icon;
  final bool active;
  final String name;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return SimpleBasePrimaryButton(
      active: active,
      name: name,
      onTap: onTap,
      icon: icon,
      activeColor: SColorsLight().red,
      activeNameColor: SColorsLight().white,
      inactiveColor: SColorsLight().grey4,
      inactiveNameColor: SColorsLight().white,
    );
  }
}
