# Stitch 프로젝트 내보내기

**프로젝트**: DDRI 따릉이 스타일 대여소 조회  
**Stitch URL**: https://stitch.withgoogle.com/projects/17527760865324934283

## 폴더 구조 (페이지별 분리)

| 폴더 | 용도 | 파일 예시 |
|------|------|-----------|
| **user/** | 사용자 페이지 (대여소 조회) | DDRI_대여소_조회_데스크탑.* |
| **admin/** | 관리자 페이지 (재배치 판단) | (추가 예정) |

→ 페이지별로 분리해 **다운로드 시 파일명 충돌**을 방지한다.

## DDRI 방향 (필수, 강력 제약)

- **DDRI는 따릉이 전용 대여 앱 아님**: 비로그인 조회 전용 정보 앱
- **절대 금지**: 이용권, 사용자 my(로그인·회원가입·프로필·즐겨찾기), 고객센터
- **허용**: 대여소 조회만

## Stitch 화면 제목 규칙

생성 시 프롬프트에 **제목**을 명시하면 Stitch 목록·다운로드 시 디바이스 구분이 쉬움.

- `DDRI 대여소 조회 - 데스크탑` / `- 태블릿` / `- 모바일`
- `DDRI 관리자 재배치 - 데스크탑` / `- 태블릿` / `- 모바일`

## 해상도

- MCP downloadUrl은 저해상도일 수 있음. **고해상도 필요 시** [Stitch 웹](https://stitch.withgoogle.com/projects/17527760865324934283)에서 직접 다운로드.
- **지도**: 단일 지도 1개. 카드마다 개별 지도 썸네일 없음.

---

## user/ – 사용자 페이지 (11차 재빌드)

| 디바이스 | 스크린샷 | HTML | Screen ID |
|----------|----------|------|-----------|
| 데스크탑 | `DDRI_대여소_조회_데스크탑_screenshot.png` | `DDRI_대여소_조회_데스크탑.html` | c5877d72... |
| 태블릿 | `DDRI_대여소_조회_태블릿_screenshot.png` | `DDRI_대여소_조회_태블릿.html` | bc4e01f1... |
| 모바일 | `DDRI_대여소_조회_모바일_screenshot.png` | `DDRI_대여소_조회_모바일.html` | 248b7e6e... |

### 레이아웃 (11차)

- **검색/입력 영역**: [내 위치 찾기] [주소 찾기] [시간대 선택] — 3가지 필수
- **대여소 카드**: [길찾기] [상세보기] 버튼
- **데스크탑**: 검색바 → 좌측 45% 지도 + 우측 55% 리스트
- **태블릿**: 가로: 좌우 분할 / 세로: 상하 분할 (지도 상단)
- **모바일**: 검색바 → 지도 상단(35~40%) + 하단 세로 카드 리스트

---

## admin/ – 관리자 페이지

| 디바이스 | 스크린샷 | HTML | Screen ID |
|----------|----------|------|-----------|
| 데스크탑 | `DDRI_관리자_재배치_데스크탑_screenshot.png` | `DDRI_관리자_재배치_데스크탑.html` | de468c03... |
| 태블릿 | `DDRI_관리자_재배치_태블릿_screenshot.png` | `DDRI_관리자_재배치_태블릿.html` | 6e39d545... |
| 모바일 | `DDRI_관리자_재배치_모바일_screenshot.png` | `DDRI_관리자_재배치_모바일.html` | b3005ebd... |

### 레이아웃

- **제어 영역**: 기준 날짜/시간, 긴급만, 정렬, 행정동 필터
- **요약 카드**: 전체 161, 위험 23, 예외 3, 평균 0.4
- **메인 표**: 대여소명, 동, 지역특성, 재고, 예측수요, 차이, 위험, 우선순위
- **예외 영역**: station_id 2314, 2323, 3628 – 실시간 비노출

---

## Flutter 웹 적용 시 참고

- `flutter_screenutil`로 반응형 적용
- 반응형 스펙: [12_ddri_responsive_breakpoints_and_layouts.md](/Users/cheng80/Desktop/ddri_web/docs/02_web_service_final/legacy/12_ddri_responsive_breakpoints_and_layouts.md)
- 지도 UX 상세: [10_ddri_user_page_map_ux_spec.md](/Users/cheng80/Desktop/ddri_web/docs/02_web_service_final/legacy/10_ddri_user_page_map_ux_spec.md)
