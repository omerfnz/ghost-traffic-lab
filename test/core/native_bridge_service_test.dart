import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ghost_traffic_lab/core/constants/channel_constants.dart';
import 'package:ghost_traffic_lab/core/services/native_bridge_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late NativeBridgeService service;
  late List<MethodCall> log;

  setUp(() {
    service = NativeBridgeService();
    log = [];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel(ChannelConstants.controlChannel),
      (call) async {
        log.add(call);
        return _mockResult(call.method);
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel(ChannelConstants.controlChannel),
      null,
    );
  });

  group('Permission checks', () {
    test('checkAccessibility returns bool', () async {
      final result = await service.checkAccessibility();
      expect(result, isA<bool>());
      expect(log.last.method, ChannelConstants.checkAccessibility);
    });

    test('checkOverlay returns bool', () async {
      final result = await service.checkOverlay();
      expect(result, isA<bool>());
      expect(log.last.method, ChannelConstants.checkOverlay);
    });
  });

  group('Service control', () {
    test('startService sends payload and package', () async {
      await service.startService(
        payload: '[{"action":"wait","duration":3000}]',
        targetPackage: 'com.test.app',
      );
      expect(log.last.method, ChannelConstants.startService);
      final args = log.last.arguments as Map<Object?, Object?>;
      expect(args['payload'], contains('wait'));
      expect(args['targetPackage'], 'com.test.app');
    });

    test('stopService invokes correct method', () async {
      await service.stopService();
      expect(log.last.method, ChannelConstants.stopService);
    });
  });

  group('Alarm', () {
    test('scheduleAlarm sends all params', () async {
      await service.scheduleAlarm(
        triggerAtMillis: 1700000000000,
        payload: '[]',
        targetPackage: 'com.test',
      );
      expect(log.last.method, ChannelConstants.scheduleAlarm);
      final args = log.last.arguments as Map<Object?, Object?>;
      expect(args['triggerAtMillis'], 1700000000000);
    });

    test('cancelAlarm invokes correct method', () async {
      await service.cancelAlarm();
      expect(log.last.method, ChannelConstants.cancelAlarm);
    });
  });
}

dynamic _mockResult(String method) {
  switch (method) {
    case ChannelConstants.checkAccessibility:
    case ChannelConstants.checkOverlay:
    case ChannelConstants.checkBatteryOpt:
    case ChannelConstants.checkExactAlarm:
    case ChannelConstants.isServiceRunning:
      return true;
    default:
      return null;
  }
}
