import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/state/app_state.dart';
import '../common/custom_app_bar.dart';

class OfficerDashboard extends StatefulWidget {
  const OfficerDashboard({super.key});

  @override
  State<OfficerDashboard> createState() => _OfficerDashboardState();
}

class _OfficerDashboardState extends State<OfficerDashboard> {
  String _selectedDistrict = 'Bhavnagar';
  Map<String, dynamic>? _generatedReport;

  final List<Map<String, dynamic>> _hotspots = [
    {
      'id': 1,
      'crop': 'Tomato',
      'hazard': 'Early Blight Outbreak',
      'location': 'Sihor Block',
      'lat': 21.7051,
      'lng': 71.9712,
      'risk': 'HIGH',
      'color': AppColors.critical,
      'farms': 8,
      'x': 0.45,
      'y': 0.55,
    },
    {
      'id': 2,
      'crop': 'Cotton',
      'hazard': 'Bacterial Blight Surge',
      'location': 'Palitana Block',
      'lat': 21.7600,
      'lng': 72.0100,
      'risk': 'HIGH',
      'color': AppColors.critical,
      'farms': 14,
      'x': 0.65,
      'y': 0.40,
    },
    {
      'id': 3,
      'crop': 'Cotton',
      'hazard': 'Pink Bollworm 48/trap',
      'location': 'Gariadhar Block',
      'lat': 21.6800,
      'lng': 71.9300,
      'risk': 'MODERATE',
      'color': AppColors.moderate,
      'farms': 6,
      'x': 0.35,
      'y': 0.70,
    },
    {
      'id': 4,
      'crop': 'Groundnut',
      'hazard': 'Tikka Spotting Early',
      'location': 'Mahuva Block',
      'lat': 21.5222,
      'lng': 70.4579,
      'risk': 'MODERATE',
      'color': AppColors.moderate,
      'farms': 5,
      'x': 0.25,
      'y': 0.85,
    },
    {
      'id': 5,
      'crop': 'Castor',
      'hazard': 'Semilooper Baseline',
      'location': 'Vallabhipur Block',
      'lat': 22.3039,
      'lng': 70.8022,
      'risk': 'LOW',
      'color': AppColors.healthy,
      'farms': 3,
      'x': 0.55,
      'y': 0.20,
    },
  ];

  void _generateReport() {
    setState(() {
      _generatedReport = {
        'id': 'REP-GUJ-2026-BHAV-01',
        'generated_at': '16 September 2026, 17:30 IST',
        'district': _selectedDistrict,
        'monitored_farms': 142,
        'active_clusters': 5,
        'high_priority': 'Sihor & Palitana blocks (Tomato Early Blight + Cotton Bacterial Blight)',
        'directive':
            'Deploy 4 block extension officers for on-site spray demonstration and drip interval advisories.',
      };
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('District Regional Intelligence Report compiled!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: FasalAppBar(
        title: 'Agriculture Officer Regional Intelligence',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Officer Profile Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.ivory,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.stone),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColors.weather,
                    child: Icon(Icons.insights, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appState.userName,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.charcoal),
                        ),
                        Text(
                          appState.userSubtitle,
                          style: const TextStyle(fontSize: 11, color: AppColors.muted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Key District Metrics
            Row(
              children: [
                Expanded(child: _buildMetricTile('Monitored Farms', '142', AppColors.deepPine)),
                const SizedBox(width: 8),
                Expanded(child: _buildMetricTile('Active Alerts', '6', AppColors.critical)),
                const SizedBox(width: 8),
                Expanded(child: _buildMetricTile('High-Risk Zones', '2', AppColors.critical)),
                const SizedBox(width: 8),
                Expanded(child: _buildMetricTile('Pending Reviews', '2', AppColors.harvestGold)),
              ],
            ),
            const SizedBox(height: 20),

            // Regional GIS Hotspot Map Container
            Container(
              padding: const EdgeInsets.all(16),
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
                          Icon(Icons.map_outlined, size: 18, color: AppColors.deepPine),
                          SizedBox(width: 8),
                          Text(
                            'Geospatial Hotspot Cluster Map (Gujarat)',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.charcoal),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.forest.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('PostGIS Layer', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.forest)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Visual GIS Map Viewport
                  Container(
                    height: 220,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5EDE8),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.stone),
                    ),
                    child: Stack(
                      children: [
                        // Grid map background lines
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _GridPainter(),
                          ),
                        ),
                        // Gujarat region title watermark
                        const Positioned(
                          left: 14,
                          top: 12,
                          child: Text(
                            'Saurashtra & Bhavnagar Agricultural Grid',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.muted),
                          ),
                        ),
                        // Hotspot Pins
                        ..._hotspots.map((h) => Positioned(
                              left: (MediaQuery.of(context).size.width - 64) * (h['x'] as double),
                              top: 200 * (h['y'] as double),
                              child: Tooltip(
                                message: '${h['hazard']} (${h['location']})',
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: h['color'],
                                        borderRadius: BorderRadius.circular(6),
                                        boxShadow: [
                                          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4),
                                        ],
                                      ),
                                      child: Text(
                                        '#${h['id']} ${h['crop']}',
                                        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
                                      ),
                                    ),
                                    Icon(Icons.location_on, color: h['color'], size: 24),
                                  ],
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Map Legend
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLegendDot(AppColors.critical, 'High Risk Hotspot'),
                      const SizedBox(width: 16),
                      _buildLegendDot(AppColors.moderate, 'Moderate Risk'),
                      const SizedBox(width: 16),
                      _buildLegendDot(AppColors.healthy, 'Low / Baseline'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Disease Trends & Pest Pressure Charts
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.ivory,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.stone),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Regional Disease & Pest Incident Trends',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.charcoal),
                  ),
                  const SizedBox(height: 14),
                  _buildTrendBar('Tomato Early Blight', 28, AppColors.critical),
                  _buildTrendBar('Cotton Bacterial Blight', 19, AppColors.warning),
                  _buildTrendBar('Tomato Late Blight', 14, AppColors.moderate),
                  _buildTrendBar('Whitefly Vector Surge', 22, AppColors.harvestGold),
                  _buildTrendBar('Groundnut Tikka Spot', 9, AppColors.healthy),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // District Intelligence Report Generator
            Container(
              padding: const EdgeInsets.all(16),
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
                      const Text(
                        'Generate Officer Advisory Report',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.charcoal),
                      ),
                      ElevatedButton.icon(
                        onPressed: _generateReport,
                        icon: const Icon(Icons.picture_as_pdf, size: 16),
                        label: const Text('Compile Report'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.deepPine,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                    ],
                  ),
                  if (_generatedReport != null) ...[
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.warmSand.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Report Reference: ${_generatedReport!['id']}',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.deepPine),
                          ),
                          const SizedBox(height: 4),
                          Text('Generated: ${_generatedReport!['generated_at']}', style: const TextStyle(fontSize: 11, color: AppColors.muted)),
                          const Divider(height: 14, color: AppColors.stone),
                          Text('Priority Interventions: ${_generatedReport!['high_priority']}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.charcoal)),
                          const SizedBox(height: 4),
                          Text('Directive: ${_generatedReport!['directive']}', style: const TextStyle(fontSize: 12, color: AppColors.charcoal)),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        color: AppColors.ivory,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.stone),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(label, textAlign: TextAlign.center, maxLines: 2, style: const TextStyle(fontSize: 10, color: AppColors.muted)),
        ],
      ),
    );
  }

  Widget _buildTrendBar(String label, int value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.charcoal)),
              Text('$value cases', style: const TextStyle(fontSize: 11, color: AppColors.muted)),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value / 35,
              minHeight: 6,
              backgroundColor: AppColors.stone.withOpacity(0.4),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.muted)),
      ],
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.06)
      ..strokeWidth = 1;

    for (double x = 0; x < size.width; x += 30) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 30) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
