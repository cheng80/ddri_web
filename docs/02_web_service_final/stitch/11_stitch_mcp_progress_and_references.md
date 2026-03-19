# Stitch MCP 사용 이후 진행 상황 및 참고 주소

작성일: 2026-03-17  
목적: Stitch MCP 도입 이후 진행 상황과 참고해야 할 주소·경로를 정리한다.

---

## 1. 진행 상황 타임라인

| 시점 | 작업 | 결과 |
|------|------|------|
| 1차 | [서울시 따릉이 앱 사용법](https://news.seoul.go.kr/traffic/archives/505738) 참고, Stitch MCP로 모바일 화면 생성 | `가까운 대여소 조회` (Screen ID: 95619023...) 생성, 502 에러로 다운로드 지연 |
| 2차 | `get_screen`으로 화면 정보 조회, curl로 스크린샷·HTML 다운로드 | `stitch_export/user/` 등 페이지별 폴더에 저장 |
| 3차 | 반응형 구조 적용 (1/2/3열 그리드, max-width 1200px) | `반응형 대여소 조회` (Screen ID: 3d39d561...) 생성 |
| 4차 | 범위 밖 항목 명시 (이용권·사용자 정보) | 03, README, stitch_export README 수정 |
| 5차 | 지도 UX 개선 (단일 지도 + 원형 반경 + 마커) | `10_ddri_user_page_map_ux_spec.md` 작성 |
| 6차 | 사용 안 하는 이미지·HTML 삭제 | `가까운_대여소_조회.*`, `반응형_대여소_조회.*` 삭제 |
| 7차 | DDRI 전용 디자인 재생성 (이용권·로그인 제외, 단일 지도) | `DDRI 대여소 조회 전용 웹` (Screen ID: 3d8c201d...) 생성 |
| 8차 | 반응형 화면 고도화 (모바일·태블릿·데스크탑) | 12_ddri_responsive_breakpoints_and_layouts.md 작성 |
| 9차 | 데스크탑 기준 태블릿·모바일 재생성 (generate_variants) | 태블릿(76b22193...), 모바일(0339726e...) 생성 |
| 10차 | 태블릿 세로 상하분할·정보풍부 리스트 반영 재생성 | 태블릿(e311fbd7...), 모바일(430845cf...) 생성 |
| 11차 | 내 위치·주소·시간대 선택·길찾기 UI 반영 재빌드 | 데스크탑(c5877d72...) 편집, 태블릿(bc4e01f1...), 모바일(248b7e6e...) variants |
| 12차 | 관리자 페이지 생성·저장 | 데스크탑(de468c03...), 태블릿(6e39d545...), 모바일(b3005ebd...) → stitch_export/admin/ |

---

## 2. 참고 주소 (URL)

### 2.1 Stitch

| 용도 | URL |
|------|-----|
| **Stitch 프로젝트** | https://stitch.withgoogle.com/projects/17527760865324934283 |
| **프로젝트 ID** | `17527760865324934283` |

### 2.2 참고 사이트 (스타일만 참고)

| 용도 | URL |
|------|-----|
| 서울시 따릉이 앱 사용법 | https://news.seoul.go.kr/traffic/archives/505738 |

※ DDRI는 따릉이 사이트 그대로가 아님. 이용권·로그인 없음.

---

## 3. 참고 경로 (로컬)

### 3.1 Stitch 산출물 (페이지별 폴더)

| 페이지 | 경로 | 디바이스 | Screen ID |
|--------|------|----------|-----------|
| 사용자 | `stitch_export/user/` | 데스크탑·태블릿·모바일 | c5877d72, bc4e01f1, 248b7e6e |
| 관리자 | `stitch_export/admin/` | 데스크탑·태블릿·모바일 | de468c03, 6e39d545, b3005ebd |

### 3.2 관련 문서

| 문서 | 경로 |
|------|------|
| 현재 화면 설계 기준 | `docs/02_web_service_final/01_screen_design_and_scope.md` |
| Stitch 적용 가이드 | `docs/02_web_service_final/stitch/09_stitch_design_application_guide.md` |
| 반응형 브레이크포인트 (레거시) | `docs/02_web_service_final/legacy/12_ddri_responsive_breakpoints_and_layouts.md` |
| 지도 UX 설계 (레거시) | `docs/02_web_service_final/legacy/10_ddri_user_page_map_ux_spec.md` |
| 사용자 페이지 상세 (레거시) | `docs/02_web_service_final/legacy/08_ddri_user_page_spec_detail.md` |
| stitch_export README | `docs/02_web_service_final/stitch/stitch_export/README.md` |

### 3.3 웹 프로젝트

| 항목 | 경로 |
|------|------|
| Flutter 웹 | `/Users/cheng80/Desktop/ddri_web` |

---

## 4. Stitch 화면 (반응형 3종, 11차 재빌드)

| 디바이스 | 화면명 | Screen ID | 해상도 |
|----------|--------|-----------|--------|
| 데스크탑 | DDRI 대여소 조회 (검색·시간 설정) | `c5877d72fd2e4722b4869d4a76e26a60` | 2560×2048 |
| 태블릿 | DDRI 대여소 조회 (태블릿 반응형) | `bc4e01f1a4e64f29a4e0007a41bfb7ee` | 1536×2048 |
| 모바일 | DDRI 대여소 조회 (모바일 검색) | `248b7e6e5c6d4be197579cd17e501008` | 780×1768 |

### MCP get_screen 호출 예시

**사용자 페이지**
```
screenId: "c5877d72fd2e4722b4869d4a76e26a60"  # 데스크탑
screenId: "bc4e01f1a4e64f29a4e0007a41bfb7ee"  # 태블릿
screenId: "248b7e6e5c6d4be197579cd17e501008"  # 모바일
```

**관리자 페이지**
```
screenId: "de468c036e1c47a8a3cbed40481e961b"  # 데스크탑
screenId: "6e39d54571a1451dba6d654c118b9931"  # 태블릿
screenId: "b3005ebdd6c646709d4d60aeb916d9a1"  # 모바일
```

---

## 5. DDRI 방향 (필수 준수, 강력 제약)

- **DDRI는 따릉이 전용 대여 앱이 아님**: 비로그인 조회 전용 정보 앱
- **참고**: 따릉이 스타일 참고. 따릉이 사이트 그대로 아님.
- **절대 포함 금지**: 이용권(구매·조회·결제), 사용자 my(로그인·회원가입·프로필·즐겨찾기·마이페이지), 고객센터
- **지도**: 단일 지도 1개. 카드마다 개별 지도 썸네일 없음.
- **레이아웃**: 좌측 지도(45%) + 우측 카드 리스트(55%)

---

## 6. MCP 도구 요약

| 도구 | 용도 |
|------|------|
| `list_projects` | 프로젝트 목록 |
| `list_screens` | 프로젝트 내 화면 목록 |
| `get_screen` | 화면 스크린샷·HTML URL 조회 |
| `generate_screen_from_text` | 텍스트 프롬프트로 새 화면 생성 |
| `edit_screens` | 기존 화면 수정 |

---

## 7. 다운로드 절차 (추가 화면 있을 때)

1. `get_screen`으로 `screenshot.downloadUrl`, `htmlCode.downloadUrl` 조회
2. `curl -L -o 파일명 "[URL]"` 로 저장
3. **페이지별 폴더**에 저장: `stitch_export/user/` 또는 `stitch_export/admin/` (파일명 충돌 방지)
4. `stitch_export/README.md` 및 해당 페이지 README 업데이트

### 7.1 Stitch 화면 제목 규칙 (디바이스 구분)

> **생성 시 프롬프트에 제목을 명시**하면 Stitch 화면 목록·다운로드 시 어떤 디바이스인지 구분하기 쉽다.

| 디바이스 | 제목 예시 |
|----------|-----------|
| 데스크탑 | `DDRI 대여소 조회 - 데스크탑` / `DDRI 관리자 재배치 - 데스크탑` |
| 태블릿 | `DDRI 대여소 조회 - 태블릿` / `DDRI 관리자 재배치 - 태블릿` |
| 모바일 | `DDRI 대여소 조회 - 모바일` / `DDRI 관리자 재배치 - 모바일` |

**프롬프트 예시** (generate_screen_from_text / generate_variants):
```
Title: DDRI 관리자 재배치 - 데스크탑
... (나머지 레이아웃·스타일 설명)
```

→ Stitch 프로젝트 내 화면 목록에서 `페이지명 - 디바이스` 형태로 바로 확인 가능.

### 7.2 해상도 이슈

- **MCP downloadUrl**: 스크린샷이 **저해상도**로 내려올 수 있음
- **고해상도 필요 시**: [Stitch 웹](https://stitch.withgoogle.com/projects/17527760865324934283)에서 화면 선택 → 스크린샷/HTML 직접 다운로드
