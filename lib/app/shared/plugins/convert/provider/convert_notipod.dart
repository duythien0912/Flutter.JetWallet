import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../screens/wallet/models/asset_with_balance_model.dart';
import '../../../../screens/wallet/providers/assets_with_balances_pod.dart';
import '../helpers/sorted_list_of_currencies.dart';
import '../notifier/convert_notifier.dart';
import '../notifier/convert_state.dart';

final convertNotipod = StateNotifierProvider.family<ConvertNotifier,
    ConvertState, AssetWithBalanceModel>(
  (ref, from) {
    final currencies = ref.watch(assetsWithBalancesPod);

    final defaultState = _defaultConvertState(currencies, from);

    return ConvertNotifier(
      defaultState: defaultState,
      currencies: currencies,
    );
  },
);

ConvertState _defaultConvertState(
  List<AssetWithBalanceModel> currencies,
  AssetWithBalanceModel from,
) {
  final toList = sortedListOfCurrencies(currencies, from);
  final to = toList.first;
  final fromList = sortedListOfCurrencies(currencies, to);

  return ConvertState(
    from: from,
    fromList: fromList,
    to: to,
    toList: toList,
  );
}
