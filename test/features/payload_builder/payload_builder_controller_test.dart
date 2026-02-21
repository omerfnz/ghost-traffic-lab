import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ghost_traffic_lab/features/payload_builder/presentation/payload_builder_controller.dart';
import 'package:ghost_traffic_lab/product/models/payload_action.dart';
import 'package:hive/hive.dart';

void main() {
  late ProviderContainer container;
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_test_');
    Hive.init(tempDir.path);
    await Hive.openBox<dynamic>('settings');
    container = ProviderContainer();
  });

  tearDown(() async {
    container.dispose();
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  PayloadBuilderController ctrl() =>
      container.read(payloadBuilderControllerProvider.notifier);

  List<PayloadAction> state() =>
      container.read(payloadBuilderControllerProvider);

  group('CRUD operations', () {
    test('starts empty', () {
      expect(state(), isEmpty);
    });

    test('addAction appends to list', () {
      ctrl().addAction(const PayloadAction.wait(duration: 3000));
      ctrl().addAction(const PayloadAction.swipe(direction: 'up'));
      expect(state(), hasLength(2));
      expect(state().first, isA<WaitAction>());
    });

    test('removeAt removes correct item', () {
      ctrl()
        ..addAction(const PayloadAction.wait(duration: 1000))
        ..addAction(const PayloadAction.click(nodeText: 'OK'))
        ..addAction(const PayloadAction.swipe(direction: 'down'));
      ctrl().removeAt(1);
      expect(state(), hasLength(2));
      expect(state().last, isA<SwipeAction>());
    });

    test('clear empties list', () {
      ctrl().addAction(const PayloadAction.wait(duration: 1000));
      ctrl().clear();
      expect(state(), isEmpty);
    });
  });

  group('Reorder', () {
    test('reorder moves item forward', () {
      ctrl()
        ..addAction(const PayloadAction.wait(duration: 1))
        ..addAction(const PayloadAction.wait(duration: 2))
        ..addAction(const PayloadAction.wait(duration: 3));
      ctrl().reorder(0, 2);
      final durations = state().map(
        (a) => a.mapOrNull(wait: (w) => w.duration) ?? 0,
      );
      expect(durations, [2, 1, 3]);
    });
  });

  group('JSON export', () {
    test('toJson produces valid format', () {
      ctrl()
        ..addAction(const PayloadAction.wait(duration: 3000))
        ..addAction(const PayloadAction.swipe(direction: 'up'));

      final json = ctrl().toJson();
      expect(json, contains('"action":"wait"'));
      expect(json, contains('"action":"swipe"'));
      expect(json, contains('"duration":3000'));
    });
  });
}
