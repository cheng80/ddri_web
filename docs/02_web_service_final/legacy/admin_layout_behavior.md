# 관리자 페이지 레이아웃 동작

작성일: 2026-03-19  
목적: 현재 Flutter 구현 기준으로 관리자 목록 영역의 높이, 여백, 스크롤 동작을 문서화한다.

## 1. 적용 범위

이 문서는 아래 구현에 대응한다.

- `lib/view/admin/admin_station_list.dart`
- `lib/core/design_token.dart`

목적은 관리자 페이지에서 목록 길이에 따라 레이아웃이 어떻게 달라지는지 고정하는 것이다.

## 2. 여백·높이 규칙

| 항목 | 값 | 위치 |
|------|-----|------|
| 섹션 간 여백 | 16px | `DesignToken.adminSectionSpacing` |
| shrinkWrap 기준 개수 | 8개 이하 | `DesignToken.adminListShrinkWrapThreshold` |
| 리스트 최대 높이 | 600px | `DesignToken.adminListMaxHeight` |

## 3. 스테이션 리스트 동작

### 목록이 적을 때 (8개 이하)

- `shrinkWrap` 방식으로 콘텐츠 높이만 사용
- 목록 아래 예외 스테이션 영역과 지도 플레이스홀더가 자연스럽게 바로 이어짐
- 불필요한 빈 공간을 만들지 않음

### 목록이 많을 때 (9개 이상)

- 목록 영역 높이를 최대 `600px`로 제한
- 목록 내부에서만 세로 스크롤 수행
- 예외 스테이션 영역과 지도 플레이스홀더는 목록 아래 별도 섹션으로 유지

## 4. 전체 페이지 스크롤 흐름

1. 상단 타이틀
2. 제어 영역
3. 요약 카드
4. 스테이션 목록
5. 예외 스테이션 영역
6. 지도 플레이스홀더

설명:

- 목록이 짧으면 페이지 전체가 자연 높이로 렌더링된다.
- 목록이 길면 목록만 내부 스크롤되고, 하단 섹션은 전체 페이지 스크롤로 접근한다.

## 5. 구현 의도

- 목록 수가 적은데도 고정 높이를 강제하면 하단에 불필요한 빈 여백이 생긴다.
- 반대로 목록 수가 많을 때 높이 제한이 없으면 예외 영역과 하단 보조 정보가 화면 아래로 과도하게 밀린다.
- 따라서 항목 수 기준으로 `shrinkWrap` 과 고정 높이 스크롤을 분기한다.

## 6. 수정 방법

`lib/core/design_token.dart` 에서 상수를 조정한다.

```dart
static const int adminListShrinkWrapThreshold = 8;
static const double adminListMaxHeight = 600;
static const double adminSectionSpacing = 16;
```

## 7. 후속 고려사항

- 모바일에서는 표보다 카드형 목록 전환이 더 적합할 수 있다.
- 실제 데이터 건수와 브라우저 높이를 기준으로 `600px` 값은 조정 가능하다.
- 관리자 지도 기능이 실제로 들어가면 목록 높이 정책을 다시 점검해야 한다.
