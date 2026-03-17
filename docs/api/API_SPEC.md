# DDRI API 명세서

강남구 따릉이 대여소 조회·재배치 지원 웹서비스 REST API 명세.

---

## 문서 정보

| 항목 | 내용 |
|------|------|
| **문서 버전** | 1.0.0 |
| **API 버전** | v1 |
| **최종 수정일** | 2026-03-18 |
| **기준 문서** | `openapi.yaml` (OpenAPI 3.0) |

---

## 1. 개요

| 항목 | 내용 |
|------|------|
| **Base URL** | `http://localhost:8000/v1` (로컬 개발) |
| **인증** | 없음 (조회 전용) |
| **데이터 형식** | JSON |
| **문자 인코딩** | UTF-8 |

---

## 2. 기능별 API 목록

### 2.1 사용자 페이지 (ddri-user)

| 메서드 | 경로 | 설명 |
|--------|------|------|
| GET | `/user/stations/nearby` | 근처 대여소 조회 |

### 2.2 관리자 페이지 (ddri-admin)

| 메서드 | 경로 | 설명 |
|--------|------|------|
| GET | `/admin/stations/risk` | 재배치 판단 목록 조회 |

### 2.3 스테이션 마스터 (ddri-stations)

| 메서드 | 경로 | 설명 |
|--------|------|------|
| GET | `/stations` | 대여소 목록 조회 (161개) |

### 2.4 날씨 (weather)

| 메서드 | 경로 | 설명 |
|--------|------|------|
| GET | `/weather/direct` | 날씨 예보 (7일) |
| GET | `/weather/direct/single` | 특정일 날씨 조회 |

---

## 3. API 상세 명세

---

### 3.1 근처 대여소 조회

**기능**: 사용자 페이지. 내 위치 근처 대여소 목록 (거리순, 지정 시간대 예측)

| 항목 | 내용 |
|------|------|
| **요청 방식** | GET |
| **경로** | `/v1/user/stations/nearby` |

#### 요청 예시

```
GET /v1/user/stations/nearby?lat=37.5012&lng=127.0396&target_datetime=2026-03-18T18:00:00%2B09:00&limit=20
```

| 파라미터 | 타입 | 필수 | 설명 |
|----------|------|------|------|
| lat | number | ✓ | 위도 |
| lng | number | ✓ | 경도 |
| target_datetime | string | ✓ | 예측 기준 시각. ISO 8601 형식 (예: `2026-03-18T18:00:00+09:00`) |
| limit | integer | | 반환 개수. 기본 20, 1~50 |
| radius_m | integer | | 반경(m). 미지정 시 전체 중 거리순 |

#### 응답 예시 (200 OK)

```json
{
  "target_datetime": "2026-03-18T18:00:00+09:00",
  "user_location": { "lat": 37.5012, "lng": 127.0396 },
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
    { "station_id": 2314, "reason": "실시간 비노출" }
  ]
}
```

#### 필드 설명

| 필드 | 타입 | 설명 |
|------|------|------|
| target_datetime | string | 예측 기준 시각. ISO 8601 형식 |
| user_location | object | 요청한 사용자 위치. lat, lng |
| items | array | 대여소 목록 (거리순) |
| items[].station_id | integer | 대여소 고유 ID |
| items[].station_name | string | 대여소명 |
| items[].address | string | 주소 |
| items[].latitude | number | 위도 |
| items[].longitude | number | 경도 |
| items[].distance_m | number | 사용자 위치에서 대여소까지 거리(m) |
| items[].current_bike_stock | number | 실시간 보유 대수 |
| items[].predicted_rental_count | number | 해당 시간대 예측 대여량 |
| items[].predicted_remaining_bikes | number | 예상 잔여 수 (current - predicted) |
| items[].bike_availability_flag | boolean | 대여 가능 여부 |
| items[].availability_level | string | `sufficient` \| `normal` \| `low` |
| items[].operational_status | string | `operational` \| `비활성` |
| exceptions | array | 예외 대여소 (실시간 비노출 등) |
| exceptions[].station_id | integer | 예외 대여소 ID |
| exceptions[].reason | string | 예외 사유 |

#### 상태코드

| 코드 | 설명 |
|------|------|
| 200 | 성공 |

---

### 3.2 재배치 판단 목록 조회

**기능**: 관리자 페이지. 시간대별 위험도·우선순위

| 항목 | 내용 |
|------|------|
| **요청 방식** | GET |
| **경로** | `/v1/admin/stations/risk` |

#### 요청 예시

```
GET /v1/admin/stations/risk?base_datetime=2026-03-18T18:00:00%2B09:00&sort_by=risk_score&sort_order=desc
```

| 파라미터 | 타입 | 필수 | 설명 |
|----------|------|------|------|
| base_datetime | string | ✓ | 기준 시각. ISO 8601 형식 |
| urgent_only | boolean | | true 시 위험 대여소만 |
| district_name | string | | 행정동 필터 (예: 역삼동) |
| cluster_code | string | | 지역 특성 필터 (예: cluster00) |
| sort_by | string | | `risk_score` \| `reallocation_priority` \| `stock_gap` |
| sort_order | string | | `asc` \| `desc` |

#### 응답 예시 (200 OK)

```json
{
  "base_datetime": "2026-03-18T18:00:00+09:00",
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
    { "station_id": 2314, "reason": "실시간 비노출" }
  ]
}
```

#### 필드 설명

| 필드 | 타입 | 설명 |
|------|------|------|
| base_datetime | string | 기준 시각. ISO 8601 형식 |
| summary.total_count | integer | 전체 대여소 수 |
| summary.risk_count | integer | 위험 대여소 수 |
| summary.exception_count | integer | 예외 대여소 수 |
| summary.avg_risk_score | number | 평균 위험도 점수 (0~1) |
| items[].station_id | integer | 대여소 고유 ID |
| items[].station_name | string | 대여소명 |
| items[].district_name | string | 행정동명 |
| items[].cluster_code | string | 지역 특성 코드 (cluster00~04) |
| items[].current_bike_stock | number | 실시간 보유 대수 |
| items[].predicted_demand | number | 해당 시간대 예측 수요(대여량) |
| items[].stock_gap | number | current_bike_stock - predicted_demand (음수면 부족) |
| items[].risk_score | number | 위험도 점수 (0~1, 높을수록 위험) |
| items[].reallocation_priority | integer | 재배치 우선순위 (1이 최우선) |
| items[].operational_status | string | `operational` \| `비활성` |

#### 상태코드

| 코드 | 설명 |
|------|------|
| 200 | 성공 |

---

### 3.3 스테이션 마스터 조회

**기능**: 161개 대여소 목록 (필터 가능)

| 항목 | 내용 |
|------|------|
| **요청 방식** | GET |
| **경로** | `/v1/stations` |

#### 요청 예시

```
GET /v1/stations?district_name=역삼동&cluster_code=cluster00
```

| 파라미터 | 타입 | 필수 | 설명 |
|----------|------|------|------|
| district_name | string | | 행정동 필터 |
| cluster_code | string | | 지역 특성 필터 (cluster00~04) |

#### 응답 예시 (200 OK)

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

#### 필드 설명

| 필드 | 타입 | 설명 |
|------|------|------|
| items | array | 대여소 목록 |
| items[].station_id | integer | 대여소 고유 ID (내부) |
| items[].api_station_id | string | 외부 API 대여소 ID |
| items[].station_name | string | 대여소명 |
| items[].district_name | string | 행정동명 |
| items[].address | string | 주소 |
| items[].latitude | number | 위도 |
| items[].longitude | number | 경도 |
| items[].cluster_code | string | 지역 특성 코드 |
| items[].operational_status | string | `operational` \| `비활성` |
| total_count | integer | 전체 대여소 수 |

#### 상태코드

| 코드 | 설명 |
|------|------|
| 200 | 성공 |

---

### 3.4 날씨 예보 (7일)

**기능**: Open-Meteo API 직접 조회. start_date 없으면 오늘 포함 7일치

| 항목 | 내용 |
|------|------|
| **요청 방식** | GET |
| **경로** | `/v1/weather/direct` |

#### 요청 예시

```
GET /v1/weather/direct?lat=37.5665&lon=126.978&start_date=2026-03-18
```

| 파라미터 | 타입 | 필수 | 설명 |
|----------|------|------|------|
| lat | number | ✓ | 위도 |
| lon | number | ✓ | 경도 |
| start_date | string | | 시작 날짜. YYYY-MM-DD. 없으면 오늘 포함 7일 |

#### 응답 예시 (200 OK)

```json
{
  "results": [
    {
      "weather_datetime": "2026-03-18T00:00:00+09:00",
      "weather_type": "맑음",
      "weather_low": 5.2,
      "weather_high": 14.1,
      "icon_url": "https://open-meteo.com/images/weather/..."
    }
  ]
}
```

#### 필드 설명

| 필드 | 타입 | 설명 |
|------|------|------|
| results | array | 일별 날씨 목록 |
| results[].weather_datetime | string | 날짜·시간. ISO 8601 형식 |
| results[].weather_type | string | 한글 날씨 유형 (맑음, 흐림, 비 등) |
| results[].weather_low | number | 최저 기온 (°C) |
| results[].weather_high | number | 최고 기온 (°C) |
| results[].icon_url | string | Open-Meteo 아이콘 URL |

#### 상태코드

| 코드 | 설명 |
|------|------|
| 200 | 성공 |
| 400 | 파라미터 오류 (날짜 형식 등) |

---

### 3.5 특정일 날씨

**기능**: 특정 날짜의 날씨만 조회. target_date 없으면 오늘

| 항목 | 내용 |
|------|------|
| **요청 방식** | GET |
| **경로** | `/v1/weather/direct/single` |

#### 요청 예시

```
GET /v1/weather/direct/single?lat=37.5665&lon=126.978&target_date=2026-03-18
```

| 파라미터 | 타입 | 필수 | 설명 |
|----------|------|------|------|
| lat | number | ✓ | 위도 |
| lon | number | ✓ | 경도 |
| target_date | string | | 조회할 날짜. YYYY-MM-DD. 없으면 오늘 |

#### 응답 예시 (200 OK)

```json
{
  "result": {
    "weather_datetime": "2026-03-18T00:00:00+09:00",
    "weather_type": "맑음",
    "weather_low": 5.2,
    "weather_high": 14.1,
    "icon_url": "https://open-meteo.com/images/weather/..."
  }
}
```

#### 필드 설명

| 필드 | 타입 | 설명 |
|------|------|------|
| result | object | 해당일 날씨 |
| result.weather_datetime | string | 날짜·시간. ISO 8601 형식 |
| result.weather_type | string | 한글 날씨 유형 |
| result.weather_low | number | 최저 기온 (°C) |
| result.weather_high | number | 최고 기온 (°C) |
| result.icon_url | string | Open-Meteo 아이콘 URL |

#### 상태코드

| 코드 | 설명 |
|------|------|
| 200 | 성공 |
| 400 | 파라미터 오류 (날짜 형식 등) |

---

## 4. 상태코드 및 에러 응답

### 4.1 HTTP 상태코드 요약

| 코드 | 설명 |
|------|------|
| 200 | 성공 |
| 400 | Bad Request — 파라미터 누락/형식 오류 |
| 404 | Not Found — 해당 조건에 맞는 데이터 없음 |
| 500 | Internal Server Error — 서버 내부 오류 |

### 4.2 에러 응답 형식 (400, 500 등)

```json
{
  "result": "Error",
  "errorMsg": "날짜 형식이 올바르지 않습니다. (YYYY-MM-DD 형식 필요): 2026/03/18"
}
```

| 필드 | 타입 | 설명 |
|------|------|------|
| result | string | 항상 `"Error"` |
| errorMsg | string | 에러 메시지 |
| traceback | string | (개발 환경에서만) 스택 트레이스 |

### 4.3 에러 코드 (비즈니스)

| code | 설명 |
|------|------|
| INVALID_PARAMETER | 필수 파라미터 누락 또는 형식 오류 |
| SERVICE_UNAVAILABLE | 실시간 API 또는 예측 서비스 장애 |
| NOT_FOUND | 해당 조건에 맞는 데이터 없음 |

---

## 5. 예외 스테이션 규칙

| 상황 | API 응답 처리 |
|------|---------------|
| 실시간 비노출 (2314, 2323, 3628 등) | `items`에 포함하지 않고 `exceptions` 배열에만 포함 |
| 비활성 스테이션 | `operational_status: "비활성"`으로 `items`에 포함 또는 `exceptions` 처리 |
| 실시간 API 장애 | `exceptions`에 포함, `reason`에 "실시간 정보 없음" 등 |

---

## 6. 버전/수정일 기록

| 버전 | 수정일 | 변경 내용 |
|------|--------|-----------|
| 1.0.0 | 2026-03-18 | 최초 작성. 기능별 API 목록, 요청/응답 예시, 필드 설명, 상태코드, 에러 응답 포함 |

---

## 7. 관련 문서

| 문서 | 용도 |
|------|------|
| `openapi.yaml` | OpenAPI 3.0 전체 명세 (Swagger Editor, ReDoc) |
| `fastapi/API_GUIDE.md` | FastAPI 서버 설치·실행 가이드 |

---

## 8. 사용법

- **Swagger UI**: 서버 실행 후 http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc
- **YAML 편집**: [Swagger Editor](https://editor.swagger.io/)에 `openapi.yaml` 붙여넣기
