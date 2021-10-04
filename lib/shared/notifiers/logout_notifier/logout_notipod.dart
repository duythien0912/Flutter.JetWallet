import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'logout_notifier.dart';
import 'logout_union.dart';

final logoutNotipod =
    StateNotifierProvider.autoDispose<LogoutNotifier, LogoutUnion>(
  (ref) {
    return LogoutNotifier(ref.read);
  },
);
