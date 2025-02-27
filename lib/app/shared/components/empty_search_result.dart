import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../shared/providers/service_providers.dart';

class EmptySearchResult extends HookWidget {
  const EmptySearchResult({
    required this.text,
    Key? key,
  }) : super(key: key);

  final String? text;

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);

    return SizedBox(
        height:
          MediaQuery.of(context).size.height -
              MediaQuery.of(context).viewInsets.bottom -
              220,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                intl.emptySearchResult_noResultsFor,
                style: sBodyText1Style.copyWith(
                  color: colors.grey1,
                ),
              ),
              Text(
                text ?? '',
                style: sTextH4Style.copyWith(
                  color: colors.black,
                ),
              ),
            ],
          ),
        ),
    );
  }
}
