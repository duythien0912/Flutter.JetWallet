import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/decimal_serialiser.dart';

part 'get_quote_response_model.freezed.dart';
part 'get_quote_response_model.g.dart';

@freezed
class GetQuoteResponseModel with _$GetQuoteResponseModel {
  const factory GetQuoteResponseModel({
    required bool isFromFixed,
    required String operationId,
    @DecimalSerialiser() required Decimal price,
    @JsonKey(name: 'fromAsset') required String fromAssetSymbol,
    @JsonKey(name: 'toAsset') required String toAssetSymbol,
    @DecimalSerialiser()
    @JsonKey(name: 'fromAssetVolume')
        required Decimal fromAssetAmount,
    @DecimalSerialiser()
    @JsonKey(name: 'toAssetVolume')
        required Decimal toAssetAmount,
    @JsonKey(name: 'actualTimeInSecond') required int expirationTime,
  }) = _GetQuoteResponseModel;

  factory GetQuoteResponseModel.fromJson(Map<String, dynamic> json) =>
      _$GetQuoteResponseModelFromJson(json);
}
