"""
Open-Meteo API 서비스
날씨 데이터를 가져오는 서비스 (DB 저장 없음, API 키 불필요)
작성일: 2026-03-18
"""

import requests
from datetime import datetime, timedelta
from typing import List, Dict, Optional
from .weather_mapping import get_weather_type_korean, get_weather_icon_url, get_weather_main_from_wmo

OPEN_METEO_BASE_URL = "https://api.open-meteo.com/v1/forecast"
DEFAULT_TIMEZONE = "Asia/Seoul"

# 기본 위치 (서울)
DEFAULT_LAT = 37.5665
DEFAULT_LON = 126.9780


class WeatherService:
    """Open-Meteo API를 사용하여 날씨 데이터를 가져오는 서비스 (API 키 불필요)"""

    def __init__(self):
        pass

    def fetch_daily_forecast(
        self,
        lat: float = DEFAULT_LAT,
        lon: float = DEFAULT_LON,
        start_date: Optional[datetime] = None,
        timezone: str = DEFAULT_TIMEZONE,
    ) -> List[Dict]:
        """
        Open-Meteo Forecast API에서 일별 예보 가져오기

        Args:
            lat: 위도 (기본값: 서울)
            lon: 경도 (기본값: 서울)
            start_date: 시작 날짜 (None이면 오늘 포함 7일치 모두 반환)
            timezone: 타임존 (기본: Asia/Seoul)

        Returns:
            List[Dict]: 날씨 데이터 리스트
            - start_date가 None이면: 오늘 포함 7일치 모두 반환
            - start_date가 지정되면: 해당 날짜부터 남은 날짜만 반환
            각 Dict: dt, weather_datetime, weather_type, weather_type_en, weather_low,
                    weather_high, icon_code, icon_url, weather_code
        """
        params = {
            "latitude": lat,
            "longitude": lon,
            "timezone": timezone,
            "daily": "temperature_2m_max,temperature_2m_min,weather_code",
            "forecast_days": 16,
        }

        try:
            response = requests.get(OPEN_METEO_BASE_URL, params=params, timeout=10)
            response.raise_for_status()
            data = response.json()

            if "daily" not in data or "time" not in data["daily"]:
                raise ValueError("API 응답에 daily 데이터가 없습니다.")

            times = data["daily"]["time"]
            temp_max = data["daily"].get("temperature_2m_max", [])
            temp_min = data["daily"].get("temperature_2m_min", [])
            weather_codes = data["daily"].get("weather_code", [])

            today = datetime.now().date()
            max_date = today + timedelta(days=15)

            start_date_only = None
            if start_date:
                if isinstance(start_date, datetime):
                    start_date_only = start_date.date()
                elif isinstance(start_date, str):
                    try:
                        start_date_only = datetime.strptime(start_date, "%Y-%m-%d").date()
                    except ValueError:
                        raise ValueError(f"날짜 형식이 올바르지 않습니다. (YYYY-MM-DD): {start_date}")
                else:
                    start_date_only = start_date

                if start_date_only < today:
                    raise ValueError("과거 날짜의 실시간 예보는 조회할 수 없습니다.")
                if start_date_only > max_date:
                    raise ValueError(f"예보는 오늘부터 최대 16일까지만 조회 가능합니다. (요청: {start_date_only})")

            result = []
            for i, time_str in enumerate(times):
                try:
                    dt = datetime.strptime(time_str, "%Y-%m-%d")
                except ValueError:
                    continue
                weather_date = dt.date()

                if start_date_only and weather_date < start_date_only:
                    continue

                weather_low = temp_min[i] if i < len(temp_min) else None
                weather_high = temp_max[i] if i < len(temp_max) else None
                wmo_code = int(weather_codes[i]) if i < len(weather_codes) else 0

                weather_low = float(weather_low) if weather_low is not None else 0.0
                weather_high = float(weather_high) if weather_high is not None else 0.0
                if weather_low > weather_high:
                    weather_low, weather_high = weather_high, weather_low

                weather_main, icon_code = get_weather_main_from_wmo(wmo_code)

                result.append({
                    "dt": int(dt.timestamp()),
                    "weather_datetime": dt.replace(hour=0, minute=0, second=0, microsecond=0),
                    "weather_type": get_weather_type_korean(weather_main),
                    "weather_type_en": weather_main,
                    "weather_low": weather_low,
                    "weather_high": weather_high,
                    "icon_code": icon_code,
                    "icon_url": get_weather_icon_url(icon_code),
                    "weather_code": wmo_code,
                })

            return result

        except requests.RequestException as e:
            raise requests.RequestException(f"Open-Meteo API 요청 실패: {str(e)}") from e
        except (KeyError, ValueError, TypeError) as e:
            raise ValueError(f"API 응답 파싱 실패: {str(e)}") from e

    def fetch_single_day_weather(
        self,
        lat: float = DEFAULT_LAT,
        lon: float = DEFAULT_LON,
        target_date: Optional[datetime] = None,
        timezone: str = DEFAULT_TIMEZONE,
    ) -> Dict:
        """
        Open-Meteo API에서 특정 날짜의 날씨 데이터만 가져오기 (하루치)

        Args:
            lat: 위도
            lon: 경도
            target_date: 조회할 날짜 (None이면 오늘)
            timezone: 타임존

        Returns:
            Dict: 날씨 데이터 (하루치)
        """
        if target_date:
            if isinstance(target_date, datetime):
                target_date_only = target_date.date()
            elif isinstance(target_date, str):
                try:
                    target_date_only = datetime.strptime(target_date, "%Y-%m-%d").date()
                except ValueError:
                    raise ValueError(f"날짜 형식이 올바르지 않습니다. (YYYY-MM-DD): {target_date}")
            else:
                target_date_only = target_date
        else:
            target_date_only = datetime.now().date()

        forecast_list = self.fetch_daily_forecast(
            lat=lat,
            lon=lon,
            start_date=target_date_only,
            timezone=timezone,
        )

        if not forecast_list:
            raise ValueError(f"해당 날짜({target_date_only})의 날씨 데이터를 찾을 수 없습니다.")

        return forecast_list[0]
