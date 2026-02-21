import 'package:flutter/material.dart';
import 'package:ghost_traffic_lab/features/payload_builder/presentation/payload_builder_controller.dart';
import 'package:ghost_traffic_lab/product/models/payload_action.dart';

class ActionTile extends StatelessWidget {
  const ActionTile({required this.action, required this.onDelete, super.key});
  final PayloadAction action;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(_icon),
        title: Text(_label),
        trailing: IconButton(
          icon: const Icon(Icons.close, size: 18),
          onPressed: onDelete,
        ),
      ),
    );
  }

  IconData get _icon => action.map(
        wait: (_) => Icons.hourglass_empty,
        swipe: (_) => Icons.swipe,
        click: (_) => Icons.touch_app,
        launch: (_) => Icons.launch,
        typeText: (_) => Icons.keyboard,
      );

  String get _label => action.map(
        wait: (a) => 'Wait ${a.duration}ms',
        swipe: (a) => 'Swipe ${a.direction}',
        click: (a) => 'Click "${a.nodeText}"',
        launch: (a) => 'Launch ${a.packageName}',
        typeText: (a) => 'Type "${a.text}"',
      );
}

void showAddActionSheet(BuildContext context, PayloadBuilderController ctrl) {
  showModalBottomSheet<void>(
    context: context,
    builder: (_) => Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SheetItem('Wait 3s', () => ctrl.addAction(const PayloadAction.wait(duration: 3000))),
          _SheetItem('Swipe Up', () => ctrl.addAction(const PayloadAction.swipe(direction: 'up'))),
          _SheetItem('Swipe Down', () => ctrl.addAction(const PayloadAction.swipe(direction: 'down'))),
          _SheetItem('Click "Skip Ad"', () => ctrl.addAction(const PayloadAction.click(nodeText: 'Skip Ad'))),
          _SheetItem('Launch Chrome', () => ctrl.addAction(const PayloadAction.launch(packageName: 'com.android.chrome'))),
        ],
      ),
    ),
  );
}

class _SheetItem extends StatelessWidget {
  const _SheetItem(this.label, this.onTap);
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      onTap: () {
        onTap();
        Navigator.pop(context);
      },
    );
  }
}
