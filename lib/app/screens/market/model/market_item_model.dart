import 'package:freezed_annotation/freezed_annotation.dart';

part 'market_item_model.freezed.dart';
part 'market_item_model.g.dart';

@freezed
class MarketItemModel with _$MarketItemModel {
  const factory MarketItemModel({
    required String id,
    required String name,
    required String iconUrl,
    required String associateAsset,
    required String associateAssetPair,
    required int weight,
    required double lastPrice,
    required double dayPriceChange,
    required double dayPercentChange,
    required double assetBalance,
    required double baseBalance,
  }) = _MarketItemModel;

  factory MarketItemModel.fromJson(Map<String, dynamic> json) =>
      _$MarketItemModelFromJson(json);

  const MarketItemModel._();

  bool get isGrowing => dayPercentChange > 0;

  bool get isBalanceEmpty => baseBalance == 0;
}