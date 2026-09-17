import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/state/app_state.dart';
import '../../services/sync/sync_service.dart';
import '../common/custom_app_bar.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final syncService = Provider.of<SyncService>(context);

    return Scaffold(
      appBar: const FasalAppBar(
        title: 'Platform Administration',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Admin Profile
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
                    backgroundColor: AppColors.charcoal,
                    child: Icon(Icons.admin_panel_settings, color: Colors.white, size: 24),
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

            // System Statistics
            Row(
              children: [
                Expanded(child: _buildTile('Total Farmers', '1,420', AppColors.deepPine)),
                const SizedBox(width: 8),
                Expanded(child: _buildTile('Experts', '24', AppColors.ai)),
                const SizedBox(width: 8),
                Expanded(child: _buildTile('Officers', '38', AppColors.weather)),
                const SizedBox(width: 8),
                Expanded(child: _buildTile('Diagnoses', '8,940', AppColors.forest)),
              ],
            ),
            const SizedBox(height: 20),

            // Demo Simulation Controls for Judges
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
                    'Hackathon Demo Controls',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.deepPine),
                  ),
                  const SizedBox(height: 10),
                  SwitchListTile(
                    title: const Text('Simulate Offline Mode', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    subtitle: const Text('Forces local storage, queues pending sync, runs on-device inference.', style: TextStyle(fontSize: 11, color: AppColors.muted)),
                    value: syncService.isOfflineMode,
                    activeColor: AppColors.warning,
                    onChanged: (val) => syncService.toggleOfflineMode(val),
                  ),
                  const Divider(height: 14, color: AppColors.stone),
                  ListTile(
                    title: const Text('Force Trigger Sync', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    subtitle: Text('Queue count: ${syncService.pendingCount} records', style: const TextStyle(fontSize: 11, color: AppColors.muted)),
                    trailing: ElevatedButton(
                      onPressed: () => syncService.syncPendingItems(),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.deepPine),
                      child: const Text('Sync Now'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Audit Logs
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
                    'System Activity Log',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.charcoal),
                  ),
                  SizedBox(height: 10),
                  _buildLogItem('17:28 IST', 'AI Inference: EfficientNet-B0 evaluated leaf pattern (Bhavnagar)'),
                  _buildLogItem('17:15 IST', 'Expert Review: Dr. Meena Sharma validated Case #02'),
                  _buildLogItem('16:50 IST', 'Sync: Client #18 pushed 1 pending diagnosis record'),
                  _buildLogItem('16:10 IST', 'Weather: Open-Meteo microclimate cache updated'),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        color: AppColors.ivory,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.stone),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(label, textAlign: TextAlign.center, maxLines: 1, style: const TextStyle(fontSize: 10, color: AppColors.muted)),
        ],
      ),
    );
  }
}

class _buildLogItem extends StatelessWidget {
  final String time;
  final String text;

  const _buildLogItem(this.time, this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(time, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.muted)),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 12, color: AppColors.charcoal))),
        ],
      ),
    );
  }
}
