import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/example/example_screen.dart';
import 'package:simple_kit/simple_kit.dart';

class Education extends HookWidget {
  const Education({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notificationQueueN = useProvider(sNotificationQueueNotipod.notifier);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const ExampleScreen();
                    },
                  ),
                );
              },
              child: const Text(
                'Example Screen',
              ),
            ),
            TextButton(
              onPressed: () async {
                notificationQueueN.addToQueue(
                  SNotification(
                    duration: 2,
                    function: (context) {
                      showSNotification(
                        context: context,
                        duration: 2,
                        text: 'Perhaps you missed “.” or “@” somewhere?”',
                      );
                    },
                  ),
                );
              },
              child: const Text(
                'Show notification',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
