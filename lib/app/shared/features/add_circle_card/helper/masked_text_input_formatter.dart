import 'package:flutter/services.dart';

class MaskedTextInputFormatter extends TextInputFormatter {
  MaskedTextInputFormatter({
    required this.mask,
    required this.separator,
  });

  final String mask;
  final String separator;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final difference = newValue.text.length - oldValue.text.length;

    if (newValue.text.length > mask.length) return oldValue;

    // paste text value or start typing
    if (oldValue.text.isEmpty) {
      final newValue2 = newValue.text.split('');
      final mask2 = mask.split('');
      newValue2.removeWhere((element) => element == separator);
      mask2.removeWhere((element) => element == separator);

      // start typing
      if (difference == 1) {
        return _value(mask, separator, newValue.text);
      }

      // paste text value
      if (newValue2.length == mask2.length) {
        return _value(mask, separator, newValue.text);
      }
    }
    // typing
    else if (difference == 1) {
      return _value(mask, separator, newValue.text);
    }
    // backspace or cut
    else if (difference < 1) {
      return newValue;
    }

    // cases when user pastes text and oldValue is not empty
    return oldValue;
  }

  TextEditingValue _value(
    String mask,
    String seperator,
    String newValue,
  ) {
    final newValue2 = newValue.split('');
    newValue2.removeWhere((element) => element == seperator);
    var text = '';
    var index = 0;

    for (final char in mask.split('')) {
      if (char == seperator) {
        text += seperator;
      } else {
        if (index == newValue2.length) break;
        text += newValue2[index];
        index++;
      }
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(
        offset: text.length,
      ),
    );
  }
}
