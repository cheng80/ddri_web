// DDRI 앱 테마: Material 3 라이트, DesignToken 적용
import 'package:flutter/material.dart';

import 'design_token.dart';

/// DDRI 앱 테마. DesignToken 기준.
class AppTheme {
  AppTheme._();

  /// 라이트 테마. DDRI 녹색 메인, 연한 배경, 카드 스타일 적용.
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: DesignToken.primary,
          surface: DesignToken.background,
          onPrimary: Colors.white,
          onSurface: Colors.black87,
        ),
        scaffoldBackgroundColor: DesignToken.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: DesignToken.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          color: DesignToken.cardBackground,
          elevation: DesignToken.cardElevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignToken.cardRadius),
          ),
        ),
      );
}
