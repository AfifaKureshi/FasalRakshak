import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/state/app_state.dart';
import '../common/custom_app_bar.dart';

class ExpertDashboard extends StatefulWidget {
  const ExpertDashboard({super.key});

  @override
  State<ExpertDashboard> createState() => _ExpertDashboardState();
}

class _ExpertDashboardState extends State<ExpertDashboard> {
  void _openValidationDialog(Map<String, dynamic> review) {
    final notesCtrl = TextEditingController(
      text: 'Concentric necrotic zonation on basal foliage is pathognomonic for Alternaria solani. Microclimate humidity is high.',
    );
    final recCtrl = TextEditingController(
      text: 'Prune lower 30cm foliage to eliminate soil water splashing. Maintain drip intervals. Apply Trichoderma bio-agent.',
    );
    String action = 'VALIDATE';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppColors.ivory,
          title: Text(
            'Expert Clinical Review (#${review['id']})',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.charcoal),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Farmer: ${review['farmer_name']} • Crop: ${review['crop']}',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.deepPine),
                ),
                Text(
                  'AI Result: ${review['ai_result']} (${(review['confidence'] * 100).toInt()}% Confidence)',
                  style: const TextStyle(fontSize: 12, color: AppColors.muted),
                ),
                const SizedBox(height: 14),

                const Text('Action:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Radio<String>(
                      value: 'VALIDATE',
                      groupValue: action,
                      onChanged: (val) => setDialogState(() => action = val!),
                    ),
                    const Text('Confirm AI Diagnosis', style: TextStyle(fontSize: 13)),
                  ],
                ),
                Row(
                  children: [
                    Radio<String>(
                      value: 'OVERRIDE',
                      groupValue: action,
                      onChanged: (val) => setDialogState(() => action = val!),
                    ),
                    const Text('Override / Correct Diagnosis', style: TextStyle(fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 10),

                TextField(
                  controller: recCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Targeted Farmer Advisory',
                    hintText: 'Actionable cultural & IPM instructions',
                  ),
                ),
                const SizedBox(height: 10),

                TextField(
                  controller: notesCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Clinical Observations / Notes',
                    hintText: 'Pathological rationale',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final appState = Provider.of<AppState>(context, listen: false);
                appState.validateExpertCase(
                  reviewId: review['id'],
                  action: action,
                  notes: notesCtrl.text,
                  recommendations: recCtrl.text,
                );
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Case #${review['id']} validated by Dr. Meena Sharma! Farmer notified.'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.deepPine),
              child: const Text('Submit Validation'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: FasalAppBar(
        title: 'Agricultural Expert Portal',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Expert Profile Card
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
                    radius: 24,
                    backgroundColor: AppColors.deepPine,
                    child: Icon(Icons.biotech, color: AppColors.softLime, size: 28),
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

            // Queue stats row
            Row(
              children: [
                Expanded(
                  child: _buildStatTile('Pending Reviews', '${appState.pendingExpertReviews.where((r) => r['status'] == 'PENDING').length}', AppColors.warning),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildStatTile('Validated Today', '14', AppColors.healthy),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildStatTile('Avg. Turnaround', '35 mins', AppColors.forest),
                ),
              ],
            ),
            const SizedBox(height: 20),

            const Text(
              'Low-Confidence Cases Requiring Clinical Validation:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.charcoal),
            ),
            const SizedBox(height: 10),

            // Cases list
            ...appState.pendingExpertReviews.map((rev) {
              final isPending = rev['status'] == 'PENDING';
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.ivory,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isPending ? AppColors.warning.withOpacity(0.5) : AppColors.healthy.withOpacity(0.5),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${rev['farmer_name']} (${rev['location']})',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.charcoal),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: (isPending ? AppColors.warning : AppColors.healthy).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            rev['status'],
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isPending ? AppColors.warning : AppColors.healthy,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Crop: ${rev['crop']} • Preliminary AI: ${rev['ai_result']}',
                      style: const TextStyle(fontSize: 12, color: AppColors.deepPine, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'AI Confidence: ${(rev['confidence'] * 100).toInt()}% (Threshold <70%) • Risk: ${rev['risk_level']}',
                      style: const TextStyle(fontSize: 11, color: AppColors.muted),
                    ),
                    const Divider(height: 18, color: AppColors.stone),

                    if (isPending)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => _openValidationDialog(rev),
                            icon: const Icon(Icons.rate_review, size: 16),
                            label: const Text('Review & Validate Case'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.deepPine,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            ),
                          ),
                        ],
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.verified, size: 16, color: AppColors.healthy),
                              SizedBox(width: 6),
                              Text(
                                'Validated by Dr. Meena Sharma',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.healthy),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Advisory: ${rev['recommendations']}',
                            style: const TextStyle(fontSize: 11, color: AppColors.charcoal),
                          ),
                        ],
                      ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatTile(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.ivory,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.stone),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: AppColors.muted)),
        ],
      ),
    );
  }
}
