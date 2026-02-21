import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ghost_traffic_lab/product/models/permission_state.dart';
import 'package:ghost_traffic_lab/product/models/service_status.dart';

part 'dashboard_state.freezed.dart';

@freezed
class DashboardState with _$DashboardState {
  const factory DashboardState({
    @Default(ServiceStatus.idle) ServiceStatus status,
    @Default(PermissionState()) PermissionState permissions,
    DateTime? scheduledTime,
    String? targetPackage,
  }) = _DashboardState;
}
