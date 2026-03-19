import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app_config.dart';
import '../../core/design_token.dart';

/// 상단 네비게이션 (사용자 / 관리자)
class TopNavBar extends StatelessWidget implements PreferredSizeWidget {
  const TopNavBar({super.key, this.title, this.currentPath});

  final String? title;
  final String? currentPath;

  @override
  Size get preferredSize => const Size.fromHeight(65);

  @override
  Widget build(BuildContext context) {
    final path = currentPath ?? Get.currentRoute;
    final isUser = path == RoutePaths.user || path == RoutePaths.root;
    final isAdmin = path == RoutePaths.admin;

    return AppBar(
      toolbarHeight: 64,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0,
      shadowColor: Colors.transparent,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: DesignToken.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.pedal_bike_rounded,
                color: DesignToken.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title ?? AppConfig.appTitle,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: const Color(0xFF0F172A),
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
            ),
            const Spacer(),
            _NavLink(
              label: '사용자',
              selected: isUser,
              onTap: isUser ? null : () => Get.offAllNamed(RoutePaths.user),
            ),
            const SizedBox(width: 8),
            _NavLink(
              label: '관리자',
              selected: isAdmin,
              onTap: isAdmin ? null : () => Get.offAllNamed(RoutePaths.admin),
            ),
            const SizedBox(width: 16),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: DesignToken.primary.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.account_circle_outlined,
                color: DesignToken.primary,
                size: 22,
              ),
            ),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: DesignToken.primary.withValues(alpha: 0.10),
        ),
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  const _NavLink({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: selected
            ? DesignToken.primary
            : const Color(0xFF64748B),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
      child: Container(
        padding: const EdgeInsets.only(bottom: 2),
        decoration: selected
            ? const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: DesignToken.primary, width: 2),
                ),
              )
            : null,
        child: Text(
          label,
          style: TextStyle(
            fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
