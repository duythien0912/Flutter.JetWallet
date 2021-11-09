import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

class ClickableLinkText extends StatelessWidget {
  const ClickableLinkText({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  final String text;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: text,
        style: sSubtitle3Style.copyWith(
          fontFamily: 'Gilroy',
          color: SColorsLight().blue,
        ),
        recognizer: TapGestureRecognizer()..onTap = onTap,
      ),
    );
  }
}
