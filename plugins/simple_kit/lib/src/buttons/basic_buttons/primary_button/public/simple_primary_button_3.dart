import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../light/simple_light_primary_button_3.dart';

class SPrimaryButton3 extends ConsumerWidget {
  const SPrimaryButton3({
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
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return SimpleLightPrimaryButton3(
        active: active,
        name: name,
        onTap: onTap,
        icon: icon,
      );
    } else {
      return SimpleLightPrimaryButton3(
        active: active,
        name: name,
        onTap: onTap,
        icon: icon,
      );
    }
  }
}
