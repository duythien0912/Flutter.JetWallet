import 'package:dio/dio.dart';

import '../../../shared/api_urls.dart';
import '../../../shared/constants.dart';
import '../../../shared/helpers/handle_api_responses.dart';
import '../../wallet/service/wallet_service.dart';
import '../model/news_request_model.dart';
import '../model/news_response_model.dart';

Future<NewsResponseModel> newsService(
  Dio dio,
  NewsRequestModel model,
  String localeName,
) async {
  final logger = WalletService.logger;
  const message = 'newsService';

  try {
    final response = await dio.post(
      '$walletApi/market/news',
      data: model.toJson(),
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      final data = handleFullResponse<Map>(responseData, localeName);
      return NewsResponseModel.fromJson(data);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
