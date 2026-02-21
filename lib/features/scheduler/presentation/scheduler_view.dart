import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghost_traffic_lab/features/payload_builder/presentation/payload_builder_controller.dart';
import 'package:ghost_traffic_lab/features/scheduler/presentation/scheduler_controller.dart';
import 'package:ghost_traffic_lab/features/scheduler/presentation/scheduler_widgets.dart';

@RoutePage()
class SchedulerView extends ConsumerWidget {
  const SchedulerView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(schedulerControllerProvider);
    final ctrl = ref.read(schedulerControllerProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: const Text('Scheduler')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TimePickerCard(
              state: state,
              onPick: () => _pickTime(context, ctrl),
            ),
            const SizedBox(height: 16),
            TargetPackageCard(
              initialValue: state.targetPackage,
              onChanged: ctrl.setTargetPackage,
            ),
            const Spacer(),
            ScheduleButton(
              state: state,
              ctrl: ctrl,
              payload: ref
                  .watch(payloadBuilderControllerProvider.notifier)
                  .toJson(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickTime(BuildContext context, SchedulerController ctrl) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return;
    final now = DateTime.now();
    var scheduled = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    ctrl.setTime(scheduled);
  }
}
