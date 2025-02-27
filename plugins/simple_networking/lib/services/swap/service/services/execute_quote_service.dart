import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/execute_quote/execute_quote_request_model.dart';
import '../../model/execute_quote/execute_quote_response_model.dart';
import '../swap_service.dart';

Future<ExecuteQuoteResponseModel> executeQuoteService(
  Dio dio,
  ExecuteQuoteRequestModel model,
  String localeName,
) async {
  final logger = SwapService.logger;
  const message = 'executeQuoteService';

  try {
    final response = await dio.post(
      '$walletApi/trading/swap/execute-quote',
      data: model.toJson(),
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      final data = handleFullResponse<Map>(responseData, localeName);

      return ExecuteQuoteResponseModel.fromJson(data);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
