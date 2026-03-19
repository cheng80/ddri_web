// 플랫폼별 API URL: Android 10.0.2.2:8000, iOS/데스크톱 127.0.0.1:8000
import 'dart:io';

/// 모바일/데스크톱 빌드용 플랫폼 기본 API URL.
String getPlatformDefaultApiUrl() =>
    Platform.isAndroid ? 'http://10.0.2.2:8000' : 'http://127.0.0.1:8000';
