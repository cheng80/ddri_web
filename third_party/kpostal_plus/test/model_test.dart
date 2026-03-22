import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:kpostal_plus/kpostal_plus.dart';

void main() {
  group('Kpostal Model Tests', () {
    test('JSON 파싱 - 도로명 주소', () {
      const jsonText =
          '{"postcode":"","postcode1":"","postcode2":"","postcodeSeq":"","zonecode":"08758","address":"서울 관악구 남부순환로 1801","addressEnglish":"1801, Nambusunhwan-ro, Gwanak-gu, Seoul, Korea","addressType":"R","bcode":"1162010100","bname":"봉천동","bnameEnglish":"Bongcheon-dong","bname1":"","bname1English":"","bname2":"봉천동","bname2English":"Bongcheon-dong","sido":"서울","sidoEnglish":"Seoul","sigungu":"관악구","sigunguEnglish":"Gwanak-gu","sigunguCode":"11620","userLanguageType":"K","query":"남부순환로 1801","buildingName":"","buildingCode":"1162010100108740004026943","apartment":"N","jibunAddress":"서울 관악구 봉천동 874-4","jibunAddressEnglish":"874-4, Bongcheon-dong, Gwanak-gu, Seoul, Korea","roadAddress":"서울 관악구 남부순환로 1801","roadAddressEnglish":"1801, Nambusunhwan-ro, Gwanak-gu, Seoul, Korea","autoRoadAddress":"","autoRoadAddressEnglish":"","autoJibunAddress":"","autoJibunAddressEnglish":"","userSelectedType":"R","noSelected":"N","hname":"","roadnameCode":"2000003","roadname":"남부순환로","roadnameEnglish":"Nambusunhwan-ro"}';
      final model = Kpostal.fromJson(jsonDecode(jsonText));

      // 기본 정보
      expect(model.postCode, '08758');
      expect(model.address, '서울 관악구 남부순환로 1801');
      expect(model.addressEng, '1801, Nambusunhwan-ro, Gwanak-gu, Seoul, Korea');

      // 도로명 주소
      expect(model.roadAddress, '서울 관악구 남부순환로 1801');
      expect(model.roadAddressEng, '1801, Nambusunhwan-ro, Gwanak-gu, Seoul, Korea');
      expect(model.roadname, '남부순환로');
      expect(model.roadnameEng, 'Nambusunhwan-ro');

      // 지번 주소
      expect(model.jibunAddress, '서울 관악구 봉천동 874-4');
      expect(model.jibunAddressEng, '874-4, Bongcheon-dong, Gwanak-gu, Seoul, Korea');

      // 지역 정보
      expect(model.sido, '서울');
      expect(model.sidoEng, 'Seoul');
      expect(model.sigungu, '관악구');
      expect(model.sigunguEng, 'Gwanak-gu');
      expect(model.bname, '봉천동');
      expect(model.bnameEng, 'Bongcheon-dong');

      // 주소 유형
      expect(model.addressType, 'R');
      expect(model.userSelectedType, 'R');
      expect(model.apartment, 'N');
    });

    test('JSON 파싱 - 지번 주소', () {
      const jsonText =
          '{"postcode":"","postcode1":"","postcode2":"","postcodeSeq":"","zonecode":"06349","address":"서울 강남구 테헤란로 212","addressEnglish":"212, Teheran-ro, Gangnam-gu, Seoul, Korea","addressType":"R","bcode":"1168010300","bname":"역삼동","bnameEnglish":"Yeoksam-dong","bname1":"","bname1English":"","bname2":"역삼동","bname2English":"Yeoksam-dong","sido":"서울","sidoEnglish":"Seoul","sigungu":"강남구","sigunguEnglish":"Gangnam-gu","sigunguCode":"11680","userLanguageType":"K","query":"역삼동","buildingName":"멀티캠퍼스","buildingCode":"1168010300103060001024211","apartment":"N","jibunAddress":"서울 강남구 역삼동 681-9","jibunAddressEnglish":"681-9, Yeoksam-dong, Gangnam-gu, Seoul, Korea","roadAddress":"서울 강남구 테헤란로 212","roadAddressEnglish":"212, Teheran-ro, Gangnam-gu, Seoul, Korea","autoRoadAddress":"","autoRoadAddressEnglish":"","autoJibunAddress":"","autoJibunAddressEnglish":"","userSelectedType":"J","noSelected":"N","hname":"","roadnameCode":"4113225","roadname":"테헤란로","roadnameEnglish":"Teheran-ro"}';
      final model = Kpostal.fromJson(jsonDecode(jsonText));

      expect(model.postCode, '06349');
      expect(model.jibunAddress, '서울 강남구 역삼동 681-9');
      expect(model.buildingName, '멀티캠퍼스');
      expect(model.userSelectedType, 'J');
      expect(model.sido, '서울');
      expect(model.sigungu, '강남구');
    });

    test('JSON 파싱 - 아파트', () {
      const jsonText =
          '{"postcode":"","postcode1":"","postcode2":"","postcodeSeq":"","zonecode":"06241","address":"서울 강남구 학동로 426","addressEnglish":"426, Hakdong-ro, Gangnam-gu, Seoul, Korea","addressType":"R","bcode":"1168010600","bname":"청담동","bnameEnglish":"Cheongdam-dong","bname1":"","bname1English":"","bname2":"청담동","bname2English":"Cheongdam-dong","sido":"서울","sidoEnglish":"Seoul","sigungu":"강남구","sigunguEnglish":"Gangnam-gu","sigunguCode":"11680","userLanguageType":"K","query":"청담동 삼성","buildingName":"청담 삼성아파트","buildingCode":"1168010600100470026004301","apartment":"Y","jibunAddress":"서울 강남구 청담동 47-26","jibunAddressEnglish":"47-26, Cheongdam-dong, Gangnam-gu, Seoul, Korea","roadAddress":"서울 강남구 학동로 426","roadAddressEnglish":"426, Hakdong-ro, Gangnam-gu, Seoul, Korea","autoRoadAddress":"","autoRoadAddressEnglish":"","autoJibunAddress":"서울 강남구 청담동 47","autoJibunAddressEnglish":"47, Cheongdam-dong, Gangnam-gu, Seoul, Korea","userSelectedType":"R","noSelected":"N","hname":"","roadnameCode":"4158012","roadname":"학동로","roadnameEnglish":"Hakdong-ro"}';
      final model = Kpostal.fromJson(jsonDecode(jsonText));

      expect(model.apartment, 'Y');
      expect(model.buildingName, '청담 삼성아파트');
      expect(model.jibunAddress, '서울 강남구 청담동 47-26');
      expect(model.jibunAddressEng, '47-26, Cheongdam-dong, Gangnam-gu, Seoul, Korea');
    });

    test('JSON 파싱 - autoJibunAddress fallback', () {
      // jibunAddress가 비어있을 때 autoJibunAddress를 사용하는지 테스트
      final model = Kpostal.fromJson({
        'zonecode': '06241',
        'jibunAddress': '',
        'jibunAddressEnglish': '',
        'autoJibunAddress': '서울 강남구 청담동 47',
        'autoJibunAddressEnglish': '47, Cheongdam-dong, Gangnam-gu, Seoul, Korea',
      });

      expect(model.jibunAddress, '서울 강남구 청담동 47');
      expect(model.jibunAddressEng, '47, Cheongdam-dong, Gangnam-gu, Seoul, Korea');
    });

    test('userSelectedAddress - 도로명 주소 선택', () {
      final model = Kpostal.fromJson({
        'zonecode': '08758',
        'roadAddress': '서울 관악구 남부순환로 1801',
        'jibunAddress': '서울 관악구 봉천동 874-4',
        'userSelectedType': 'R',
      });

      expect(model.userSelectedAddress, '서울 관악구 남부순환로 1801');
    });

    test('userSelectedAddress - 지번 주소 선택', () {
      final model = Kpostal.fromJson({
        'zonecode': '08758',
        'roadAddress': '서울 관악구 남부순환로 1801',
        'jibunAddress': '서울 관악구 봉천동 874-4',
        'userSelectedType': 'J',
      });

      expect(model.userSelectedAddress, '서울 관악구 봉천동 874-4');
    });

    test('userSelectedAddress - 선택 없음 (기본값: 도로명)', () {
      final model = Kpostal.fromJson({
        'zonecode': '08758',
        'roadAddress': '서울 관악구 남부순환로 1801',
        'jibunAddress': '서울 관악구 봉천동 874-4',
        'userSelectedType': '',
      });

      expect(model.userSelectedAddress, '서울 관악구 남부순환로 1801');
    });

    test('JSON 파싱 - null 값 처리', () {
      final model = Kpostal.fromJson({
        'zonecode': '12345',
        'roadAddress': null,
        'jibunAddress': null,
        'buildingName': null,
      });

      expect(model.postCode, '12345');
      expect(model.roadAddress, '');
      expect(model.jibunAddress, '');
      expect(model.buildingName, '');
    });

    test('JSON 파싱 - 빈 JSON', () {
      final model = Kpostal.fromJson({});

      expect(model.postCode, '');
      expect(model.address, '');
      expect(model.sido, '');
      expect(model.sigungu, '');
    });

    test('초기 좌표값은 null', () {
      final model = Kpostal.fromJson({
        'zonecode': '08758',
        'roadAddress': '서울 관악구 남부순환로 1801',
      });

      expect(model.latitude, null);
      expect(model.longitude, null);
      expect(model.kakaoLatitude, null);
      expect(model.kakaoLongitude, null);
    });

    test('플랫폼 좌표값 설정', () {
      final model = Kpostal.fromJson({
        'zonecode': '08758',
        'roadAddress': '서울 관악구 남부순환로 1801',
      });

      model.latitude = 37.4601;
      model.longitude = 126.9527;

      expect(model.latitude, 37.4601);
      expect(model.longitude, 126.9527);
    });

    test('카카오 좌표값 파싱', () {
      final model = Kpostal.fromJson({
        'zonecode': '08758',
        'roadAddress': '서울 관악구 남부순환로 1801',
        'kakaoLat': '37.4602',
        'kakaoLng': '126.9528',
      });

      expect(model.kakaoLatitude, 37.4602);
      expect(model.kakaoLongitude, 126.9528);
    });
  });

  group('Constant Tests', () {
    test('KpostalConst 값 확인', () {
      expect(KpostalConst.postCode, 'zonecode');
      expect(KpostalConst.address, 'address');
      expect(KpostalConst.roadAddress, 'roadAddress');
      expect(KpostalConst.jibunAddress, 'jibunAddress');
    });
  });
}
