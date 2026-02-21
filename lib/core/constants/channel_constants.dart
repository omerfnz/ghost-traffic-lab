abstract final class ChannelConstants {
  static const controlChannel = 'com.ghosttraffic.lab/control';
  static const logChannel = 'com.ghosttraffic.lab/logs';

  // Permission checks
  static const checkAccessibility = 'checkAccessibility';
  static const checkOverlay = 'checkOverlay';
  static const checkBatteryOpt = 'checkBatteryOpt';
  static const checkExactAlarm = 'checkExactAlarm';

  // Permission requests
  static const requestAccessibility = 'requestAccessibility';
  static const requestOverlay = 'requestOverlay';
  static const requestBatteryOpt = 'requestBatteryOpt';
  static const requestExactAlarm = 'requestExactAlarm';

  // Service control
  static const startService = 'startService';
  static const stopService = 'stopService';
  static const isServiceRunning = 'isServiceRunning';

  // Alarm
  static const scheduleAlarm = 'scheduleAlarm';
  static const cancelAlarm = 'cancelAlarm';
}
