import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/action_send/simple_light_action_send_icon.dart';

class SActionSendIcon extends ConsumerWidget {
  const SActionSendIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightActionSendIcon();
    } else {
      return const SimpleLightActionSendIcon();
    }
  }
}
