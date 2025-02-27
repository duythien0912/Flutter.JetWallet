import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import '../model/authenticate/authentication_response_model.dart';
import '../model/authenticate/login_request_model.dart';
import '../model/authenticate/register_request_model.dart';
import '../model/forgot_password/forgot_password_request_model.dart';
import '../model/logout/logout_request_model.dart';
import '../model/password_recovery/password_recovery_request_model.dart';
import '../model/refresh/auth_refresh_request_model.dart';
import '../model/refresh/auth_refresh_response_model.dart';
import '../model/server_time/server_time_response_model.dart';
import 'services/forgot_password_service.dart';
import 'services/login_service.dart';
import 'services/logout_service.dart';
import 'services/password_recovery_service.dart';
import 'services/refresh_service.dart';
import 'services/register_service.dart';
import 'services/server_time_service.dart';

class AuthenticationService {
  AuthenticationService(this.dio);

  final Dio dio;

  static final logger = Logger('AuthenticationService');

  Future<AuthenticationResponseModel> register(
    RegisterRequestModel model,
    String localName,
  ) {
    return registerService(
      dio,
      model,
      localName,
    );
  }

  Future<AuthenticationResponseModel> login(
    LoginRequestModel model,
    String localName,
  ) {
    return loginService(
      dio,
      model,
      localName,
    );
  }

  Future<AuthRefreshResponseModel> refresh(
    AuthRefreshRequestModel model,
    String localName,
  ) {
    return refreshService(
      dio,
      model,
      localName,
    );
  }

  Future<void> logout(LogoutRequestModel model) {
    return logoutService(dio, model);
  }

  Future<void> forgotPassword(
    ForgotPasswordRequestModel model,
    String localeName,
  ) {
    return forgotPasswordService(dio, model, localeName);
  }

  Future<void> recoverPassword(
    PasswordRecoveryRequestModel model,
    String localeName,
  ) {
    return recoverPasswordService(dio, model, localeName);
  }

  Future<ServerTimeResponseModel> serverTime(String localName) {
    return serverTimeService(dio, localName);
  }
}
