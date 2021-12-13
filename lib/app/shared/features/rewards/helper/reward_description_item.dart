import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../service/services/signal_r/model/campaign_response_model.dart';
import 'set_reward_description_item.dart';
import 'set_reward_icon.dart';

class RewardsDescriptionItem extends HookWidget {
  const RewardsDescriptionItem({
    Key? key,
    required this.condition,
    required this.conditions,
  }) : super(key: key);

  final CampaignConditionModel condition;
  final List<CampaignConditionModel> conditions;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);

    return Container(
      margin: const EdgeInsets.only(
        bottom: 16.0,
      ),
      width: 287.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          createRewardDescriptionItem(condition, conditions, colors),
          setRewardIcon(condition, conditions),
        ],
      ),
    );
  }
}
