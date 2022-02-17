import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';

import '../model/analytics_model.dart';
import '../model/app_config_model.dart';
import '../model/connection_flavor_model.dart';
import '../model/versioning_model.dart';
import '../remote_config_values.dart';

const _defaultFlavorIndex = 0;

/// [RemoteConfigService] is a Signleton
class RemoteConfigService {
  factory RemoteConfigService() => _service;

  RemoteConfigService._internal();

  static final _service = RemoteConfigService._internal();

  final _config = RemoteConfig.instance;

  Future<void> fetchAndActivate() async {
    await _config.fetchAndActivate();
    overrideAppConfigValues();
    overrideApisFrom(_defaultFlavorIndex);
    overrideVersioningValues();
    overrideAnalyticsValues();
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

  VersioningModel get versioning {
    final values = _config.getString('Versioning');

    final json = jsonDecode(values) as Map<String, dynamic>;

    return VersioningModel.fromJson(json);
  }

  AnalyticsModel get analytics {
    final values = _config.getString('Analytics');

    final json = jsonDecode(values) as Map<String, dynamic>;

    return AnalyticsModel.fromJson(json);
  }

  /// Each index respresents different flavor (backend environment)
  void overrideApisFrom(int index) {
    final flavor = connectionFlavors.flavors[index];

    candlesApi = flavor.candlesApi;
    authApi = flavor.authApi;
    walletApi = flavor.walletApi;
    walletApiSignalR = flavor.walletApiSignalR;
    validationApi = flavor.validationApi;
    iconApi = flavor.iconApi;
  }

  void overrideAppConfigValues() {
    emailVerificationCodeLength = appConfig.emailVerificationCodeLength;
    phoneVerificationCodeLength = appConfig.phoneVerificationCodeLength;
    userAgreementLink = appConfig.userAgreementLink;
    privacyPolicyLink = appConfig.privacyPolicyLink;
    minAmountOfCharsInPassword = appConfig.minAmountOfCharsInPassword;
    maxAmountOfCharsInPassword = appConfig.maxAmountOfCharsInPassword;
    quoteRetryInterval = appConfig.quoteRetryInterval;
    defaultAssetIcon = appConfig.defaultAssetIcon;
    emailResendCountdown = appConfig.emailResendCountdown;
    withdrawalConfirmResendCountdown = appConfig.withdrawConfirmResendCountdown;
    localPinLength = appConfig.localPinLength;
  }

  void overrideVersioningValues() {
    recommendedVersion = versioning.recommendedVersion;
    minimumVersion = versioning.minimumVersion;
  }

  void overrideAnalyticsValues() {
    analyticsApiKey = analytics.apiKey;
  }
}
