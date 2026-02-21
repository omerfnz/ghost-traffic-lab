import 'package:ghost_traffic_lab/core/services/native_bridge_service.dart';
import 'package:ghost_traffic_lab/product/models/permission_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'permissions_controller.g.dart';

@riverpod
class PermissionsController extends _$PermissionsController {
  @override
  PermissionState build() {
    Future.microtask(refreshAll);
    return const PermissionState();
  }

  Future<void> refreshAll() async {
    final bridge = ref.read(nativeBridgeServiceProvider);
    state = PermissionState(
      accessibility: await bridge.checkAccessibility(),
      overlay: await bridge.checkOverlay(),
      batteryOpt: await bridge.checkBatteryOpt(),
      exactAlarm: await bridge.checkExactAlarm(),
    );
  }

  Future<void> requestAccessibility() async {
    final bridge = ref.read(nativeBridgeServiceProvider);
    await bridge.requestAccessibility();
  }

  Future<void> requestOverlay() async {
    final bridge = ref.read(nativeBridgeServiceProvider);
    await bridge.requestOverlay();
  }

  Future<void> requestBatteryOpt() async {
    final bridge = ref.read(nativeBridgeServiceProvider);
    await bridge.requestBatteryOpt();
  }

  Future<void> requestExactAlarm() async {
    final bridge = ref.read(nativeBridgeServiceProvider);
    await bridge.requestExactAlarm();
  }
}
