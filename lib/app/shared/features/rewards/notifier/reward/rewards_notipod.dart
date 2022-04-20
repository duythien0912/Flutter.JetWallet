import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../service/services/signal_r/model/campaign_response_model.dart';
import '../../../../../../service/services/signal_r/model/referral_stats_response_model.dart';
import '../../../referral_stats/provider/referral_stats_pod.dart';
import '../../model/campaign_or_referral_model.dart';
import '../../provider/rewards_pod.dart';
import 'rewards_notifier.dart';
import 'rewards_state.dart';

final rewardsNotipod = StateNotifierProvider.autoDispose<RewardsNotifier,
    RewardsState>(
  (ref) {
    final campaigns = ref.watch(rewardsPod);
    final referralStats = ref.watch(referralStatsPod);

    final sortedCampaigns = _sort(campaigns, referralStats);

    return RewardsNotifier(
      read: ref.read,
      sortedCampaigns: sortedCampaigns,
    );
  },
  name: 'rewardsNotipod',
);

List<CampaignOrReferralModel> _sort(
    List<CampaignModel> campaigns,
    List<ReferralStatsModel> referralStats,
    ) {
  final combinedArray = <CampaignOrReferralModel>[];
  final campaignsArray = List<CampaignModel>.from(campaigns);
  final referralStatsArray =
  List<ReferralStatsModel>.from(referralStats);

  for (final campaign in campaignsArray) {
    combinedArray.add(CampaignOrReferralModel(campaign: campaign));
  }

  for (final referralStat in referralStatsArray) {
    combinedArray.add(CampaignOrReferralModel(referralState: referralStat));
  }

  combinedArray.sort((a, b) {
    final weight1 = a.campaign?.weight ?? a.referralState!.weight;
    final weight2 = b.campaign?.weight ?? b.referralState!.weight;

    return weight2.compareTo(weight1);
  });

  return combinedArray;
}
