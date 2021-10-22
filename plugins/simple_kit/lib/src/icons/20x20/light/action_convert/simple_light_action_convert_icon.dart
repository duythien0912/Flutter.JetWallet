import 'package:flutter/material.dart';

import '../../base/simple_base_svg_20x20.dart';

class SimpleLightActionConvertIcon extends StatelessWidget {
  const SimpleLightActionConvertIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg20X20(
      assetName: 'assets/icons/light/20x20/action_convert/action_convert.svg',
      color: color,
    );
  }
}
