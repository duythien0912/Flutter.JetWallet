import 'package:flutter/cupertino.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/signal_r/model/recurring_buys_model.dart';

import '../../../../../shared/constants.dart';

Widget recurringBuysImage(RecurringBuysStatus type) {
  switch (type) {
    case RecurringBuysStatus.active:
      return Image.asset(
        recurringBuyImage,
        height: 24,
        width: 24,
      );
    case RecurringBuysStatus.paused:
      return Image.asset(
        recurringBuyPausedImage,
        height: 24,
        width: 24,
      );
    case RecurringBuysStatus.deleted:
      return const SRecurringBuysIcon();
    case RecurringBuysStatus.empty:
      return const SRecurringBuysIcon();
  }
}
