import 'package:get/get.dart';

import 'app_config.dart';
import 'view/admin_view.dart';
import 'view/user_view.dart';

/// GetX 라우팅 설정.
final List<GetPage> appPages = [
  GetPage(name: RoutePaths.root, page: () => const UserView()),
  GetPage(name: RoutePaths.user, page: () => const UserView()),
  GetPage(name: RoutePaths.admin, page: () => const AdminView()),
];
