"""
DDRI 사용자 페이지 API - 근처 대여소 조회
14_ddri_api_schema.md 기준
"""

from fastapi import APIRouter, Query
from typing import Optional

router = APIRouter()


@router.get("/stations/nearby")
async def get_stations_nearby(
    lat: float = Query(..., description="위도"),
    lng: float = Query(..., description="경도"),
    target_datetime: str = Query(..., description="예측 기준 시각 (ISO 8601, 예: 2026-03-18T18:00:00+09:00)"),
    limit: Optional[int] = Query(20, ge=1, le=50, description="반환 개수"),
    radius_m: Optional[int] = Query(None, description="반경(m). 미지정 시 전체 중 거리순"),
):
    """
    근처 대여소 목록 조회 (거리순, 지정 시간대 예측)

    - 사용자 페이지용
    - lat, lng 기준 거리순 정렬
    - 목업 응답 (실제 DB 연동 시 stations + realtime_station_stock + station_demand_forecasts)
    """
    # TODO: DB 연동 - stations, realtime_station_stock, station_demand_forecasts
    return {
        "target_datetime": target_datetime,
        "user_location": {"lat": lat, "lng": lng},
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
                "bike_availability_flag": True,
                "availability_level": "low",
                "operational_status": "operational",
            },
            {
                "station_id": 2348,
                "station_name": "강남역 2번출구 앞",
                "address": "서울 강남구 역삼동 456-78",
                "latitude": 37.4985,
                "longitude": 127.0276,
                "distance_m": 320,
                "current_bike_stock": 12,
                "predicted_rental_count": 8.0,
                "predicted_remaining_bikes": 4.0,
                "bike_availability_flag": True,
                "availability_level": "normal",
                "operational_status": "operational",
            },
        ],
        "exceptions": [
            {"station_id": 2314, "reason": "실시간 비노출"},
        ],
    }
