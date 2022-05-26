import 'package:flutter/material.dart';

import '../../base/simple_base_svg_56x56.dart';

class SimpleLightEarnActiveIcon extends StatelessWidget {
  const SimpleLightEarnActiveIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvg56X56(
      assetName: 'assets/icons/light/56x56/earn/earn_active.svg',
      color: color,
    );
  }
}
