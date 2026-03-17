-- DDRI MySQL Init Schema
-- 강남구 따릉이 대여소 조회·재배치 지원 웹서비스
-- 실행: mysql -u team0101 -p -h cheng80.myqnapcloud.com -P 13306 < init_schema.sql
-- 또는: mysql -u team0101 -p -h cheng80.myqnapcloud.com -P 13306 ddri_db < init_schema.sql

-- 1. 데이터베이스 생성
CREATE DATABASE IF NOT EXISTS ddri_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE ddri_db;

-- 2. stations: 서비스 대상 스테이션 마스터 (161개)
CREATE TABLE IF NOT EXISTS stations (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  station_id INT NOT NULL UNIQUE COMMENT '숫자형 대여소 ID',
  api_station_id VARCHAR(32) DEFAULT NULL COMMENT 'ST-xxxx 등 외부 API ID',
  station_name VARCHAR(255) NOT NULL,
  district_name VARCHAR(64) DEFAULT NULL COMMENT '행정동',
  address VARCHAR(512) DEFAULT NULL,
  latitude DECIMAL(10, 7) DEFAULT NULL,
  longitude DECIMAL(10, 7) DEFAULT NULL,
  cluster_code VARCHAR(32) DEFAULT NULL COMMENT 'cluster00~04',
  operational_status VARCHAR(32) DEFAULT 'operational' COMMENT 'operational|비노출|비활성',
  is_service_target TINYINT(1) DEFAULT 1,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_district (district_name),
  INDEX idx_cluster (cluster_code),
  INDEX idx_location (latitude, longitude)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3. station_api_mappings: station_id ↔ 외부 API ID 매핑
CREATE TABLE IF NOT EXISTS station_api_mappings (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  station_id INT NOT NULL,
  resolved_api_station_id VARCHAR(32) DEFAULT NULL,
  source_api VARCHAR(64) DEFAULT NULL,
  match_status VARCHAR(32) DEFAULT NULL COMMENT 'matched|unmatched|exception',
  exception_reason VARCHAR(255) DEFAULT NULL COMMENT '실시간 비노출 등',
  verified_at DATETIME DEFAULT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (station_id) REFERENCES stations(station_id) ON DELETE CASCADE,
  INDEX idx_station (station_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4. realtime_station_stock: 실시간 재고 캐시
CREATE TABLE IF NOT EXISTS realtime_station_stock (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  station_id INT NOT NULL,
  stock_datetime DATETIME NOT NULL,
  current_bike_stock INT DEFAULT 0,
  parking_bike_total_count INT DEFAULT NULL,
  shared_count DECIMAL(10, 2) DEFAULT NULL,
  operational_status VARCHAR(32) DEFAULT NULL,
  raw_payload_hash CHAR(64) DEFAULT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (station_id) REFERENCES stations(station_id) ON DELETE CASCADE,
  INDEX idx_station_datetime (station_id, stock_datetime),
  INDEX idx_datetime (stock_datetime)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 5. station_demand_forecasts: 시간 단위 예측 결과
CREATE TABLE IF NOT EXISTS station_demand_forecasts (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  station_id INT NOT NULL,
  target_datetime DATETIME NOT NULL,
  predicted_rental_count DECIMAL(10, 2) DEFAULT NULL,
  predicted_return_count DECIMAL(10, 2) DEFAULT NULL,
  predicted_remaining_bikes DECIMAL(10, 2) DEFAULT NULL,
  availability_level VARCHAR(32) DEFAULT NULL COMMENT 'sufficient|normal|low',
  model_version VARCHAR(64) DEFAULT NULL,
  cluster_code VARCHAR(32) DEFAULT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (station_id) REFERENCES stations(station_id) ON DELETE CASCADE,
  INDEX idx_station_datetime (station_id, target_datetime),
  INDEX idx_datetime (target_datetime)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 6. station_risk_snapshots: 관리자용 재배치 판단 결과
CREATE TABLE IF NOT EXISTS station_risk_snapshots (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  station_id INT NOT NULL,
  base_datetime DATETIME NOT NULL,
  current_bike_stock INT DEFAULT NULL,
  predicted_demand DECIMAL(10, 2) DEFAULT NULL,
  stock_gap DECIMAL(10, 2) DEFAULT NULL COMMENT 'current - predicted',
  risk_score DECIMAL(5, 4) DEFAULT NULL COMMENT '0~1',
  reallocation_priority INT DEFAULT NULL COMMENT '1=최우선',
  operational_status VARCHAR(32) DEFAULT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (station_id) REFERENCES stations(station_id) ON DELETE CASCADE,
  INDEX idx_station_datetime (station_id, base_datetime),
  INDEX idx_datetime (base_datetime),
  INDEX idx_risk (risk_score),
  INDEX idx_priority (reallocation_priority)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 7. statistics_snapshots: 통계 집계 결과 (통계 페이지용)
CREATE TABLE IF NOT EXISTS statistics_snapshots (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  base_date DATE NOT NULL,
  base_hour INT DEFAULT NULL,
  cluster_code VARCHAR(32) DEFAULT NULL,
  metric_key VARCHAR(64) NOT NULL,
  metric_value DECIMAL(15, 4) DEFAULT NULL,
  dimension_key VARCHAR(64) DEFAULT NULL,
  dimension_value VARCHAR(255) DEFAULT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_base (base_date, base_hour),
  INDEX idx_metric (metric_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
