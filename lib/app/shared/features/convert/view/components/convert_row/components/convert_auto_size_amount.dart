import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../../shared/providers/service_providers.dart';

class ConvertAutoSizeAmount extends HookWidget {
  const ConvertAutoSizeAmount({
    Key? key,
    required this.onTap,
    required this.value,
    required this.enabled,
  }) : super(key: key);

  final Function() onTap;
  final String value;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);

    return Expanded(
      child: STransparentInkWell(
        onTap: onTap,
        child: AutoSizeText(
          // TODO add reactive value (blocked by backend)
          value.isEmpty ? '${intl.min} 0.001' : value,
          textAlign: TextAlign.end,
          minFontSize: 4.0,
          maxLines: 1,
          strutStyle: const StrutStyle(
            height: 1.29,
            fontSize: 28.0,
            fontFamily: 'Gilroy',
          ),
          style: TextStyle(
            height: 1.29,
            fontSize: 28.0,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w600,
            color: enabled
                ? value.isEmpty
                    ? colors.grey2
                    : colors.black
                : colors.grey2,
          ),
        ),
      ),
    );
  }
}
