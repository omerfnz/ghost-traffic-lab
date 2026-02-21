import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghost_traffic_lab/core/services/log_stream_service.dart';
import 'package:ghost_traffic_lab/core/theme/app_colors.dart';
import 'package:ghost_traffic_lab/features/logs/presentation/logs_controller.dart';

@RoutePage()
class LogsView extends ConsumerStatefulWidget {
  const LogsView({super.key});

  @override
  ConsumerState<LogsView> createState() => _LogsViewState();
}

class _LogsViewState extends ConsumerState<LogsView> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _listenToStream();
    final logs = ref.watch(logsControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Logs (${logs.length})'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: ref.read(logsControllerProvider.notifier).clear,
          ),
        ],
      ),
      body: logs.isEmpty
          ? const Center(child: Text('No logs yet'))
          : _LogList(logs: logs, controller: _scrollController),
    );
  }

  void _listenToStream() {
    ref.listen(logStreamProvider, (_, next) {
      next.whenData((message) {
        ref.read(logsControllerProvider.notifier).addLog(message);
        _autoScroll();
      });
    });
  }

  void _autoScroll() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }
}

class _LogList extends StatelessWidget {
  const _LogList({required this.logs, required this.controller});
  final List<String> logs;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      padding: const EdgeInsets.all(8),
      itemCount: logs.length,
      itemBuilder: (_, index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Text(
          logs[index],
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
