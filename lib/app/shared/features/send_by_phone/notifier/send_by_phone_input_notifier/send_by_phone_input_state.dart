import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:permission_handler/permission_handler.dart';

part 'send_by_phone_input_state.freezed.dart';

enum PhonebookStatus { granted, dismissed, denied, undefined }
enum UserLocation {app, settings}

@freezed
class SendByPhoneInputState with _$SendByPhoneInputState {
  const factory SendByPhoneInputState({
    @Default('') String code,
    @Default('') String phoneNumber,
    @Default(UserLocation.app) UserLocation userLocation,
    @Default(PermissionStatus.denied) PermissionStatus permissionStatus,
    @Default(PhonebookStatus.undefined) PhonebookStatus phonebookStatus,
  }) = _SendByPhoneInputState;
}
