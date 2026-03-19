# DDRI API 명세서

작성일: 2026-03-20  
목적: 현재 DDRI 웹서비스에서 사용하는 조회형 API를 화면 기준으로 정리한다.

## 문서 기준

- API 버전: `v1`
- 인증: 없음
- 응답 형식: JSON
- 서비스 성격: 비로그인 모니터링 웹

현재 기준 설계 문서:

- [01_screen_design_and_scope.md](/Users/cheng80/Desktop/ddri_web/docs/02_web_service_final/01_screen_design_and_scope.md)
- [02_system_design.md](/Users/cheng80/Desktop/ddri_web/docs/02_web_service_final/02_system_design.md)
- [03_api_and_runtime_contract.md](/Users/cheng80/Desktop/ddri_web/docs/02_web_service_final/03_api_and_runtime_contract.md)

## 1. API 목록

### 기본

| 메서드 | 경로 | 설명 |
|--------|------|------|
| GET | `/` | API 정보 |
| GET | `/health` | 헬스 체크 |

### 사용자 페이지

| 메서드 | 경로 | 설명 |
|--------|------|------|
| GET | `/v1/user/stations/nearby` | 위치 기준 주변 대여소 조회 |

### 관리자 페이지

| 메서드 | 경로 | 설명 |
|--------|------|------|
| GET | `/v1/admin/stations/risk` | 기준 시각 부족 위험 목록 조회 |

### 스테이션 마스터

| 메서드 | 경로 | 설명 |
|--------|------|------|
| GET | `/v1/stations` | 화면용 스테이션 기본 정보 조회 |

### 날씨

| 메서드 | 경로 | 설명 |
|--------|------|------|
| GET | `/v1/weather/direct` | 7일 일별 날씨 조회 |
| GET | `/v1/weather/direct/single` | 특정 날짜 또는 시각 기준 날씨 조회 |

## 2. 사용자 API

### `GET /v1/user/stations/nearby`

용도:
- 사용자 위치 또는 주소 위치 기준 대여소 조회
- 현재 재고와 예측 결과 표시
- 화면에서 주간 날씨와 선택 시각 예상 날씨를 함께 표시 가능

#### 요청 파라미터

| 파라미터 | 타입 | 필수 | 설명 |
|----------|------|------|------|
| `lat` | number | ✓ | 위도 |
| `lng` | number | ✓ | 경도 |
| `target_datetime` | string | ✓ | 조회 기준 시각, ISO 8601 |
| `limit` | integer | | 반환 개수, 기본 20 |
| `radius_m` | integer | | 반경(m) |

#### 응답 예시

```json
{
  "target_datetime": "2026-03-20T18:00:00+09:00",
  "user_location": {
    "lat": 37.5012,
    "lng": 127.0396
  },
  "weather": {
    "weekly_forecast": [
      {
        "date": "2026-03-20",
        "weather_type": "맑음",
        "weather_low": 4,
        "weather_high": 13,
        "icon_url": "https://..."
      }
    ],
    "selected_forecast": {
      "weather_datetime": "2026-03-20T18:00:00+09:00",
      "weather_type": "구름많음",
      "weather_low": 6,
      "weather_high": 14,
      "icon_url": "https://..."
    }
  },
  "items": [
    {
      "station_id": 2328,
      "station_name": "르네상스 호텔 사거리 역삼지하보도 7번출구 앞",
      "address": "서울 강남구 역삼동 123-45",
      "latitude": 37.5001,
      "longitude": 127.0389,
      "distance_m": 150,
      "current_bike_stock": 7,
      "predicted_rental_count": 5.2,
      "predicted_remaining_bikes": 1.8,
      "bike_availability_flag": true,
      "availability_level": "low",
      "operational_status": "operational"
    }
  ],
  "exceptions": [
    {
      "station_id": 2314,
      "reason": "실시간 비노출"
    }
  ]
}
```

#### 응답 해석

- `weather.weekly_forecast`
  - 기본으로 보여줄 주간 일별 날씨
- `weather.selected_forecast`
  - 사용자가 선택한 날짜/시간 기준 예상 날씨
- `items`
  - 거리순 대여소 목록
- `exceptions`
  - 실시간 비노출 등 예외 스테이션

## 3. 관리자 API

### `GET /v1/admin/stations/risk`

용도:
- 기준 시각에 부족 위험이 큰 대여소 목록 조회
- 위험도 판단과 함께 주간 날씨, 기준 시각 날씨 확인

#### 요청 파라미터

| 파라미터 | 타입 | 필수 | 설명 |
|----------|------|------|------|
| `base_datetime` | string | ✓ | 기준 시각, ISO 8601 |
| `urgent_only` | boolean | | 위험 대여소만 조회 |
| `district_name` | string | | 행정동 필터 |
| `cluster_code` | string | | 보조 필터 |
| `sort_by` | string | | `risk_score` \| `reallocation_priority` \| `stock_gap` |
| `sort_order` | string | | `asc` \| `desc` |

#### 응답 예시

```json
{
  "base_datetime": "2026-03-20T18:00:00+09:00",
  "weather": {
    "weekly_forecast": [
      {
        "date": "2026-03-20",
        "weather_type": "맑음",
        "weather_low": 4,
        "weather_high": 13,
        "icon_url": "https://..."
      }
    ],
    "selected_forecast": {
      "weather_datetime": "2026-03-20T18:00:00+09:00",
      "weather_type": "구름많음",
      "weather_low": 6,
      "weather_high": 14,
      "icon_url": "https://..."
    }
  },
  "summary": {
    "total_count": 161,
    "risk_count": 23,
    "exception_count": 3,
    "avg_risk_score": 0.42
  },
  "items": [
    {
      "station_id": 2328,
      "station_name": "르네상스 호텔 사거리 역삼지하보도 7번출구 앞",
      "district_name": "역삼동",
      "cluster_code": "cluster00",
      "current_bike_stock": 7,
      "predicted_demand": 12.0,
      "stock_gap": -5.0,
      "risk_score": 0.72,
      "reallocation_priority": 1,
      "operational_status": "operational"
    }
  ],
  "exceptions": [
    {
      "station_id": 2314,
      "reason": "실시간 비노출"
    }
  ]
}
```

## 4. 스테이션 마스터 API

### `GET /v1/stations`

용도:
- 화면용 기본 스테이션 정보 조회
- 로컬 선탑재 데이터와 비교 가능

#### 요청 파라미터

| 파라미터 | 타입 | 필수 | 설명 |
|----------|------|------|------|
| `district_name` | string | | 행정동 필터 |
| `cluster_code` | string | | 군집 필터 |

#### 응답 예시

```json
{
  "items": [
    {
      "station_id": 2328,
      "api_station_id": "ST-1234",
      "station_name": "르네상스 호텔 사거리 역삼지하보도 7번출구 앞",
      "district_name": "역삼동",
      "address": "서울 강남구 역삼동 123-45",
      "latitude": 37.5001,
      "longitude": 127.0389,
      "cluster_code": "cluster00",
      "operational_status": "operational"
    }
  ],
  "total_count": 161
}
```

## 5. 날씨 API

### `GET /v1/weather/direct`

용도:
- 오늘 포함 7일 일별 예보 조회
- 사용자/관리자 탭의 주간 날씨 UI 구성

### `GET /v1/weather/direct/single`

용도:
- 선택 날짜 또는 기준 시각의 상세 날씨 조회
- 화면의 선택 시간 상세 날씨 구성

날짜 선택 원칙:

- 과거 날짜 선택 불가
- 현재 시점부터 7일 이내까지만 허용

## 6. 에러 응답 원칙

예시:

```json
{
  "error": {
    "code": "INVALID_PARAMETER",
    "message": "lat, lng are required"
  }
}
```

주요 원칙:
- 필수 파라미터 누락 시 명확한 오류 반환
- 일부 외부 데이터 실패 시 전체 실패보다 부분 응답 우선
- 폴백이 발생하면 응답 상태 필드로 구분 가능

## 7. 현재 메모

- 현재 FastAPI는 목업 응답 기준으로 동작한다.
- 실시간 재고 연동, 예측 런타임 연결, 로컬 마스터 로딩은 후속 작업이다.
- DB는 필수 조건이 아니며, 필요 시 `prediction_logs`만 최소 저장한다.
