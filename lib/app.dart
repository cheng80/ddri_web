import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_config.dart';
import 'router.dart';
import 'view/user_view.dart';

/// 앱의 루트 위젯. GetMaterialApp + GetX 라우팅.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConfig.appTitle,
      debugShowCheckedModeBanner: false,
      initialRoute: RoutePaths.user,
      getPages: appPages,
      unknownRoute: GetPage(
        name: RoutePaths.user,
        page: () => const UserView(),
      ),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
