import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../authentication/service/authentication_service.dart';
import '../model/verify_email_confirmation_request.dart';

Future<void> verifyEmailConfirmationService(
  Dio dio,
  VerifyEmailConfirmationRequest model,
  String localeName,
) async {
  final logger = AuthenticationService.logger;
  const message = 'emailConfirmationService';

  try {
    final response = await dio.post(
      '$validationApi/verification/verify',
      data: model.toJson(),
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      handleResultResponse(responseData, localeName);
    } catch (e) {
      logger.log(contract, message, e);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message, e);
    rethrow;
  }
}
