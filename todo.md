# DDRI Next Chat TODO

목적: 다음 대화에서 현재 상태를 빠르게 이어받고, 가장 먼저 해야 할 작업부터 바로 진행하기 위한 인수인계 문서.

## 다음 대화 시작 시 먼저 할 일

1. `plan.md` 읽기
2. `todo.md` 읽기
3. `plan.md`의 최신 우선순위 1~3을 그대로 이어받기
4. 사용자 웹 위치 자동 호출 상태와 관리자/사용자 화면의 남은 UI 안정화 확인

## 현재 기준 커밋

- 최근 커밋: `621f066`
- 커밋 메시지: `Stabilize web flows and add prediction log persistence`

## 현재 상태 한 줄 요약

- top6 임시 런타임 E2E, `prediction_logs` 저장 연결, 지도/드롭다운 주요 UI 안정화는 끝났고, 최근에는 웹 위치 호출·베타 팝업 충돌·`/ddri/` 배포와 mixed content 원인을 정리했다.

## 지금 확정된 사실

### 사용자 페이지 `/user`

- 반응형 레이아웃은 정리된 상태다.
- 낮은 높이에서 overflow 나던 문제는 페이지 전체 스크롤 구조로 정리했다.
- 주간 날씨 카드 overflow도 정리했다.
- 선택 시각 날씨 카드 스타일은 관리자 카드 톤에 맞췄다.
- 날씨 컨테이너는 접고 펼칠 수 있다.
- 조회 필터는 `전체보기 / 300m / 500m / 1km` 4개가 라디오처럼 동작한다.
- `전체보기`는 반경 미적용, `300m / 500m / 1km`는 실제 반경 필터가 적용된다.
- 지도는 `flutter_map` 기반이며, 휠 줌은 꺼져 있고 `+ / - / 초기화` 버튼이 있다.
- 지도/리스트 기본 포커스 연동은 동작한다.
- 데스크탑/모바일 브라우저 렌더와 API 값 대조는 확인했다.
- 검색 조건 변경 시 다음 결과 기준 포커스 재선정 로직을 반영했다.
- 날씨는 초기 공간을 먼저 확보하고 그 자리에서 로딩 상태를 표시하도록 바꿨다.
- 검색 상단 버튼은 웹 렌더 assert를 피하기 위해 `.icon` 생성자 대신 일반 버튼 + `Row`로 변경했다.
- 웹 위치 요청은 현재 다시 자동 호출 상태로 복원돼 있다.
- 베타 안내 팝업은 위치 로딩이 끝난 뒤에만 뜨도록 지연된다.
- 주소 검색은 `kpostal_plus`를 로컬 오버라이드해서 웹 내부 geocoding 예외 정지를 우회했다.
- 다만 실제 수동 조작 기준으로 중심 이동 체감이 자연스러운지는 한 번 더 확인 필요하다.
- macOS/브라우저 위치 공급이 `kCLErrorLocationUnknown`으로 실패한 적이 있어, 재발 여부 최종 확인이 필요하다.

### 관리자 페이지 `/admin`

- 관리자 API 호출은 정상이다.
- 실제 실시간 재고 + `joblib` 예측값이 관리자 응답에 반영된다.
- 관리자 날씨는 실제 API 기반 구조로 연결돼 있다.
- 행정동 필터는 현재 top6 기준 5개 동만 노출한다.
- `긴급만` 기준은 이제 `예상 잔여 5대 이하`다.
- 위험도 숫자 중심 표기는 줄이고, `예상 잔여`, `부족 예상` 중심으로 바꿨다.
- 지도는 휠 줌이 꺼져 있고 `+ / - / 초기화` 버튼이 있다.
- 실제 마커 지도와 리스트 선택 연동은 붙어 있지만, 브레이크포인트별 표시 안정성은 추가 검증이 필요하다.
- 데스크탑/태블릿/모바일 브라우저 렌더와 API 값 대조는 확인했다.
- `isSupplementReady`, `isMapReady` 지연 렌더는 제거했다.
- 정렬/행정동/순서 드롭다운은 상태 변경 시 버튼 라벨도 즉시 갱신되도록 수정했다.

### 백엔드 / 런타임

- 서울시 `bikeList` 실시간 재고 연동 완료
- top6 대상 `joblib` 번들 6개 생성 및 로드 완료
- `beta`와 `live` 모두 더미 응답은 제거됐고, 현재는 같은 top6 임시 런타임을 사용
- 디버그 로그는 Flutter/FastAPI 모두 토글 가능
- `prediction_logs` MySQL 스키마 생성 및 `/user`, `/admin` 저장 연결 완료
- 현재는 호출당 스테이션별 예측 로그가 누적 저장되며, 중복 저장 방지 정책은 아직 미정
- `/ddri/` 서브폴더 기준 웹 release build는 생성 완료
- 배포 mixed content 원인은 확인됨: `https://.../ddri/`에서 `http://...:18000` API 직접 호출은 브라우저가 차단

## 지금 가장 중요한 미해결 이슈

### 1. 사용자 웹 위치 재발 여부 확인

- 자동 호출과 수동 호출이 현재 브라우저/OS에서 모두 안정적으로 동작하는지 다시 확인 필요
- 문제 재발 시 앱 코드보다 macOS 위치 공급 상태를 먼저 확인해야 함

### 2. 관리자 지도/레이아웃 최종 안정화

- 태블릿 폭과 데스크탑에서 지도, 리스트, 보조 패널 배치가 기대대로 유지되는지 최종 확인 필요
- Selenium 기준 다중 뷰포트 렌더는 정상이다.

### 3. 사용자 지도 검색 결과 동기화

- 리스트 클릭 포커스는 동작
- 검색 조건 변경 시 다음 결과 기준 포커스 재선정은 반영했다.
- 다만 실제 수동 조작 기준으로 중심 이동 체감이 자연스러운지 확인 필요

### 4. 저장 정책 정리

- `prediction_logs` 저장은 동작함
- 다만 같은 조건 재호출 시 중복 누적을 막을지, 그대로 이력으로 둘지 정책 확정 필요

### 5. 오류·빈 상태·폴백 상태 보안 노출 점검

- 400 오류 응답은 안전 문구로 정리돼 있음
- `/user` 빈 결과도 안전한 안내 문구로 표시됨
- 주소 검색 실패 문구에서 내부 구현 힌트는 제거함
- 날씨 로딩 시 예약 공간 확보로 화면 밀림을 완화함
- 관리자 날씨/예외 폴백 상태 안내는 한 번 더 최종 점검 필요

## 다음 대화에서 우선 볼 파일

### 최우선

- `lib/view/admin_view.dart`
- `lib/view/admin/admin_map_placeholder.dart`
- `lib/view/admin/admin_station_list.dart`
- `lib/view/user_view.dart`
- `lib/view/user/user_map_section.dart`
- `lib/vm/admin_page_controller.dart`
- `lib/vm/user_page_controller.dart`

### 그다음

- `lib/view/admin/admin_weather_section.dart`
- `lib/view/admin/admin_exceptions_section.dart`
- `lib/view/user/user_weather_section.dart`
- `lib/common/api/ddri_api_client.dart`
- `lib/common/api/models/station_models.dart`

### 백엔드 확인 필요 시

- `fastapi/app/api/ddri_admin.py`
- `fastapi/app/api/beta_station_data.py`
- `fastapi/app/api/ddri_user.py`
- `fastapi/app/api/weather.py`
- `fastapi/app/utils/security.py`

## 다음 대화에서 바로 진행할 우선 작업

1. `/user`, `/admin`를 실제로 열고 최종 체감 기준으로 레이아웃과 지도 동작 확인
2. `/user` 자동 위치 호출과 수동 `현 위치` 호출 재발 여부 확인
3. 사용자 검색 조건 변경 시 지도 중심 이동 체감 최종 확인
4. 관리자 지도/브레이크포인트 표시 안정성 최종 확인
5. 관리자 날씨/예외 폴백 상태 안내 방식 점검
6. `prediction_logs` 중복 저장 방지 정책 결정

## 이미 끝난 작업이라 다시 하지 말 것

- `docs/api/README.md`, `docs/api/API_SPEC.md`, `docs/api/openapi.yaml`, `fastapi/API_GUIDE.md` 재정리
- 관리자 예외 UI의 `station_id` 직접 노출 제거
- Flutter `ApiException` raw body 노출 제거
- 사용자 날씨 카드 overflow 수정
- 사용자 페이지 낮은 높이 overflow 수정
- 관리자 목록 GetX improper use 예외 수정
- top6 실시간 재고 + `joblib` 예측 런타임 연결
- top6 임시 런타임 기준 `/user`, `/admin` 화면 E2E 스모크 검증
- `prediction_logs` MySQL 스키마 생성 및 `/user`, `/admin` 저장 연결
- 사용자 검색 조건 변경 시 다음 결과 기준 포커스 재선정
- 관리자 보조 패널/스택 레이아웃 지연 렌더 제거
- 날씨 로딩 공간 사전 확보 및 플레이스홀더 반영
- 관리자 드롭다운 선택 상태 UI 즉시 갱신 수정
- Selenium 다중 뷰포트 지도 안정화 테스트
- 사용자/관리자 지도 `+ / - / 초기화` 버튼 추가
- 사용자/관리자 지도 휠 줌 비활성화
- 사용자 반경 필터를 `전체보기 / 300m / 500m / 1km` 라디오형으로 정리
- 관리자 행정동 필터 5개 동 기준 정리
- 관리자 대수 표기 올림 정수 처리
- `/ddri/` 서브폴더 릴리즈 빌드 생성
- `kpostal_plus` 웹 내부 geocoding 예외 정지를 로컬 오버라이드로 우회

## 주의할 점

- 관리자 페이지 문제를 분리하려고 레이아웃 순서를 임시로 바꿨다가 회귀가 생긴 적이 있다.
- 다음 수정에서는 데스크탑과 태블릿/모바일 레이아웃을 분리해서 생각해야 한다.
- 지도 문제를 잡을 때 목록/날씨/요약까지 같이 흔들지 않는 것이 중요하다.
- 현재 워크트리는 더러울 수 있으므로 기존 수정사항을 되돌리지 말 것
- DB 저장은 연결됐지만, 중복 저장 정책은 아직 확정되지 않았다
- 배포 환경 API는 아직 HTTPS same-origin 경로가 없어서, `/ddri/` HTTPS 웹과 `:18000` HTTP API는 함께 못 쓴다

## 다음 대화 권장 시작 프롬프트

```text
plan.md와 todo.md를 먼저 읽고 현재 상태를 요약한 뒤, 사용자 웹 위치 자동 호출 재발 여부와 관리자 최종 레이아웃 점검부터 진행해줘.
```
