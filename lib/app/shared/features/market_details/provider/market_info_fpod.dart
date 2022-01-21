import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../service/services/market_info/model/market_info_request_model.dart';
import '../../../../../service/services/market_info/model/market_info_response_model.dart';
import '../../../../../shared/providers/service_providers.dart';

final marketInfoFpod = FutureProvider.family
    .autoDispose<MarketInfoResponseModel?, String>((ref, id) {
  final walletService = ref.watch(walletServicePod);
  final intl = ref.watch(intlPod);

  try {
    return walletService.marketInfo(
      MarketInfoRequestModel(
        assetId: id,
        language: intl.localeName,
      ),
    );
  } catch (_) {
    sShowErrorNotification(
      ref.read(sNotificationQueueNotipod.notifier),
      'Something went wrong',
    );
  }

  return Future.value(null);
});
