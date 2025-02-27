import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/transfer_resend_request_model/transfer_resend_request_model.dart';
import '../transfer_service.dart';

Future<void> transferResendService(
  Dio dio,
  TransferResendRequestModel model,
  String localeName,
) async {
  final logger = TransferService.logger;
  const message = 'transferResendService';

  try {
    final response = await dio.post(
      '$walletApi/transfer/transfer-resend',
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
