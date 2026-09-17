import logging
import json
import urllib.request
from typing import Dict, Any

logger = logging.getLogger(__name__)

# Fallback weather cache if Open-Meteo is unreachable or offline
DEMO_CACHED_WEATHER = {
    "temperature_c": 29.4,
    "relative_humidity_pct": 78.0,
    "rainfall_chance_pct": 65.0,
    "wind_speed_kmh": 14.2,
    "condition": "Overcast & Humid",
    "agricultural_relevance": "High relative humidity (>75%) with warm canopy temperature substantially elevates fungal spore germination and foliar blight development.",
    "forecast": [
        {"day": "Today", "temp_max": 31, "temp_min": 24, "rain_pct": 65, "condition": "Scattered Rain"},
        {"day": "Tomorrow", "temp_max": 30, "temp_min": 23, "rain_pct": 70, "condition": "Thunderstorms"},
        {"day": "Day +2", "temp_max": 32, "temp_min": 24, "rain_pct": 40, "condition": "Partly Cloudy"},
        {"day": "Day +3", "temp_max": 33, "temp_min": 25, "rain_pct": 20, "condition": "Sunny Intervals"},
    ],
    "source": "Open-Meteo (Demo / Cached)"
}

def get_current_weather(latitude: float = 21.7051, longitude: float = 71.9712) -> Dict[str, Any]:
    url = f"https://api.open-meteo.com/v1/forecast?latitude={latitude}&longitude={longitude}&current=temperature_2m,relative_humidity_2m,precipitation,wind_speed_10m&daily=temperature_2m_max,temperature_2m_min,precipitation_probability_max&timezone=auto"
    try:
        req = urllib.request.Request(url, headers={"User-Agent": "FasalRakshak/1.0"})
        with urllib.request.urlopen(req, timeout=4) as response:
            if response.status == 200:
                data = json.loads(response.read().decode("utf-8"))
                curr = data.get("current", {})
                daily = data.get("daily", {})
                temp = curr.get("temperature_2m", 29.4)
                humidity = curr.get("relative_humidity_2m", 78.0)
                rain_chance = daily.get("precipitation_probability_max", [65.0])[0] if daily.get("precipitation_probability_max") else 65.0
                wind = curr.get("wind_speed_10m", 14.2)

            
            # Formulate agricultural relevance
            relevance = "Optimal growing conditions."
            if humidity > 70:
                relevance = "Elevated humidity increases foliar fungal risk. Maintain plant spacing and avoid leaf wetness."
            if rain_chance > 50:
                relevance += " High rain probability may wash off contact protectants. Plan biological/organic sprays accordingly."

            return {
                "temperature_c": temp,
                "relative_humidity_pct": humidity,
                "rainfall_chance_pct": rain_chance,
                "wind_speed_kmh": wind,
                "condition": "Humid / Overcast" if humidity > 70 else "Clear / Mild",
                "agricultural_relevance": relevance,
                "forecast": [
                    {"day": "Today", "temp_max": daily.get("temperature_2m_max", [31])[0], "temp_min": daily.get("temperature_2m_min", [24])[0], "rain_pct": rain_chance, "condition": "Humid"},
                    {"day": "Tomorrow", "temp_max": daily.get("temperature_2m_max", [31, 30])[1] if len(daily.get("temperature_2m_max", [])) > 1 else 30, "temp_min": 23, "rain_pct": 60, "condition": "Scattered Clouds"},
                ],
                "source": "Open-Meteo Live API"
            }
    except Exception as e:
        logger.warning(f"Weather API request failed: {e}. Using resilient cached agro-weather.")
        return DEMO_CACHED_WEATHER
