import 'package:dio/dio.dart';

import '../model/authorization_refresh_request_model.dart';
import '../model/authorization_request_model.dart';
import '../model/authorization_response_model.dart';
import 'services/authorization_service.dart';
import 'services/logout_service.dart';
import 'services/refresh_service.dart';

class AuthorizationService {
  AuthorizationService(this.dio);

  final Dio dio;

  Future<void> logout() {
    return logoutService(dio);
  }

  Future<AuthorizationResponseModel> authorize(
    AuthorizationRequestModel model,
  ) {
    return authorizationService(dio, model);
  }

  Future<AuthorizationResponseModel> refresh(
      AuthorizationRefreshRequestModel model) {
    return refreshService(dio, model);
  }
}
