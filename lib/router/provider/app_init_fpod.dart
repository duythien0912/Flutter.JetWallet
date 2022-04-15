import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_analytics/simple_analytics.dart';

import '../../auth/shared/notifiers/auth_info_notifier/auth_info_notipod.dart';
import '../../shared/helpers/refresh_token.dart';
import '../../shared/notifiers/user_info_notifier/user_info_notipod.dart';
import '../../shared/providers/service_providers.dart';
import '../../shared/services/apps_flyer_service.dart';
import '../../shared/services/local_storage_service.dart';
import '../../shared/services/remote_config_service/remote_config_values.dart';
import '../notifier/startup_notifier/startup_notipod.dart';
import 'authorization_stpod/authorization_stpod.dart';
import 'authorization_stpod/authorization_union.dart';

final appInitFpod = FutureProvider<void>(
  (ref) async {
    final router = ref.watch(authorizationStpod.notifier);
    final authInfoN = ref.watch(authInfoNotipod.notifier);
    final userInfoN = ref.watch(userInfoNotipod.notifier);
    final storageService = ref.watch(localStorageServicePod);

    final token = await storageService.getString(refreshTokenKey);
    final email = await storageService.getString(userEmailKey);
    final parsedEmail = email ?? '<Email not found>';

    try {
      await AppTrackingTransparency.requestTrackingAuthorization();

      final appsFlyerService = AppsFlyerService.create(
        devKey: appsFlyerKey,
        iosAppId: iosAppId,
      );

      await appsFlyerService.init();
    } catch (error, stackTrace) {
      Logger.root.log(Level.SEVERE, 'appsFlyerService', error, stackTrace);
    }

    if (token == null) {
      await sAnalytics.init(analyticsApiKey);

      router.state = const Unauthorized();
    } else {
      authInfoN.updateRefreshToken(token);
      authInfoN.updateEmail(parsedEmail);

      try {
        final result = await refreshToken(ref.read);

        if (result == RefreshTokenStatus.success) {
          await userInfoN.initPinStatus();

          router.state = const Authorized();

          await sAnalytics.init(analyticsApiKey, parsedEmail);

          ref.read(startupNotipod.notifier).authenticatedBoot();
        } else {
          await sAnalytics.init(analyticsApiKey);

          router.state = const Unauthorized();
        }
      } catch (e) {
        await sAnalytics.init(analyticsApiKey);

        router.state = const Unauthorized();
      }
    }
  },
  name: 'appInitFpod',
);
