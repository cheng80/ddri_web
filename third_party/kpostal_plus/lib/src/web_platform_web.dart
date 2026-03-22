// 웹용 구현
import 'dart:js_interop';
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

void registerWebPostcode() {
  ui_web.platformViewRegistry.registerViewFactory(
    'kakao-postcode-web',
    (int viewId) {
      // iframe 대신 직접 div 생성
      final div = web.HTMLDivElement();
      div.id = 'kakao-postcode-container-$viewId';
      div.style.setProperty('width', '100%');
      div.style.setProperty('height', '100%');
      div.style.setProperty('position', 'relative');

      // Kakao Postcode 스크립트 로드 및 초기화
      _loadKakaoPostcode(div.id);

      return div;
    },
  );
}

void _loadKakaoPostcode(String containerId) {
  // 스크립트가 이미 로드되었는지 확인
  final existingScript =
      web.document.querySelector('script[src*="postcode.v2.js"]');

  if (existingScript == null) {
    // 스크립트 로드
    final script = web.HTMLScriptElement();
    script.src =
        '//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js';

    // addEventListener로 load 이벤트 처리
    script.addEventListener(
        'load',
        ((web.Event event) {
          _initializePostcode(containerId);
        }).toJS);

    web.document.head!.appendChild(script);
  } else {
    // 이미 로드된 경우 바로 초기화
    _initializePostcode(containerId);
  }
}

void _initializePostcode(String containerId) {
  // 기존 kpostal 관련 스크립트들 정리
  final existingScripts =
      web.document.querySelectorAll('script[data-kpostal="init"]');
  for (int i = 0; i < existingScripts.length; i++) {
    final script = existingScripts.item(i);
    if (script != null) {
      script.parentNode?.removeChild(script);
    }
  }

  // 기존 인스턴스 정리
  final cleanupScript = web.HTMLScriptElement();
  cleanupScript.setAttribute('data-kpostal', 'cleanup');
  cleanupScript.text = '''
    (function() {
      const container = document.getElementById('$containerId');
      if (container) {
        container.innerHTML = '';
      }
    })();
  ''';
  web.document.head!.appendChild(cleanupScript);

  // 약간의 지연 후 초기화
  Future.delayed(const Duration(milliseconds: 50), () {
    // 기존 초기화 스크립트 제거
    final oldCleanup =
        web.document.querySelector('script[data-kpostal="cleanup"]');
    if (oldCleanup != null) {
      oldCleanup.parentNode?.removeChild(oldCleanup);
    }

    final initScript = web.HTMLScriptElement();
    initScript.setAttribute('data-kpostal', 'init');
    initScript.text = '''
      (function() {
        let retryCount = 0;
        const maxRetries = 30; // 3초 (100ms * 30)
        
        function tryInit() {
        const container = document.getElementById('$containerId');
        if (container && window.daum && window.daum.Postcode) {
          try {
            new daum.Postcode({
              oncomplete: function(data) {
                const result = {
                    zonecode: data.zonecode,
                  postCode: data.zonecode,
                  address: data.address,
                    addressEnglish: data.addressEnglish || '',
                  roadAddress: data.roadAddress,
                    roadAddressEnglish: data.roadAddressEnglish || '',
                    jibunAddress: data.jibunAddress || '',
                    jibunAddressEnglish: data.jibunAddressEnglish || '',
                    autoJibunAddress: data.autoJibunAddress || '',
                    autoJibunAddressEnglish: data.autoJibunAddressEnglish || '',
                  buildingCode: data.buildingCode,
                  buildingName: data.buildingName,
                  apartment: data.apartment,
                  addressType: data.addressType,
                  sido: data.sido,
                    sidoEnglish: data.sidoEnglish || '',
                  sigungu: data.sigungu,
                    sigunguEnglish: data.sigunguEnglish || '',
                  sigunguCode: data.sigunguCode,
                  roadnameCode: data.roadnameCode,
                  roadname: data.roadname,
                    roadnameEnglish: data.roadnameEnglish || '',
                  bcode: data.bcode,
                  bname: data.bname,
                    bnameEnglish: data.bnameEnglish || '',
                  bname1: data.bname1 || '',
                  query: data.query,
                  userSelectedType: data.userSelectedType,
                  userLanguageType: data.userLanguageType
                };
                
                // Flutter 콜백 호출
                if (window.flutterKpostalCallback) {
                  window.flutterKpostalCallback(JSON.stringify(result));
                }
              },
              width: '100%',
              height: '100%'
            }).embed(container);
          } catch (e) {
              console.error('Kakao Postcode 초기화 실패:', e);
          }
          } else if (container && retryCount < maxRetries) {
            retryCount++;
            setTimeout(tryInit, 100);
          } else if (!container) {
            console.error('Container not found: $containerId');
          } else {
            console.error('Kakao Postcode 스크립트 로딩 실패 (timeout)');
          }
        }
        
        tryInit();
      })();
    ''';
    web.document.head!.appendChild(initScript);
  });
}

// 중복 등록 방지를 위한 플래그
bool _listenerRegistered = false;

void setupWebMessageListener(Function(String) handleMessage) {
  if (_listenerRegistered) return;

  // DOM 이벤트 리스너 등록
  web.document.addEventListener(
      'kpostalResult',
      (web.Event event) {
        final customEvent = event as web.CustomEvent;
        final data = customEvent.detail;
        if (data != null) {
          handleMessage(data.toString());
        }
      }.toJS);

  // 전역 콜백 함수 등록 (중복 방지 강화)
  final existingCallbackScript =
      web.document.querySelector('script[data-kpostal="callback"]');
  if (existingCallbackScript != null) {
    existingCallbackScript.parentNode?.removeChild(existingCallbackScript);
  }

  final script = web.HTMLScriptElement();
  script.setAttribute('data-kpostal', 'callback');
  script.text = '''
    if (!window.flutterKpostalCallback) {
      window.flutterKpostalCallback = function(data) {
        const event = new CustomEvent('kpostalResult', { detail: data });
        document.dispatchEvent(event);
      };
    }
  ''';
  web.document.head!.appendChild(script);

  _listenerRegistered = true;
}

Widget buildWebPostcodeView() {
  return const SizedBox(
    width: double.infinity,
    height: double.infinity,
    child: HtmlElementView(
      viewType: 'kakao-postcode-web',
    ),
  );
}

void cleanupWebResources() {
  // kpostal 관련 스크립트들 정리
  final kpostalScripts = web.document.querySelectorAll('script[data-kpostal]');
  for (int i = 0; i < kpostalScripts.length; i++) {
    final script = kpostalScripts.item(i);
    if (script != null) {
      script.parentNode?.removeChild(script);
    }
  }

  // 전역 변수 정리 (최소한의 스크립트 사용)
  // 기존 cleanup 스크립트가 있다면 제거
  final existingCleanup =
      web.document.querySelector('script[data-kpostal-cleanup]');
  if (existingCleanup != null) {
    existingCleanup.parentNode?.removeChild(existingCleanup);
  }

  // 새로운 cleanup 스크립트 생성 및 즉시 실행
  final cleanupScript = web.HTMLScriptElement();
  cleanupScript.setAttribute('data-kpostal-cleanup', 'true');
  cleanupScript.text =
      'if (window.flutterKpostalCallback) { delete window.flutterKpostalCallback; }';
  web.document.head!.appendChild(cleanupScript);

  // 즉시 제거 (실행은 이미 완료됨)
  cleanupScript.parentNode?.removeChild(cleanupScript);

  // 리스너 등록 플래그 초기화
  _listenerRegistered = false;
}
