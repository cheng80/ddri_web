import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../common/api/ddri_api_client.dart';
import '../../common/api/models/station_models.dart';
import '../../core/design_token.dart';

/// 사용자 페이지 상태·로직 (GetX)
class UserPageController extends GetxController {
  UserPageController({DdriApiClient? apiClient})
      : _api = apiClient ?? DdriApiClient();

  final DdriApiClient _api;

  // ─── 검색 조건 ───────────────────────────
  final Rx<double?> lat = Rx<double?>(null);
  final Rx<double?> lng = Rx<double?>(null);
  final Rx<String> address = ''.obs;
  final Rx<DateTime> targetDatetime = DateTime.now().obs;
  final Rx<int> radiusM = DesignToken.radiusOptions[1].obs; // 500m 기본

  // ─── 결과 ───────────────────────────────
  final RxList<StationNearbyItem> items = <StationNearbyItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingLocation = false.obs;
  final RxString errorMessage = ''.obs;

  bool get hasLocation => lat.value != null && lng.value != null;

  String get targetDatetimeIso =>
      '${targetDatetime.value.toIso8601String().substring(0, 19)}+09:00';

  void setRadius(int m) => radiusM.value = m;

  void setTargetDatetime(DateTime dt) => targetDatetime.value = dt;

  /// 현 위치로 검색
  Future<void> fetchCurrentLocation() async {
    try {
      errorMessage.value = '';
      isLoadingLocation.value = true;
      final pos = await Geolocator.getCurrentPosition();
      debugPrint('[DDRI] 현 위치 좌표: lat=${pos.latitude}, lng=${pos.longitude}');
      lat.value = pos.latitude;
      lng.value = pos.longitude;
      address.value = '현재 위치';
      await _fetchStations();
    } catch (e) {
      errorMessage.value = '위치를 가져올 수 없습니다. 주소 검색을 이용해 주세요.';
    } finally {
      isLoadingLocation.value = false;
    }
  }

  /// 주소 검색 결과 적용 후 조회
  Future<void> applyAddressAndFetch(double newLat, double newLng, String addr) async {
    debugPrint('[DDRI] 주소 검색 좌표: lat=$newLat, lng=$newLng, addr=$addr');
    lat.value = newLat;
    lng.value = newLng;
    address.value = addr;
    await _fetchStations();
  }

  /// 대여소 목록 조회
  Future<void> _fetchStations() async {
    final la = lat.value;
    final ln = lng.value;
    if (la == null || ln == null) return;

    try {
      errorMessage.value = '';
      isLoading.value = true;
      final res = await _api.getStationsNearby(
        lat: la,
        lng: ln,
        targetDatetime: targetDatetimeIso,
        limit: 20,
        radiusM: radiusM.value,
      );
      items.value = res.items;
    } catch (e, st) {
      debugPrint('[DDRI] 대여소 목록 조회 실패: $e');
      debugPrint('[DDRI] 스택: $st');
      final msg = e.toString().toLowerCase();
      if (msg.contains('connection') ||
          msg.contains('refused') ||
          msg.contains('failed host lookup') ||
          msg.contains('socket')) {
        errorMessage.value =
            '서버에 연결할 수 없습니다. FastAPI 서버를 실행했는지 확인하세요. (터미널: cd fastapi && uvicorn app.main:app --reload)';
      } else {
        errorMessage.value = '대여소 목록을 불러오지 못했습니다. $e';
      }
      items.clear();
    } finally {
      isLoading.value = false;
    }
  }

  /// 반경 변경 시 재조회
  Future<void> onRadiusChanged(int m) async {
    setRadius(m);
    if (hasLocation) await _fetchStations();
  }

  /// 시간 변경 시 재조회
  Future<void> onDatetimeChanged(DateTime dt) async {
    setTargetDatetime(dt);
    if (hasLocation) await _fetchStations();
  }
}
