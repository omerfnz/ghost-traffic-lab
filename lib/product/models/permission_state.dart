import 'package:freezed_annotation/freezed_annotation.dart';

part 'permission_state.freezed.dart';

@freezed
class PermissionState with _$PermissionState {
  const factory PermissionState({
    @Default(false) bool accessibility,
    @Default(false) bool overlay,
    @Default(false) bool batteryOpt,
    @Default(false) bool exactAlarm,
  }) = _PermissionState;

  const PermissionState._();

  bool get allGranted =>
      accessibility && overlay && batteryOpt && exactAlarm;

  int get grantedCount =>
      [accessibility, overlay, batteryOpt, exactAlarm]
          .where((v) => v)
          .length;
}
