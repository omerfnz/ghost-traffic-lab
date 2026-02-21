import 'package:flutter/material.dart';
import 'package:ghost_traffic_lab/core/theme/app_colors.dart';
import 'package:ghost_traffic_lab/product/models/service_status.dart';

class PermissionSummary extends StatelessWidget {
  const PermissionSummary({required this.count, super.key});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.security),
        title: const Text('Permissions'),
        trailing: Text(
          '$count/4',
          style: TextStyle(
            color: count == 4 ? AppColors.running : AppColors.armed,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class ScheduleInfo extends StatelessWidget {
  const ScheduleInfo({required this.time, super.key});
  final DateTime time;

  @override
  Widget build(BuildContext context) {
    final formatted =
        '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}';
    return Card(
      child: ListTile(
        leading: const Icon(Icons.schedule, color: AppColors.armed),
        title: const Text('Scheduled'),
        trailing: Text(
          formatted,
          style: const TextStyle(
            color: AppColors.armed,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

class ArmButton extends StatelessWidget {
  const ArmButton({
    required this.status,
    required this.allGranted,
    required this.onArm,
    required this.onDisarm,
    super.key,
  });

  final ServiceStatus status;
  final bool allGranted;
  final VoidCallback onArm;
  final VoidCallback onDisarm;

  @override
  Widget build(BuildContext context) {
    final isArmed = status == ServiceStatus.armed ||
        status == ServiceStatus.running;
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isArmed ? onDisarm : (allGranted ? onArm : null),
        style: ElevatedButton.styleFrom(
          backgroundColor: isArmed ? AppColors.error : AppColors.running,
        ),
        child: Text(
          isArmed ? 'DISARM' : 'ARM SYSTEM',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
