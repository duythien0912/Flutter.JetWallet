import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'preview_sell_union.dart';

part 'preview_sell_state.freezed.dart';

@freezed
class PreviewSellState with _$PreviewSellState {
  const factory PreviewSellState({
    String? operationId,
    double? price,
    String? fromAssetSymbol,
    String? toAssetSymbol,
    double? fromAssetAmount,
    double? toAssetAmount,
    // Will be initialzied on initState of the parent widget
    AnimationController? timerAnimation,
    // [true] when requestQuote() takes too long
    @Default(false) bool connectingToServer,
    @Default(QuoteLoading()) PreviewSellUnion union,
    @Default(0) int timer,
  }) = _ConvertState;
}
