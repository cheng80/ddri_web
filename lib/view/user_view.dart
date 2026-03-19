import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/layout/app_scaffold.dart';
import 'user/user_page_controller.dart';
import 'user/user_search_area.dart';
import 'user/user_station_list.dart';

/// 사용자 페이지: 근처 대여소 조회
class UserView extends StatelessWidget {
  const UserView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<UserPageController>()) {
      Get.put(UserPageController(), permanent: true);
    }

    return AppScaffold(
      title: '대여소 조회',
      currentPath: '/user',
      body: Column(
        children: [
          const UserSearchArea(),
          const Divider(height: 1),
          Expanded(child: UserStationList()),
        ],
      ),
    );
  }
}
