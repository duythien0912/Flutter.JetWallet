import 'dart:async';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/device_info/device_info.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/core/services/refresh_token_service.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/core/services/startup_service.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/app/store/models/auth_info_state.dart';
import 'package:jetwallet/features/app/store/models/authorization_union.dart';
import 'package:jetwallet/features/app/store/models/authorized_union.dart';
import 'package:jetwallet/utils/helpers/firebase_analytics.dart';
import 'package:logging/logging.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_networking/helpers/models/refresh_token_status.dart';
import 'package:mobx/mobx.dart';

part 'app_store.g.dart';

class AppStore = _AppStoreBase with _$AppStore;

abstract class _AppStoreBase with Store {
  /// Variable for storing the Auth user's state. Can be: authorized/unauthorized
  @observable
  AuthorizationUnion authStatus = const AuthorizationUnion.unauthorized();
  @action
  AuthorizationUnion setAuthStatus(AuthorizationUnion value) =>
      authStatus = value;

  @observable
  AuthorizedUnion authorizedStatus = const Loading();
  @action
  void setAuthorizedStatus(AuthorizedUnion value) {
    print('setAuthorizedStatus $value');

    authorizedStatus = value;
  }

  @observable
  AuthInfoState authState = const AuthInfoState();

  @observable
  bool actionMenuActive = false;
  @action
  bool setActionMenuActive(bool value) => actionMenuActive = value;

  @observable
  bool openBottomMenu = false;
  @action
  bool setOpenBottomMenu(bool value) => openBottomMenu = value;

  @action
  Future<void> getAuthStatus() async {
    print('getAuthStatus');

    final storageService = getIt.get<LocalStorageService>();
    final deviceInfo = getIt.get<DeviceInfo>();
    final userInfo = getIt.get<UserInfoService>();
    // TODO
    //final appsFlyerService = getIt.get<AppsFlyerService>();

    final token = await storageService.getValue(refreshTokenKey);
    final email = await storageService.getValue(userEmailKey);
    final parsedEmail = email ?? '<${intl.appInitFpod_emailNotFound}>';

    try {
      await AppTrackingTransparency.requestTrackingAuthorization();

      await deviceInfo.deviceInfo();

      /// Init out API client
      await getIt.get<SNetwork>().init();

      unawaited(
        checkInitAppFBAnalytics(
          storageService,
          deviceInfo.model,
        ),
      );

      //await appsFlyerService.init();
      //await appsFlyerService.updateServerUninstallToken();
      // TODO
      // await internetCheckerN.initialise();

    } catch (error, stackTrace) {
      Logger.root.log(Level.SEVERE, 'appsFlyerService', error, stackTrace);
    }

    print('APP STPORE ${token}');

    if (token == null) {
      // TODO
      //await sAnalytics.init(analyticsApiKey);

      authStatus = const AuthorizationUnion.unauthorized();
    } else {
      updateAuthState(
        refreshToken: token,
        email: parsedEmail,
      );

      /// Recreating a dio object with a token
      await getIt.get<SNetwork>().recreateDio();

      try {
        final result = await refreshToken();

        print(result);

        if (result == RefreshTokenStatus.success) {
          await userInfo.initPinStatus();

          await sAnalytics.init(analyticsApiKey, parsedEmail);

          authStatus = const AuthorizationUnion.authorized();

          await getIt.get<StartupService>().processStartupState();
        } else {
          await sAnalytics.init(analyticsApiKey);

          authStatus = const AuthorizationUnion.unauthorized();
        }
      } catch (e) {
        await sAnalytics.init(analyticsApiKey);

        authStatus = const AuthorizationUnion.unauthorized();
      }
    }
  }

  @action
  void updateAuthState({
    String? token,
    String? refreshToken,
    String? email,
    String? deleteToken,
  }) {
    authState = authState.copyWith(
      token: token ?? authState.token,
      refreshToken: refreshToken ?? authState.refreshToken,
      email: email ?? authState.email,
      deleteToken: deleteToken ?? authState.deleteToken,
    );
  }

  /// Whether to show ResendButton in EmailVerification Screen at first open
  void updateResendButton() {
    authState = authState.copyWith(
      showResendButton: !authState.showResendButton,
    );
  }

  /// Resets ResendButton state to the default one
  void resetResendButton() {
    authState = authState.copyWith(showResendButton: true);
  }
}
