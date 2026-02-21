import 'package:ghost_traffic_lab/core/services/native_bridge_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'scheduler_controller.g.dart';

@riverpod
class SchedulerController extends _$SchedulerController {
  @override
  SchedulerState build() => const SchedulerState();

  void setTime(DateTime time) {
    state = state.copyWith(selectedTime: time);
  }

  void setTargetPackage(String pkg) {
    state = state.copyWith(targetPackage: pkg);
  }

  Future<void> scheduleAlarm(String payload) async {
    final time = state.selectedTime;
    if (time == null) return;
    final bridge = ref.read(nativeBridgeServiceProvider);
    await bridge.scheduleAlarm(
      triggerAtMillis: time.millisecondsSinceEpoch,
      payload: payload,
      targetPackage: state.targetPackage,
    );
    state = state.copyWith(isScheduled: true);
  }

  Future<void> cancelAlarm() async {
    final bridge = ref.read(nativeBridgeServiceProvider);
    await bridge.cancelAlarm();
    state = state.copyWith(isScheduled: false, selectedTime: null);
  }
}

const _sentinel = Object();

class SchedulerState {
  const SchedulerState({
    this.selectedTime,
    this.targetPackage = 'com.android.chrome',
    this.isScheduled = false,
  });

  final DateTime? selectedTime;
  final String targetPackage;
  final bool isScheduled;

  SchedulerState copyWith({
    Object? selectedTime = _sentinel,
    String? targetPackage,
    bool? isScheduled,
  }) {
    return SchedulerState(
      selectedTime: identical(selectedTime, _sentinel)
          ? this.selectedTime
          : selectedTime as DateTime?,
      targetPackage: targetPackage ?? this.targetPackage,
      isScheduled: isScheduled ?? this.isScheduled,
    );
  }
}
