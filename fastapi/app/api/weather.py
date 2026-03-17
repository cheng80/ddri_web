"""
Weather API - Open-Meteo API 조회 (DB 저장 없음, API 키 불필요)
작성일: 2026-03-18
"""

from fastapi import APIRouter, Query
from typing import Optional
from datetime import datetime
from ..utils.weather_service import WeatherService

router = APIRouter()


@router.get("/direct")
async def fetch_weather_direct(
    lat: float = Query(..., description="위도 (필수)"),
    lon: float = Query(..., description="경도 (필수)"),
    start_date: Optional[str] = Query(None, description="시작 날짜 (YYYY-MM-DD), 없으면 오늘 포함 7일치 모두 반환"),
):
    """
    Open-Meteo API에서 직접 날씨 데이터 가져오기 (DB 저장 없음)

    - lat, lon으로 Open-Meteo Forecast API 호출
    - start_date가 없으면: 오늘 포함 7일치 모두 반환
    - start_date가 있으면: 해당 날짜부터 남은 날짜만 반환 (최대 16일)
    - API 키 불필요
    """
    try:
        start_date_obj = None
        if start_date:
            try:
                start_date_obj = datetime.strptime(start_date, "%Y-%m-%d")
            except ValueError:
                return {
                    "result": "Error",
                    "errorMsg": f"날짜 형식이 올바르지 않습니다. (YYYY-MM-DD 형식 필요): {start_date}",
                }

        weather_service = WeatherService()
        forecast_list = weather_service.fetch_daily_forecast(
            lat=lat,
            lon=lon,
            start_date=start_date_obj,
        )

        results = []
        for forecast in forecast_list:
            weather_datetime = forecast["weather_datetime"]
            if isinstance(weather_datetime, datetime):
                weather_datetime_str = weather_datetime.isoformat()
            else:
                weather_datetime_str = str(weather_datetime)

            results.append({
                "weather_datetime": weather_datetime_str,
                "weather_type": forecast["weather_type"],
                "weather_low": forecast["weather_low"],
                "weather_high": forecast["weather_high"],
                "icon_url": forecast["icon_url"],
            })

        return {"results": results}

    except ValueError as e:
        return {"result": "Error", "errorMsg": str(e)}
    except Exception as e:
        import traceback
        return {
            "result": "Error",
            "errorMsg": str(e),
            "traceback": traceback.format_exc(),
        }


@router.get("/direct/single")
async def fetch_weather_direct_single(
    lat: float = Query(..., description="위도 (필수)"),
    lon: float = Query(..., description="경도 (필수)"),
    target_date: Optional[str] = Query(None, description="조회할 날짜 (YYYY-MM-DD), 없으면 오늘 날짜"),
):
    """
    Open-Meteo API에서 특정 날짜의 날씨 데이터만 가져오기 (하루치)

    - lat, lon으로 Open-Meteo Forecast API 호출
    - target_date가 없으면 오늘 날씨만 반환
    - target_date가 있으면 해당 날짜의 날씨만 반환 (오늘부터 최대 16일)
    - API 키 불필요
    """
    try:
        target_date_obj = None
        if target_date:
            try:
                target_date_obj = datetime.strptime(target_date, "%Y-%m-%d")
            except ValueError:
                return {
                    "result": "Error",
                    "errorMsg": f"날짜 형식이 올바르지 않습니다. (YYYY-MM-DD 형식 필요): {target_date}",
                }

        weather_service = WeatherService()
        forecast = weather_service.fetch_single_day_weather(
            lat=lat,
            lon=lon,
            target_date=target_date_obj,
        )

        weather_datetime = forecast["weather_datetime"]
        if isinstance(weather_datetime, datetime):
            weather_datetime_str = weather_datetime.isoformat()
        else:
            weather_datetime_str = str(weather_datetime)

        result = {
            "weather_datetime": weather_datetime_str,
            "weather_type": forecast["weather_type"],
            "weather_low": forecast["weather_low"],
            "weather_high": forecast["weather_high"],
            "icon_url": forecast["icon_url"],
        }

        return {"result": result}

    except ValueError as e:
        return {"result": "Error", "errorMsg": str(e)}
    except Exception as e:
        import traceback
        return {
            "result": "Error",
            "errorMsg": str(e),
            "traceback": traceback.format_exc(),
        }
