import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../model/candles_request_model.dart';
import '../../model/candles_response_model.dart';
import '../chart_service.dart';

Future<CandlesResponseModel> candlesService(
  Dio dio,
  CandlesRequestModel model,
) async {
  final logger = ChartService.logger;
  const message = 'candlesService';

  try {
    final response = await dio.get(
      '$candlesApi/Candles/Candles/${model.type}',
      queryParameters: model.toJson(),
    );

    try {
      final responseData = response.data as List<dynamic>;

      return CandlesResponseModel.fromList(responseData);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
