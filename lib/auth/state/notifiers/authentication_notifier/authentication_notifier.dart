import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../router/state/providers/router_stpod.dart';
import '../../../../router/state/union/router_union.dart';
import '../../../../shared/source/services/local_storage_service.dart';
import '../../../model/authentication/login_request_model.dart';
import '../../../model/authentication/register_request_model.dart';
import '../../../source/repository/auth_repository.dart';
import '../../providers/auth_model_stpod.dart';
import '../../providers/auth_screen_stpod.dart';
import '../../providers/credentials_notipod.dart';
import 'union/authentication_union.dart';

class AuthenticationNotifier extends StateNotifier<AuthenticationUnion> {
  AuthenticationNotifier(this.read) : super(const Input());

  final Reader read;

  Future<AsyncValue<void>> authenticate(AuthScreen authScreen) async {
    if (authScreen == AuthScreen.signIn) {
      return _login();
    } else {
      return _register();
    }
  }

  Future<AsyncValue<void>> _register() async {
    final credentials = read(credentialsNotipod);
    final router = read(routerStpod);

    final model = RegisterRequestModel(
      email: credentials.emailController.text,
      password: credentials.passwordController.text,
    );

    try {
      state = const Loading();

      final authModel = await AuthRepository.register(model);

      read(authModelStpod).state = authModel;

      await LocalStorageService.setString(tokenKey, authModel.token);

      router.state = const Authorised();

      state = const Input();

      return const AsyncValue.data(null);
    } catch (e, st) {
      state = Input(e, st);
      router.state = const Unauthorised();
      return AsyncValue.error(e, st);
    }
  }

  Future<AsyncValue<void>> _login() async {
    final credentials = read(credentialsNotipod);
    final router = read(routerStpod);

    final model = LoginRequestModel(
      email: credentials.emailController.text,
      password: credentials.passwordController.text,
    );

    try {
      state = const Loading();

      final authModel = await AuthRepository.login(model);

      read(authModelStpod).state = authModel;

      await LocalStorageService.setString(tokenKey, authModel.token);

      router.state = const Authorised();

      state = const Input();

      return const AsyncValue.data(null);
    } catch (e, st) {
      state = Input(e, st);
      router.state = const Unauthorised();
      return AsyncValue.error(e, st);
    }
  }
}
