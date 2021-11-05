import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../simple_kit.dart';
import '../../../src/action_sheet/components/simple_fiat_sheet_item.dart';

class SimpleFiatSheetItemExample extends StatelessWidget {
  const SimpleFiatSheetItemExample({Key? key}) : super(key: key);

  static const routeName = '/simple_fiat_sheet_item_example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  color: Colors.grey[200],
                  child: SFiatSheetItem(
                    onTap: () {},
                    icon: const SActionBuyIcon(),
                    name: 'Fiat Currency',
                    amount: '\$1000000.00',
                  ),
                ),
                Column(
                  children: [
                    const SpaceH34(),
                    Row(
                      children: [
                        const SpaceW24(),
                        Container(
                          width: 24.w,
                          height: 24.w,
                          color: Colors.purple.withOpacity(0.2),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    const SpaceW24(),
                    const SpaceW24(),
                    Container(
                      width: 20.w,
                      height: 88.h,
                      color: Colors.blue.withOpacity(0.2),
                      child: const Text('20px'),
                    ),
                    Container(
                      width: 150.w,
                      height: 88.h,
                      color: Colors.red.withOpacity(0.2),
                      child: Column(
                        children: const [
                          Spacer(),
                          Text(
                            '150px',
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 120.w,
                      height: 88.h,
                      color: Colors.red.withOpacity(0.2),
                      child: Column(
                        children: const [
                          Spacer(),
                          Text(
                            '120px',
                          ),
                        ],
                      ),
                    ),
                    const SpaceW24(),
                  ],
                ),
                Container(
                  height: 34.h,
                  color: Colors.blue.withOpacity(0.2),
                  child: const Center(
                    child: Text(
                      '34px',
                    ),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      height: 50.h,
                      color: Colors.green.withOpacity(0.2),
                      child: Column(
                        children: [
                          const Spacer(),
                          Row(
                            children: const [
                              SpaceW90(),
                              SpaceW90(),
                              SpaceW30(),
                              Center(
                                child: Text(
                                  '50px',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
            const SpaceH20(),
            SFiatSheetItem(
              onTap: () {},
              icon: const SActionBuyIcon(),
              name: 'Fiat Currency',
              amount: '\$1000000.00',
            ),
          ],
        ),
      ),
    );
  }
}
