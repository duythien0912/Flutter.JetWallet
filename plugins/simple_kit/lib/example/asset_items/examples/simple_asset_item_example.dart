import 'package:flutter/material.dart';

import '../../../simple_kit.dart';

class SimpleAssetItemExample extends StatelessWidget {
  const SimpleAssetItemExample({Key? key}) : super(key: key);

  static const routeName = '/simple_asset_item_example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                ColoredBox(
                  color: Colors.grey[200]!,
                  child: SAssetItem(
                    onTap: () {},
                    icon: const SActionBuyIcon(),
                    name: 'Asset Name',
                    amount: '\$1000000.00',
                    description: 'Description',
                    helper: 'Helper text',
                  ),
                ),
                Column(
                  children: [
                    const SpaceH22(),
                    Row(
                      children: [
                        const SpaceW24(),
                        Container(
                          width: 24.0,
                          height: 24.0,
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
                      width: 20.0,
                      height: 88.0,
                      color: Colors.blue.withOpacity(0.2),
                      child: const Text('20px'),
                    ),
                    Expanded(
                      child: Container(
                        height: 88.0,
                        color: Colors.red.withOpacity(0.2),
                        child: Column(
                          children: const [
                            Spacer(),
                            Text(
                              'Expanded',
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 16.0,
                      height: 88.0,
                      color: Colors.blue.withOpacity(0.2),
                      child: const Text('16px'),
                    ),
                    Container(
                      width: 120.0,
                      height: 88.0,
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
                  height: 22.0,
                  color: Colors.blue.withOpacity(0.2),
                  child: const Center(
                    child: Text(
                      '22px',
                    ),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      height: 40.0,
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
                                  '40px',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 20.0,
                      color: Colors.purple.withOpacity(0.2),
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
                                  '20px',
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
            SAssetItem(
              onTap: () {},
              icon: const SActionBuyIcon(),
              name: 'Asset Name',
              amount: '\$1000000.00',
              description: 'Description',
              helper: 'Helper text',
            ),
            const SpaceH20(),
            Stack(
              children: [
                ColoredBox(
                  color: Colors.grey[200]!,
                  child: SAssetItem(
                    onTap: () {},
                    icon: const SActionBuyIcon(),
                    name: 'Card Name',
                    amount: '•••• 0000',
                    description: 'Date',
                    helper: 'Limit',
                  ),
                ),
                Column(
                  children: [
                    const SpaceH22(),
                    Row(
                      children: [
                        const SpaceW24(),
                        Container(
                          width: 24.0,
                          height: 24.0,
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
                      width: 20.0,
                      height: 88.0,
                      color: Colors.blue.withOpacity(0.2),
                      child: const Text('20px'),
                    ),
                    Expanded(
                      child: Container(
                        height: 88.0,
                        color: Colors.red.withOpacity(0.2),
                        child: Column(
                          children: const [
                            Spacer(),
                            Text(
                              'Expanded',
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 16.0,
                      height: 88.0,
                      color: Colors.blue.withOpacity(0.2),
                      child: const Text('16px'),
                    ),
                    Container(
                      width: 90.0,
                      height: 88.0,
                      color: Colors.red.withOpacity(0.2),
                      child: Column(
                        children: const [
                          Spacer(),
                          Text(
                            '90px',
                          ),
                        ],
                      ),
                    ),
                    const SpaceW24(),
                  ],
                ),
                Container(
                  height: 22.0,
                  color: Colors.blue.withOpacity(0.2),
                  child: const Center(
                    child: Text(
                      '22px',
                    ),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      height: 40.0,
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
                                  '40px',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 20.0,
                      color: Colors.purple.withOpacity(0.2),
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
                                  '20px',
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
            SAssetItem(
              onTap: () {},
              icon: const SActionBuyIcon(),
              name: 'Card Name',
              amount: '•••• 0000',
              description: 'Date',
              helper: 'Limit',
            ),
          ],
        ),
      ),
    );
  }
}
