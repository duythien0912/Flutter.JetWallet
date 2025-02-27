import 'package:flutter/material.dart';

import '../../../simple_kit.dart';
import '../../shared.dart';

class SimpleSecondaryButtonExample extends StatelessWidget {
  const SimpleSecondaryButtonExample({Key? key}) : super(key: key);

  static const routeName = '/simple_secondary_button_example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SPaddingH24(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const ThemeSwitch(),
              const SpaceH20(),
              SSecondaryButton1(
                active: true,
                name: 'Primary',
                onTap: () {},
              ),
              const SpaceH20(),
              SSecondaryButton2(
                active: true,
                name: 'Primary',
                onTap: () {},
              ),
              const SpaceH20(),
              SSecondaryButton1(
                active: false,
                name: 'Primary',
                onTap: () {},
              ),
              const SpaceH20(),
              SSecondaryButton2(
                active: false,
                name: 'Primary',
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
