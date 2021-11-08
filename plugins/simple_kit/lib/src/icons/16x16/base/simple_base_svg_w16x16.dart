import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Sometimes we need an icon to target height and sometimes width in order
// to satisfy design guides. This is why there exists BaseSvgR16 and BaseSvgW16
class SimpleBaseSvgW16X16 extends StatelessWidget {
  const SimpleBaseSvgW16X16({
    Key? key,
    this.color,
    required this.assetName,
  }) : super(key: key);

  final Color? color;
  final String assetName;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 16.w,
        maxHeight: 16.w,
        minWidth: 16.w,
        minHeight: 16.w,
      ),
      child: SvgPicture.asset(
        assetName,
        color: color,
        package: 'simple_kit',
      ),
    );
  }
}
