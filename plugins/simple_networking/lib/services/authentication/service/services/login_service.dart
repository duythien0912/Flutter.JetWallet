import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/authenticate/authentication_response_model.dart';
import '../../model/authenticate/login_request_model.dart';
import '../authentication_service.dart';

Future<AuthenticationResponseModel> loginService(
  Dio dio,
  LoginRequestModel model,
  String localName,
) async {
  final logger = AuthenticationService.logger;
  const message = 'loginService';

  try {
    final response = await dio.post(
      '$authApi/trader/AuthenticateW2',
      data: model.toJson(),
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      final data = handleFullResponse<Map>(responseData, localName);

      return AuthenticationResponseModel.fromJson(data);
    } catch (e) {
      logger.log(contract, message, e);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message, e);
    rethrow;
  }
}
