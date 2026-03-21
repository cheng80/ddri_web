// DDRI 디자인 토큰: 브레이크포인트, 색상, 카드, 반경, 관리자 리스트
import 'package:flutter/material.dart';

/// DDRI Design Token.
/// 구간별 레이아웃만 다르고, 색상·타이포·컴포넌트는 공통 유지.
class DesignToken {
  DesignToken._();

  // ─── 브레이크포인트 (px) ─────────────────
  /// 모바일 구간 (0px~)
  static const double breakpointMobile = 0;
  /// 태블릿 구간 (600px~)
  static const double breakpointTablet = 600;
  /// 데스크탑 구간 (1024px~)
  static const double breakpointDesktop = 1024;
  /// 태블릿에서 좌우분할 사용 최소 너비 (900px~: 가로폭 충분 시 세로여도 좌우분할)
  static const double breakpointTabletSideLayout = 900;

  // ─── 색상 ────────────────────────────────
  /// DDRI 메인 컬러 (녹색)
  static const Color primary = Color(0xFF00A857);
  /// 배경색 (연한 회녹)
  static const Color background = Color(0xFFF5F8F7);
  /// 카드·패널 배경
  static const Color cardBackground = Colors.white;

  /// 대여 가능(녹색), 보통(주황), 부족(회색) 배지 색상
  static const Color badgeSufficient = Color(0xFF00A857);
  static const Color badgeNormal = Color(0xFFFF9800);
  static const Color badgeLow = Color(0xFF9E9E9E);

  // ─── 카드 스타일 ─────────────────────────
  /// 카드 모서리 반경
  static const double cardRadius = 12;
  /// 카드 그림자 높이
  static const double cardElevation = 1;

  // ─── 반경 옵션 (m) ──────────────────────
  /// 사용자 페이지 대여소 검색 반경 옵션 (300m, 500m, 1km)
  static const List<int> radiusOptions = [300, 500, 1000];

  // ─── 사용자 페이지 지도 높이 (px) ─────────
  /// 모바일/태블릿세로 스크롤 레이아웃에서 지도 최소 높이 (항상 유지)
  static const double userMapMinHeight = 280;
  /// 지도 최대 높이
  static const double userMapMaxHeight = 450;
  /// 사용자 날씨 섹션 초기 예약 높이
  static const double userWeatherReservedHeight = 320;
  /// 관리자 날씨 섹션 초기 예약 높이
  static const double adminWeatherReservedHeight = 300;

  // ─── 관리자 리스트 영역 높이 (px) ─────────
  /// 이 개수 이하면 콘텐츠 높이만 사용 (shrinkWrap)
  static const int adminListShrinkWrapThreshold = 8;
  /// 목록이 많을 때 최대 높이 (이 안에서 스크롤)
  static const double adminListMaxHeight = 600;
  /// 섹션 간 여백
  static const double adminSectionSpacing = 16;

  // ─── flutter_screenutil designSize ───────
  /// 기준 디자인 해상도 (모바일 기준)
  static const Size designSize = Size(375, 812);
}
