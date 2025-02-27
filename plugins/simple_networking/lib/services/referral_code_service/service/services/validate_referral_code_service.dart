import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/validate_referral_code_request_model.dart';
import '../referral_code_service.dart';

Future<void> validateReferralCodeService(
  Dio dio,
  ValidateReferralCodeRequestModel model,
  String localeName,
) async {
  final logger = ReferralCodeService.logger;
  const message = 'validateReferralCodeService';

  try {
    final response = await dio.post(
      '$authApi/trader/VerifyReferralCode',
      data: model.toJson(),
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      handleResultResponse(responseData, localeName);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
