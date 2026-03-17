# DDRI FastAPI 서버

강남구 따릉이 대여소 조회·재배치 지원 웹서비스를 위한 FastAPI 백엔드입니다.

## 프로젝트 구조

```
fastapi/
├── app/
│   ├── api/                  # API 엔드포인트 라우터
│   │   ├── __init__.py
│   │   ├── weather.py        # 날씨 API (Open-Meteo)
│   │   ├── ddri_user.py      # 사용자용: 주변 대여소 조회
│   │   ├── ddri_admin.py     # 관리자용: 위험 대여소 조회
│   │   └── ddri_stations.py  # 대여소 목록 조회
│   ├── database/             # 데이터베이스 연결 설정
│   │   ├── __init__.py
│   │   ├── connection.py     # 운영용 DB 연결
│   │   └── connection_local.py  # 로컬 개발용 DB 연결
│   ├── utils/                # 유틸리티
│   │   ├── weather_service.py
│   │   └── weather_mapping.py
│   └── main.py               # FastAPI 애플리케이션 진입점
├── mysql/
│   └── init_schema.sql       # DDRI 데이터베이스 초기화 스키마 (DDL)
├── requirements.txt          # Python 의존성
└── API_GUIDE.md              # 이 파일
```

## 설치 및 실행

### 1. 가상 환경 생성 및 활성화

```bash
cd fastapi
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
```

### 2. 의존성 설치

```bash
pip install -r requirements.txt
```

### 3. 환경변수 설정

`fastapi/.env` 파일을 생성하고 DB 및 API 키를 설정합니다.

```env
DB_HOST=your_host
DB_USER=your_user
DB_PASSWORD=your_password
DB_NAME=ddri_db
DB_PORT=13306
OPENMETEO_API_KEY=  # Open-Meteo (선택)
```

### 4. 데이터베이스 초기화

```bash
mysql -u your_user -p < mysql/init_schema.sql
```

### 5. 서버 실행

```bash
cd fastapi
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

### 6. API 문서 확인

- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

## 현재 엔드포인트

### 기본
- `GET /` - API 정보
- `GET /health` - 헬스 체크

### Weather (`/v1/weather`)
- `GET /v1/weather/current?lat={lat}&lon={lon}` - 현재 날씨 조회

### DDRI User (`/v1/user`)
- `GET /v1/user/stations/nearby?lat={lat}&lon={lon}&radius_km={km}` - 주변 대여소 조회

### DDRI Admin (`/v1/admin`)
- `GET /v1/admin/stations/risk` - 위험 대여소 목록 조회

### DDRI Stations (`/v1/stations`)
- `GET /v1/stations` - 대여소 목록 조회 (페이지네이션 지원)

## 데이터베이스 설정

`app/database/connection.py`는 `.env`의 `DB_*` 환경변수를 사용합니다.  
로컬 개발 시 `connection_local.py`를 참고하여 설정을 분기할 수 있습니다.

`mysql/init_schema.sql` 실행 시 DDRI용 테이블(stations, station_risk_snapshots 등)이 생성됩니다.

## CORS 설정

개발 환경에서는 모든 origin을 허용합니다. 프로덕션에서는 Flutter 웹 도메인으로 제한하세요.

## 엔드포인트 추가 방법

1. `app/api/`에 새 라우터 파일 생성
2. `main.py`에서 `app.include_router(...)` 등록
3. DB 사용 시 `from app.database.connection import connect_db` 사용

## 참고

- API 문서: `/docs`, `/redoc`
- MySQL 8.0, utf8mb4 인코딩
