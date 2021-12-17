import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../service/services/blockchain/model/validate_address/validate_address_request_model.dart';
import '../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../../shared/logging/levels.dart';
import '../../../../../../shared/providers/service_providers.dart';
import '../../../../models/currency_model.dart';
import '../../model/withdrawal_model.dart';
import '../../view/screens/withdrawal_amount.dart';
import 'address_validation_union.dart';
import 'withdrawal_address_state.dart';

/// Responsible for input and validation of withdrawal address and tag
class WithdrawalAddressNotifier extends StateNotifier<WithdrawalAddressState> {
  WithdrawalAddressNotifier(
    this.read,
    this.withdrawal,
  ) : super(
          WithdrawalAddressState(
            addressErrorNotifier: StandardFieldErrorNotifier(),
            tagErrorNotifier: StandardFieldErrorNotifier(),
            addressController: TextEditingController(),
            tagController: TextEditingController(),
            addressFocus: FocusNode(),
            tagFocus: FocusNode(),
            qrKey: GlobalKey(),
          ),
        ) {
    currency = withdrawal.currency;
    state = state.copyWith(currency: currency);
  }

  final Reader read;
  final WithdrawalModel withdrawal;

  late CurrencyModel currency;

  static final _logger = Logger('WithdrawalAddressNotifier');

  void updateQrController(QRViewController controller) {
    _logger.log(notifier, 'updateQrController');

    state = state.copyWith(qrController: controller);
  }

  void updateAddress(String address) {
    if (address != state.address) {
      _logger.log(notifier, 'updateAddress');

      _updateAddressValidation(const Hide());
      state = state.copyWith(address: address);
    }
  }

  void updateTag(String tag) {
    if (tag != state.tag) {
      _logger.log(notifier, 'updateTag');

      _updateTagValidation(const Hide());
      state = state.copyWith(tag: tag);
    }
  }

  void eraseAddress() {
    _logger.log(notifier, 'eraseAddress');

    state.addressController.text = '';
    updateAddress('');
    state.addressFocus.unfocus();
    _updateAddressValidation(const Hide());
  }

  void eraseTag() {
    _logger.log(notifier, 'eraseTag');

    state.tagController.text = '';
    updateTag('');
    state.tagFocus.unfocus();
    _updateTagValidation(const Hide());
  }

  Future<void> pasteAddress() async {
    _logger.log(notifier, 'pasteAddress');

    final copiedText = await _copiedText();
    state.addressController.text = copiedText;
    _moveCursorAtTheEnd(state.addressController);
    state.addressFocus.requestFocus();
    updateAddress(copiedText);
    await _validateAddressOrTag(
      _updateAddressValidation,
      _triggerErrorOfAddressField,
    );
  }

  Future<void> pasteTag() async {
    _logger.log(notifier, 'pasteTag');

    final copiedText = await _copiedText();
    state.tagController.text = copiedText;
    _moveCursorAtTheEnd(state.tagController);
    state.tagFocus.requestFocus();
    updateTag(copiedText);
    await _validateAddressOrTag(
      _updateTagValidation,
      _triggerErrorOfTagField,
    );
  }

  Future<void> scanAddressQr(BuildContext context) async {
    _logger.log(notifier, 'scanAddressQr');

    final result = await _pushQrView(context);

    if (result is Barcode) {
      state.addressController.text = result.code ?? '';
      _moveCursorAtTheEnd(state.addressController);
      state.addressFocus.requestFocus();
      updateAddress(result.code ?? '');
      await _validateAddressOrTag(
        _updateAddressValidation,
        _triggerErrorOfAddressField,
      );
    }
  }

  Future<void> scanTagQr(BuildContext context) async {
    _logger.log(notifier, 'scanTagQr');

    final result = await _pushQrView(context);

    if (result is Barcode) {
      state.tagController.text = result.code ?? '';
      _moveCursorAtTheEnd(state.tagController);
      state.tagFocus.requestFocus();
      updateTag(result.code ?? '');
      await _validateAddressOrTag(
        _updateTagValidation,
        _triggerErrorOfTagField,
      );
    }
  }

  Future<String> _copiedText() async {
    final data = await Clipboard.getData('text/plain');
    return (data?.text ?? '').replaceAll(' ', '');
  }

  void _moveCursorAtTheEnd(TextEditingController controller) {
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );
  }

  Future _pushQrView(BuildContext context) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return QRView(
            key: state.qrKey,
            onQRViewCreated: (c) => _onQRViewCreated(c, context),
            overlay: QrScannerOverlayShape(),
          );
        },
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller, BuildContext context) {
    updateQrController(controller);

    controller.scannedDataStream.listen(
      (event) {
        controller.dispose();
        Navigator.pop(context, event);
      },
    );
  }

  Future<void> _validateAddressOrTag(
    void Function(AddressValidationUnion) updateValidation,
    void Function() triggerErrorOfField,
  ) async {
    updateValidation(const Loading());

    try {
      final model = ValidateAddressRequestModel(
        assetSymbol: currency.symbol,
        toAddress: state.address,
        toTag: state.tag,
      );

      final service = read(blockchainServicePod);

      final response = await service.validateAddress(model);

      if (!mounted) return;

      _updateAddressIsInternal(response.isInternal);

      if (response.isValid) {
        updateValidation(const Valid());
      } else {
        updateValidation(const Invalid());
        triggerErrorOfField();
      }
    } catch (error) {
      if (!mounted) return;
      _logger.log(stateFlow, '_validateAddressOrTag', error);
      updateValidation(const Invalid());
      triggerErrorOfField();
    }
  }

  Future<void> validateOnContinue(BuildContext context) async {
    _logger.log(notifier, 'validateAddressAndTag');

    if (state.credentialsValid) {
      _pushWithdrawalAmount(context);
      return;
    }

    _updateValidationOfBothFields(const Loading());

    try {
      final model = ValidateAddressRequestModel(
        assetSymbol: currency.symbol,
        toAddress: state.address,
        toTag: state.tag,
      );

      final service = read(blockchainServicePod);

      final response = await service.validateAddress(model);

      if (!mounted) return;

      _updateAddressIsInternal(response.isInternal);

      if (response.isValid) {
        _updateValidationOfBothFields(const Valid());
      } else {
        _updateValidationOfBothFields(const Invalid());
        _triggerErrorOfBothFields();
      }

      if (state.credentialsValid) {
        _pushWithdrawalAmount(context);
      }
    } catch (error) {
      if (!mounted) return;
      _logger.log(stateFlow, 'validateAddressAndTag', error);
      _updateValidationOfBothFields(const Invalid());
      _triggerErrorOfBothFields();
    }
  }

  void _updateValidationOfBothFields(AddressValidationUnion value) {
    _updateAddressValidation(value);
    if (currency.hasTag) {
      _updateTagValidation(value);
    }
  }

  void _triggerErrorOfBothFields() {
    _triggerErrorOfAddressField();
    if (currency.hasTag) {
      _triggerErrorOfTagField();
    }
  }

  void _triggerErrorOfAddressField() {
    state.addressErrorNotifier!.enableError();
  }

  void _triggerErrorOfTagField() {
    state.tagErrorNotifier!.enableError();
  }

  void _updateAddressValidation(AddressValidationUnion value) {
    state = state.copyWith(addressValidation: value);
  }

  void _updateTagValidation(AddressValidationUnion value) {
    state = state.copyWith(tagValidation: value);
  }

  void _updateAddressIsInternal(bool value) {
    state = state.copyWith(addressIsInternal: value);
  }

  void _pushWithdrawalAmount(BuildContext context) {
    navigatorPush(context, WithdrawalAmount(withdrawal: withdrawal));
  }

  @override
  void dispose() {
    state.addressFocus.dispose();
    state.tagFocus.dispose();
    state.addressController.dispose();
    state.tagController.dispose();
    state.qrController?.dispose();
    super.dispose();
  }
}
