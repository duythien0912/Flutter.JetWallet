import 'package:flutter/material.dart';

import '../../base/simple_base_svg_w16x16.dart';

class SimpleLightFeeAlertIcon extends StatelessWidget {
  const SimpleLightFeeAlertIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SimpleBaseSvgW16X16(
      assetName: 'assets/icons/light/16x16/fee_alert/fee_alert.svg',
      color: color,
    );
  }
}
