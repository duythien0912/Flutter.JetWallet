import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';

import '../../../../service/shared/api_urls.dart';
import '../model/app_config_model.dart';
import '../model/connection_flavor_model.dart';

/// [RemoteConfigService] is a Signleton
class RemoteConfigService {
  factory RemoteConfigService() => _service;

  RemoteConfigService._internal();

  static final _service = RemoteConfigService._internal();

  final _config = RemoteConfig.instance;

  Future<void> fetchAndActivate() async {
    await _config.fetchAndActivate();
  }

  ConnectionFlavorsModel get connectionFlavors {
    final flavors = _config.getString('ConnectionFlavors');

    final list = jsonDecode(flavors) as List;

    return ConnectionFlavorsModel.fromList(list);
  }

  AppConfigModel get appConfig {
    final config = _config.getString('AppConfig');

    final json = jsonDecode(config) as Map<String, dynamic>;

    return AppConfigModel.fromJson(json);
  }

  /// Each index respresents different flavor (backend environment)
  void overrideApisFrom(int index) {
    final flavor = connectionFlavors.flavors[index];

    tradingAuthApi = flavor.tradingAuthApi;
    walletApi = flavor.walletApi;
    tradingApi = flavor.tradingApi;
    validationApi = flavor.validationApi;
  }
}
