import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/helpers/navigate_to_router.dart';
import '../../../../shared/notifiers/timer_notifier/timer_notipod.dart';
import '../components/result_frame.dart';
import '../components/result_icon.dart';

class SuccessScreen extends HookWidget {
  const SuccessScreen({
    Key? key,
    this.then,
    this.header,
    required this.description,
  }) : super(key: key);

  // Triggered when SuccessScreen is done
  final Function()? then;
  final String? header;
  final String description;

  @override
  Widget build(BuildContext context) {
    return ProviderListener<int>(
      provider: timerNotipod(2),
      onChange: (context, value) {
        if (value == 0) {
          navigateToRouter(context.read);
          then?.call();
        }
      },
      child: ResultFrame(
        header: header,
        resultIcon: const ResultIcon(
          FontAwesomeIcons.checkCircle,
        ),
        title: 'Success',
        description: description,
        children: [
          LinearProgressIndicator(
            minHeight: 8.h,
            color: Colors.grey,
            backgroundColor: const Color(0xffeeeeee),
          )
        ],
      ),
    );
  }
}
