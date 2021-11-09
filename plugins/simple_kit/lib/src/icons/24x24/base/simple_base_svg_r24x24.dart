import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Sometimes we need an icon to target height and sometimes width in order
// to satisfy design guides. This is why there exists BaseSvgR24 and BaseSvgW24
class SimpleBaseSvgR24X24 extends StatelessWidget {
  const SimpleBaseSvgR24X24({
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
        maxWidth: 24.r,
        maxHeight: 24.r,
        minWidth: 24.r,
        minHeight: 24.r,
      ),
      child: SvgPicture.asset(
        assetName,
        color: color,
        package: 'simple_kit',
      ),
    );
  }
}
