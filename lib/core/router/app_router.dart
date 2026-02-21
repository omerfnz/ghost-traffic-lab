import 'package:auto_route/auto_route.dart';
import 'package:ghost_traffic_lab/core/router/app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page|Screen|View,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: ShellRoute.page,
      initial: true,
      children: [
        AutoRoute(page: DashboardRoute.page, initial: true),
        AutoRoute(page: PayloadBuilderRoute.page),
        AutoRoute(page: SchedulerRoute.page),
        AutoRoute(page: LogsRoute.page),
        AutoRoute(page: PermissionsRoute.page),
      ],
    ),
  ];
}
