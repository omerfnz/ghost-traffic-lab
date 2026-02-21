import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghost_traffic_lab/features/dashboard/presentation/dashboard_controller.dart';
import 'package:ghost_traffic_lab/features/dashboard/presentation/dashboard_widgets.dart';
import 'package:ghost_traffic_lab/product/widgets/status_badge.dart';

@RoutePage()
class DashboardView extends ConsumerStatefulWidget {
  const DashboardView({super.key});

  @override
  ConsumerState<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends ConsumerState<DashboardView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(dashboardControllerProvider.notifier).refresh(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dash = ref.watch(dashboardControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('GhostTraffic Lab')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            StatusBadge(status: dash.status),
            const SizedBox(height: 24),
            PermissionSummary(count: dash.permissions.grantedCount),
            const SizedBox(height: 16),
            if (dash.scheduledTime != null)
              ScheduleInfo(time: dash.scheduledTime!),
            const Spacer(),
            ArmButton(
              status: dash.status,
              allGranted: dash.permissions.allGranted,
              onArm: () => _handleArm(context),
              onDisarm: _handleDisarm,
            ),
          ],
        ),
      ),
    );
  }

  void _handleArm(BuildContext context) {
    ref.read(dashboardControllerProvider.notifier).arm('[]', '');
  }

  void _handleDisarm() {
    ref.read(dashboardControllerProvider.notifier).disarm();
  }
}
