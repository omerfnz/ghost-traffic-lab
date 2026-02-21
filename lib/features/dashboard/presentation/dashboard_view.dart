import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghost_traffic_lab/core/router/app_router.gr.dart';
import 'package:ghost_traffic_lab/features/dashboard/presentation/dashboard_controller.dart';
import 'package:ghost_traffic_lab/features/dashboard/presentation/dashboard_widgets.dart';
import 'package:ghost_traffic_lab/features/payload_builder/presentation/payload_builder_controller.dart';
import 'package:ghost_traffic_lab/features/scheduler/presentation/scheduler_controller.dart';
import 'package:ghost_traffic_lab/product/widgets/status_badge.dart';

@RoutePage()
class DashboardView extends ConsumerStatefulWidget {
  const DashboardView({super.key});

  @override
  ConsumerState<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends ConsumerState<DashboardView>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.microtask(
      () => ref.read(dashboardControllerProvider.notifier).refresh(),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(dashboardControllerProvider.notifier).refresh();
    }
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
            PermissionSummary(
              count: dash.permissions.grantedCount,
              onTap: () => context.pushRoute(const PermissionsRoute()),
            ),
            const SizedBox(height: 16),
            if (dash.scheduledTime != null)
              ScheduleInfo(time: dash.scheduledTime!),
            if (!dash.permissions.allGranted) _WarningBanner(),
            const Spacer(),
            ArmButton(
              status: dash.status,
              allGranted: dash.permissions.allGranted,
              onArm: () => _handleArm(context),
              onDisarm: _handleDisarm,
              onDisabledTap: () => _showMissing(context, dash),
            ),
          ],
        ),
      ),
    );
  }

  void _handleArm(BuildContext context) {
    final actions = ref.read(payloadBuilderControllerProvider);
    if (actions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Add payload actions first!')),
      );
      return;
    }
    final payload = ref
        .read(payloadBuilderControllerProvider.notifier)
        .toJson();
    final targetPkg = ref.read(schedulerControllerProvider).targetPackage;
    ref.read(dashboardControllerProvider.notifier).arm(payload, targetPkg);
  }

  void _handleDisarm() {
    ref.read(dashboardControllerProvider.notifier).disarm();
  }

  void _showMissing(BuildContext context, dynamic dash) {
    context.pushRoute(const PermissionsRoute());
  }
}

class _WarningBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Card(
      color: Color(0xFF3A2A1A),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.warning_amber, color: Color(0xFFF0883E)),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Grant all permissions first. '
                'Tap Permissions to configure.',
                style: TextStyle(color: Color(0xFFF0883E), fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
