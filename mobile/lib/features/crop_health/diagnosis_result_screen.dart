import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/state/app_state.dart';
import '../common/custom_app_bar.dart';

class DiagnosisResultScreen extends StatelessWidget {
  const DiagnosisResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final loc = AppLocalizations.of(context);
    final diag = appState.currentDiagnosis;
    final risk = appState.currentRisk;

    final confidencePct = ((diag?.confidence ?? 0.85) * 100).toInt();
    final isLowConfidence = (diag?.confidence ?? 0.85) < 0.70;

    return Scaffold(
      appBar: FasalAppBar(
        title: loc.tr('ai_result'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Alert Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isLowConfidence ? const Color(0xFFFEF3C7) : AppColors.lightMint,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isLowConfidence ? AppColors.warningAmber : AppColors.primaryGreen,
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isLowConfidence ? Icons.medical_services_outlined : Icons.verified_outlined,
                    color: isLowConfidence ? AppColors.warningAmber : AppColors.primaryGreen,
                    size: 26,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isLowConfidence
                              ? loc.tr('doctor_review_tag')
                              : 'AI Verified Result',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isLowConfidence ? const Color(0xFF92400E) : AppColors.primaryGreen,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          isLowConfidence
                              ? 'Confidence is $confidencePct%. A crop specialist doctor has been alerted to double-check your leaf.'
                              : 'High confidence check ($confidencePct%). Analysis complete.',
                          style: const TextStyle(fontSize: 12, color: AppColors.charcoal),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Leaf Image & Disease Name Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (appState.pickedImageBytes != null) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.memory(
                          appState.pickedImageBytes!,
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.lightMint,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${diag?.crop ?? "Tomato"} Plant',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryGreen),
                          ),
                        ),
                        Text(
                          'Confidence: $confidencePct%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isLowConfidence ? AppColors.warningAmber : AppColors.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      diag?.disease ?? 'Tomato Early Blight',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.charcoal),
                    ),
                    const SizedBox(height: 14),

                    // Risk & Severity Indicators
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildSimpleBadge('Severity', diag?.severity ?? 'Moderate', Icons.warning_amber),
                          _buildSimpleBadge('Risk', risk?.riskLevel ?? 'MODERATE', Icons.shield_outlined),
                          _buildSimpleBadge('Risk Score', '${risk?.riskScore.toStringAsFixed(0) ?? 65}/100', Icons.speed),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Card 1: What is the problem?
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info_outline, size: 18, color: AppColors.primaryGreen),
                        const SizedBox(width: 8),
                        Text(
                          loc.tr('problem_found'),
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryGreen),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      diag?.explanation ?? 'Brown spots with concentric rings on foliage. Spreads rapidly in wet weather.',
                      style: const TextStyle(fontSize: 13, height: 1.45, color: AppColors.charcoal),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Card 2: Treatment & Medicine
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.healing, size: 18, color: AppColors.vibrantGreen),
                        const SizedBox(width: 8),
                        Text(
                          loc.tr('treatment'),
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryGreen),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      diag?.recommendations ??
                          '• Pluck and safely destroy yellow/spotted leaves.\n• Water directly at roots; do not splash water on leaves.\n• Awaiting Agricultural Expert confirmation for exact spray.',
                      style: const TextStyle(fontSize: 13, height: 1.5, color: AppColors.charcoal),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Card 3: Prevention
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.shield, size: 18, color: AppColors.infoBlue),
                        const SizedBox(width: 8),
                        Text(
                          loc.tr('prevention'),
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.infoBlue),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      diag?.prevention ??
                          'Maintain proper gap between crops for airflow. Rotate crops next season.',
                      style: const TextStyle(fontSize: 13, height: 1.45, color: AppColors.charcoal),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Action Buttons
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed('/monitoring');
              },
              icon: const Icon(Icons.calendar_today, size: 18),
              label: Text(loc.tr('monitoring')),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 10),

            OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed('/risk-details');
              },
              icon: const Icon(Icons.cloud_queue, size: 18),
              label: const Text('View Weather & Farm Risk Details'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 10),

            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/farmer-dashboard');
              },
              child: const Text('← Back to Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleBadge(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 18, color: AppColors.primaryGreen),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.charcoal),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.muted),
        ),
      ],
    );
  }
}
