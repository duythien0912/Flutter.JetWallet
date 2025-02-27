import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_networking/services/key_value/model/key_value_request_model.dart';
import 'package:simple_networking/services/signal_r/model/key_value_model.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/providers/service_providers.dart';

class KeyValueNotifier extends StateNotifier<KeyValueModel> {
  KeyValueNotifier({
    required this.read,
    required this.keyValue,
  }) : super(
          const KeyValueModel(
            now: 0,
            keys: [],
          ),
        ) {
    keyValue.whenData(
      (data) {
        state = data;
      },
    );
  }

  final Reader read;
  final AsyncValue<KeyValueModel> keyValue;

  static final _logger = Logger('KeyValueNotifier');

  Future<void> addToKeyValue(KeyValueRequestModel model) async {
    _logger.log(notifier, 'addToKeyValue');

    try {
      await read(keyValueServicePod).set(model);
    } catch (e) {
      _logger.log(stateFlow, 'addToKeyValue', e);
    }
  }

  Future<void> removeFromKeyValue(List<String> keys) async {
    _logger.log(notifier, 'removeFromKeyValue');

    try {
      await read(keyValueServicePod).remove(keys);
    } catch (e) {
      _logger.log(stateFlow, 'removeFromKeyValue', e);
    }
  }
}
