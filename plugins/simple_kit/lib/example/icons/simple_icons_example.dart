import 'package:flutter/material.dart';

import '../shared.dart';
import 'examples/simple_icons_102x56_example.dart';
import 'examples/simple_icons_16x16_example.dart';
import 'examples/simple_icons_24x24_example.dart';
import 'examples/simple_icons_36x36_example.dart';
import 'examples/simple_icons_40x40_example.dart';
import 'examples/simple_icons_56x56_example.dart';

class SimpleIconsExample extends StatelessWidget {
  const SimpleIconsExample({Key? key}) : super(key: key);

  static const routeName = '/simple_icons_example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            NavigationButton(
              buttonName: '16x16',
              routeName: SimpleIcons16X16Example.routeName,
            ),
            NavigationButton(
              buttonName: '24x24',
              routeName: SimpleIcons24X24Example.routeName,
            ),
            NavigationButton(
              buttonName: '36x36',
              routeName: SimpleIcons36X36Example.routeName,
            ),
            NavigationButton(
              buttonName: '40x40',
              routeName: SimpleIcons40X40Example.routeName,
            ),
            NavigationButton(
              buttonName: '56x56',
              routeName: SimpleIcons56X56Example.routeName,
            ),
            NavigationButton(
              buttonName: '102x56',
              routeName: SimpleIcons102X56Example.routeName,
            ),
          ],
        ),
      ),
    );
  }
}
