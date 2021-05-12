import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_model.freezed.dart';

@freezed
class AuthModel with _$AuthModel {
  const factory AuthModel({
    required String token,
    required String refreshToken,
    required String tradingUrl,
    required String connectionTimeOut,
    required String reconnectTimeOut,
  }) = _AuthModel;
}
