import 'package:geocoding/geocoding.dart';
import 'constant.dart';
import 'log.dart';

class Kpostal {
  /// 국가기초구역번호. 2015년 8월 1일부터 시행된 새 우편번호.
  final String postCode;

  /// 기본 주소
  final String address;

  /// 기본 영문 주소
  final String addressEng;

  /// 도로명 주소
  final String roadAddress;

  /// 영문 도로명 주소
  final String roadAddressEng;

  /// 지번 주소
  final String jibunAddress;

  /// 영문 지번 주소
  final String jibunAddressEng;

  /// 건물관리번호
  final String buildingCode;

  /// 건물명
  final String buildingName;

  /// 공동주택 여부(Y/N)
  final String apartment;

  /// 검색된 기본 주소 타입: R(도로명), J(지번)
  final String addressType;

  /// 도/시 이름
  final String sido;

  /// 영문 도/시 이름
  final String sidoEng;

  /// 시/군/구 이름
  final String sigungu;

  /// 영문 시/군/구 이름
  final String sigunguEng;

  /// 시/군/구 코드
  final String sigunguCode;

  /// 도로명 코드, 7자리로 구성된 도로명 코드입니다. 추후 7자리 이상으로 늘어날 수 있습니다.
  final String roadnameCode;

  /// 법정동/법정리 코드
  final String bcode;

  /// 도로명 값, 검색 결과 중 선택한 도로명주소의 "도로명" 값이 들어갑니다.(건물번호 제외)
  final String roadname;

  /// 도로명 값, 검색 결과 중 선택한 도로명주소의 "도로명의 영문" 값이 들어갑니다.(건물번호 제외)
  final String roadnameEng;

  /// 법정동/법정리 이름
  final String bname;

  /// 영문 법정동/법정리 이름
  final String bnameEng;

  /// 법정리의 읍/면 이름
  final String bname1;

  /// 사용자가 입력한 검색어
  final String query;

  /// 검색 결과에서 사용자가 선택한 주소의 타입
  final String userSelectedType;

  /// 검색 결과에서 사용자가 선택한 주소의 언어 타입: K(한글주소), E(영문주소)
  final String userLanguageType;

  /// 위도(플랫폼 geocoding)
  late double? latitude;

  /// 경도(플랫폼 geocoding)
  late double? longitude;

  /// 위도(카카오 geocoding)
  final double? kakaoLatitude;

  /// 경도(카카오 geocoding)
  final double? kakaoLongitude;

  Kpostal({
    required this.postCode,
    required this.address,
    required this.addressEng,
    required this.roadAddress,
    required this.roadAddressEng,
    required this.jibunAddress,
    required this.jibunAddressEng,
    required this.buildingCode,
    required this.buildingName,
    required this.apartment,
    required this.addressType,
    required this.sido,
    required this.sidoEng,
    required this.sigungu,
    required this.sigunguEng,
    required this.sigunguCode,
    required this.roadnameCode,
    required this.roadname,
    required this.roadnameEng,
    required this.bcode,
    required this.bname,
    required this.bnameEng,
    required this.query,
    required this.userSelectedType,
    required this.userLanguageType,
    required this.bname1,
    this.latitude,
    this.longitude,
    this.kakaoLatitude,
    this.kakaoLongitude,
  });

  factory Kpostal.fromJson(Map json) => Kpostal(
        postCode: json[KpostalConst.postCode]?.toString() ?? '',
        address: json[KpostalConst.address]?.toString() ?? '',
        addressEng: json[KpostalConst.addressEng]?.toString() ?? '',
        roadAddress: json[KpostalConst.roadAddress]?.toString() ?? '',
        roadAddressEng: json[KpostalConst.roadAddressEng]?.toString() ?? '',
        jibunAddress:
            (json[KpostalConst.jibunAddress]?.toString() ?? '').isNotEmpty
                ? json[KpostalConst.jibunAddress]?.toString() ?? ''
                : json[KpostalConst.autoJibunAddress]?.toString() ?? '',
        jibunAddressEng:
            (json[KpostalConst.jibunAddressEng]?.toString() ?? '').isNotEmpty
                ? json[KpostalConst.jibunAddressEng]?.toString() ?? ''
                : json[KpostalConst.autoJibunAddressEng]?.toString() ?? '',
        buildingCode: json[KpostalConst.buildingCode]?.toString() ?? '',
        buildingName: json[KpostalConst.buildingName]?.toString() ?? '',
        apartment: json[KpostalConst.apartment]?.toString() ?? '',
        addressType: json[KpostalConst.addressType]?.toString() ?? '',
        sido: json[KpostalConst.sido]?.toString() ?? '',
        sidoEng: json[KpostalConst.sidoEng]?.toString() ?? '',
        sigungu: json[KpostalConst.sigungu]?.toString() ?? '',
        sigunguEng: json[KpostalConst.sigunguEng]?.toString() ?? '',
        sigunguCode: json[KpostalConst.sigunguCode]?.toString() ?? '',
        roadnameCode: json[KpostalConst.roadnameCode]?.toString() ?? '',
        roadname: json[KpostalConst.roadname]?.toString() ?? '',
        roadnameEng: json[KpostalConst.roadnameEng]?.toString() ?? '',
        bcode: json[KpostalConst.bcode]?.toString() ?? '',
        bname: json[KpostalConst.bname]?.toString() ?? '',
        bname1: json[KpostalConst.bname1]?.toString() ?? '',
        bnameEng: json[KpostalConst.bnameEng]?.toString() ?? '',
        query: json[KpostalConst.query]?.toString() ?? '',
        userSelectedType: json[KpostalConst.userSelectedType]?.toString() ?? '',
        userLanguageType: json[KpostalConst.userLanguageType]?.toString() ?? '',
        kakaoLatitude: double.tryParse(json[KpostalConst.kakaoLatitude] ?? ''),
        kakaoLongitude:
            double.tryParse(json[KpostalConst.kakaoLongitude] ?? ''),
      );

  @override
  String toString() {
    return "우편번호: $postCode, 주소: $address, 경위도: N$latitude° E$longitude°";
  }

  /// 유저가 화면에서 선택한 주소를 그대로 return합니다.
  String get userSelectedAddress {
    if (userSelectedType == 'J') {
      if (userLanguageType == 'E') return jibunAddressEng;
      return jibunAddress;
    }
    if (userLanguageType == 'E') return roadAddressEng;
    return roadAddress;
  }

  Future<List<Location>> searchLocation(String address) async {
    try {
      setLocaleIdentifier(KpostalConst.localeKo);
      final List<Location> result = await locationFromAddress(address);
      log('LatLng Found from "$address"');
      return result;
    }
    // 경위도 조회 결과가 없는 경우
    on NoResultFoundException {
      log('LatLng NotFound from "$address"');
      return <Location>[];
    } catch (e) {
      log('Unexpected Exception Occurs from "$address" : $e');
      return <Location>[];
    }
  }

  Future<Location?> get latLng async {
    try {
      final List<Location> fromEngAddress = await searchLocation(addressEng);
      if (fromEngAddress.isNotEmpty) {
        return fromEngAddress.last;
      }
      final List<Location> fromAddress = await searchLocation(address);
      return fromAddress.last;
    } on StateError {
      log('Location is not found from geocoding');
      return null;
    }
  }
}
