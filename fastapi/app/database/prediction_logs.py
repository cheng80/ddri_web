"""
예측 로그 저장 유틸리티.

- prediction_logs 테이블 생성 보장
- 사용자/관리자 API 응답 시 생성한 예측 결과를 최소 메타데이터로 저장
- DB 실패가 조회 API 본 흐름을 깨지 않도록 best-effort로 동작
"""

from __future__ import annotations

from datetime import datetime
import logging
from pathlib import Path

import pymysql

from .connection import DB_CONFIG, connect_db


logger = logging.getLogger(__name__)
_SCHEMA_READY = False


def _connect_server_without_database():
    server_config = dict(DB_CONFIG)
    server_config.pop("database", None)
    return pymysql.connect(**server_config)


def _normalize_datetime(value: str | datetime | None) -> datetime | None:
    if value is None:
        return None
    if isinstance(value, datetime):
        return value.replace(tzinfo=None)

    normalized = str(value).strip()
    if not normalized:
        return None

    try:
        return datetime.fromisoformat(
            normalized.replace("Z", "+00:00")
        ).replace(tzinfo=None)
    except ValueError:
        return None


def ensure_prediction_logs_schema() -> None:
    """prediction_logs 테이블이 없으면 생성한다."""
    global _SCHEMA_READY
    if _SCHEMA_READY:
        return

    schema_path = Path(__file__).resolve().parents[2] / "mysql" / "init_schema.sql"
    sql_script = schema_path.read_text(encoding="utf-8")
    statements = [
        statement.strip() for statement in sql_script.split(";") if statement.strip()
    ]

    try:
        conn = connect_db()
    except Exception:
        conn = _connect_server_without_database()
    try:
        with conn.cursor() as cursor:
            for statement in statements:
                cursor.execute(statement)
        conn.commit()
        _SCHEMA_READY = True
    finally:
        conn.close()


def save_prediction_logs(logs: list[dict]) -> int:
    """예측 로그 목록을 저장한다. 저장 수를 반환한다."""
    if not logs:
        return 0

    ensure_prediction_logs_schema()

    rows = []
    for log in logs:
      rows.append(
        (
          _normalize_datetime(log.get("prediction_time")),
          _normalize_datetime(log.get("target_time")),
          int(log["station_id"]),
          str(log.get("request_path") or "")[:32] or None,
          int(log["horizon_hours"]),
          float(log["current_bike_stock"]) if log.get("current_bike_stock") is not None else None,
          float(log["predicted_rental_count"]) if log.get("predicted_rental_count") is not None else None,
          float(log["predicted_return_count"]) if log.get("predicted_return_count") is not None else None,
          float(log["predicted_net_change"]) if log.get("predicted_net_change") is not None else None,
          float(log["predicted_remaining_bikes"]) if log.get("predicted_remaining_bikes") is not None else None,
          str(log.get("model_version") or "")[:64] or None,
          _normalize_datetime(log.get("source_updated_at")),
        )
      )

    insert_sql = """
    INSERT INTO prediction_logs (
      prediction_time,
      target_time,
      station_id,
      request_path,
      horizon_hours,
      current_bike_stock,
      predicted_rental_count,
      predicted_return_count,
      predicted_net_change,
      predicted_remaining_bikes,
      model_version,
      source_updated_at
    ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
    """

    conn = connect_db()
    try:
        with conn.cursor() as cursor:
            cursor.executemany(insert_sql, rows)
        conn.commit()
        return len(rows)
    finally:
        conn.close()


def save_prediction_logs_safely(logs: list[dict]) -> int:
    """예측 로그 저장 실패를 경고 로그로만 남기고 API 흐름은 유지한다."""
    try:
        saved = save_prediction_logs(logs)
        if saved:
            logger.info("[DDRI][db] prediction_logs saved=%s", saved)
        return saved
    except Exception as exc:
        logger.warning("[DDRI][db] prediction_logs save skipped: %s", exc)
        return 0
