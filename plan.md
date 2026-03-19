# DDRI 웹서비스 실행 계획

작성일: 2026-03-17  
목적: 강남구 따릉이 대여소 조회·재배치 지원 웹서비스를 단계별로 완료해 나가기 위한 체크리스트.

---

## 서비스 기본 원칙

- **따릉이 전용 대여 앱 아님**: 따릉이 사용자가 **비로그인 상태로 조회만** 하는 정보 앱
- **로그인 없음**: 주소만 알면 누구나 접속 가능
- **서비스 대상**: 서울시 따릉이 자전거 대여 서비스 이용자 (정보 조회 목적)
- **지역 범위**: 현재 강남구 한정

### 절대 포함 금지 (강력 제약)

| 항목 | 금지 내용 |
|------|-----------|
| **이용권** | 구매, 조회, 결제, 구독, 이용권 관리 |
| **사용자 my** | 로그인, 회원가입, 프로필, 즐겨찾기, 마이페이지 |

- **반응형**: 모바일·태블릿·데스크탑 웹 모두 지원 (패키지: `flutter_screenutil`)
- **반응형 일관성**: 구간별 레이아웃만 다르고, 색상·타이포·컴포넌트는 공통 Design Token 유지
- **참조 문서**: 마스터 플랜(Phase 1~6)은 `ddri_work` ML 프로젝트 기준 참조용. ML 산출물은 별도 투트랙으로 확정 후 이 웹앱에 연결 예정.

### 스테이션 데이터 구분

| 구분 | stations (161개) | 실전 웹 |
|------|------------------|----------|
| **용도** | ML 학습·예측용 (2023~2025 공통 스테이션) | 현재 강남구 전체 대여소 조회 |
| **출처** | DB 고정 (학습/예측 파이프라인용) | 외부 API 실시간/주기 수집 |
| **특징** | 예측 모델과 1:1 매칭 | 운영 중인 실제 대여소 목록 |

실전 웹에서는 **외부 API(서울시 따릉이 등)를 통해 현재 강남구 전체 스테이션**을 받아와야 한다. 161개는 ML용으로 유지.

---

## 페이지 범위 (현재 기획)

| 페이지 | 경로 | 대상 | 목적 |
|--------|------|------|------|
| **사용자 페이지** | `/user` | 따릉이 이용자 | 내 근처·지정 주소 근처에서 지정 시간대 자전거 예측 조회, 길찾기(가능하면) |
| **관리자 페이지** | `/admin` | 재배치 관리자 | 자전거가 부족한 위치 파악, 재배치 판단 지원 |

- **통계 페이지**: 미정 (현재 기획 범위 밖)

---

## 실행 체크리스트

### Phase 0. 기획·설계 고정

> **원칙**: 화면 설계가 먼저다. 구성이 나와야 그에 맞는 API·서비스를 설계할 수 있다.

- [x] 0.1 사용자 페이지 화면 설계 확정
  - [x] 검색/입력 영역 (내 위치 찾기, 주소 찾기, 시간대 선택 — 3가지 필수)
  - [x] 대여소 목록·카드 표시 항목 (길찾기 버튼 포함)
  - [x] 레이아웃·와이어프레임 (Stitch user/ 데스크탑·태블릿·모바일)
- [x] 0.2 관리자 페이지 화면 설계 확정
  - [x] 기능 플랜 작성 (13_ddri_admin_page_plan.md)
  - [x] 필터·정렬 기준 (긴급만, 행정동, 정렬)
  - [x] 표/카드 표시 항목 (재고·예측·차이·위험·우선순위)
  - [x] 레이아웃·와이어프레임 (Stitch admin/ 데스크탑·태블릿·모바일)
- [x] 0.3 API 응답 스키마 문서화 (화면 구성에 맞춰)
  - [x] 일반 사용자 조회 응답 예시 확정 (14_ddri_api_schema.md)
  - [x] 관리자 목록 응답 예시 확정
  - [x] 예외 스테이션 규칙 API 응답 포함 방식 정의

### Phase 1. Flutter 프로젝트 골격

- [x] 1.1 main.dart 수정
  - [x] 패키지/import 경로 ddri_web 기준으로 정리
  - [x] 문법 오류 수정 (GetMaterialApp, ThemeData)
- [x] 1.2 라우팅 설정
  - [x] `/user` 진입점
  - [x] `/admin` 진입점
  - [x] 기본 경로(`/`) → `/user` 리다이렉트
- [x] 1.3 공통 레이아웃
  - [x] 상단 네비게이션 (사용자 / 관리자)
  - [x] 공통 테마·스타일 (DesignToken, AppTheme)

### Phase 2. 사용자 페이지

- [x] 2.1 검색/입력 UI
  - [x] 내 위치 찾기 (geolocator)
  - [x] 주소 찾기 (kpostal_plus)
  - [x] 시간대 선택 (예측 기준 시각)
  - [x] 길찾기 버튼 (url_launcher)
- [x] 2.2 대여소 목록 UI
  - [x] 거리순 정렬
  - [x] 현재 자전거 수, 예상 잔여 수, 대여 가능 여부 배지
- [x] 2.3 API 연동 (목업 → 실제)
  - [x] 목업 API 클라이언트 연결
  - [ ] 실제 백엔드 연동 (준비 시)

### Phase 3. 관리자 페이지

- [x] 3.1 제어 영역
  - [x] 기준 날짜/시간 선택
  - [x] 긴급 필터, 행정동 필터 (군집은 보조)
  - [x] 정렬 기준 선택
- [x] 3.2 대여소 목록 표
  - [x] 현재 재고, 예측 수요, 재고 차이값
  - [x] 위험 점수, 재배치 우선순위
  - [x] 예외 스테이션 구분 표시
- [x] 3.3 API 연동 (목업 → 실제)
  - [x] 목업 API 클라이언트 연결
  - [ ] 실제 백엔드 연동 (준비 시)

### Phase 4. 백엔드

- [x] 4.1 DDRI 서비스용 API 엔드포인트
  - [x] 사용자 조회 API (`GET /v1/user/stations/nearby`)
  - [x] 관리자 목록 API (`GET /v1/admin/stations/risk`)
  - [x] 스테이션 마스터 (`GET /v1/stations`), 날씨 (`GET /v1/weather/*`) — 목업
- [ ] 4.2 실시간 재고 연동
  - [ ] OA-15493 bikeList 수집
  - [ ] 강남구 전체 스테이션 (외부 API 수집, 161개는 ML용)
- [ ] 4.3 예측 결과 연동
  - [ ] ddri_work ML 산출물 연결 (준비 시)
- [ ] 4.4 DB 데이터 멱등성
  - [ ] `realtime_station_stock`: (station_id, stock_datetime) 유니크·UPSERT
  - [ ] `station_demand_forecasts`: (station_id, target_datetime) 유니크·UPSERT
  - [ ] `stations`: 외부 API 수집 시 INSERT/UPDATE 정책 (api_station_id 기준)

### Phase 5. 마무리·검증

- [ ] 5.1 Chrome 웹 실행 검증
- [ ] 5.2 예외 스테이션 처리 검증
- [ ] 5.3 사용자·관리자 시나리오 E2E 확인

---

## 참조 문서

| 용도 | 경로 |
|------|------|
| 마스터 플랜 (ML Phase 참조) | `ddri_work/works/00_overview/01_ddri_master_plan.md` |
| 웹서비스 기획 | `docs/02_web_service_final/` |
| Stitch MCP 진행 상황 | `docs/02_web_service_final/11_stitch_mcp_progress_and_references.md` |
| 관리자 페이지 기능 플랜 | `docs/02_web_service_final/13_ddri_admin_page_plan.md` |
| API 스키마 (화면 기능 기준) | `docs/02_web_service_final/14_ddri_api_schema.md` |
| API 명세서 (OpenAPI 3.0) | `docs/api/openapi.yaml` |
| 반응형 브레이크포인트 | `docs/02_web_service_final/12_ddri_responsive_breakpoints_and_layouts.md` |
| API 운영 규칙 | `cheng80/02_ddri_api_operational_rules.md` |
| API 테스트 결과 | `cheng80/api_output/` |
| 개발 규칙 | `CURSOR.md` |

---

## 현재 진행 상황 (체크 요약)

| Phase | 완료 | 미완료 | 비고 |
|-------|------|--------|------|
| 0 | 3/3 | 0 | 기획·설계 고정 완료 |
| 1 | 3/3 | 0 | Phase 1 완료 |
| 2 | 3/3 | 0 | Phase 2 완료 |
| 3 | 3/3 | 0 | Phase 3 완료 |
| 4 | 1/4 | 3 | API 엔드포인트(목업) 완료, 실시간·예측·멱등성 대기 |
| 5 | 0/3 | 3 | 마무리·검증 대기 |

**다음 권장 작업**: Phase 4.2 실시간 재고 연동

---

## 모듈화 구조

| 경로 | 역할 |
|------|------|
| `core/` | DesignToken, AppTheme (공통 상수·테마) |
| `common/layout/` | AppScaffold, TopNavBar (공통 레이아웃) |
| `common/api/` | DdriApiClient, 모델 (API 인터페이스) |
| `common/map/` | map_directions_launcher (웹 길찾기) |
| `view/` | 페이지 진입점 (UserView, AdminView) |
| `view/user/` | UserPageController, UserSearchArea, UserStationCard/List |
| `view/admin/` | AdminPageController, AdminControlArea, AdminStationList, AdminSummaryCards |

---

## 진행 방식

- **화면 설계 → API 스키마 → 구현** 순서 유지
- 위 체크리스트 항목을 순서대로 진행
- 완료 시 `- [ ]` → `- [x]` 로 변경
- 불분명한 요구사항은 구현 전에 확인 후 진행
