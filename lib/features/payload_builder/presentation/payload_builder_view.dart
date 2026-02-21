import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghost_traffic_lab/features/payload_builder/presentation/payload_builder_controller.dart';
import 'package:ghost_traffic_lab/features/payload_builder/presentation/payload_builder_widgets.dart';
import 'package:ghost_traffic_lab/product/models/payload_action.dart';

@RoutePage()
class PayloadBuilderView extends ConsumerWidget {
  const PayloadBuilderView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = ref.watch(payloadBuilderControllerProvider);
    final ctrl = ref.read(payloadBuilderControllerProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payload Builder'),
        actions: [
          IconButton(
            icon: const Icon(Icons.code),
            onPressed: () => _showJson(context, ctrl),
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: ctrl.clear,
          ),
        ],
      ),
      body: actions.isEmpty
          ? const Center(child: Text('Add actions with + button'))
          : _ActionList(actions: actions, ctrl: ctrl),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddActionSheet(context, ctrl),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showJson(BuildContext context, PayloadBuilderController ctrl) {
    final json = ctrl.toJson();
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Payload JSON'),
        content: SelectableText(json),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
      ),
    );
  }
}

class _ActionList extends StatelessWidget {
  const _ActionList({required this.actions, required this.ctrl});
  final List<PayloadAction> actions;
  final PayloadBuilderController ctrl;

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: actions.length,
      onReorder: ctrl.reorder,
      itemBuilder: (context, index) {
        return ActionTile(
          key: ValueKey(index),
          action: actions[index],
          onDelete: () => ctrl.removeAt(index),
        );
      },
    );
  }
}
