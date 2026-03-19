import 'package:flutter/material.dart';

import 'design_token.dart';

/// DDRI 앱 테마. DesignToken 기준.
class AppTheme {
  AppTheme._();

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
