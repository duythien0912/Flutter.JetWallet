import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

class CountryName extends HookWidget {
  const CountryName({
    Key? key,
    required this.countryName,
  }) : super(key: key);

  final String countryName;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final size = MediaQuery.of(context).size;

    return Baseline(
      baseline: 38.0,
      baselineType: TextBaseline.alphabetic,
      child: Row(
        children: [
          const SpaceW10(),
          SizedBox(
            width: size.width - 140.0,
            child: Text(
              countryName,
              style: sSubtitle2Style.copyWith(
                color: colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
