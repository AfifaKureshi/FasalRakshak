import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/state/app_state.dart';
import '../common/custom_app_bar.dart';

class RiskDetailsScreen extends StatelessWidget {
  const RiskDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final risk = appState.currentRisk;
    final w = appState.weather;

    Color riskColor;
    if (risk?.riskLevel == 'HIGH') {
      riskColor = AppColors.critical;
    } else if (risk?.riskLevel == 'LOW') {
      riskColor = AppColors.healthy;
    } else {
      riskColor = AppColors.moderate;
    }

    return Scaffold(
      appBar: FasalAppBar(
        title: 'Crop Risk Intelligence',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Overall Risk Score Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.ivory,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.stone),
              ),
              child: Column(
                children: [
                  Text(
                    'CURRENT CROP RISK',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: AppColors.muted,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    risk?.riskLevel ?? 'MODERATE',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: riskColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Multi-Factor Composite Score: ${(risk?.riskScore ?? 65.0).toStringAsFixed(0)} / 100',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.charcoal),
                  ),
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: ((risk?.riskScore ?? 65.0) / 100).clamp(0.0, 1.0),
                      minHeight: 10,
                      backgroundColor: AppColors.stone.withOpacity(0.4),
                      valueColor: AlwaysStoppedAnimation<Color>(riskColor),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // "Why this risk?" Explainability Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.ivory,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.stone),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.psychology, size: 20, color: AppColors.deepPine),
                      SizedBox(width: 8),
                      Text(
                        'Why this risk?',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.charcoal),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    risk?.explanation ??
                        'Elevated atmospheric humidity combined with foliar lesion detection and recent rainfall forecast significantly increases pathogen vulnerability.',
                    style: const TextStyle(fontSize: 13, height: 1.4, color: AppColors.charcoal),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'Risk Contributing Factors:',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.muted),
                  ),
                  const SizedBox(height: 10),

                  // Factors breakdown list
                  if (risk != null)
                    ...risk.factors.map((f) => Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.warmSand.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.stone.withOpacity(0.7)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: f.impact == 'High'
                                      ? AppColors.critical.withOpacity(0.15)
                                      : AppColors.harvestGold.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '+${f.points} pts',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: f.impact == 'High' ? AppColors.critical : AppColors.harvestGold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      f.factor,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.charcoal,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      f.description,
                                      style: const TextStyle(fontSize: 11, color: AppColors.muted),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Environmental Inputs Summary Card
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
                    'Active Field Parameters',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.charcoal),
                  ),
                  const SizedBox(height: 12),
                  _buildInputRow('Crop & Variety', '${appState.crop} (${appState.variety})'),
                  _buildInputRow('Growth Stage', appState.cropStage),
                  _buildInputRow('Relative Humidity', '${w.humidityPct.toStringAsFixed(0)}% (Elevated)'),
                  _buildInputRow('24h Rain Chance', '${w.rainChancePct.toStringAsFixed(0)}%'),
                  _buildInputRow('Soil Moisture', '${appState.soilMoisture}% (${appState.soilType})'),
                  _buildInputRow('Sticky Trap Count', '18 Whiteflies / trap'),
                  _buildInputRow('Regional Hotspot', 'Active early blight surge in Sihor block'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.deepPine,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Back to Dashboard'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildInputRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
          Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.charcoal),
          ),
        ],
      ),
    );
  }
}
