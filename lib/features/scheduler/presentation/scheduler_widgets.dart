import 'package:flutter/material.dart';
import 'package:ghost_traffic_lab/core/theme/app_colors.dart';
import 'package:ghost_traffic_lab/features/scheduler/presentation/scheduler_controller.dart';

class TimePickerCard extends StatelessWidget {
  const TimePickerCard({required this.state, required this.onPick, super.key});
  final SchedulerState state;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    final timeStr = state.selectedTime != null
        ? '${state.selectedTime!.hour.toString().padLeft(2, '0')}:'
              '${state.selectedTime!.minute.toString().padLeft(2, '0')}'
        : 'Not set';
    return Card(
      child: ListTile(
        leading: const Icon(Icons.access_time, color: AppColors.primary),
        title: const Text('Wake Time'),
        subtitle: Text(timeStr),
        trailing: IconButton(icon: const Icon(Icons.edit), onPressed: onPick),
      ),
    );
  }
}

class TargetPackageCard extends StatefulWidget {
  const TargetPackageCard({
    required this.initialValue,
    required this.onChanged,
    super.key,
  });

  final String initialValue;
  final ValueChanged<String> onChanged;

  @override
  State<TargetPackageCard> createState() => _TargetPackageCardState();
}

class _TargetPackageCardState extends State<TargetPackageCard> {
  late final _ctrl = TextEditingController(text: widget.initialValue);

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(
          decoration: const InputDecoration(
            labelText: 'Target Package',
            hintText: 'com.android.chrome',
            border: OutlineInputBorder(),
          ),
          controller: _ctrl,
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}

class ScheduleButton extends StatelessWidget {
  const ScheduleButton({
    required this.state,
    required this.ctrl,
    required this.payload,
    super.key,
  });
  final SchedulerState state;
  final SchedulerController ctrl;
  final String payload;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ElevatedButton.icon(
        onPressed: state.selectedTime != null
            ? () {
                if (state.isScheduled) {
                  ctrl.cancelAlarm();
                } else {
                  ctrl.scheduleAlarm(payload);
                }
              }
            : null,
        icon: Icon(state.isScheduled ? Icons.cancel : Icons.schedule),
        label: Text(state.isScheduled ? 'CANCEL ALARM' : 'SCHEDULE ALARM'),
      ),
    );
  }
}
