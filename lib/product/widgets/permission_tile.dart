import 'package:flutter/material.dart';
import 'package:ghost_traffic_lab/core/theme/app_colors.dart';

class PermissionTile extends StatelessWidget {
  const PermissionTile({
    required this.title,
    required this.isGranted,
    required this.onRequest,
    super.key,
  });

  final String title;
  final bool isGranted;
  final VoidCallback onRequest;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          isGranted ? Icons.check_circle : Icons.cancel,
          color: isGranted ? AppColors.running : AppColors.error,
        ),
        title: Text(title),
        trailing: isGranted
            ? const Text('Granted', style: TextStyle(color: AppColors.running))
            : ElevatedButton(
                onPressed: onRequest,
                child: const Text('Grant'),
              ),
      ),
    );
  }
}
