import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'logs_controller.g.dart';

@riverpod
class LogsController extends _$LogsController {
  @override
  List<String> build() => [];

  void addLog(String message) {
    final timestamp = DateTime.now().toIso8601String().substring(11, 19);
    state = [...state, '[$timestamp] $message'];
  }

  void clear() => state = [];
}
