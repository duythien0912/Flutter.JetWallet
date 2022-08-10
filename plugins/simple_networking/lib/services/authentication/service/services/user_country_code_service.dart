import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/country/country_response_model.dart';
import '../authentication_service.dart';

Future<CountryResponseModel> userCountryService(
  Dio dio,
  String localName,
) async {
  final logger = AuthenticationService.logger;
  const message = 'userCountryService';

  try {
    final response = await dio.get(
      '$authApi/common/ip-country',
    );
    try {
      final responseData = response.data as Map<String, dynamic>;
      final data = handleFullResponse<Map>(
        responseData,
        localName,
      );
      return CountryResponseModel.fromJson(data);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
