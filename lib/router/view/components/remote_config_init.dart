import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../shared/components/app_frame.dart';
import '../../../shared/components/loaders/loader.dart';
import '../../notifier/remote_config_notifier/remote_config_notipod.dart';

/// Fetches and activates remote config, needed to go first after [AppRouter]
class RemoteConfigInit extends HookWidget {
  const RemoteConfigInit({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final remoteConfig = useProvider(remoteConfigNotipod);

    return remoteConfig.when(
      success: () => child,
      loading: () {
        return const AppFrame(
          child: Loader(
            color: Colors.pink,
          ),
        );
      },
    );
  }
}
