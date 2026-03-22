// 모바일용 스텁 - 웹 기능 비활성화
import 'package:flutter/material.dart';

void registerWebPostcode() {
  // 모바일에서는 아무것도 하지 않음
}

void setupWebMessageListener(Function(String) handleMessage) {
  // 모바일에서는 아무것도 하지 않음
}

Widget buildWebPostcodeView() {
  return const Center(
    child: Text('웹에서만 사용 가능합니다.'),
  );
}

void cleanupWebResources() {
  // Stub for non-web platforms
}
