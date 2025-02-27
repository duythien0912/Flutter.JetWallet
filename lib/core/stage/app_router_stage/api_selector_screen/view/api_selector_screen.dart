import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/dio/dio_proxy_notifier/dio_proxy_notipod.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../../../components/app_init.dart';

//final _config = RemoteConfigService();

class ApiSelectorScreen extends HookWidget {
  const ApiSelectorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final index = useState(0);
    final dioProxyN = useProvider(dioProxyNotipod.notifier);
    final intl = useProvider(intlPod);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            SPaddingH24(
              child: SStandardField(
                labelText: intl.apiSelectorScreen_provideProxy,
                onChanged: (value) => dioProxyN.updateProxyName(value),
                onErase: () => dioProxyN.updateProxyName(''),
              ),
            ),
            SPaddingH24(
              child: Row(
                children: [
                  const SErrorIcon(),
                  const SpaceW10(),
                  Text(
                    intl.apiSelector_justSkip,
                    style: sBodyText2Style.copyWith(
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            /*
            Expanded(
              child: CupertinoPicker(
                itemExtent: 50,
                diameterRatio: 1,
                onSelectedItemChanged: (value) => index.value = value,
                children: [
                  for (final flavor in _config.connectionFlavors.flavors)
                    Center(
                      child: Text(
                        apiTitleFromUrl(flavor.candlesApi),
                        style: const TextStyle(color: Colors.black),
                      ),
                    )
                ],
              ),
            ),
            */
            const SpaceH40(),
            TextButton(
              onPressed: () {
                //_config.overrideApisFrom(index.value);
                Navigator.pushReplacementNamed(context, AppInit.routeName);
              },
              child: Text(
                intl.serverCode0_ok,
                style: const TextStyle(
                  fontSize: 30.0,
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
