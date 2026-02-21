import 'package:auto_route/auto_route.dart';
import 'package:ghost_traffic_lab/core/router/app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: ShellView.page,
          initial: true,
          children: [
            AutoRoute(page: DashboardView.page, initial: true),
            AutoRoute(page: PayloadBuilderView.page),
            AutoRoute(page: SchedulerView.page),
            AutoRoute(page: LogsView.page),
          ],
        ),
        AutoRoute(page: PermissionsView.page),
      ];
}
