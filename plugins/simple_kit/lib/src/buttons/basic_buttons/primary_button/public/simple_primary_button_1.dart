import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../dark/simple_dark_primary_button_1.dart';
import '../light/simple_light_primary_button_1.dart';

class SPrimaryButton1 extends ConsumerWidget {
  const SPrimaryButton1({
    Key? key,
    this.icon,
    this.addIconPadding = true,
    required this.active,
    required this.name,
    required this.onTap,
  }) : super(key: key);

  final Widget? icon;
  final bool active;
  final String name;
  final Function() onTap;
  final bool addIconPadding;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return SimpleDarkPrimaryButton1(
        active: active,
        name: name,
        onTap: onTap,
        icon: icon,
      );
    } else {
      return SimpleLightPrimaryButton1(
        active: active,
        name: name,
        onTap: onTap,
        icon: icon,
        addIconPadding: addIconPadding,
      );
    }
  }
}
