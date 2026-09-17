import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/state/app_state.dart';
import '../common/custom_app_bar.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final loc = AppLocalizations.of(context);
    final w = appState.weather;

    return Scaffold(
      appBar: FasalAppBar(
        title: loc.tr('weather'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Current Weather Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.ivory,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.stone),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Sihor, Bhavnagar',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.charcoal),
                          ),
                          Text(
                            'Source: ${w.source}',
                            style: const TextStyle(fontSize: 11, color: AppColors.muted),
                          ),
                        ],
                      ),
                      Text(
                        w.condition,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.weather),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.cloud_outlined, size: 54, color: AppColors.weather),
                      const SizedBox(width: 16),
                      Text(
                        '${w.tempC.toStringAsFixed(1)}°',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: AppColors.charcoal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMetricCol('Humidity', '${w.humidityPct.toStringAsFixed(0)}%', Icons.water_drop),
                      _buildMetricCol('Rain Probability', '${w.rainChancePct.toStringAsFixed(0)}%', Icons.umbrella),
                      _buildMetricCol('Wind Speed', '${w.windKmh.toStringAsFixed(0)} km/h', Icons.air),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Agricultural Impact Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.weather.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.weather.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.spa_outlined, color: AppColors.weather, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Agricultural Relevance & Disease Risk',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.charcoal),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    w.agriculturalRelevance,
                    style: const TextStyle(fontSize: 13, height: 1.4, color: AppColors.charcoal),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 3-Day Agro Forecast
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.ivory,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.stone),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Multi-Day Microclimate Forecast',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.charcoal),
                  ),
                  const SizedBox(height: 12),
                  ...w.forecast.map((f) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(f['day'] ?? '', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                            Text(f['cond'] ?? '', style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                            Row(
                              children: [
                                const Icon(Icons.umbrella, size: 13, color: AppColors.weather),
                                const SizedBox(width: 4),
                                Text('${f['rain_pct']}%', style: const TextStyle(fontSize: 12, color: AppColors.weather)),
                                const SizedBox(width: 12),
                                Text('${f['temp']}°C', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCol(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppColors.weather),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.charcoal)),
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.muted)),
      ],
    );
  }
}
