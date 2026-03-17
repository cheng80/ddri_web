"""
DDRI 관리자 페이지 API - 재배치 판단 목록 조회
14_ddri_api_schema.md 기준
"""

from fastapi import APIRouter, Query
from typing import Optional

router = APIRouter()


@router.get("/stations/risk")
async def get_stations_risk(
    base_datetime: str = Query(..., description="기준 시각 (ISO 8601)"),
    urgent_only: Optional[bool] = Query(None, description="true 시 위험 대여소만"),
    district_name: Optional[str] = Query(None, description="행정동 필터 (예: 역삼동)"),
    cluster_code: Optional[str] = Query(None, description="지역 특성 필터 (예: cluster00)"),
    sort_by: Optional[str] = Query(
        "risk_score",
        description="risk_score | reallocation_priority | stock_gap",
    ),
    sort_order: Optional[str] = Query("desc", description="asc | desc"),
):
    """
    재배치 판단 목록 조회 (시간대별 위험도·우선순위)

    - 관리자 페이지용
    - 목업 응답 (실제 DB 연동 시 station_risk_snapshots)
    """
    # TODO: DB 연동 - station_risk_snapshots, stations
    return {
        "base_datetime": base_datetime,
        "summary": {
            "total_count": 161,
            "risk_count": 23,
            "exception_count": 3,
            "avg_risk_score": 0.42,
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
                "operational_status": "operational",
            },
            {
                "station_id": 2348,
                "station_name": "강남역 2번출구 앞",
                "district_name": "역삼동",
                "cluster_code": "cluster01",
                "current_bike_stock": 3,
                "predicted_demand": 8.0,
                "stock_gap": -5.0,
                "risk_score": 0.68,
                "reallocation_priority": 2,
                "operational_status": "operational",
            },
        ],
        "exceptions": [
            {"station_id": 2314, "reason": "실시간 비노출"},
            {"station_id": 2323, "reason": "실시간 비노출"},
            {"station_id": 3628, "reason": "실시간 비노출"},
        ],
    }
