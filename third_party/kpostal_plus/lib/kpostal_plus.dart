library;

export 'src/kpostal_model.dart';
export 'src/constant.dart';

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:geocoding/geocoding.dart';
import 'src/kpostal_model.dart';

// 조건부 import - 플랫폼별 구현
import 'src/web_platform_stub.dart'
    if (dart.library.html) 'src/web_platform_web.dart' as web_platform;

class KpostalPlusView extends StatefulWidget {
  static const String routeName = '/kpostal_plus';

  /// AppBar's title
  ///
  /// 앱바 타이틀
  final String title;

  /// AppBar's background color
  ///
  /// 앱바 배경색
  final Color appBarColor;

  /// AppBar's contents color
  ///
  /// 앱바 아이콘, 글자 색상
  final Color titleColor;

  /// this callback function is called when user selects addresss.
  ///
  /// 유저가 주소를 선택했을 때 호출됩니다.
  final void Function(Kpostal result)? callback;

  /// build custom AppBar.
  ///
  /// 커스텀 앱바를 추가할 수 있습니다. 추가할 경우 다른 관련 속성은 무시됩니다.
  final PreferredSizeWidget? appBar;

  /// if [userLocalServer] is true, the search page is running on localhost. Default is false.
  ///
  /// [userLocalServer] 값이 ture면, 검색 페이지를 로컬 서버에서 동작시킵니다.
  /// 기본적으로 연결된 웹페이지에 문제가 생기더라도 작동 가능합니다.
  final bool useLocalServer;

  /// Localhost port number. Default is 8080.
  ///
  /// 로컬 서버 포트. 기본값은 8080
  final int localPort;

  /// 웹뷰 로딩 시 인디케이터 색상
  final Color loadingColor;

  /// 웹뷰 로딩 시 표시할 커스텀 위젯
  ///
  /// 해당 옵션 사용 시, 기존 인디케이터를 대체하며, [loadingColor] 옵션은 무시됩니다.
  final Widget? onLoading;

  /// 카카오 API를 통한 경위도 좌표 지오코딩 사용 여부
  final bool useKakaoGeocoder;

  /// [kakaoKey] 설정 시, [kakaoLatitude], [kakaoLongitude] 값을 받을 수 있습니다.
  ///
  /// `developers.kakao.com` 에서 발급받은 유효한 자바스크립트 키를 사용하세요.
  ///
  /// 플랫폼 설정에서 허용 도메인도 추가해야 합니다.
  /// ex) `http://localhost:8080`, `https://tykann.github.io`
  final String kakaoKey;

  KpostalPlusView({
    super.key,
    this.title = '주소검색',
    this.appBarColor = Colors.white,
    this.titleColor = Colors.black,
    this.appBar,
    this.callback,
    this.useLocalServer = false,
    this.localPort = 8080,
    this.loadingColor = Colors.blue,
    this.onLoading,
    this.kakaoKey = '',
  })  : assert(1024 <= localPort && localPort <= 49151,
            'localPort is out of range. It should be from 1024 to 49151(Range of Registered Port)'),
        useKakaoGeocoder = kakaoKey.isNotEmpty;

  @override
  State<KpostalPlusView> createState() => _KpostalPlusViewState();
}

class _KpostalPlusViewState extends State<KpostalPlusView> {
  InAppLocalhostServer? _localhost;

  late final Uri targetUri;

  bool initLoadComplete = false;
  bool isLocalhostOn = false;

  // 웹 전용 변수들
  bool _webViewReady = false;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      // 웹용 초기화
      _setupWebView();
    } else {
      // 모바일용 초기화
      if (widget.useLocalServer) {
        _localhost = InAppLocalhostServer(port: widget.localPort);
        _localhost!.start().then((_) {
          setState(() {
            isLocalhostOn = true;
          });
        });
      }
    }

    final Map<String, String> queryParams = {
      'enableKakao': '${widget.useKakaoGeocoder}'
    };
    if (widget.useKakaoGeocoder) {
      queryParams.addAll({'key': widget.kakaoKey});
    }

    targetUri = widget.useLocalServer
        ? Uri.http(
            'localhost:${widget.localPort}',
            '/packages/kpostal_plus/assets/kakao_postcode_localhost.html',
            queryParams)
        : Uri.https('tykann.github.io', '/kpostal/assets/kakao_postcode.html',
            queryParams);
  }

  void _setupWebView() {
    if (kIsWeb) {
      web_platform.registerWebPostcode();
      web_platform.setupWebMessageListener(handleMessage);
      setState(() {
        _webViewReady = true;
      });
    }
  }

  @override
  void dispose() {
    if (kIsWeb) {
      // 웹용 정리 작업
      _cleanupWebResources();
    } else if (widget.useLocalServer && _localhost != null) {
      _localhost!.close();
    }
    super.dispose();
  }

  void _cleanupWebResources() {
    // kpostal 관련 스크립트들 정리 (웹 플랫폼에서만 실행)
    if (kIsWeb) {
      web_platform.cleanupWebResources();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar ??
          AppBar(
            backgroundColor: widget.appBarColor,
            title: Text(
              widget.title,
              style: TextStyle(
                color: widget.titleColor,
              ),
            ),
            iconTheme:
                Theme.of(context).iconTheme.copyWith(color: widget.titleColor),
          ),
      body: kIsWeb ? _buildWebView() : _buildMobileView(),
    );
  }

  Widget _buildWebView() {
    if (!_webViewReady) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // 웹에서 직접 HTML로 카카오 우편번호 서비스 구현
    return _buildWebPostcodeView();
  }

  Widget _buildWebPostcodeView() {
    return web_platform.buildWebPostcodeView();
  }

  Widget _buildMobileView() {
    return Stack(
      children: [
        Builder(
          builder: (BuildContext context) {
            if (widget.useLocalServer && !isLocalhostOn) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return InAppWebView(
              initialSettings: InAppWebViewSettings(
                useHybridComposition: true,
                javaScriptEnabled: true,
                // 추가 권장 설정들
                domStorageEnabled: true,
                databaseEnabled: true,
                allowsInlineMediaPlayback: true,
                mediaPlaybackRequiresUserGesture: false,
                // 웹 보안 설정
                allowsBackForwardNavigationGestures: false,
                clearCache: false,
              ),
              onWebViewCreated: (controller) async {
                // 안드로이드는 롤리팝 버전 이상 빌드에서만 작동 유의
                // WEB_MESSAGE_LISTENER 지원 여부 확인
                if (!Platform.isAndroid ||
                    await WebViewFeature.isFeatureSupported(
                        WebViewFeature.WEB_MESSAGE_LISTENER)) {
                  await controller.addWebMessageListener(
                    WebMessageListener(
                      jsObjectName: "onComplete",
                      allowedOriginRules: {"*"},
                      onPostMessage:
                          (message, sourceOrigin, isMainFrame, replyProxy) =>
                              handleMessage(message?.data.toString()),
                    ),
                  );
                } else {
                  controller.addJavaScriptHandler(
                    handlerName: 'onComplete',
                    callback: (args) => handleMessage(args[0]),
                  );
                }

                await controller.loadUrl(
                  urlRequest: URLRequest(
                    url: WebUri.uri(targetUri),
                  ),
                );
              },
              onLoadStop: (_, __) {
                setState(() {
                  initLoadComplete = true;
                });
              },
            );
          },
        ),
        initLoadComplete
            ? const SizedBox.shrink()
            : Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.white,
                child: Center(
                  child: widget.onLoading ??
                      CircularProgressIndicator(color: widget.loadingColor),
                ),
              ),
      ],
    );
  }

  void handleMessage(String? message) async {
    // 위젯이 unmount된 경우 처리 중단
    if (!mounted) {
      return;
    }

    final navigator = Navigator.of(context);
    try {
      if (message == null) {
        if (mounted) navigator.pop();
        return;
      }

      // JSON 파싱 시도
      final Map<String, dynamic> jsonData;
      try {
        jsonData = jsonDecode(message);
      } catch (e) {
        if (mounted) navigator.pop();
        return;
      }

      final Kpostal result = Kpostal.fromJson(jsonData);

      // 웹에서는 내부 geocoding 예외가 디버거를 멈추게 할 수 있어
      // 주소 결과만 우선 반환하고, 좌표 보강은 앱 레이어에서 처리한다.
      final bool shouldResolveLatLng =
          !kIsWeb &&
          result.kakaoLatitude == null &&
          result.kakaoLongitude == null;

      // 경위도 조회 시도 (실패해도 주소 결과는 반환)
      try {
        if (shouldResolveLatLng) {
          final Location? latLng = await result.latLng;
          if (latLng != null) {
            result.latitude = latLng.latitude;
            result.longitude = latLng.longitude;
          }
        }
      } catch (e) {
        // 경위도 실패해도 주소 결과는 반환
      }

      widget.callback?.call(result);
      if (mounted) navigator.pop(result);
    } catch (e) {
      if (mounted) navigator.pop();
    }
  }
}
