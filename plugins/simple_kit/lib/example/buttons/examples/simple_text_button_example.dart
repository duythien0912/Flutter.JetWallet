import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../simple_kit.dart';
import '../../shared.dart';

class SimpleTextButtonExample extends StatelessWidget {
  const SimpleTextButtonExample({Key? key}) : super(key: key);

  static const routeName = '/simple_text_button_example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 24.w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const ThemeSwitch(),
              const SpaceH20(),
              STextButton1(
                active: true,
                name: 'Primary',
                onTap: () {},
              ),
              const SpaceH20(),
              STextButton2(
                active: true,
                name: 'Primary',
                onTap: () {},
              ),
              const SpaceH20(),
              STextButton1(
                active: false,
                name: 'Primary',
                onTap: () {},
              ),
              const SpaceH20(),
              STextButton2(
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
