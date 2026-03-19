import 'app_config_platform_stub.dart'
    if (dart.library.io) 'app_config_platform_io.dart'
    as _platform;

/// 앱 전반에서 사용하는 상수 모음.
/// private 생성자(_)로 인스턴스 생성을 막고, static 상수만 제공한다.
class AppConfig {
  AppConfig._();

  static const String appTitle = 'DDRI';

  /// FastAPI 서버 기본 URL (커스텀 오버라이드)
  /// null/빈값이면 플랫폼 자동 선택 (웹·iOS: 127.0.0.1, Android 에뮬: 10.0.2.2)
  static const String? customApiBaseUrl = null;

  /// 카카오 JavaScript API 키 (주소 검색→위경도 변환용, 웹에서 필요)
  static const String? kakaoJsKey = '945bd56201340c858e34dda4bea79688';
  // static const String? customApiBaseUrl = 'http://192.168.90.7:8000';
  // static const String? customApiBaseUrl = 'http://cheng80.myqnapcloud.com:18000';
}

/// FastAPI 서버 베이스 URL
String getApiBaseUrl() {
  if (AppConfig.customApiBaseUrl != null &&
      AppConfig.customApiBaseUrl!.trim().isNotEmpty) {
    return AppConfig.customApiBaseUrl!.trim();
  }
  return _platform.getPlatformDefaultApiUrl();
}

/// 로컬 저장소(GetStorage) 키 상수.
class StorageKeys {
  StorageKeys._();

  static const String apiBaseUrl = 'api_base_url';
  static const String savedAddress = 'saved_address';
  static const String savedLat = 'saved_lat';
  static const String savedLng = 'saved_lng';
}

/// GoRouter에서 사용할 경로 상수.
class RoutePaths {
  RoutePaths._();

  static const String root = '/';
  static const String user = '/user';
  static const String admin = '/admin';
}
