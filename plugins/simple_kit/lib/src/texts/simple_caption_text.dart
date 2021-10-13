import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'base/simple_base_text.dart';

class SCaptionText extends StatelessWidget {
  const SCaptionText({
    Key? key,
    this.color,
    this.maxLines,
    required this.text,
  }) : super(key: key);

  final Color? color;
  final int? maxLines;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseText(
      text: text,
      color: color,
      fontSize: 12.sp,
      maxLines: maxLines,
      fontWeight: FontWeight.w600,
    );
  }
}
