import 'package:flutter/material.dart';

import '../../base/simple_base_svg_40x40.dart';

class SimpleLightConvertIcon extends StatelessWidget {
  const SimpleLightConvertIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg40X40(
      assetName: 'assets/icons/light/40x40/convert/convert.svg',
      color: color,
    );
  }
}
