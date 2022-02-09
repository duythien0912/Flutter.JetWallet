import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../service/services/signal_r/model/kyc_countries_response_model.dart';
import '../../../../shared/providers/service_providers.dart';

final kycCountriesSpod =
    StreamProvider.autoDispose<KycCountriesResponseModel>((ref) {
  ref.maintainState = true;

  final signalRService = ref.watch(signalRServicePod);

  return signalRService.kycCountries();
});
