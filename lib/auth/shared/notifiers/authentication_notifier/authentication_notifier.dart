import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../router/provider/router_stpod/router_union.dart';
import '../../../../../service/services/authentication/model/authenticate/authentication_model.dart';
import '../../../../../service/services/authentication/model/authenticate/login_request_model.dart';
import '../../../../../service/services/authentication/model/authenticate/register_request_model.dart';
import '../../../../../service/services/authentication/service/authentication_service.dart';
import '../../../../../service/shared/constants.dart';
import '../../../../../shared/helpers/current_platform.dart';
import '../../../../../shared/helpers/navigate_to_router.dart';
import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/services/local_storage_service.dart';
import '../../../../../shared/services/rsa_service.dart';
import '../../../../shared/features/pin_screen/model/pin_flow_union.dart';
import '../../../../shared/features/pin_screen/view/pin_screen.dart';
import '../../../../shared/helpers/device_uid.dart';
import '../auth_info_notifier/auth_info_notifier.dart';
import 'authentication_union.dart';

enum AuthOperation { login, register }

class AuthenticationNotifier extends StateNotifier<AuthenticationUnion> {
  AuthenticationNotifier({
    required this.router,
    required this.authInfoN,
    required this.authService,
    required this.storageService,
    required this.navigatorKey,
    required this.rsaService,
  }) : super(const Input());

  final StateController<RouterUnion> router;
  final AuthInfoNotifier authInfoN;
  final AuthenticationService authService;
  final LocalStorageService storageService;
  final GlobalKey<NavigatorState> navigatorKey;
  final RsaService rsaService;

  static final _logger = Logger('AuthenticationNotifier');

  Future<void> authenticate({
    required String email,
    required String password,
    required AuthOperation operation,
  }) async {
    _logger.log(notifier, 'authenticate');

    try {
      state = const Loading();

      await rsaService.init();
      await rsaService.savePrivateKey(storageService);

      final publicKey = rsaService.publicKey;

      final id = await deviceUid();

      final loginRequest = LoginRequestModel(
        publicKey: publicKey,
        email: email,
        password: password,
        platform: currentPlatform,
        deviceUid: id,
      );

      final registerRequest = RegisterRequestModel(
        publicKey: publicKey,
        email: email,
        password: password,
        platformType: platformType,
        platform: currentPlatform,
        deviceUid: id,
      );

      AuthenticationModel authModel;

      if (operation == AuthOperation.login) {
        authModel = await authService.login(loginRequest);
      } else {
        authModel = await authService.register(registerRequest);
        authInfoN.updateResendButton();
      }

      await storageService.setString(refreshTokenKey, authModel.refreshToken);
      await storageService.setString(userEmailKey, email);

      authInfoN.updateToken(authModel.token);
      authInfoN.updateRefreshToken(authModel.refreshToken);
      authInfoN.updateEmail(email);

      router.state = const Authorized();

      state = const Input();

      navigateToRouter(navigatorKey);
      PinScreen.push(
        navigatorKey.currentContext!,
        const Enable(),
        cannotLeave: true,
      );
    } catch (e, st) {
      _logger.log(stateFlow, 'authenticate', e);

      state = Input(e, st);
    }
  }
}
