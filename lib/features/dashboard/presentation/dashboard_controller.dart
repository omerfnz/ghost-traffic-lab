import 'package:ghost_traffic_lab/core/services/native_bridge_service.dart';
import 'package:ghost_traffic_lab/features/dashboard/domain/entities/dashboard_state.dart';
import 'package:ghost_traffic_lab/features/permissions/presentation/permissions_controller.dart';
import 'package:ghost_traffic_lab/product/models/service_status.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dashboard_controller.g.dart';

@riverpod
class DashboardController extends _$DashboardController {
  @override
  DashboardState build() => const DashboardState();

  Future<void> refresh() async {
    final bridge = ref.read(nativeBridgeServiceProvider);
    await ref.read(permissionsControllerProvider.notifier).refreshAll();
    final perms = ref.read(permissionsControllerProvider);
    final running = await bridge.isServiceRunning();

    state = state.copyWith(
      permissions: perms,
      status: running ? ServiceStatus.running : state.status,
    );
  }

  Future<void> arm(String payload, String targetPkg) async {
    if (!state.permissions.allGranted) return;
    final bridge = ref.read(nativeBridgeServiceProvider);
    await bridge.startService(
      payload: payload,
      targetPackage: targetPkg,
    );
    state = state.copyWith(
      status: ServiceStatus.armed,
      targetPackage: targetPkg,
    );
  }

  Future<void> disarm() async {
    final bridge = ref.read(nativeBridgeServiceProvider);
    await bridge.stopService();
    await bridge.cancelAlarm();
    state = state.copyWith(
      status: ServiceStatus.idle,
      scheduledTime: null,
    );
  }

  void setSchedule(DateTime time) {
    state = state.copyWith(scheduledTime: time);
  }
}
