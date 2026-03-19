import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'app_config.dart';
import 'core/app_theme.dart';
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
      locale: const Locale('ko'),
      supportedLocales: const [
        Locale('ko'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: RoutePaths.user,
      getPages: appPages,
      unknownRoute: GetPage(
        name: RoutePaths.user,
        page: () => const UserView(),
      ),
      theme: AppTheme.light,
    );
  }
}
