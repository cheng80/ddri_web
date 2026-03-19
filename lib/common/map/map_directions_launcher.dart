/// 웹 환경용 외부 지도 길찾기
/// url_launcher로 Google/Naver/Kakao 지도 웹 URL을 새 탭에서 엽니다.
/// (map_launcher는 iOS/Android 전용이라 웹 미지원)

import 'package:url_launcher/url_launcher.dart';

/// 지원 지도 종류
enum MapProvider {
  google,
  naver,
  kakao,
}

/// 위도·경도로 외부 지도 길찾기 URL 열기
///
/// [provider]: 사용할 지도 (기본: Google Maps)
/// [lat], [lng]: 목적지 좌표
/// [destinationTitle]: 목적지 이름 (일부 지도에서 사용)
Future<bool> launchMapDirections({
  required double lat,
  required double lng,
  String? destinationTitle,
  MapProvider provider = MapProvider.google,
}) async {
  final uri = _buildDirectionsUri(provider: provider, lat: lat, lng: lng, title: destinationTitle);
  return launchUrl(uri, mode: LaunchMode.externalApplication);
}

Uri _buildDirectionsUri({
  required MapProvider provider,
  required double lat,
  required double lng,
  String? title,
}) {
  switch (provider) {
    case MapProvider.google:
      // https://www.google.com/maps/dir/?api=1&destination=lat,lng
      return Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng',
      );
    case MapProvider.naver:
      // 네이버 지도 길찾기 (목적지 좌표)
      return Uri.parse(
        'https://map.naver.com/v5/directions/-/-/-/car?c=$lng,$lat,15,0,0,0,dh',
      );
    case MapProvider.kakao:
      // 카카오맵 길찾기 (placeName,lat,lng)
      final name = (title ?? '목적지').replaceAll(',', ' ');
      return Uri.parse(
        'https://map.kakao.com/link/to/$name,$lat,$lng',
      );
  }
}
