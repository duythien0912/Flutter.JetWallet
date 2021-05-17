import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../router/providers/union/router_union.dart';
import '../../../../../service/services/authorization/service/authorization_service.dart';
import '../../../../../shared/services/local_storage_service.dart';
import 'union/logout_union.dart';

class LogoutNotifier extends StateNotifier<LogoutUnion> {
  LogoutNotifier({
    required this.router,
    required this.authorizationService,
    required this.localStorageService,
  }) : super(const Result());

  final StateController<RouterUnion> router;
  final AuthorizationService authorizationService;
  final LocalStorageService localStorageService;

  Future<void> logout() async {
    try {
      state = const Loading();
      
      // todo uncomment
      // await authorizationService.logout();

      await localStorageService.clearStorage();

      router.state = const Unauthorised();
      state = const Result();
    } catch (e, st) {
      state = Result(e, st);
    }
  }
}
