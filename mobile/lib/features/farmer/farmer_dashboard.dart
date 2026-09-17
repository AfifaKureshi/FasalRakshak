import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/state/app_state.dart';
import '../../services/sync/sync_service.dart';
import '../../data/local/local_storage_service.dart';
import '../common/custom_app_bar.dart';

class FarmerDashboard extends StatefulWidget {
  const FarmerDashboard({super.key});

  @override
  State<FarmerDashboard> createState() => _FarmerDashboardState();
}

class _FarmerDashboardState extends State<FarmerDashboard> {
  int _currentNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final syncService = Provider.of<SyncService>(context);
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: FasalAppBar(
        title: loc.tr('dashboard'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Farm & Risk Header Card
            _buildFarmHeader(appState, syncService, loc),
            const SizedBox(height: 16),

            // PRIMARY HERO CARD: Crop Doctor
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed('/check-crop-health');
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryGreen, Color(0xFF166534)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryGreen.withOpacity(0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                loc.tr('crop_doctor'),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.accentLime,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'AI',
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            loc.tr('check_crop_health'),
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Secondary Quick Actions Row
            Row(
              children: [
                Expanded(
                  child: _buildActionTile(
                    title: loc.tr('pest_trap'),
                    icon: Icons.bug_report_outlined,
                    color: AppColors.harvestGold,
                    onTap: () => Navigator.of(context).pushNamed('/pest-trap'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildActionTile(
                    title: loc.tr('why_this_risk'),
                    icon: Icons.shield_outlined,
                    color: AppColors.critical,
                    onTap: () => Navigator.of(context).pushNamed('/risk-details'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildActionTile(
                    title: loc.tr('weather'),
                    icon: Icons.cloud_outlined,
                    color: AppColors.weather,
                    onTap: () => Navigator.of(context).pushNamed('/weather'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildActionTile(
                    title: loc.tr('my_farm'),
                    icon: Icons.landscape_outlined,
                    color: AppColors.forest,
                    onTap: () => Navigator.of(context).pushNamed('/my-farm'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Crop Health Intelligence Card
            _buildCropHealthCard(appState, loc),
            const SizedBox(height: 14),

            // Continuous Monitoring Card (Day 0 vs Day 7)
            _buildMonitoringCard(appState, loc),
            const SizedBox(height: 14),

            // Agro-Weather Summary Card
            _buildWeatherSummaryCard(appState, loc),
            const SizedBox(height: 14),

            // Alerts Section
            _buildAlertsSection(appState, loc),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentNavIndex,
        selectedItemColor: AppColors.deepPine,
        unselectedItemColor: AppColors.muted,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.ivory,
        elevation: 8,
        onTap: (index) {
          setState(() => _currentNavIndex = index);
          if (index == 1) Navigator.of(context).pushNamed('/my-farm');
          if (index == 2) Navigator.of(context).pushNamed('/check-crop-health');
          if (index == 3) Navigator.of(context).pushNamed('/alerts');
          if (index == 4) Navigator.of(context).pushNamed('/history');
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_filled),
            label: loc.tr('dashboard'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.eco),
            label: loc.tr('my_farm'),
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: AppColors.deepPine,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
            ),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.notifications_outlined),
            label: loc.tr('alerts'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.history),
            label: loc.tr('history'),
          ),
        ],
      ),
    );
  }

  // --- TOP FARM HEADER ---
  Widget _buildFarmHeader(AppState appState, SyncService syncService, AppLocalizations loc) {
    Color riskColor;
    String riskText;
    final riskLevel = appState.currentRisk?.riskLevel ?? 'MODERATE';

    if (riskLevel == 'HIGH') {
      riskColor = AppColors.critical;
      riskText = loc.tr('high_risk');
    } else if (riskLevel == 'LOW') {
      riskColor = AppColors.healthy;
      riskText = loc.tr('low_risk');
    } else {
      riskColor = AppColors.moderate;
      riskText = loc.tr('moderate_risk');
    }

    return Container(
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good Morning, ${appState.userName}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.charcoal,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${appState.farmName} • ${appState.crop} (${appState.variety})',
                    style: const TextStyle(fontSize: 12, color: AppColors.muted),
                  ),
                ],
              ),
              // Sync Status Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: syncService.syncState == SyncState.synced
                      ? AppColors.healthy.withOpacity(0.12)
                      : AppColors.warning.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      syncService.syncState == SyncState.synced
                          ? Icons.check_circle_outline
                          : Icons.sync,
                      size: 13,
                      color: syncService.syncState == SyncState.synced
                          ? AppColors.healthy
                          : AppColors.warning,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      syncService.syncState == SyncState.synced
                          ? loc.tr('synced')
                          : loc.tr('pending_sync'),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: syncService.syncState == SyncState.synced
                            ? AppColors.healthy
                            : AppColors.warning,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 22, color: AppColors.stone),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(color: riskColor, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${loc.tr('risk_level')}: $riskText',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: riskColor,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => Navigator.of(context).pushNamed('/risk-details'),
                child: Row(
                  children: const [
                    Text(
                      'View Factors',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.forest),
                    ),
                    Icon(Icons.chevron_right, size: 16, color: AppColors.forest),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- SECONDARY ACTION TILE ---
  Widget _buildActionTile({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        decoration: BoxDecoration(
          color: AppColors.ivory,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.stone),
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: color.withOpacity(0.12),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.charcoal),
            ),
          ],
        ),
      ),
    );
  }

  // --- CROP HEALTH INTELLIGENCE CARD ---
  Widget _buildCropHealthCard(AppState appState, AppLocalizations loc) {
    final diag = appState.currentDiagnosis;
    final isLowConfidence = diag != null && diag.confidence < 0.70;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.ivory,
        borderRadius: BorderRadius.circular(14),
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
                  Icon(Icons.spa, size: 18, color: AppColors.forest),
                  SizedBox(width: 6),
                  Text(
                    'Latest Crop Health Assessment',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.charcoal),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isLowConfidence
                      ? AppColors.warning.withOpacity(0.15)
                      : AppColors.healthy.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isLowConfidence ? loc.tr('expert_review_recommended') : loc.tr('ai_result'),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isLowConfidence ? AppColors.warning : AppColors.healthy,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: AppColors.warmSand,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.stone),
                ),
                child: const Icon(Icons.image, size: 36, color: AppColors.muted),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      diag?.disease ?? 'Tomato Early Blight',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.charcoal),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'AI Confidence: ${(diag?.confidence ?? 0.54) * 100}% • Severity: ${diag?.severity ?? "Moderate"}',
                      style: const TextStyle(fontSize: 12, color: AppColors.muted),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Model: ${diag?.modelVersion ?? "EfficientNet-B0"}',
                      style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: AppColors.muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Primary advisory snippet
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.warmSand.withOpacity(0.6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline, size: 16, color: AppColors.forest),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    diag?.recommendations.split('\n').first ??
                        'Prune lower leaves to eliminate bottom soil spore splash.',
                    style: const TextStyle(fontSize: 12, height: 1.3, color: AppColors.charcoal),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- CONTINUOUS MONITORING CARD ---
  Widget _buildMonitoringCard(AppState appState, AppLocalizations loc) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.ivory,
        borderRadius: BorderRadius.circular(14),
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
                  Icon(Icons.timeline, size: 18, color: AppColors.deepPine),
                  SizedBox(width: 6),
                  Text(
                    '7-Day Continuous Monitoring',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.charcoal),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: appState.day7Completed
                      ? AppColors.healthy.withOpacity(0.15)
                      : AppColors.harvestGold.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  appState.day7Completed ? 'Day 7 Completed' : 'Follow-up Due',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: appState.day7Completed ? AppColors.healthy : AppColors.harvestGold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            appState.day7Completed
                ? 'Progression: ${appState.monitoringProgression}. Follow-up advisory active.'
                : 'Initial observation recorded at Day 0. Upload Day 7 follow-up image to evaluate pathogen regression.',
            style: const TextStyle(fontSize: 12, color: AppColors.charcoal),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => Navigator.of(context).pushNamed('/monitoring'),
            icon: const Icon(Icons.compare, size: 16),
            label: Text(appState.day7Completed ? 'View Day 0 vs Day 7' : 'Submit Day 7 Follow-Up'),
          ),
        ],
      ),
    );
  }

  // --- WEATHER SUMMARY CARD ---
  Widget _buildWeatherSummaryCard(AppState appState, AppLocalizations loc) {
    final w = appState.weather;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.ivory,
        borderRadius: BorderRadius.circular(14),
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
                  Icon(Icons.cloud_outlined, size: 18, color: AppColors.weather),
                  SizedBox(width: 6),
                  Text(
                    'Farm Microclimate & Weather',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.charcoal),
                  ),
                ],
              ),
              Text(
                w.condition,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.weather),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildWeatherMetric('Temp', '${w.tempC.toStringAsFixed(1)}°C', Icons.thermostat),
              _buildWeatherMetric('Humidity', '${w.humidityPct.toStringAsFixed(0)}%', Icons.water_drop),
              _buildWeatherMetric('Rain Chance', '${w.rainChancePct.toStringAsFixed(0)}%', Icons.umbrella),
              _buildWeatherMetric('Wind', '${w.windKmh.toStringAsFixed(0)} km/h', Icons.air),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            w.agriculturalRelevance,
            style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: AppColors.muted),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherMetric(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 18, color: AppColors.weather),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.charcoal)),
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.muted)),
      ],
    );
  }

  // --- ALERTS SECTION ---
  Widget _buildAlertsSection(AppState appState, AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              loc.tr('alerts'),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.charcoal),
            ),
            InkWell(
              onTap: () => Navigator.of(context).pushNamed('/alerts'),
              child: const Text('See All', style: TextStyle(fontSize: 12, color: AppColors.forest)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...appState.alerts.take(2).map((alert) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.ivory,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.stone),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: alert['severity'] == 'HIGH'
                        ? AppColors.critical.withOpacity(0.15)
                        : AppColors.harvestGold.withOpacity(0.15),
                    child: Icon(
                      alert['severity'] == 'HIGH' ? Icons.warning_amber : Icons.info_outline,
                      size: 18,
                      color: alert['severity'] == 'HIGH' ? AppColors.critical : AppColors.harvestGold,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          alert['title'] ?? '',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.charcoal),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          alert['message'] ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 11, color: AppColors.muted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
