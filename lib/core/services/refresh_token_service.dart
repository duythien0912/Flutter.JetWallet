import 'package:dio/dio.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/core/services/rsa_service.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/app/store/models/authorization_union.dart';
import 'package:simple_networking/helpers/models/refresh_token_status.dart';
import 'package:simple_networking/modules/auth_api/models/refresh/auth_refresh_request_model.dart';

/// Returns [success] if
/// Refreshed token successfully
///
/// Returns [caught] if:
/// 1. Caught 401 error
/// 2. Caught 403 error
///
/// Else [throws] an error
Future<RefreshTokenStatus> refreshToken() async {
  final rsaService = getIt.get<RsaService>();
  final storageService = getIt.get<LocalStorageService>();
  final authInfo = getIt.get<AppStore>().authState;

  try {
    final serverTimeResponse = await getIt
        .get<SNetwork>()
        .simpleNetworking
        .getAuthModule()
        .getServerTime();

    if (serverTimeResponse.data != null) {
      final privateKey = await storageService.getValue(privateKeyKey);
      final refreshToken = authInfo.refreshToken;

      final tokenDateTimeSignatureBase64 = rsaService.sign(
        refreshToken + serverTimeResponse.data!.time,
        privateKey!,
      );

      final model = AuthRefreshRequestModel(
        refreshToken: refreshToken,
        requestTime: serverTimeResponse.data!.time,
        tokenDateTimeSignatureBase64: tokenDateTimeSignatureBase64,
        lang: intl.localeName,
      );

      print(model);

      final refreshRequest = await getIt
          .get<SNetwork>()
          .simpleNetworking
          .getAuthModule()
          .postRefresh(model);

      if (refreshRequest.data != null) {
        print(refreshRequest.data);

        await storageService.setString(
          refreshTokenKey,
          refreshRequest.data!.refreshToken,
        );

        getIt.get<AppStore>().updateAuthState(
              token: refreshRequest.data!.token,
              refreshToken: refreshRequest.data!.refreshToken,
            );

        /// Recreating a dio object with a token
        await getIt.get<SNetwork>().recreateDio();

        print('REFRESH TOKEN ${refreshRequest.data!.token}');

        return RefreshTokenStatus.success;
      } else {
        return RefreshTokenStatus.caught;
      }
    } else {
      return RefreshTokenStatus.caught;
    }
  } on DioError catch (error) {
    print('REFRESH ERROR 3 ${error}');

    final code = error.response?.statusCode;

    if (code == 401 || code == 403) {
      getIt.get<AppStore>().setAuthStatus(
            const AuthorizationUnion.unauthorized(),
          );

      // remove refreshToken from storage
      await storageService.clearStorage();

      return RefreshTokenStatus.caught;
    } else {
      rethrow;
    }
  }
}
