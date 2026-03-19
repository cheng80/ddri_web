import 'package:flutter/material.dart';

/// DDRI Design Token (12_ddri_responsive_breakpoints_and_layouts.md 기준)
/// 구간별 레이아웃만 다르고, 색상·타이포·컴포넌트는 공통 유지
class DesignToken {
  DesignToken._();

  // ─── 브레이크포인트 (px) ─────────────────
  static const double breakpointMobile = 0;
  static const double breakpointTablet = 600;
  static const double breakpointDesktop = 1024;

  // ─── 색상 ────────────────────────────────
  static const Color primary = Color(0xFF00A857);
  static const Color background = Color(0xFFF5F8F7);
  static const Color cardBackground = Colors.white;

  /// 대여가능(녹색), 보통(주황), 부족(회색)
  static const Color badgeSufficient = Color(0xFF00A857);
  static const Color badgeNormal = Color(0xFFFF9800);
  static const Color badgeLow = Color(0xFF9E9E9E);

  // ─── 카드 스타일 ─────────────────────────
  static const double cardRadius = 12;
  static const double cardElevation = 1;

  // ─── 반경 옵션 (m) ──────────────────────
  static const List<int> radiusOptions = [300, 500, 1000];

  // ─── 관리자 리스트 영역 높이 (px) ─────────
  /// 이 개수 이하면 콘텐츠 높이만 사용 (shrinkWrap)
  static const int adminListShrinkWrapThreshold = 8;
  /// 목록이 많을 때 최대 높이 (이 안에서 스크롤)
  static const double adminListMaxHeight = 600;
  /// 섹션 간 여백
  static const double adminSectionSpacing = 16;

  // ─── flutter_screenutil designSize ───────
  static const Size designSize = Size(375, 812);
}
