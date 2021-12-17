import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../model/contact_model.dart';

part 'send_by_phone_input_state.freezed.dart';

@freezed
class SendByPhoneInputState with _$SendByPhoneInputState {
  const factory SendByPhoneInputState({
    SPhoneNumber? activeDialCode,
    @Default('') String contactName,
    @Default('') String dialCodeSearch,
    @Default([]) List<SPhoneNumber> sortedDialCodes,
    @Default('') String phoneSearch,
    @Default([]) List<ContactModel> contacts,
    @Default([]) List<ContactModel> sortedContacts,
    required TextEditingController dialCodeController,
    required TextEditingController phoneNumberController,
  }) = _SendByPhoneInputState;

  const SendByPhoneInputState._();

  /// Will be called at SendByPhoneInput screen
  String get fullNumber {
    return '${dialCodeController.text} ${phoneNumberController.text}';
  }

  bool get isReadyToContinue {
    return dialCodeController.text.isNotEmpty &&
        phoneNumberController.text.isNotEmpty;
  }
}
