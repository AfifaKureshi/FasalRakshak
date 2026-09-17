import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/state/app_state.dart';
import '../common/custom_app_bar.dart';

class ContinuousMonitoringScreen extends StatefulWidget {
  const ContinuousMonitoringScreen({super.key});

  @override
  State<ContinuousMonitoringScreen> createState() =>
      _ContinuousMonitoringScreenState();
}

class _ContinuousMonitoringScreenState
    extends State<ContinuousMonitoringScreen> {
  String _selectedProgression = 'IMPROVED';
  bool _isSubmitting = false;

  void _submitDay7() {
    setState(() => _isSubmitting = true);
    final appState = Provider.of<AppState>(context, listen: false);

    Future.delayed(const Duration(milliseconds: 600), () {
      appState.completeDay7Monitoring(progression: _selectedProgression);
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Day 7 comparative analysis completed!')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: FasalAppBar(
        title: loc.tr('monitoring'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.ivory,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.stone),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Continuous Health Monitoring Journey',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.charcoal),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Track disease regression or progression over time. Compare initial baseline symptoms with 7-day follow-up observations.',
                    style: TextStyle(fontSize: 12, color: AppColors.muted),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Side-by-side comparison: Day 0 vs Day 7
            Row(
              children: [
                // Day 0
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.ivory,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.stone),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.deepPine.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            loc.tr('day_0'),
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.deepPine),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 110,
                          decoration: BoxDecoration(
                            color: AppColors.warmSand,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.stone),
                          ),
                          child: const Center(
                            child: Icon(Icons.spa, size: 40, color: AppColors.warning),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Tomato Early Blight',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.charcoal),
                        ),
                        const Text(
                          'Active brown concentric lesions on lower canopy.',
                          style: TextStyle(fontSize: 10, color: AppColors.muted),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Day 7
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.ivory,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: appState.day7Completed ? AppColors.healthy : AppColors.stone,
                        width: appState.day7Completed ? 1.5 : 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: (appState.day7Completed ? AppColors.healthy : AppColors.harvestGold).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            loc.tr('day_7'),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: appState.day7Completed ? AppColors.healthy : AppColors.harvestGold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 110,
                          decoration: BoxDecoration(
                            color: AppColors.warmSand,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.stone),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.eco,
                              size: 40,
                              color: appState.day7Completed ? AppColors.healthy : AppColors.muted,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          appState.day7Completed
                              ? 'Status: ${appState.monitoringProgression}'
                              : 'Pending Follow-up',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: appState.day7Completed ? AppColors.healthy : AppColors.charcoal,
                          ),
                        ),
                        Text(
                          appState.day7Completed
                              ? 'Lesions dried; apical flush healthy.'
                              : 'Ready for follow-up evaluation.',
                          style: const TextStyle(fontSize: 10, color: AppColors.muted),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Demonstration Follow-Up Selector
            if (!appState.day7Completed) ...[
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
                      'Demonstrate Day 7 Observation Outcome:',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.charcoal),
                    ),
                    const SizedBox(height: 10),
                    RadioListTile<String>(
                      title: const Text('Improved (Symptoms Reduced / Lesions Dried)'),
                      subtitle: const Text('Lower affected leaves pruned; new green flush emerged.'),
                      value: 'IMPROVED',
                      groupValue: _selectedProgression,
                      onChanged: (val) => setState(() => _selectedProgression = val!),
                    ),
                    RadioListTile<String>(
                      title: const Text('Stable (Symptoms Contained)'),
                      subtitle: const Text('No new lesions; existing spots haven\'t spread.'),
                      value: 'STABLE',
                      groupValue: _selectedProgression,
                      onChanged: (val) => setState(() => _selectedProgression = val!),
                    ),
                    RadioListTile<String>(
                      title: const Text('Worsened (Lesions Spreading)'),
                      subtitle: const Text('Secondary spots expanding to mid-canopy.'),
                      value: 'WORSENED',
                      groupValue: _selectedProgression,
                      onChanged: (val) => setState(() => _selectedProgression = val!),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              ElevatedButton.icon(
                onPressed: _isSubmitting ? null : _submitDay7,
                icon: const Icon(Icons.compare_arrows),
                label: Text(_isSubmitting ? 'Evaluating...' : 'Run Comparative Analysis (Day 0 vs Day 7)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.deepPine,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],

            // Completed Comparative Analysis Card
            if (appState.day7Completed) ...[
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.healthy.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.healthy.withOpacity(0.5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.check_circle, color: AppColors.healthy, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Comparative Evaluation: IMPROVED',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.healthy),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      appState.monitoringNotes,
                      style: const TextStyle(fontSize: 13, height: 1.4, color: AppColors.charcoal),
                    ),
                    const Divider(height: 20, color: AppColors.stone),
                    const Text(
                      'Updated Advisory:',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.forest),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '• Continue standard drip irrigation schedule.\n• No emergency chemical spray needed.\n• Next milestone follow-up scouting scheduled in 14 days.',
                      style: TextStyle(fontSize: 12, height: 1.4, color: AppColors.charcoal),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              OutlinedButton(
                onPressed: () {
                  setState(() {
                    appState.completeDay7Monitoring(progression: 'PENDING');
                  });
                },
                child: const Text('Reset Demo Monitoring'),
              ),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
