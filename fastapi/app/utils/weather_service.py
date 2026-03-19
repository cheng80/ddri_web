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
                    weather_high, precipitation_probability_max, icon_code, icon_url, weather_code
        """
        params = {
            "latitude": lat,
            "longitude": lon,
            "timezone": timezone,
            "daily": "temperature_2m_max,temperature_2m_min,weather_code,precipitation_probability_max",
            "forecast_days": 7,
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
            precipitation_probabilities = data["daily"].get("precipitation_probability_max", [])

            today = datetime.now().date()
            max_date = today + timedelta(days=6)

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
                    raise ValueError(f"예보는 오늘부터 최대 7일까지만 조회 가능합니다. (요청: {start_date_only})")

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
                precipitation_probability = (
                    precipitation_probabilities[i] if i < len(precipitation_probabilities) else None
                )
                raw_weather_code = weather_codes[i] if i < len(weather_codes) else 0
                wmo_code = int(raw_weather_code) if raw_weather_code is not None else 0

                weather_low = float(weather_low) if weather_low is not None else 0.0
                weather_high = float(weather_high) if weather_high is not None else 0.0
                precipitation_probability = (
                    float(precipitation_probability) if precipitation_probability is not None else 0.0
                )
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
                    "precipitation_probability_max": precipitation_probability,
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

    def fetch_single_datetime_weather(
        self,
        lat: float = DEFAULT_LAT,
        lon: float = DEFAULT_LON,
        target_datetime: Optional[datetime] = None,
        timezone: str = DEFAULT_TIMEZONE,
    ) -> Dict:
        """
        Open-Meteo API에서 특정 시각에 가장 가까운 시간별 예보 1건을 가져온다.

        - 시간별 날씨/강수확률은 선택 시각 기준으로 제공
        - 최고/최저 기온은 같은 날짜의 일별 예보에서 보강
        """
        now = datetime.now()
        target_dt = target_datetime or now

        if isinstance(target_dt, str):
            try:
                target_dt = datetime.fromisoformat(target_dt)
            except ValueError:
                raise ValueError(f"날짜 형식이 올바르지 않습니다. (ISO datetime): {target_datetime}")

        if target_dt.tzinfo is not None:
            target_dt = target_dt.astimezone().replace(tzinfo=None)

        today = now.date()
        max_date = today + timedelta(days=6)
        target_date = target_dt.date()

        if target_date < today:
            raise ValueError("과거 날짜의 실시간 예보는 조회할 수 없습니다.")
        if target_date > max_date:
            raise ValueError(f"예보는 오늘부터 최대 7일까지만 조회 가능합니다. (요청: {target_date})")

        params = {
            "latitude": lat,
            "longitude": lon,
            "timezone": timezone,
            "hourly": "temperature_2m,weather_code,precipitation_probability",
            "forecast_days": 7,
        }

        try:
            response = requests.get(OPEN_METEO_BASE_URL, params=params, timeout=10)
            response.raise_for_status()
            data = response.json()

            if "hourly" not in data or "time" not in data["hourly"]:
                raise ValueError("API 응답에 hourly 데이터가 없습니다.")

            times = data["hourly"]["time"]
            temperatures = data["hourly"].get("temperature_2m", [])
            weather_codes = data["hourly"].get("weather_code", [])
            precipitation_probabilities = data["hourly"].get("precipitation_probability", [])

            best_index = None
            best_diff_seconds = None
            for i, time_str in enumerate(times):
                try:
                    dt = datetime.strptime(time_str, "%Y-%m-%dT%H:%M")
                except ValueError:
                    continue

                if dt.date() != target_date:
                    continue

                diff_seconds = abs((dt - target_dt).total_seconds())
                if best_diff_seconds is None or diff_seconds < best_diff_seconds:
                    best_index = i
                    best_diff_seconds = diff_seconds

            if best_index is None:
                raise ValueError(f"해당 시각({target_dt.isoformat()})의 시간별 날씨 데이터를 찾을 수 없습니다.")

            best_dt = datetime.strptime(times[best_index], "%Y-%m-%dT%H:%M")
            raw_weather_code = weather_codes[best_index] if best_index < len(weather_codes) else 0
            wmo_code = int(raw_weather_code) if raw_weather_code is not None else 0
            precipitation_probability = (
                float(precipitation_probabilities[best_index])
                if best_index < len(precipitation_probabilities)
                and precipitation_probabilities[best_index] is not None
                else 0.0
            )
            temperature = (
                float(temperatures[best_index])
                if best_index < len(temperatures) and temperatures[best_index] is not None
                else 0.0
            )

            daily_forecast = self.fetch_single_day_weather(
                lat=lat,
                lon=lon,
                target_date=target_dt,
                timezone=timezone,
            )

            weather_main, icon_code = get_weather_main_from_wmo(wmo_code)

            return {
                "dt": int(best_dt.timestamp()),
                "weather_datetime": best_dt,
                "weather_type": get_weather_type_korean(weather_main),
                "weather_type_en": weather_main,
                "weather_low": daily_forecast["weather_low"],
                "weather_high": daily_forecast["weather_high"],
                "temperature": temperature,
                "precipitation_probability": precipitation_probability,
                "icon_code": icon_code,
                "icon_url": get_weather_icon_url(icon_code),
                "weather_code": wmo_code,
            }

        except requests.RequestException as e:
            raise requests.RequestException(f"Open-Meteo API 요청 실패: {str(e)}") from e
        except (KeyError, ValueError, TypeError) as e:
            raise ValueError(f"API 응답 파싱 실패: {str(e)}") from e
