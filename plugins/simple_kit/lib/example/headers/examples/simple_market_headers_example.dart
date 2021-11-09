import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../simple_kit.dart';
import '../../../src/headers/simple_market_header/simple_market_header.dart';
import '../../../src/headers/simple_market_header/simple_market_header_closed.dart';
import '../../shared.dart';

class SimpleMarketHeadersExample extends StatelessWidget {
  const SimpleMarketHeadersExample({Key? key}) : super(key: key);

  static const routeName = '/simple_market_headers_example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SPaddingH24(
            child: SMarketHeader(
              title: 'Title',
              percent: 1.73,
              isPositive: true,
              subtitle: 'Subtitle',
              onSearchButtonTap: () => showSnackBar(context),
            ),
          ),
          SMarketHeaderClosed(
            title: 'Title',
            onSearchButtonTap: () => showSnackBar(context),
          ),
          const SpaceH30(),
          SPaddingH24(
            child: Stack(
              children: [
                Container(
                  height: 160.h,
                  color: Colors.grey.withOpacity(0.3),
                ),
                Column(
                  children: [
                    Container(
                      height: 64.h,
                      color: Colors.blue.withOpacity(0.3),
                      child: const Center(
                        child: Text('64px'),
                      ),
                    ),
                    Container(
                      height: 24.h,
                      color: Colors.red.withOpacity(0.3),
                      child: const Center(
                        child: Text('24px'),
                      ),
                    ),
                    Container(
                      height: 40.h,
                      color: Colors.green.withOpacity(0.3),
                      child: const Center(
                        child: Text('40px'),
                      ),
                    ),
                    Container(
                      width: 100,
                      height: 32.h,
                      color: Colors.black.withOpacity(0.3),
                      child: const Center(
                        child: Text('32px'),
                      ),
                    ),
                  ],
                ),
                SMarketHeader(
                  title: 'Title',
                  percent: 1.73,
                  isPositive: true,
                  subtitle: 'Subtitle',
                  onSearchButtonTap: () => showSnackBar(context),
                ),
              ],
            ),
          ),
          const SpaceH20(),
          Stack(
            children: [
              SPaddingH24(
                child: Container(
                  height: 120.h,
                  color: Colors.grey.withOpacity(0.3),
                ),
              ),
              SPaddingH24(
                child: Column(
                  children: [
                    Container(
                      height: 64.h,
                      color: Colors.blue.withOpacity(0.3),
                      child: const Center(
                        child: Text('64px'),
                      ),
                    ),
                    Container(
                      height: 24.h,
                      color: Colors.red.withOpacity(0.3),
                      child: const Center(
                        child: Text('24px'),
                      ),
                    ),
                    Container(
                      width: 100,
                      height: 32.h,
                      color: Colors.black.withOpacity(0.3),
                      child: const Center(
                        child: Text('32px'),
                      ),
                    ),
                  ],
                ),
              ),
              SMarketHeaderClosed(
                title: 'Title',
                onSearchButtonTap: () => showSnackBar(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
