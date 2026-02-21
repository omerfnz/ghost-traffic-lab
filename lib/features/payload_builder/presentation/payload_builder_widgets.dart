import 'package:flutter/material.dart';
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
    clickXy: (_) => Icons.gps_fixed,
    longPress: (_) => Icons.touch_app_outlined,
    openUrl: (_) => Icons.link,
    back: (_) => Icons.arrow_back,
    home: (_) => Icons.home,
    scrollUntil: (_) => Icons.find_in_page,
    randomWait: (_) => Icons.shuffle,
  );

  String get _label => action.map(
    wait: (a) => 'Wait ${a.duration}ms',
    swipe: (a) => 'Swipe ${a.direction}',
    click: (a) => 'Click "${a.nodeText}"',
    launch: (a) => 'Launch ${a.packageName}',
    typeText: (a) => 'Type "${a.text}"',
    clickXy: (a) => 'Tap (${a.x.toInt()}, ${a.y.toInt()})',
    longPress: (a) => 'Hold (${a.x.toInt()}, ${a.y.toInt()})',
    openUrl: (a) => 'Open ${a.url}',
    back: (_) => 'Back',
    home: (_) => 'Home',
    scrollUntil: (a) => 'Find "${a.text}"',
    randomWait: (a) => 'Wait ${a.minMs}-${a.maxMs}ms',
  );
}
