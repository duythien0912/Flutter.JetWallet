import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/shared/notifiers/auth_info_notifier/auth_info_state.dart';
import '../providers/flavor_pod.dart';
import 'helpers/add_interceptors.dart';
import 'helpers/add_logger.dart';
import 'helpers/add_proxy.dart';
import 'helpers/setup_image_headers.dart';

Dio imageDio(AuthInfoState authModel, Reader read) {
  final _dio = Dio();

  setupImageHeaders(_dio, read, authModel.token);

  if (read(flavorPod) == Flavor.dev) {
    addLogger(_dio);
  }

  addInterceptors(_dio, read);

  addProxy(_dio, read);

  return _dio;
}
