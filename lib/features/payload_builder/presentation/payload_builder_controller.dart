import 'dart:convert';

import 'package:ghost_traffic_lab/product/models/payload_action.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'payload_builder_controller.g.dart';

@riverpod
class PayloadBuilderController extends _$PayloadBuilderController {
  Box<dynamic> get _box => Hive.box('settings');
  static const _key = 'payload';

  @override
  List<PayloadAction> build() {
    final raw = _box.get(_key) as String?;
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list
          .map((e) => PayloadAction.fromJson(e as Map<String, dynamic>))
          .toList();
    } on Exception catch (_) {
      return [];
    }
  }

  void _save() => _box.put(_key, toJson());

  void addAction(PayloadAction action) {
    state = [...state, action];
    _save();
  }

  void removeAt(int index) {
    state = [...state]..removeAt(index);
    _save();
  }

  void reorder(int oldIndex, int newIndex) {
    final list = [...state];
    var idx = newIndex;
    if (idx > oldIndex) idx--;
    final item = list.removeAt(oldIndex);
    list.insert(idx, item);
    state = list;
    _save();
  }

  void clear() {
    state = [];
    _save();
  }

  String toJson() {
    final list = state.map((action) => action.toJson()).toList();
    return jsonEncode(list);
  }
}
