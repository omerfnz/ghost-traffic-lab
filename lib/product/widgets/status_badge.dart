import 'package:flutter/material.dart';
import 'package:ghost_traffic_lab/core/theme/app_colors.dart';
import 'package:ghost_traffic_lab/product/models/service_status.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({required this.status, super.key});

  final ServiceStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _color.withAlpha(30),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color.withAlpha(100)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StatusDot(color: _color),
          const SizedBox(width: 8),
          Text(
            status.label,
            style: TextStyle(color: _color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Color get _color => switch (status) {
        ServiceStatus.idle => AppColors.disarmed,
        ServiceStatus.armed => AppColors.armed,
        ServiceStatus.running => AppColors.running,
        ServiceStatus.error => AppColors.error,
      };
}

class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
