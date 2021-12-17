import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SDivider(),
        Padding(
          padding: const EdgeInsets.all(24),
          child: SPrimaryButton1(
            name: 'Action',
            onTap: () {
              // TODO(any): Add action button sheet
            },
            active: true,
          ),
        ),
      ],
    );
  }
}
