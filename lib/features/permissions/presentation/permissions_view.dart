import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghost_traffic_lab/features/permissions/presentation/permissions_controller.dart';
import 'package:ghost_traffic_lab/product/widgets/permission_tile.dart';

@RoutePage()
class PermissionsView extends ConsumerStatefulWidget {
  const PermissionsView({super.key});

  @override
  ConsumerState<PermissionsView> createState() => _PermissionsViewState();
}

class _PermissionsViewState extends ConsumerState<PermissionsView>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refresh();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _refresh();
  }

  void _refresh() {
    ref.read(permissionsControllerProvider.notifier).refreshAll();
  }

  @override
  Widget build(BuildContext context) {
    final perms = ref.watch(permissionsControllerProvider);
    final ctrl = ref.read(permissionsControllerProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: const Text('Permissions')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (perms.allGranted) _SuccessBanner(),
          PermissionTile(
            title: 'Accessibility Service',
            isGranted: perms.accessibility,
            onRequest: ctrl.requestAccessibility,
          ),
          PermissionTile(
            title: 'Overlay Permission',
            isGranted: perms.overlay,
            onRequest: ctrl.requestOverlay,
          ),
          PermissionTile(
            title: 'Battery Optimization',
            isGranted: perms.batteryOpt,
            onRequest: ctrl.requestBatteryOpt,
          ),
          PermissionTile(
            title: 'Exact Alarm',
            isGranted: perms.exactAlarm,
            onRequest: ctrl.requestExactAlarm,
          ),
        ],
      ),
    );
  }
}

class _SuccessBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Card(
      color: Color(0xFF1A3A2A),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.check_circle, color: Color(0xFF3FB950)),
            SizedBox(width: 12),
            Text(
              'All permissions granted!',
              style: TextStyle(
                color: Color(0xFF3FB950),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
