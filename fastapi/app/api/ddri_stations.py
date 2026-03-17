"""
DDRI 스테이션 마스터 API - 161개 대여소 목록
14_ddri_api_schema.md 기준 (선택)
"""

from fastapi import APIRouter, Query
from typing import Optional

router = APIRouter()


@router.get("")
async def get_stations(
    district_name: Optional[str] = Query(None, description="행정동 필터"),
    cluster_code: Optional[str] = Query(None, description="지역 특성 필터 (cluster00~04)"),
):
    """
    스테이션 마스터 목록 조회 (161개)

    - stations 테이블 기반
    - 목업 응답 (실제 DB 연동 시)
    """
    # TODO: DB 연동 - stations
    return {
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
                "operational_status": "operational",
            },
            {
                "station_id": 2348,
                "api_station_id": "ST-1235",
                "station_name": "강남역 2번출구 앞",
                "district_name": "역삼동",
                "address": "서울 강남구 역삼동 456-78",
                "latitude": 37.4985,
                "longitude": 127.0276,
                "cluster_code": "cluster01",
                "operational_status": "operational",
            },
        ],
        "total_count": 161,
    }
