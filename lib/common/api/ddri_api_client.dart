import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../utils/custom_common_util.dart';
import 'package:http/http.dart' as http;

import 'models/station_models.dart';

/// DDRI API 클라이언트 인터페이스
/// 모든 API 호출은 이 클라이언트를 통해 수행
class DdriApiClient {
  DdriApiClient({String? baseUrl}) : _baseUrl = baseUrl ?? CustomCommonUtil.getApiBaseUrlSync();

  final String _baseUrl;

  String get _v1 => '$_baseUrl/v1';

  Future<Map<String, dynamic>> _get(String path, {Map<String, String>? queryParams}) async {
    final uri = Uri.parse('$_v1$path').replace(queryParameters: queryParams);
    final response = await http.get(uri);
    if (response.statusCode >= 400) {
      throw ApiException(response.statusCode, response.body);
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  /// 근처 대여소 조회
  Future<NearbyStationsResponse> getStationsNearby({
    required double lat,
    required double lng,
    required String targetDatetime,
    int limit = 20,
    int? radiusM,
  }) async {
    debugPrint('[DDRI] 좌표 수신: lat=$lat, lng=$lng');
    final params = <String, String>{
      'lat': lat.toString(),
      'lng': lng.toString(),
      'target_datetime': targetDatetime,
      'limit': limit.toString(),
    };
    if (radiusM != null) params['radius_m'] = radiusM.toString();

    final json = await _get('/user/stations/nearby', queryParams: params);
    final res = NearbyStationsResponse.fromJson(json);
    debugPrint('[DDRI] API 응답 user_location: lat=${res.userLocation.lat}, lng=${res.userLocation.lng}');
    return res;
  }

  /// 재배치 판단 목록 조회
  Future<RiskStationsResponse> getStationsRisk({
    required String baseDatetime,
    bool? urgentOnly,
    String? districtName,
    String sortBy = 'risk_score',
    String sortOrder = 'desc',
  }) async {
    final params = <String, String>{
      'base_datetime': baseDatetime,
      'sort_by': sortBy,
      'sort_order': sortOrder,
    };
    if (urgentOnly != null) params['urgent_only'] = urgentOnly.toString();
    if (districtName != null && districtName.isNotEmpty) params['district_name'] = districtName;

    final json = await _get('/admin/stations/risk', queryParams: params);
    return RiskStationsResponse.fromJson(json);
  }

  /// 스테이션 마스터 조회
  Future<StationsListResponse> getStations({
    String? districtName,
  }) async {
    final params = <String, String>{};
    if (districtName != null && districtName.isNotEmpty) params['district_name'] = districtName;

    final json = await _get('/stations', queryParams: params.isNotEmpty ? params : null);
    return StationsListResponse.fromJson(json);
  }
}

/// API 예외
class ApiException implements Exception {
  ApiException(this.statusCode, this.body);
  final int statusCode;
  final String body;
  @override
  String toString() => 'ApiException($statusCode): $body';
}

/// 근처 대여소 응답
class NearbyStationsResponse {
  const NearbyStationsResponse({
    required this.targetDatetime,
    required this.userLocation,
    required this.items,
    required this.exceptions,
  });

  final String targetDatetime;
  final UserLocation userLocation;
  final List<StationNearbyItem> items;
  final List<ExceptionItem> exceptions;

  factory NearbyStationsResponse.fromJson(Map<String, dynamic> json) {
    return NearbyStationsResponse(
      targetDatetime: json['target_datetime'] as String? ?? '',
      userLocation: UserLocation.fromJson(json['user_location'] as Map<String, dynamic>? ?? {}),
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => StationNearbyItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      exceptions: (json['exceptions'] as List<dynamic>?)
              ?.map((e) => ExceptionItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class UserLocation {
  const UserLocation({required this.lat, required this.lng});
  final double lat;
  final double lng;
  factory UserLocation.fromJson(Map<String, dynamic> json) => UserLocation(
        lat: (json['lat'] as num?)?.toDouble() ?? 0,
        lng: (json['lng'] as num?)?.toDouble() ?? 0,
      );
}

class ExceptionItem {
  const ExceptionItem({required this.stationId, required this.reason});
  final int stationId;
  final String reason;
  factory ExceptionItem.fromJson(Map<String, dynamic> json) => ExceptionItem(
        stationId: json['station_id'] as int? ?? 0,
        reason: json['reason'] as String? ?? '',
      );
}

/// 위험 대여소 응답
class RiskStationsResponse {
  const RiskStationsResponse({
    required this.baseDatetime,
    required this.summary,
    required this.items,
    required this.exceptions,
  });

  final String baseDatetime;
  final RiskSummary summary;
  final List<StationRiskItem> items;
  final List<ExceptionItem> exceptions;

  factory RiskStationsResponse.fromJson(Map<String, dynamic> json) {
    return RiskStationsResponse(
      baseDatetime: json['base_datetime'] as String? ?? '',
      summary: RiskSummary.fromJson(json['summary'] as Map<String, dynamic>? ?? {}),
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => StationRiskItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      exceptions: (json['exceptions'] as List<dynamic>?)
              ?.map((e) => ExceptionItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class RiskSummary {
  const RiskSummary({
    required this.totalCount,
    required this.riskCount,
    required this.exceptionCount,
    required this.avgRiskScore,
  });
  final int totalCount;
  final int riskCount;
  final int exceptionCount;
  final double avgRiskScore;
  factory RiskSummary.fromJson(Map<String, dynamic> json) => RiskSummary(
        totalCount: json['total_count'] as int? ?? 0,
        riskCount: json['risk_count'] as int? ?? 0,
        exceptionCount: json['exception_count'] as int? ?? 0,
        avgRiskScore: (json['avg_risk_score'] as num?)?.toDouble() ?? 0,
      );
}

/// 스테이션 목록 응답
class StationsListResponse {
  const StationsListResponse({required this.items, required this.totalCount});
  final List<StationMasterItem> items;
  final int totalCount;
  factory StationsListResponse.fromJson(Map<String, dynamic> json) => StationsListResponse(
        items: (json['items'] as List<dynamic>?)
                ?.map((e) => StationMasterItem.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        totalCount: json['total_count'] as int? ?? 0,
      );
}
