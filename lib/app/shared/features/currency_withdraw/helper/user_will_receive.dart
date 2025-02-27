import 'package:decimal/decimal.dart';

import '../../../helpers/truncate_zeros_from.dart';
import '../../../models/currency_model.dart';

/// Calculates amount that user will receive after
/// subtraction of the currency fee
String userWillreceive({
  required String amount,
  required CurrencyModel currency,
  required bool addressIsInternal,
  required String network,
}) {
  final value = Decimal.parse(amount);

  if (addressIsInternal || currency.isFeeInOtherCurrency) {
    return '$amount ${currency.symbol}';
  }

  final fee = currency.withdrawalFeeSize(network);

  if (value <= fee) {
    return '0 ${currency.symbol}';
  } else {
    final result = (value - fee).toStringAsFixed(currency.accuracy);
    final truncated = truncateZerosFrom(result);

    return '$truncated ${currency.symbol}';
  }
}
