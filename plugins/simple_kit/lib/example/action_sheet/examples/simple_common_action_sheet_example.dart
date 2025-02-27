import 'package:flutter/material.dart';

import '../../../simple_kit.dart';

class SimpleCommonActionSheetExample extends StatelessWidget {
  const SimpleCommonActionSheetExample({Key? key}) : super(key: key);

  static const routeName = '/simple_common_action_sheet_example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                sShowBasicModalBottomSheet(
                  context: context,
                  pinned: const SBottomSheetHeader(
                    name: 'Deposit With',
                  ),
                  children: [
                    SFiatItem(
                      icon: const SActionBuyIcon(),
                      name: 'Fiat Currency',
                      amount: '\$0.00',
                      onTap: () {},
                    ),
                    SAssetItem(
                      icon: const SActionBuyIcon(),
                      name: 'Asset Name',
                      amount: '\$0.00',
                      description: 'Asset balance',
                      onTap: () {},
                    ),
                    const SpaceH20(),
                  ],
                );
              },
              child: const Text('Show Common Action Sheet'),
            )
          ],
        ),
      ),
    );
  }
}
