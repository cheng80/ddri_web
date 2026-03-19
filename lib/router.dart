// DDRI 라우팅: GetX GetPage, /·/user→UserView, /admin→AdminView
import 'package:get/get.dart';

import 'app_config.dart';
import 'view/admin_view.dart';
import 'view/user_view.dart';

/// GetX 라우팅 페이지 목록.
/// [RoutePaths.root], [RoutePaths.user] → UserView, [RoutePaths.admin] → AdminView.
final List<GetPage> appPages = [
  GetPage(name: RoutePaths.root, page: () => const UserView()),
  GetPage(name: RoutePaths.user, page: () => const UserView()),
  GetPage(name: RoutePaths.admin, page: () => const AdminView()),
];
