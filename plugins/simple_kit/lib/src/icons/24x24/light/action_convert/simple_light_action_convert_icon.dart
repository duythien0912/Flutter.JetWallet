import 'package:flutter/material.dart';

import '../../base/simple_base_svg_w24x24.dart';

class SimpleLightActionConvertIcon extends StatelessWidget {
  const SimpleLightActionConvertIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvgW24X24(
      assetName: 'assets/icons/light/24x24/action_convert/action_convert.svg',
      color: color,
    );
  }
}
