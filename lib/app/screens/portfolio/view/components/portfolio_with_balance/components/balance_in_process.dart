import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../shared/providers/service_providers.dart';
import '../../../../../../shared/components/dash_line.dart';

class BalanceInProcess extends HookWidget {
  const BalanceInProcess({
    this.removeDivider = false,
    required this.text,
  });

  final bool removeDivider;
  final String text;

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);

    return SPaddingH24(
      child: SizedBox(
        height: 54,
        child: Column(
          children: [
            Row(
              children: const [
                Expanded(
                  child: DashLine(),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: SPlusIcon(
                    color: colors.grey2,
                  ),
                ),
                const SpaceW12(),
                Baseline(
                  baseline: 27.0,
                  baselineType: TextBaseline.alphabetic,
                  child: Text(
                    text,
                    style: sBodyText2Style.copyWith(
                      color: colors.grey2,
                    ),
                  ),
                ),
                const Spacer(),
                Baseline(
                  baseline: 27.0,
                  baselineType: TextBaseline.alphabetic,
                  child: Text(
                    '${intl.balanceInProcess_balanceInProcess}...',
                    style: sBodyText2Style.copyWith(
                      color: colors.grey2,
                    ),
                  ),
                )
              ],
            ),
            const Spacer(),
            if (!removeDivider) const SDivider(),
          ],
        ),
      ),
    );
  }
}
