import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/add_card/add_card_request_model.dart';
import '../../model/circle_card.dart';
import '../circle_service.dart';

Future<CircleCard> addCardService(
  Dio dio,
  AddCardRequestModel model,
  String localeName,
) async {
  final logger = CircleService.logger;
  const message = 'addCardService';

  try {
    final response = await dio.post(
      '$walletApi/circle/add-card',
      data: model.toJson(),
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      final data = handleFullResponse<Map>(responseData, localeName);

      return CircleCard.fromJson(data);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
