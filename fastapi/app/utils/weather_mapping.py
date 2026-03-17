"""
날씨 상태 매핑 테이블
- OpenWeatherMap weather.main → 한글 매핑 (기존 유지)
- Open-Meteo WMO weather_code → OpenWeatherMap main/icon 매핑 (추가)
작성일: 2026-01-15
수정일: 2026-03-18 - Open-Meteo WMO 코드 매핑 추가
"""

# OpenWeatherMap weather.main → 한글 매핑
WEATHER_TYPE_MAPPING = {
    "Clear": "맑음",
    "Clouds": "흐림",
    "Rain": "비",
    "Drizzle": "이슬비",
    "Thunderstorm": "천둥번개",
    "Snow": "눈",
    "Mist": "안개",
    "Fog": "짙은 안개",
    "Haze": "연무",
    "Dust": "먼지",
    "Sand": "모래",
    "Ash": "화산재",
    "Squall": "돌풍",
    "Tornado": "토네이도"
}

# OpenWeatherMap weather.main → 아이콘 코드 매핑 (기본값)
# 실제 아이콘 코드는 API 응답의 weather[].icon을 사용하지만,
# 매핑이 실패할 경우를 대비한 기본값
WEATHER_ICON_MAPPING = {
    "Clear": "01d",      # 맑음 (낮)
    "Clouds": "02d",     # 흐림
    "Rain": "10d",       # 비
    "Drizzle": "09d",    # 이슬비
    "Thunderstorm": "11d",  # 천둥번개
    "Snow": "13d",       # 눈
    "Mist": "50d",       # 안개
    "Fog": "50d",        # 짙은 안개
    "Haze": "50d",       # 연무
    "Dust": "50d",       # 먼지
    "Sand": "50d",       # 모래
    "Ash": "50d",        # 화산재
    "Squall": "11d",     # 돌풍
    "Tornado": "11d"     # 토네이도
}


def get_weather_type_korean(weather_main: str) -> str:
    """
    OpenWeatherMap weather.main 값을 한글로 변환
    
    Args:
        weather_main: OpenWeatherMap API의 weather.main 값 (예: "Clear", "Rain")
        
    Returns:
        str: 한글 날씨 상태 (예: "맑음", "비")
        매핑되지 않은 경우 원본 값 반환
    """
    return WEATHER_TYPE_MAPPING.get(weather_main, weather_main)


def get_weather_icon_url(icon_code: str, size: str = "2x") -> str:
    """
    OpenWeatherMap 아이콘 URL 생성
    
    Args:
        icon_code: OpenWeatherMap API의 weather.icon 값 (예: "01d", "10n")
        size: 아이콘 크기 ("1x", "2x", "4x"), 기본값 "2x"
        
    Returns:
        str: OpenWeatherMap 아이콘 URL
        예: "http://openweathermap.org/img/wn/01d@2x.png"
    """
    base_url = "http://openweathermap.org/img/wn"
    return f"{base_url}/{icon_code}@{size}.png"


# Open-Meteo WMO weather_code → (OpenWeatherMap main, icon_code) 매핑
# WMO: https://open-meteo.com/en/docs - Weather interpretation codes (WW)
WMO_TO_OWM_MAPPING = {
    0: ("Clear", "01d"),
    1: ("Clear", "01d"),       # Mainly clear
    2: ("Clouds", "02d"),      # Partly cloudy
    3: ("Clouds", "04d"),     # Overcast
    45: ("Fog", "50d"),
    48: ("Fog", "50d"),       # Depositing rime fog
    51: ("Drizzle", "09d"),   # Drizzle: Light
    53: ("Drizzle", "09d"),   # Drizzle: Moderate
    55: ("Drizzle", "09d"),   # Drizzle: Dense
    56: ("Drizzle", "09d"),   # Freezing Drizzle: Light
    57: ("Drizzle", "09d"),   # Freezing Drizzle: Dense
    61: ("Rain", "10d"),     # Rain: Slight
    63: ("Rain", "10d"),     # Rain: Moderate
    65: ("Rain", "10d"),     # Rain: Heavy
    66: ("Rain", "10d"),     # Freezing Rain: Light
    67: ("Rain", "10d"),     # Freezing Rain: Heavy
    71: ("Snow", "13d"),     # Snow: Slight
    73: ("Snow", "13d"),     # Snow: Moderate
    75: ("Snow", "13d"),     # Snow: Heavy
    77: ("Snow", "13d"),     # Snow grains
    80: ("Rain", "09d"),     # Rain showers: Slight
    81: ("Rain", "09d"),     # Rain showers: Moderate
    82: ("Rain", "09d"),     # Rain showers: Violent
    85: ("Snow", "13d"),     # Snow showers: Slight
    86: ("Snow", "13d"),     # Snow showers: Heavy
    95: ("Thunderstorm", "11d"),
    96: ("Thunderstorm", "11d"),  # Thunderstorm with slight hail
    99: ("Thunderstorm", "11d"),  # Thunderstorm with heavy hail
}


def get_weather_main_from_wmo(wmo_code: int) -> tuple[str, str]:
    """
    Open-Meteo WMO weather_code를 OpenWeatherMap main, icon_code로 변환

    Args:
        wmo_code: Open-Meteo API의 weather_code (WMO)

    Returns:
        tuple: (weather_main, icon_code) - 매핑 실패 시 ("Clear", "01d")
    """
    return WMO_TO_OWM_MAPPING.get(wmo_code, ("Clear", "01d"))


def get_default_icon_code(weather_main: str) -> str:
    """
    weather.main 값으로부터 기본 아이콘 코드 반환
    (API 응답에 icon이 없을 경우 사용)
    
    Args:
        weather_main: OpenWeatherMap API의 weather.main 값 또는 한글 날씨 상태
        
    Returns:
        str: 기본 아이콘 코드
    """
    # 한글 날씨 상태인 경우 영문으로 역매핑
    korean_to_english = {v: k for k, v in WEATHER_TYPE_MAPPING.items()}
    weather_main_en = korean_to_english.get(weather_main, weather_main)
    return WEATHER_ICON_MAPPING.get(weather_main_en, "01d")
