// DDRI 앱 루트: GetMaterialApp, GetX 라우팅, 한국어, 공통 테마
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'app_config.dart';
import 'core/app_theme.dart';
import 'router.dart';
import 'view/user_view.dart';

/// 앱의 루트 위젯.
/// GetMaterialApp + GetX 라우팅, 한국어 로컬라이제이션, 공통 테마 적용.
class App extends StatelessWidget {
  const App({super.key});

  /// 터치·마우스·트랙패드 등 모든 스크롤 디바이스 지원
  ScrollBehavior _scrollBehavior() {
    return const MaterialScrollBehavior().copyWith(
      dragDevices: {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
        PointerDeviceKind.invertedStylus,
        PointerDeviceKind.unknown,
      },
    );
  }

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
      scrollBehavior: _scrollBehavior(),
    );
  }
}
