import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/app_constants.dart';

class WeatherData {
  final double tempC;
  final double humidityPct;
  final double rainChancePct;
  final double windKmh;
  final String condition;
  final String agriculturalRelevance;
  final List<Map<String, dynamic>> forecast;
  final String source;

  WeatherData({
    required this.tempC,
    required this.humidityPct,
    required this.rainChancePct,
    required this.windKmh,
    required this.condition,
    required this.agriculturalRelevance,
    required this.forecast,
    required this.source,
  });

  factory WeatherData.cachedDefault() {
    return WeatherData(
      tempC: 29.4,
      humidityPct: 78.0,
      rainChancePct: 65.0,
      windKmh: 14.2,
      condition: 'Overcast & Humid',
      agriculturalRelevance:
          'High relative humidity (>75%) with warm canopy temperature substantially elevates fungal spore germination and foliar blight development.',
      forecast: [
        {'day': 'Today', 'temp': 31, 'rain_pct': 65, 'cond': 'Scattered Rain'},
        {'day': 'Tomorrow', 'temp': 30, 'rain_pct': 70, 'cond': 'Thunderstorms'},
        {'day': 'Day +2', 'temp': 32, 'rain_pct': 40, 'cond': 'Partly Cloudy'},
      ],
      source: 'Cached Agro-Weather',
    );
  }

  factory WeatherData.fromMap(Map<String, dynamic> map) {
    return WeatherData(
      tempC: (map['temperature_c'] as num?)?.toDouble() ?? 29.4,
      humidityPct: (map['relative_humidity_pct'] as num?)?.toDouble() ?? 78.0,
      rainChancePct: (map['rainfall_chance_pct'] as num?)?.toDouble() ?? 65.0,
      windKmh: (map['wind_speed_kmh'] as num?)?.toDouble() ?? 14.2,
      condition: map['condition'] ?? 'Humid',
      agriculturalRelevance: map['agricultural_relevance'] ?? '',
      forecast: List<Map<String, dynamic>>.from(map['forecast'] ?? []),
      source: map['source'] ?? 'Open-Meteo',
    );
  }
}

class WeatherService {
  static final WeatherService instance = WeatherService._();
  WeatherService._();

  Future<WeatherData> fetchWeather({
    double lat = 21.7051,
    double lng = 71.9712,
    bool isOffline = false,
  }) async {
    if (isOffline) {
      return WeatherData.cachedDefault();
    }
    try {
      final response = await http
          .get(Uri.parse('${AppConstants.defaultApiBaseUrl}/weather'))
          .timeout(const Duration(seconds: 3));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return WeatherData.fromMap(data);
      }
    } catch (_) {
      // Fallback on network failure
    }
    return WeatherData.cachedDefault();
  }
}
