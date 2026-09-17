import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../common/custom_app_bar.dart';

class PestTrapScreen extends StatefulWidget {
  const PestTrapScreen({super.key});

  @override
  State<PestTrapScreen> createState() => _PestTrapScreenState();
}

class _PestTrapScreenState extends State<PestTrapScreen> {
  bool _isAnalyzing = false;
  bool _showResult = true; // Show preloaded demo observation

  void _analyzeNewTrap() {
    setState(() => _isAnalyzing = true);
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() {
        _isAnalyzing = false;
        _showResult = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sticky trap analyzed successfully!')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: FasalAppBar(
        title: loc.tr('pest_trap'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Guidance Card
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
                  Row(
                    children: const [
                      Icon(Icons.info_outline, size: 18, color: AppColors.harvestGold),
                      SizedBox(width: 8),
                      Text(
                        'Sticky Trap Surveillance',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.charcoal),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Upload 1–3 clear photos of field yellow sticky traps or pheromone delta traps to estimate vector count and calculate threshold surge risk.',
                    style: TextStyle(fontSize: 12, color: AppColors.muted),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Note: Prototype engine with simulated insect detection. Architecture is modular and ready for YOLOv8 model integration.',
                    style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: AppColors.forest),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Image Upload Placeholder
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: AppColors.warmSand,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.stone, width: 1.5),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.crop_original, size: 48, color: AppColors.harvestGold),
                      SizedBox(height: 8),
                      Text(
                        'Yellow Sticky Trap #01 (South Plot)',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.charcoal),
                      ),
                      Text(
                        'Simulated detection boxes: 18 Whiteflies identified',
                        style: TextStyle(fontSize: 11, color: AppColors.muted),
                      ),
                    ],
                  ),
                  // Simulated bounding boxes overlay
                  Positioned(
                    left: 40,
                    top: 30,
                    child: _buildBBox(24, 24),
                  ),
                  Positioned(
                    left: 120,
                    top: 50,
                    child: _buildBBox(26, 26),
                  ),
                  Positioned(
                    right: 60,
                    top: 40,
                    child: _buildBBox(22, 22),
                  ),
                  Positioned(
                    right: 110,
                    bottom: 30,
                    child: _buildBBox(25, 25),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: _isAnalyzing ? null : _analyzeNewTrap,
              icon: const Icon(Icons.analytics_outlined),
              label: Text(_isAnalyzing ? 'Analyzing Trap...' : 'Upload & Analyze Sticky Trap'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.deepPine,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
            const SizedBox(height: 20),

            if (_showResult) ...[
              // Analysis Results Card
              Container(
                padding: const EdgeInsets.all(18),
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
                        const Text(
                          'Pest Trap Intelligence Result',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.charcoal),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.harvestGold.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Prototype Analysis',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.harvestGold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildMetric('Detected Pest', 'Whitefly\n(Bemisia tabaci)'),
                        _buildMetric('Estimated Count', '18\ninsects / trap'),
                        _buildMetric('Pest Pressure', 'Moderate\n(Threshold Active)'),
                        _buildMetric('Trap Risk', 'MODERATE\n(IPM Action)'),
                      ],
                    ),
                    const Divider(height: 24, color: AppColors.stone),

                    const Text(
                      'Integrated Pest Management (IPM) Advisory:',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.forest),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      '• Count has reached 18 insects/trap; close to vector economic threshold (20/trap).\n'
                      '• Maintain 10-12 yellow sticky traps per hectare at crop canopy height.\n'
                      '• Apply 5% Neem Seed Kernel Extract (NSKE) or approved bio-repellent spray to deter oviposition.\n'
                      '• Clean and replace trap sheets within 7 days to monitor population surge.',
                      style: TextStyle(fontSize: 12, height: 1.45, color: AppColors.charcoal),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBBox(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.critical, width: 1.5),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildMetric(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.charcoal),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: AppColors.muted),
        ),
      ],
    );
  }
}
