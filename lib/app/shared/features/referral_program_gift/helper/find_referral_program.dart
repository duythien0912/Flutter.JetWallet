import 'package:simple_networking/services/signal_r/model/campaign_response_model.dart';

List<CampaignModel> findReferralProgram(List<CampaignModel> campaigns) {
  for (final campaign in campaigns) {
    if (campaign.conditions != null && campaign.conditions!.isNotEmpty) {
      for (final condition in campaign.conditions!) {
        if (condition.reward != null) {
          return [campaign];
        }
      }
    }
  }
  return [];
}
