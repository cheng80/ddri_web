/// API 응답 모델 (OpenAPI 스키마 기준)
/// 화면별로 필요한 필드만 사용, 공통 인터페이스 유지

/// 근처 대여소 1건 (사용자 페이지)
class StationNearbyItem {
  const StationNearbyItem({
    required this.stationId,
    required this.stationName,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.distanceM,
    required this.currentBikeStock,
    required this.predictedRentalCount,
    required this.predictedRemainingBikes,
    required this.bikeAvailabilityFlag,
    required this.availabilityLevel,
    required this.operationalStatus,
  });

  final int stationId;
  final String stationName;
  final String address;
  final double latitude;
  final double longitude;
  final double distanceM;
  final int currentBikeStock;
  final double predictedRentalCount;
  final double predictedRemainingBikes;
  final bool bikeAvailabilityFlag;
  final String availabilityLevel; // sufficient | normal | low
  final String operationalStatus;

  factory StationNearbyItem.fromJson(Map<String, dynamic> json) {
    return StationNearbyItem(
      stationId: json['station_id'] as int,
      stationName: json['station_name'] as String,
      address: json['address'] as String? ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      distanceM: (json['distance_m'] as num).toDouble(),
      currentBikeStock: json['current_bike_stock'] as int? ?? 0,
      predictedRentalCount: (json['predicted_rental_count'] as num?)?.toDouble() ?? 0,
      predictedRemainingBikes: (json['predicted_remaining_bikes'] as num?)?.toDouble() ?? 0,
      bikeAvailabilityFlag: json['bike_availability_flag'] as bool? ?? false,
      availabilityLevel: json['availability_level'] as String? ?? 'low',
      operationalStatus: json['operational_status'] as String? ?? '',
    );
  }
}

/// 위험 대여소 1건 (관리자 페이지)
class StationRiskItem {
  const StationRiskItem({
    required this.stationId,
    required this.stationName,
    required this.districtName,
    required this.clusterCode,
    required this.currentBikeStock,
    required this.predictedDemand,
    required this.stockGap,
    required this.riskScore,
    required this.reallocationPriority,
    required this.operationalStatus,
  });

  final int stationId;
  final String stationName;
  final String districtName;
  final String clusterCode;
  final int currentBikeStock;
  final double predictedDemand;
  final double stockGap;
  final double riskScore;
  final int reallocationPriority;
  final String operationalStatus;

  factory StationRiskItem.fromJson(Map<String, dynamic> json) {
    return StationRiskItem(
      stationId: json['station_id'] as int,
      stationName: json['station_name'] as String,
      districtName: json['district_name'] as String? ?? '',
      clusterCode: json['cluster_code'] as String? ?? '',
      currentBikeStock: json['current_bike_stock'] as int? ?? 0,
      predictedDemand: (json['predicted_demand'] as num?)?.toDouble() ?? 0,
      stockGap: (json['stock_gap'] as num?)?.toDouble() ?? 0,
      riskScore: (json['risk_score'] as num?)?.toDouble() ?? 0,
      reallocationPriority: json['reallocation_priority'] as int? ?? 0,
      operationalStatus: json['operational_status'] as String? ?? '',
    );
  }
}

/// 스테이션 마스터 1건
class StationMasterItem {
  const StationMasterItem({
    required this.stationId,
    required this.apiStationId,
    required this.stationName,
    required this.districtName,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.clusterCode,
    required this.operationalStatus,
  });

  final int stationId;
  final String apiStationId;
  final String stationName;
  final String districtName;
  final String address;
  final double latitude;
  final double longitude;
  final String clusterCode;
  final String operationalStatus;

  factory StationMasterItem.fromJson(Map<String, dynamic> json) {
    return StationMasterItem(
      stationId: json['station_id'] as int,
      apiStationId: json['api_station_id'] as String? ?? '',
      stationName: json['station_name'] as String,
      districtName: json['district_name'] as String? ?? '',
      address: json['address'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0,
      clusterCode: json['cluster_code'] as String? ?? '',
      operationalStatus: json['operational_status'] as String? ?? '',
    );
  }
}
