import 'package:flutter/material.dart';

import '../../app_config.dart';
import 'top_nav_bar.dart';

/// 공통 레이아웃: 상단 네비 + 본문
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.currentPath,
  });

  final String title;
  final Widget body;
  final String? currentPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavBar(
        title: title,
        currentPath: currentPath ?? RoutePaths.user,
      ),
      body: body,
    );
  }
}
