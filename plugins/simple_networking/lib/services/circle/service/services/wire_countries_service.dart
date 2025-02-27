import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/wire_countries/wire_countries_response_model.dart';
import '../circle_service.dart';

Future<WireCountriesResponseModel> wireCountriesService(
  Dio dio,
  String localeName,
) async {
  final logger = CircleService.logger;
  const message = 'wireCountriesService';

  try {
    final response = await dio.get(
      '$walletApi/circle/wire-countries',
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      final data = handleFullResponse<Map>(
        responseData,
        localeName,
      );

      return WireCountriesResponseModel.fromJson(data);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
