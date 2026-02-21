import 'package:flutter_test/flutter_test.dart';
import 'package:ghost_traffic_lab/product/models/permission_state.dart';
import 'package:ghost_traffic_lab/product/models/service_status.dart';

void main() {
  group('PermissionState', () {
    test('default is all false', () {
      const state = PermissionState();
      expect(state.allGranted, isFalse);
      expect(state.grantedCount, 0);
    });

    test('allGranted when all true', () {
      const state = PermissionState(
        accessibility: true,
        overlay: true,
        batteryOpt: true,
        exactAlarm: true,
      );
      expect(state.allGranted, isTrue);
      expect(state.grantedCount, 4);
    });

    test('grantedCount partial', () {
      const state = PermissionState(
        accessibility: true,
        overlay: true,
      );
      expect(state.grantedCount, 2);
      expect(state.allGranted, isFalse);
    });
  });

  group('ServiceStatus', () {
    test('has correct labels', () {
      expect(ServiceStatus.idle.label, 'Idle');
      expect(ServiceStatus.armed.label, 'Armed');
      expect(ServiceStatus.running.label, 'Running');
      expect(ServiceStatus.error.label, 'Error');
    });

    test('has descriptions', () {
      for (final status in ServiceStatus.values) {
        expect(status.description, isNotEmpty);
      }
    });
  });
}
