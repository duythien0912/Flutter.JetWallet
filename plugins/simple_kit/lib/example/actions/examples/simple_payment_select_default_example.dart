import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../simple_kit.dart';

class SimplePaymentSelectDefaultExample extends StatelessWidget {
  const SimplePaymentSelectDefaultExample({Key? key}) : super(key: key);

  static const routeName = '/simple_payment_select_default_example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                SPaymentSelectDefault(
                  icon: const SActionBuyIcon(),
                  name: 'Choose payment method',
                  onTap: () {},
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SpaceW24(),
                    const SpaceW24(),
                    const SpaceW24(),
                    Column(
                      children: [
                        const SpaceH32(),
                        Container(
                          width: 24.w,
                          height: 24.w,
                          color: Colors.red.withOpacity(0.3),
                        ),
                      ],
                    ),
                    Container(
                      width: 10.w,
                      height: 88.h,
                      color: Colors.blue.withOpacity(0.2),
                      child: const Text('10px'),
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  height: 32.h,
                  color: Colors.blue.withOpacity(0.3),
                  child: const Text(
                    '32px',
                    textAlign: TextAlign.end,
                  ),
                ),
                Container(
                  height: 50.h,
                  width: double.infinity,
                  color: Colors.green.withOpacity(0.3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      SpaceH32(),
                      Text(
                        '50px',
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SpaceH20(),
            SPaymentSelectDefault(
              icon: const SActionBuyIcon(),
              name: 'Choose payment method',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
