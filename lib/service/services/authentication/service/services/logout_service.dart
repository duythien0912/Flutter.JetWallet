import 'package:dio/dio.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../model/logout/logout_request_model.dart';
import '../authentication_service.dart';

Future<void> logoutService(
  Dio dio,
  LogoutRequestModel model,
) async {
  try {
    await dio.post(
      '$authApi/trader/Logout',
      data: model.toJson(),
    );
  } catch (e) {
    AuthenticationService.logger.log(transport, 'logoutService', e);
    rethrow;
  }
}
