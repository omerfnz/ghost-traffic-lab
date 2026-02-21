import 'package:flutter/material.dart';
import 'package:ghost_traffic_lab/features/payload_builder/presentation/payload_builder_controller.dart';
import 'package:ghost_traffic_lab/product/models/payload_action.dart';

void showAddActionSheet(BuildContext context, PayloadBuilderController ctrl) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => DraggableScrollableSheet(
      initialChildSize: 0.55,
      maxChildSize: 0.8,
      minChildSize: 0.3,
      expand: false,
      builder: (ctx, scrollCtrl) =>
          _SheetBody(ctx: ctx, scrollCtrl: scrollCtrl, ctrl: ctrl),
    ),
  );
}

class _SheetBody extends StatelessWidget {
  const _SheetBody({
    required this.ctx,
    required this.scrollCtrl,
    required this.ctrl,
  });

  final BuildContext ctx;
  final ScrollController scrollCtrl;
  final PayloadBuilderController ctrl;

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scrollCtrl,
      padding: const EdgeInsets.all(16),
      children: [
        _header('⏱ Timing'),
        _preset('Wait 3s', const PayloadAction.wait(duration: 3000)),
        _preset(
          'Random Wait 2-5s',
          const PayloadAction.randomWait(minMs: 2000, maxMs: 5000),
        ),
        _header('👆 Gestures'),
        _preset('Swipe Up', const PayloadAction.swipe(direction: 'up')),
        _preset('Swipe Down', const PayloadAction.swipe(direction: 'down')),
        _preset(
          'Click "Skip Ad"',
          const PayloadAction.click(nodeText: 'Skip Ad'),
        ),
        _preset('Tap Center', const PayloadAction.clickXy(x: 540, y: 960)),
        _preset(
          'Long Press Center',
          const PayloadAction.longPress(x: 540, y: 960, duration: 1000),
        ),
        _header('📱 Navigation'),
        _preset(
          'Launch Chrome',
          const PayloadAction.launch(packageName: 'com.android.chrome'),
        ),
        _preset(
          'Launch YouTube',
          const PayloadAction.launch(packageName: 'com.google.android.youtube'),
        ),
        _dialog('Open URL...', () => _urlDialog(ctx)),
        _preset('Back', const PayloadAction.back()),
        _preset('Home', const PayloadAction.home()),
        _header('📝 Text'),
        _dialog('Type Text...', () => _textDialog(ctx)),
        _dialog('Scroll Until...', () => _scrollDialog(ctx)),
      ],
    );
  }

  Widget _header(String title) => Padding(
    padding: const EdgeInsets.only(top: 12, bottom: 4),
    child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
  );

  Widget _preset(String label, PayloadAction action) => ListTile(
    title: Text(label),
    onTap: () {
      ctrl.addAction(action);
      Navigator.pop(ctx);
    },
  );

  Widget _dialog(String label, VoidCallback onTap) => ListTile(
    title: Text(label),
    trailing: const Icon(Icons.edit, size: 16),
    onTap: onTap,
  );

  Future<void> _urlDialog(BuildContext context) async {
    final tc = TextEditingController(text: 'https://');
    final url = await _inputDialog(context, 'URL', tc);
    if (url != null && url.isNotEmpty) {
      ctrl.addAction(PayloadAction.openUrl(url: url));
    }
  }

  Future<void> _textDialog(BuildContext context) async {
    final tc = TextEditingController();
    final text = await _inputDialog(context, 'Text to type', tc);
    if (text != null && text.isNotEmpty) {
      ctrl.addAction(PayloadAction.typeText(text: text));
    }
  }

  Future<void> _scrollDialog(BuildContext context) async {
    final tc = TextEditingController();
    final text = await _inputDialog(context, 'Text to find', tc);
    if (text != null && text.isNotEmpty) {
      ctrl.addAction(PayloadAction.scrollUntil(text: text));
    }
  }
}

Future<String?> _inputDialog(
  BuildContext context,
  String label,
  TextEditingController controller,
) {
  return showDialog<String>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(label),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: InputDecoration(hintText: label),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, controller.text),
          child: const Text('Add'),
        ),
      ],
    ),
  );
}
