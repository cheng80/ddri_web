[![pub package](https://img.shields.io/pub/v/kpostal_plus.svg?label=kpostal_plus&color=blue)](https://pub.dev/packages/kpostal_plus)
[![Pub Likes](https://img.shields.io/pub/likes/kpostal_plus)](https://pub.dev/packages/kpostal_plus/score)

[![English](https://img.shields.io/badge/Language-English-9cf?style=for-the-badge)](README.md)
[![Korean](https://img.shields.io/badge/Language-Korean-9cf?style=for-the-badge)](README.ko-kr.md)

# kpostal_plus

[카카오 우편번호 서비스](https://postcode.map.daum.net/guide)를 활용한 **크로스 플랫폼** Flutter 패키지입니다. `kpostal`의 향상된 버전으로 모바일과 웹을 하나의 통합 패키지로 지원합니다.

## 특징

- 📱 **크로스 플랫폼 지원**: **iOS**, **Android**, **Web** 플랫폼에서 완벽하게 작동
- 🔍 **한국 주소 검색**: 카카오 우편번호 서비스 기반 실시간 검색
- 🌐 **네이티브 웹 통합**: DOM 조작을 통한 최적의 웹 성능
- 📍 **선택적 지오코딩**: 위도/경도 좌표 제공
  - 플랫폼 지오코딩 (iOS/Android 네이티브)
  - 카카오 지오코딩 API (한국 주소에 더 높은 정확도)
- 🛡️ **Null-safe**: 완전한 null safety 지원
- 🎯 **통합 API**: 모든 플랫폼을 위한 단일 패키지 - 플랫폼별 의존성 불필요
- 🎨 **커스터마이징 가능**: AppBar, 색상, 로딩 인디케이터 설정 가능
- 🌐 **로컬 서버 지원**: 오프라인 사용을 위한 localhost 호스팅 옵션
- 🔄 **유연한 콜백**: 콜백과 Navigator.pop 반환값 모두 지원

## 스크린샷

### 모바일

![검색 화면](https://raw.githubusercontent.com/pyowonsik/kpostal_plus/main/screenshots/search_app.png)

![검색 결과](https://raw.githubusercontent.com/pyowonsik/kpostal_plus/main/screenshots/search_result_app.png)

![커스텀 UI](https://raw.githubusercontent.com/pyowonsik/kpostal_plus/main/screenshots/custom_search_app.png)

![API 키 안내](https://raw.githubusercontent.com/pyowonsik/kpostal_plus/main/screenshots/need_api_app.png)

### 웹

![웹 검색](https://raw.githubusercontent.com/pyowonsik/kpostal_plus/main/screenshots/search_web.png)

![웹 결과](https://raw.githubusercontent.com/pyowonsik/kpostal_plus/main/screenshots/search_result_web.png)

## 설치

`pubspec.yaml` 파일에 `kpostal_plus`를 추가하세요:

```yaml
dependencies:
  kpostal_plus: ^1.0.0
```

그리고 다음을 실행하세요:

```bash
flutter pub get
```

## 플랫폼 지원

| 플랫폼      | 지원 여부 | 비고              |
| ----------- | --------- | ----------------- |
| **Android** | ✅        | 인터넷 권한 필요  |
| **iOS**     | ✅        | 전체 지원         |
| **Web**     | ✅        | 네이티브 DOM 통합 |
| macOS       | ❌        | 지원하지 않음     |
| Windows     | ❌        | 지원하지 않음     |
| Linux       | ❌        | 지원하지 않음     |

## 설정

### 🤖 Android

`AndroidManifest.xml`에 인터넷 권한을 추가하세요:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET"/>
    <!-- ... -->
</manifest>
```

#### 로컬 서버 사용 시 (선택사항)

로컬 서버 호스팅(`useLocalServer: true`)을 사용하려면 다음을 추가하세요:

```xml
<application
    android:label="your_app"
    android:icon="@mipmap/ic_launcher"
    android:usesCleartextTraffic="true">
    <!-- ... -->
</application>
```

### 🍎 iOS

기본 사용에는 추가 설정이 필요 없습니다.

#### 지오코딩 사용 시 (선택사항)

플랫폼 지오코딩을 사용하려면 `Info.plist`에 위치 권한을 추가하세요:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>정확한 주소 정보를 제공하기 위해 위치 정보가 필요합니다</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>정확한 주소 정보를 제공하기 위해 위치 정보가 필요합니다</string>
```

#### 로컬 서버 사용 시 (선택사항)

`Info.plist`에 `NSAppTransportSecurity`를 추가하세요:

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

### 🌐 Web

추가 설정이 필요 없습니다. 패키지가 네이티브 DOM 조작을 통해 자동으로 웹 통합을 처리합니다.

### 🗺️ 카카오 지오코딩 (선택사항)

한국 주소에 대한 더 나은 지오코딩 정확도를 원하시면:

1. [카카오 개발자 사이트](https://developers.kakao.com) 접속
2. 개발자 등록 및 앱 생성
3. 웹 플랫폼 추가 및 도메인 등록:
   - GitHub 호스팅용: `https://tykann.github.io`
   - 로컬 서버용: `http://localhost:8080`
4. "앱 키" 섹션에서 **JavaScript 키** 발급
5. 코드에서 사용:

```dart
KpostalPlusView(
  kakaoKey: 'YOUR_KAKAO_JAVASCRIPT_KEY',
  callback: (result) {
    // result.kakaoLatitude 와 result.kakaoLongitude 사용 가능
  },
)
```

> **참고**: 오픈소스 프로젝트의 경우, API 키를 하드코딩하지 말고 환경 변수나 사용자 설정을 사용하세요.

## 사용법

### 기본 사용법

```dart
import 'package:flutter/material.dart';
import 'package:kpostal_plus/kpostal_plus.dart';

// 콜백 사용
TextButton(
  onPressed: () async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => KpostalPlusView(
          callback: (Kpostal result) {
            print('우편번호: ${result.postCode}');
            print('주소: ${result.address}');
            print('좌표: ${result.latitude}, ${result.longitude}');
          },
        ),
      ),
    );
  },
  child: Text('주소 검색'),
)

// 반환값 사용
TextButton(
  onPressed: () async {
    Kpostal? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => KpostalPlusView()),
    );
    if (result != null) {
      print('선택한 주소: ${result.address}');
    }
  },
  child: Text('주소 검색'),
)
```

### 고급 사용법

```dart
KpostalPlusView(
  // [선택사항] 커스텀 AppBar
  title: '주소 검색',
  appBarColor: Colors.blue,
  titleColor: Colors.white,

  // [선택사항] 또는 커스텀 AppBar 위젯 사용
  appBar: AppBar(
    title: Text('커스텀 AppBar'),
    backgroundColor: Colors.green,
  ),

  // [선택사항] 로컬 서버 모드 활성화
  useLocalServer: true,
  localPort: 8080, // 기본값: 8080 (범위: 1024-49151)

  // [선택사항] 지오코딩을 위한 카카오 JavaScript API 키
  kakaoKey: 'YOUR_KAKAO_JS_KEY',

  // [선택사항] 커스텀 로딩 인디케이터
  loadingColor: Colors.blue,
  onLoading: CircularProgressIndicator(color: Colors.red),

  // 콜백
  callback: (Kpostal result) {
    print('🏠 주소 정보:');
    print('우편번호: ${result.postCode}');
    print('도로명 주소: ${result.roadAddress}');
    print('지번 주소: ${result.jibunAddress}');
    print('건물명: ${result.buildingName}');

    // 플랫폼 지오코딩 (null일 수 있음)
    print('위도/경도: ${result.latitude}, ${result.longitude}');

    // 카카오 지오코딩 (kakaoKey 제공 시)
    print('카카오 위도/경도: ${result.kakaoLatitude}, ${result.kakaoLongitude}');
  },
)
```

### 사용 예시

```dart
// 📮 배송지 주소
KpostalPlusView(
  title: '배송지 주소',
  callback: (result) {
    saveDeliveryAddress(
      postCode: result.postCode,
      address: result.address,
    );
  },
)

// 🏢 회사/매장 등록
KpostalPlusView(
  title: '매장 위치 등록',
  kakaoKey: 'YOUR_KEY',
  callback: (result) {
    registerStore(
      name: storeName,
      address: result.address,
      latitude: result.kakaoLatitude ?? result.latitude,
      longitude: result.kakaoLongitude ?? result.longitude,
    );
  },
)

// 🗺️ 지도 연동
KpostalPlusView(
  kakaoKey: 'YOUR_KEY', // 좌표 필요 시 필수
  callback: (result) {
    showOnMap(
      latitude: result.kakaoLatitude ?? result.latitude ?? 0,
      longitude: result.kakaoLongitude ?? result.longitude ?? 0,
    );
  },
)
```

## 매개변수

### KpostalPlusView

| 매개변수       | 타입                    | 기본값       | 설명                                                  |
| -------------- | ----------------------- | ------------ | ----------------------------------------------------- |
| title          | String                  | '주소검색'   | AppBar 제목 텍스트                                    |
| appBarColor    | Color                   | Colors.white | AppBar 배경색                                         |
| titleColor     | Color                   | Colors.black | AppBar 제목 및 아이콘 색상                            |
| appBar         | PreferredSizeWidget?    | null         | 커스텀 AppBar (title, appBarColor, titleColor 무시됨) |
| callback       | void Function(Kpostal)? | null         | 주소 선택 시 호출되는 콜백                            |
| useLocalServer | bool                    | false        | GitHub 호스팅 대신 localhost 서버 사용                |
| localPort      | int                     | 8080         | Localhost 포트 번호 (1024-49151)                      |
| loadingColor   | Color                   | Colors.blue  | 로딩 인디케이터 색상                                  |
| onLoading      | Widget?                 | null         | 커스텀 로딩 위젯 (loadingColor 무시됨)                |
| kakaoKey       | String                  | ''           | 지오코딩용 카카오 JavaScript API 키                   |

### Kpostal 모델

```dart
class Kpostal {
  // 기본 정보
  String postCode;              // 우편번호
  String address;               // 전체 주소
  String addressEng;            // 영문 주소
  String roadAddress;           // 도로명 주소
  String roadAddressEng;        // 영문 도로명 주소
  String jibunAddress;          // 지번 주소
  String jibunAddressEng;       // 영문 지번 주소
  String autoJibunAddress;      // 자동 지번 주소
  String autoJibunAddressEnglish; // 영문 자동 지번 주소

  // 건물 정보
  String buildingCode;          // 건물 코드
  String buildingName;          // 건물명
  String apartment;             // 아파트 여부 (Y/N)

  // 주소 유형
  String addressType;           // R (도로명) 또는 J (지번)
  String userSelectedType;      // 사용자 선택 유형 (R/J)

  // 지역 정보
  String sido;                  // 시/도
  String sidoEng;              // 영문 시/도
  String sigungu;              // 시/군/구
  String sigunguEng;           // 영문 시/군/구
  String sigunguCode;          // 시/군/구 코드
  String bcode;                // 법정동 코드
  String bname;                // 법정동명
  String bnameEng;             // 영문 법정동명
  String bname1;               // 법정리명

  // 도로 정보
  String roadnameCode;         // 도로명 코드
  String roadname;             // 도로명
  String roadnameEng;          // 영문 도로명

  // 추가 정보
  String zonecode;             // 우편번호 (5자리)
  String query;                // 검색어
  String userLanguageType;     // 사용자 언어 타입 (K/E)

  // 지오코딩 (null일 수 있음)
  double? latitude;            // 플랫폼 지오코딩 위도
  double? longitude;           // 플랫폼 지오코딩 경도
  double? kakaoLatitude;       // 카카오 지오코딩 위도 (kakaoKey 제공 시)
  double? kakaoLongitude;      // 카카오 지오코딩 경도 (kakaoKey 제공 시)

  // 메서드
  Future<Location?> get latLng; // 플랫폼 지오코딩 결과 가져오기
  String get userSelectedAddress; // 사용자 선택 주소 가져오기 (도로명 또는 지번)
}
```

## 지오코딩 지원

### 플랫폼 지오코딩 (무료, API 키 불필요)

네이티브 iOS (CoreLocation) 및 Android (Geocoder) 서비스 사용:

- ✅ **장점**: 무료, API 키 불필요
- ❌ **단점**: 한국 주소에 대한 정확도 낮음, 실패 가능, 웹 미지원

**예시:**

```dart
KpostalPlusView(
  callback: (result) {
    // 지오코딩 실패 시 null일 수 있음
    print('위도: ${result.latitude}');
    print('경도: ${result.longitude}');
  },
)
```

### 카카오 지오코딩 (API 키 필요)

카카오 지오코딩 서비스 사용:

- ✅ **장점**: 한국 주소에 높은 정확도, 모든 플랫폼 지원 (웹/모바일)
- ✅ **장점**: 더 안정적인 결과
- ⚠️ **참고**: 카카오 JavaScript API 키 필요

> 📌 **v1.1.0 예정**: 카카오 API 키 통합이 완료된 테스트 예제와 상세한 설정 가이드가 추가됩니다.

**예시:**

```dart
KpostalPlusView(
  kakaoKey: 'YOUR_KAKAO_JAVASCRIPT_KEY',
  callback: (result) {
    // 한국 주소에 더 안정적
    print('카카오 위도: ${result.kakaoLatitude}');
    print('카카오 경도: ${result.kakaoLongitude}');
  },
)
```

### 권장사항

| 사용 사례          | 권장사항                       |
| ------------------ | ------------------------------ |
| 주소 텍스트만 필요 | 지오코딩 불필요 ✅             |
| 지도에 위치 표시   | 카카오 지오코딩 사용 ⭐        |
| 거리 계산          | 카카오 지오코딩 사용 ⭐        |
| 경로 탐색          | 카카오 지오코딩 사용 ⭐        |
| 웹 플랫폼          | 카카오 지오코딩 사용 (필수) ⭐ |

## 로컬 서버 vs GitHub 호스팅

### GitHub 호스팅 (기본값)

```dart
KpostalPlusView(
  // 사용: https://tykann.github.io/kpostal/assets/kakao_postcode.html
  callback: (result) { /* ... */ },
)
```

- ✅ **장점**: 추가 설정 불필요, 항상 사용 가능
- ✅ **장점**: 빠른 초기 로드
- ❌ **단점**: GitHub Pages 가용성에 의존
- ❌ **단점**: HTML 수정 불가

### 로컬 서버

```dart
KpostalPlusView(
  useLocalServer: true,
  localPort: 8080,
  callback: (result) { /* ... */ },
)
```

- ✅ **장점**: 오프라인 작동 (HTML 로드 후)
- ✅ **장점**: HTML에 대한 완전한 제어
- ✅ **장점**: 외부 의존성 없음
- ❌ **단점**: 추가 플랫폼 설정 필요 (cleartext traffic)
- ❌ **단점**: 초기 로드 약간 느림

## 마이그레이션 가이드

### `kpostal` 또는 `kpostal_web`에서 마이그레이션

1. **`pubspec.yaml` 업데이트:**

```yaml
dependencies:
  # 제거:
  # kpostal: ^x.x.x
  # kpostal_web: ^x.x.x

  # 추가:
  kpostal_plus: ^1.0.0
```

2. **import 업데이트:**

```dart
// 이전
import 'package:kpostal/kpostal.dart';
// 또는
import 'package:kpostal_web/kpostal_web.dart';

// 새로운
import 'package:kpostal_plus/kpostal_plus.dart';
```

3. **클래스 이름 업데이트:**

```dart
// 이전 (kpostal)
KpostalView(
  callback: (result) { /* ... */ },
)

// 새로운 (kpostal_plus)
KpostalPlusView(
  callback: (result) { /* ... */ },
)
```

4. **API는 동일합니다!** 클래스 이름만 변경되었으며, 모든 매개변수와 콜백은 동일하게 작동합니다.

4. **새로운 기능 사용 가능:**
   - 통합 모바일 + 웹 지원
   - 더 나은 에러 처리
   - 개선된 지오코딩
   - 더 많은 커스터마이징 옵션

## 예제

완전한 작동 예제 앱은 [`example/`](example/) 디렉토리를 참조하세요.

## 테스트

테스트 실행:

```bash
flutter test
```

## 기여하기

기여를 환영합니다! Pull Request를 자유롭게 제출해 주세요.

1. 저장소 포크
2. 기능 브랜치 생성 (`git checkout -b feature/amazing-feature`)
3. 변경사항 커밋 (`git commit -m 'Add some amazing feature'`)
4. 브랜치에 푸시 (`git push origin feature/amazing-feature`)
5. Pull Request 열기

## 라이선스

이 프로젝트는 MIT 라이선스로 배포됩니다 - 자세한 내용은 [LICENSE](LICENSE) 파일을 참조하세요.

## 감사의 말

- TykanN의 원본 [kpostal](https://pub.dev/packages/kpostal) 패키지에서 영감을 받았습니다
- [카카오 우편번호 서비스](https://postcode.map.daum.net/guide)로 구축되었습니다
- 모든 기여자와 사용자분들께 감사드립니다! 🎉

## 관련 패키지

- [kpostal](https://pub.dev/packages/kpostal) - 원본 모바일 전용 패키지
- [kpostal_web](https://pub.dev/packages/kpostal_web) - 원본 웹 전용 패키지
- [geocoding](https://pub.dev/packages/geocoding) - 플랫폼 지오코딩 (내부적으로 사용)
- [flutter_inappwebview](https://pub.dev/packages/flutter_inappwebview) - 모바일용 WebView (내부적으로 사용)

## 지원

문제가 발생하거나 기능 요청이 있으시면 [GitHub 저장소](https://github.com/pyowonsik/kpostal_plus/issues)에 이슈를 등록해 주세요.

## 로드맵

### v1.1.0 예정

- 🗺️ **카카오 지오코딩 예제**: Kakao API 키 통합이 완료된 테스트 예제 추가
- 📍 **향상된 지오코딩 문서**: 카카오 지오코딩 설정 및 사용에 대한 상세 가이드
- 🧪 **지오코딩 통합 테스트**: 플랫폼 및 카카오 지오코딩에 대한 포괄적인 테스트

### 향후 계획

- 🌍 다국어 지원 (일본어, 중국어)
- 🎨 추가 UI 커스터마이징 옵션
- 📦 패키지 크기 최적화
- ⚡ 성능 개선

---

Flutter 커뮤니티를 위해 ❤️로 만들었습니다
