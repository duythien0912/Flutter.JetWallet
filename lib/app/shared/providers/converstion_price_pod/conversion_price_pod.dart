import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/providers/service_providers.dart';
import 'conversion_price_input.dart';

final conversionPriceFpod = FutureProvider.autoDispose
    .family<void, ConversionPriceInput>((ref, input) async {
  final walletService = ref.read(walletServicePod);
  final intl = ref.read(intlPod);

  final response = await walletService.conversionPrice(
    input.baseAssetSymbol,
    input.quotedAssetSymbol,
    intl.localeName,
  );

  input.then(response.price);
});
