import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/components/result_screens/failure_screen/failure_screen.dart';
import '../../../../../shared/components/result_screens/success_screen/success_screen.dart';
import '../../../../../shared/helpers/navigate_to_router.dart';
import '../../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../../../screens/navigation/provider/navigation_stpod.dart';

class SimplexWebView extends HookWidget {
  const SimplexWebView(this.url);

  final String url;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);

    void _showSuccess() {
      SuccessScreen.push(
        context: context,
        secondaryText: 'Your payment will be processed within\n≈ 10-30 minutes',
        then: () => context.read(navigationStpod).state = 1,
      );
    }

    void _showFailure() {
      FailureScreen.push(
        context: context,
        primaryText: 'Failure',
        secondaryText: 'Failed to buy',
        primaryButtonName: 'Edit Order',
        onPrimaryButtonTap: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
        secondaryButtonName: 'Close',
        onSecondaryButtonTap: () => navigateToRouter(context.read),
      );
    }

    return Column(
      children: [
        Container(
          height: 48.0,
          color: colors.white,
        ),
        Expanded(
          child: WebView(
            initialUrl: url,
            javascriptMode: JavascriptMode.unrestricted,
            navigationDelegate: (request) {
              final uri = Uri.parse(request.url);
              final success = uri.queryParameters['success'];

              if (uri.origin == simplexOrigin) {
                if (success == '1') {
                  _showSuccess();
                  return NavigationDecision.prevent;
                } else if (success == '2') {
                  _showFailure();
                  return NavigationDecision.prevent;
                } else {
                  return NavigationDecision.navigate;
                }
              } else {
                return NavigationDecision.navigate;
              }
            },
          ),
        ),
      ],
    );
  }
}
