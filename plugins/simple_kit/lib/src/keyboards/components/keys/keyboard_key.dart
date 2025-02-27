import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../../../simple_kit.dart';
import '../../../colors/view/simple_colors_light.dart';
import 'components/keyboard_key_detector.dart';
import 'components/keyboard_key_size.dart';

class KeyboardKey extends HookWidget {
  const KeyboardKey({
    required this.realValue,
    required this.frontKey,
    required this.onKeyPressed,
  });

  /// The value that will be returned onPressed
  final String realValue;

  /// The key that will be showed to the user
  final String frontKey;
  final void Function(String) onKeyPressed;

  @override
  Widget build(BuildContext context) {
    final highlighted = useState(false);

    return KeyboardKeySize(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: highlighted.value
              ? SColorsLight().white
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: KeyboardKeyDetector(
          onTap: () => onKeyPressed(realValue),
          onHighlightChanged: (value) {
            highlighted.value = value;
          },
          child: Center(
            child: Text(
              frontKey,
              style: sTextH4Style.copyWith(
                color: highlighted.value
                    ? SColorsLight().black.withOpacity(0.8)
                    : SColorsLight().black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
