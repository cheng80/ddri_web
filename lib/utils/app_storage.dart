import '../app_config.dart';
import 'package:get_storage/get_storage.dart';

/// AppStorage - 화면 간 상태 동기화용 정적 헬퍼
class AppStorage {
  AppStorage._();

  static GetStorage get _storage => GetStorage();

  static GetStorage get rawStorage => _storage;

  // ─── API 서버 ───────────────────────────────
  static String? getApiBaseUrl() =>
      _storage.read<String>(StorageKeys.apiBaseUrl);

  static Future<void> saveApiBaseUrl(String? value) =>
      value == null || value.trim().isEmpty
          ? _storage.remove(StorageKeys.apiBaseUrl)
          : _storage.write(StorageKeys.apiBaseUrl, value.trim());

  // ─── 주소 / 좌표 ─────────────────────────────
  static String? getAddress() =>
      _storage.read<String>(StorageKeys.savedAddress);

  static String? getLat() => _storage.read<String>(StorageKeys.savedLat);

  static String? getLng() => _storage.read<String>(StorageKeys.savedLng);

  static Future<void> saveAddress(String address) =>
      _storage.write(StorageKeys.savedAddress, address);

  static Future<void> saveCoordinates(String lat, String lng) async {
    await _storage.write(StorageKeys.savedLat, lat);
    await _storage.write(StorageKeys.savedLng, lng);
  }

  static Future<void> clearAll() => _storage.erase();
}
