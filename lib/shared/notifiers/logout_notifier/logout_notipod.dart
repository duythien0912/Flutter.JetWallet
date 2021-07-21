import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../auth/shared/notifiers/auth_info_notifier/auth_info_notipod.dart';
import '../../../router/provider/authorized_stpod/authorized_stpod.dart';
import '../../../router/provider/router_stpod/router_stpod.dart';
import '../../providers/service_providers.dart';
import 'logout_notifier.dart';
import 'logout_union.dart';

final logoutNotipod = StateNotifierProvider<LogoutNotifier, LogoutUnion>(
  (ref) {
    final router = ref.watch(routerStpod.notifier);
    final authService = ref.watch(authServicePod);
    final storageService = ref.watch(localStorageServicePod);
    final authInfo = ref.watch(authInfoNotipod);
    final authInfoN = ref.watch(authInfoNotipod.notifier);
    final signalRService = ref.watch(signalRServicePod);
    final authorized = ref.watch(authorizedStpod);

    return LogoutNotifier(
      router: router,
      authInfo: authInfo,
      authInfoN: authInfoN,
      authService: authService,
      storageService: storageService,
      signalRService: signalRService,
      authorized: authorized,
    );
  },
);
