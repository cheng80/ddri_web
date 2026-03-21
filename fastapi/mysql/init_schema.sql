-- DDRI MySQL Init Schema
-- 현재 기준: 선택적 예측 로그 저장용 최소 스키마

CREATE DATABASE IF NOT EXISTS ddri_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE ddri_db;

CREATE TABLE IF NOT EXISTS prediction_logs (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  prediction_time DATETIME NOT NULL COMMENT '예측 실행 시각',
  target_time DATETIME NOT NULL COMMENT '예측 대상 시각',
  station_id INT NOT NULL COMMENT '숫자형 대여소 ID',
  request_path VARCHAR(32) DEFAULT NULL COMMENT '예측이 발생한 API 경로 구분 (/user 또는 /admin)',
  horizon_hours INT NOT NULL COMMENT '예측 시간 간격',
  current_bike_stock DECIMAL(10, 2) DEFAULT NULL COMMENT '예측 시점의 현재 재고',
  predicted_rental_count DECIMAL(10, 2) DEFAULT NULL COMMENT '예상 대여량',
  predicted_return_count DECIMAL(10, 2) DEFAULT NULL COMMENT '예상 반납량',
  predicted_net_change DECIMAL(10, 2) DEFAULT NULL COMMENT '예상 누적 순변화',
  predicted_remaining_bikes DECIMAL(10, 2) DEFAULT NULL COMMENT '예상 잔여 재고',
  model_version VARCHAR(64) DEFAULT NULL,
  source_updated_at DATETIME DEFAULT NULL COMMENT '실시간 재고 또는 외부 원천 기준 시각',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_station_target (station_id, target_time),
  INDEX idx_prediction_time (prediction_time),
  INDEX idx_target_time (target_time),
  INDEX idx_request_path (request_path),
  INDEX idx_model_version (model_version)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
