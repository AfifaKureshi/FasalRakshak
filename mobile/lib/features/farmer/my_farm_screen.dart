import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/state/app_state.dart';
import '../common/custom_app_bar.dart';

class MyFarmScreen extends StatelessWidget {
  const MyFarmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: FasalAppBar(
        title: loc.tr('my_farm'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Farm Basic Info Card
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        appState.farmName,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.charcoal),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.healthy.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Verified Plot',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.healthy),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _buildDetailRow('Owner', appState.userName),
                  _buildDetailRow('Village / Taluka', 'Sihor'),
                  _buildDetailRow('District & State', 'Bhavnagar, Gujarat'),
                  _buildDetailRow('GPS Coordinates', '21.7051° N, 71.9712° E'),
                  _buildDetailRow('Survey Number', 'GUJ/BHAV/2026/894'),
                  _buildDetailRow('Total Plot Area', '4.5 Acres (1.82 Hectares)'),
                  const Divider(height: 20, color: AppColors.stone),
                  _buildDetailRow('Primary Crop', appState.crop),
                  _buildDetailRow('Variety', appState.variety),
                  _buildDetailRow('Crop Growth Stage', appState.cropStage),
                  _buildDetailRow('Sowing Date', '02 August 2026 (45 days active)'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Soil & Microclimate Sensor / IoT Card
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.sensors, size: 20, color: AppColors.deepPine),
                          SizedBox(width: 8),
                          Text(
                            'Soil & Moisture Telemetry',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.charcoal),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.forest.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Manual / IoT Data',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.forest),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSoilMetric('Moisture', '${appState.soilMoisture.toStringAsFixed(0)}%', Icons.water),
                      _buildSoilMetric('Soil pH', '${appState.soilPh.toStringAsFixed(1)}', Icons.science),
                      _buildSoilMetric('Temperature', '${appState.soilTemp.toStringAsFixed(1)}°C', Icons.thermostat),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow('Soil Classification', appState.soilType),
                  _buildDetailRow('Drainage Status', 'Moderate Retention (Black Cotton Clay)'),
                  _buildDetailRow('Organic Carbon', '0.68% (Adequate for Solanaceous Crops)'),
                  const SizedBox(height: 12),
                  const Text(
                    'Note: Sensor values simulated for hackathon presentation. Hardware connector interface ready for ESP32 capacitive probe integration.',
                    style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: AppColors.muted),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
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

  Widget _buildSoilMetric(String label, String value, IconData icon) {
    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.forest.withOpacity(0.1),
          child: Icon(icon, color: AppColors.forest, size: 20),
        ),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.charcoal)),
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.muted)),
      ],
    );
  }
}
