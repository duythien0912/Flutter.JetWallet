import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/validate_address/validate_address_request_model.dart';
import '../../model/validate_address/validate_address_response_model.dart';
import '../blockchain_service.dart';

Future<ValidateAddressResponseModel> validateAddressService(
  Dio dio,
  ValidateAddressRequestModel model,
  String localeName,
) async {
  final logger = BlockchainService.logger;
  const message = 'validateAddressService';

  try {
    final response = await dio.post(
      '$walletApi/blockchain/validate-address',
      data: model.toJson(),
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      final data = handleFullResponse<Map>(responseData, localeName);

      return ValidateAddressResponseModel.fromJson(data);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
