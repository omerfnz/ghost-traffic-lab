import 'package:flutter/services.dart';
import 'package:ghost_traffic_lab/core/constants/channel_constants.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'native_bridge_service.g.dart';

@riverpod
NativeBridgeService nativeBridgeService(NativeBridgeServiceRef ref) {
  return NativeBridgeService();
}

class NativeBridgeService {
  static const _channel = MethodChannel(ChannelConstants.controlChannel);

  // Permission checks
  Future<bool> checkAccessibility() =>
      _invoke<bool>(ChannelConstants.checkAccessibility);

  Future<bool> checkOverlay() =>
      _invoke<bool>(ChannelConstants.checkOverlay);

  Future<bool> checkBatteryOpt() =>
      _invoke<bool>(ChannelConstants.checkBatteryOpt);

  Future<bool> checkExactAlarm() =>
      _invoke<bool>(ChannelConstants.checkExactAlarm);

  // Permission requests
  Future<void> requestAccessibility() =>
      _channel.invokeMethod<void>(ChannelConstants.requestAccessibility);

  Future<void> requestOverlay() =>
      _channel.invokeMethod<void>(ChannelConstants.requestOverlay);

  Future<void> requestBatteryOpt() =>
      _channel.invokeMethod<void>(ChannelConstants.requestBatteryOpt);

  Future<void> requestExactAlarm() =>
      _channel.invokeMethod<void>(ChannelConstants.requestExactAlarm);

  // Service control
  Future<void> startService({
    required String payload,
    required String targetPackage,
  }) =>
      _channel.invokeMethod<void>(ChannelConstants.startService, {
        'payload': payload,
        'targetPackage': targetPackage,
      });

  Future<void> stopService() =>
      _channel.invokeMethod<void>(ChannelConstants.stopService);

  Future<bool> isServiceRunning() =>
      _invoke<bool>(ChannelConstants.isServiceRunning);

  // Alarm
  Future<void> scheduleAlarm({
    required int triggerAtMillis,
    required String payload,
    required String targetPackage,
  }) =>
      _channel.invokeMethod<void>(ChannelConstants.scheduleAlarm, {
        'triggerAtMillis': triggerAtMillis,
        'payload': payload,
        'targetPackage': targetPackage,
      });

  Future<void> cancelAlarm() =>
      _channel.invokeMethod<void>(ChannelConstants.cancelAlarm);

  Future<T> _invoke<T>(String method) async {
    final result = await _channel.invokeMethod<T>(method);
    return result as T;
  }
}
