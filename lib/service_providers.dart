import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'auth/providers/authentication_model_stpod.dart';
import 'router/providers/router_key_pod.dart';
import 'router/providers/router_stpod.dart';
import 'service/services/authentication/service/authentication_service.dart';
import 'service/services/authorization/service/authorization_service.dart';
import 'shared/dio/basic_dio.dart';
import 'shared/dio/dio_without_interceptors.dart';
import 'shared/services/local_storage_service.dart';

final authenticationServicePod = Provider<AuthenticationService>((ref) {
  return AuthenticationService(dioWithoutInterceptors());
});

final authorizationServicePod = Provider<AuthorizationService>((ref) {
  return AuthorizationService(dioWithoutInterceptors());
});

final localStorageServicePod = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});

final dioPod = Provider<Dio>((ref) {
  final router = ref.watch(routerStpod);
  final authModel = ref.watch(authenticationModelStpod);
  final routerKey = ref.watch(routerKeyPod);
  final authenticationService = ref.watch(authenticationServicePod);
  final storageService = ref.watch(localStorageServicePod);

  return basicDio(
    router,
    authModel,
    routerKey,
    authenticationService,
    storageService,
  );
});
