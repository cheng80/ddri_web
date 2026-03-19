import 'dart:convert';

import 'package:http/http.dart' as http;

/// 주소 → 위경도 변환 (OpenStreetMap Nominatim, API 키 불필요)
/// Kpostal 지오코딩 실패 시 폴백용
/// Nominatim 정책: 1 req/sec, User-Agent 필수
Future<({double lat, double lng})?> geocodeAddress(String address) async {
  if (address.trim().isEmpty) return null;

  final url = Uri.parse(
    'https://nominatim.openstreetmap.org/search'
    '?q=${Uri.encodeComponent(address)}'
    '&format=json'
    '&limit=1',
  );

  try {
    final response = await http.get(
      url,
      headers: {'User-Agent': 'DDRI/1.0 (https://github.com/ddri_web)'},
    );

    if (response.statusCode != 200) return null;

    final list = jsonDecode(response.body) as List<dynamic>?;
    if (list == null || list.isEmpty) return null;

    final item = list.first as Map<String, dynamic>;
    final lat = double.tryParse(item['lat']?.toString() ?? '');
    final lon = double.tryParse(item['lon']?.toString() ?? '');

    if (lat != null && lon != null) return (lat: lat, lng: lon);
  } catch (_) {}
  return null;
}

/// Kpostal 결과에서 여러 주소 형식으로 지오코딩 시도
Future<({double lat, double lng})?> geocodeKpostal(dynamic result) async {
  final candidates = <String>{
    result.address,
    result.roadAddress,
    result.jibunAddress,
    result.userSelectedAddress,
  }.where((s) => s.trim().isNotEmpty).map((s) => s.trim()).toList();

  for (var i = 0; i < candidates.length; i++) {
    if (i > 0) await Future<void>.delayed(const Duration(seconds: 1));
    final coords = await geocodeAddress(candidates[i]);
    if (coords != null) return coords;
  }
  return null;
}
