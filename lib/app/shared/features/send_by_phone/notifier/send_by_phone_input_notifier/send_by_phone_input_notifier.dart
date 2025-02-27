import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/logging/levels.dart';
import '../../../../../../shared/providers/service_providers.dart';
import '../../../../helpers/country_code_by_user_register.dart';
import '../../../../helpers/is_phone_number_valid.dart';
import '../../model/contact_model.dart';
import '../send_by_phone_permission_notifier/send_by_phone_permission_state.dart';
import 'send_by_phone_input_state.dart';

class SendByPhoneInputNotifier extends StateNotifier<SendByPhoneInputState> {
  SendByPhoneInputNotifier(this.read, this.permission)
      : super(
          SendByPhoneInputState(
            activeDialCode: sPhoneNumbers[0],
            dialCodeController: TextEditingController(
              text: countryCodeByUserRegister(read)?.countryCode ??
                  sPhoneNumbers[0].countryCode,
            ),
            phoneNumberController: TextEditingController(),
          ),
        ) {
    _initState();
  }

  final Reader read;
  final SendByPhonePermissionState permission;

  static final _logger = Logger('SendByPhoneInputNotifier');

  Future<void> _initState() async {
    if (permission.permissionStatus == PermissionStatus.granted) {
      final contacts = await ContactsService.getContacts(withThumbnails: false);
      final parsedContacts = <ContactModel>{};
      for (final contact in contacts) {
        if (contact.phones!.isNotEmpty) {
          for (final phoneNumber in contact.phones!) {
            if (phoneNumber.value != null) {
              parsedContacts.add(
                ContactModel(
                  name: contact.displayName ?? phoneNumber.value!,
                  phoneNumber: phoneNumber.value!.replaceAll(' ', ''),
                ),
              );
            }
          }
        }
      }
      final result = parsedContacts.toList();
      state = state.copyWith(
        contacts: result,
        sortedContacts: result,
      );
    }
  }

  void initDialCodeSearch() {
    updateDialCodeSearch('');
  }

  void updateDialCodeSearch(String dialCodeSearch) {
    _logger.log(notifier, 'updateDialCodeSearch');

    state = state.copyWith(dialCodeSearch: dialCodeSearch);

    _filterByDialCodeSearch();
  }

  void _filterByDialCodeSearch() {
    final newList = List<SPhoneNumber>.from(sPhoneNumbers);

    newList.removeWhere((element) {
      return !_isDialCodeInSearch(element);
    });

    state = state.copyWith(sortedDialCodes: List.from(newList));
  }

  bool _isDialCodeInSearch(SPhoneNumber number) {
    final search = state.dialCodeSearch.toLowerCase().replaceAll(' ', '');
    final code = number.countryCode.toLowerCase().replaceAll(' ', '');
    final name = number.countryName.toLowerCase().replaceAll(' ', '');

    return code.contains(search) || name.contains(search);
  }

  void pickDialCodeFromSearch(SPhoneNumber code) {
    state.dialCodeController.text = code.countryCode;
    updateActiveDialCode(code);
    final number = '${code.countryCode} ${state.phoneNumberController.text}';
    updateContactName(
      ContactModel(
        name: number,
        phoneNumber: number,
      ),
    );
  }

  void initPhoneSearch() {
    _logger.log(notifier, 'initPhoneSearch');

    final dialCode = state.dialCodeController.text;
    final phoneNumber = state.phoneNumberController.text;
    final intl = read(intlPod);

    if (dialCode.isEmpty || dialCode == intl.sendByPhoneInput_select) {
      updatePhoneSearch(phoneNumber);
    } else if (phoneNumber.isEmpty) {
      updatePhoneSearch('');
    } else {
      updatePhoneSearch('$dialCode $phoneNumber');
    }
  }

  void updatePhoneSearch(String phoneSearch) {
    _logger.log(notifier, 'updateSearch');

    state = state.copyWith(phoneSearch: phoneSearch);

    _filterByPhoneSearchInput();
  }

  Future<void> _filterByPhoneSearchInput() async {
    final newList = List<ContactModel>.from(state.contacts);

    newList.removeWhere((element) {
      return !_isContactInSearch(element);
    });

    if (newList.isEmpty && validWeakPhoneNumber(state.phoneSearch)) {
      final dialCode = state.dialCodeController.text;
      final number = state.phoneSearch;

      var phoneNumber = '';

      if (number.startsWith('+')) {
        phoneNumber = number;
      } else {
        phoneNumber = '$dialCode $number';
      }

      newList.add(
        ContactModel(
          name: number,
          phoneNumber: phoneNumber,
          isCustomContact: true,
          valid: await isInternationalPhoneNumberValid(phoneNumber),
        ),
      );
    }

    state = state.copyWith(sortedContacts: List.from(newList));
  }

  Future<void> pickNumberFromSearch(ContactModel contact) async {
    _logger.log(notifier, 'pickNumberFromSearch');

    if (contact.phoneNumber[0] == '+') {
      final info = await PhoneNumber.getRegionInfoFromPhoneNumber(
        contact.phoneNumber,
      );

      final phoneNumber = PhoneNumber(
        phoneNumber: info.phoneNumber,
        isoCode: info.isoCode,
      );

      final parsable = await PhoneNumber.getParsableNumber(phoneNumber);

      var validNumber = false;
      var code = sPhoneNumbers[0];

      for (final sNumber in sPhoneNumbers) {
        if (sNumber.isoCode == info.isoCode) {
          validNumber = true;
          code = sNumber;
        }
      }

      if (info.dialCode != null && validNumber) {
        state.dialCodeController.text = '+${info.dialCode!}';
        state.phoneNumberController.text = parsable;
        updateActiveDialCode(code);
      } else {
        state.dialCodeController.clear();
        updateActiveDialCode(null);
        if (contact.phoneNumber.startsWith('+')) {
          state.phoneNumberController.text = contact.phoneNumber.substring(1);
        } else {
          state.phoneNumberController.text = contact.phoneNumber;
        }
      }
    } else {
      final intl = read(intlPod);
      final finalCode = contact.phoneNumber.replaceAll('(', ' ')
          .replaceAll(')', ' ')
          .replaceAll('-', ' ');
      state.phoneNumberController.text = finalCode;
      state.dialCodeController.text = intl.sendByPhoneInput_select;
      state.copyWith(
        contactWithoutCode: true,
      );
    }

    if (contact.isCustomContact) {
      updateContactName(
        ContactModel(
          name: contact.phoneNumber,
          phoneNumber: contact.phoneNumber,
        ),
      );
    } else {
      updateContactName(contact);
    }
  }

  bool _isContactInSearch(ContactModel contact) {
    final search = state.phoneSearch.toLowerCase().replaceAll(' ', '');
    final name = contact.name.toLowerCase().replaceAll(' ', '');
    final number = contact.phoneNumber.toLowerCase().replaceAll(' ', '');
    final parsedNamber = number.replaceAll('-', '');

    return name.contains(search) || parsedNamber.contains(search);
  }

  void updateContactName(ContactModel contact) {
    state = state.copyWith(pickedContact: contact);
  }

  void updateActiveDialCode(SPhoneNumber? number) {
    state = state.copyWith(activeDialCode: number);
  }
}
