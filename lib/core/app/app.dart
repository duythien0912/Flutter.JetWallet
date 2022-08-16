import 'package:flutter/cupertino.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../auth/screens/email_verification/view/email_verification.dart';


import '../../auth/screens/single_sign_in/sing_in.dart';
import '../../router/view/router.dart';
import '../../shared/logging/provider_logger.dart';
import '../../shared/notifiers/time_tracking_notifier/time_tracking_notipod.dart';
import '../../shared/providers/background/initialize_background_providers.dart';
import '../../shared/providers/device_info_pod.dart';
import '../../shared/providers/package_info_fpod.dart';
import '../../shared/providers/service_providers.dart';
import '../stage/app_router_stage/app_router_stage.dart';
import '../stage/components/app_init.dart';
import 'app_builder.dart';

final _providerTypes = <String>[
  'AutoDisposeProvider<List<CurrencyModel>>',
  'AutoDisposeProvider<List<MarketItemModel>>',
  'AutoDisposeStreamProvider<BasePricesModel>',
  'AutoDisposeStateNotifierProvider<ChartNotifier, ChartState>',
  'AutoDisposeStateNotifierProvider<TimerNotifier, int>',
  'AutoDisposeStateNotifierProvider<ConvertInputNotifier, ConvertInputState>',
  'AutoDisposeStreamProvider<PriceAccuracies>',
  'AutoDisposeStreamProvider<AssetsModel>',
  'AutoDisposeStreamProvider<BalancesModel>',
  'AutoDisposeStreamProvider<KycCountriesResponseModel>',
  'AutoDisposeStateNotifierProvider<KycCountriesNotifier, KycCountriesState>',
  'AutoDisposeStreamProvider<MarketReferencesModel>',
  'AutoDisposeStreamProvider<CampaignResponseModel>',
  'AutoDisposeProvider<List<CampaignModel>>',
  'AutoDisposeStateNotifierProvider<CampaignNotifier, List<CampaignModel>>',
  'AutoDisposeStateNotifierProvider<CurrencyBuyNotifier, CurrencyBuyState>',
  'AutoDisposeStateNotifierProvider<ActionSearchNotifier, ActionSearchState>',
];

final _providerNames = <String>[
  'logRecordsNotipod',
  'timerNotipod',
  'convertPriceAccuraciesPod',
  'addCircleCardNotipod',
];

class App extends HookWidget {
  const App({
    Key? key,
    this.locale,
    this.builder,
    this.isStageEnv = false,
    this.debugShowCheckedModeBanner = true,
  }) : super(key: key);

  final Locale? locale;
  final Widget Function(BuildContext, Widget?)? builder;
  final bool isStageEnv;
  final bool debugShowCheckedModeBanner;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      observers: [
        ProviderLogger(
          ignoreByType: _providerTypes,
          ignoreByName: _providerNames,
        ),
      ],
      child: _App(
        locale: locale,
        builder: builder,
        isStageEnv: isStageEnv,
        debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      ),
    );
  }
}

class _App extends HookWidget {
  const _App({
    Key? key,
    this.locale,
    this.builder,
    this.isStageEnv = false,
    this.debugShowCheckedModeBanner = true,
  }) : super(key: key);

  final Locale? locale;
  final Widget Function(BuildContext, Widget?)? builder;
  final bool isStageEnv;
  final bool debugShowCheckedModeBanner;

  @override
  Widget build(BuildContext context) {
    useProvider(initializeBackgroundProviders.select((_) {}));
    useProvider(deviceInfoPod);
    useProvider(packageInfoFpod);
    final navigatorKey = useProvider(sNavigatorKeyPod);
    final theme = useProvider(sThemePod);
    final timeTrackerN = useProvider(timeTrackingNotipod.notifier);
    final storage = useProvider(localStorageServicePod);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final isCleared = await storage.getValue('cleared');
      if (isCleared == null) {
        await timeTrackerN.clear();
        await timeTrackerN.updateAppStarted(DateTime.now());
        await timeTrackerN.updateSignalRStarted(DateTime.now());
      }
    });

    return CupertinoApp(
      restorationScopeId: 'app',
      locale: locale,
      theme: theme,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      builder: builder ?? (_, child) => AppBuilder(child),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: const [
        Locale('en'),
        Locale('pl'),
        Locale('es'),
      ],
      // supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: isStageEnv ? AppRouterStage.routeName : AppRouter.routeName,
      routes: {
        AppRouter.routeName: (_) {
          return const AppRouter();
        },
        SingIn.routeName: (_) {
          return const SingIn();
        },
        EmailVerification.routeName: (_) {
          return const EmailVerification();
        },
        // [START] Stage only routes ->
        AppRouterStage.routeName: (_) {
          return const AppRouterStage();
        },
        AppInit.routeName: (_) {
          return const AppInit();
        },

      },
    );
  }
}
