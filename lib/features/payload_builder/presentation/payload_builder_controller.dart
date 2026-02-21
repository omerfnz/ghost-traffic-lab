import 'dart:convert';

import 'package:ghost_traffic_lab/product/models/payload_action.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'payload_builder_controller.g.dart';

@riverpod
class PayloadBuilderController extends _$PayloadBuilderController {
  @override
  List<PayloadAction> build() => [];

  void addAction(PayloadAction action) {
    state = [...state, action];
  }

  void removeAt(int index) {
    state = [...state]..removeAt(index);
  }

  void reorder(int oldIndex, int newIndex) {
    final list = [...state];
    var idx = newIndex;
    if (idx > oldIndex) idx--;
    final item = list.removeAt(oldIndex);
    list.insert(idx, item);
    state = list;
  }

  void clear() => state = [];

  String toJson() {
    final list = state.map(_actionToMap).toList();
    return jsonEncode(list);
  }

  Map<String, dynamic> _actionToMap(PayloadAction action) {
    return action.map(
      wait: (a) => {'action': 'wait', 'duration': a.duration},
      swipe: (a) => {'action': 'swipe', 'direction': a.direction},
      click: (a) => {'action': 'click', 'node_text': a.nodeText},
      launch: (a) => {'action': 'launch', 'package_name': a.packageName},
      typeText: (a) => {'action': 'type', 'text': a.text},
    );
  }
}
