import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/two_fa_disable/two_fa_disable_request_model.dart';
import '../two_fa_service.dart';

Future<void> twoFaDisableService(
  Dio dio,
  TwoFaDisableRequestModel model,
  String localeName,
) async {
  final logger = TwoFaService.logger;
  const message = 'twoFaDisableService';

  try {
    final response = await dio.post(
      '$validationApi/2fa/verify-disable',
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
