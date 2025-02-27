import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

class TransactionListItemHeaderText extends StatelessWidget {
  const TransactionListItemHeaderText({
    Key? key,
    this.textAlign,
    this.color,
    required this.text,
  }) : super(key: key);

  final String text;
  final TextAlign? textAlign;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: sSubtitle2Style.copyWith(color: color),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
    );
  }
}
