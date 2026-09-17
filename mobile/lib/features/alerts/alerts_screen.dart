import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/state/app_state.dart';
import '../common/custom_app_bar.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: FasalAppBar(
        title: loc.tr('alerts'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: appState.alerts.length,
        itemBuilder: (ctx, i) {
          final alert = appState.alerts[i];
          final isHigh = alert['severity'] == 'HIGH';
          final isVerified = alert['type'] == 'EXPERT_VALIDATED';

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.ivory,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isVerified
                    ? AppColors.healthy.withOpacity(0.5)
                    : (isHigh ? AppColors.critical.withOpacity(0.4) : AppColors.stone),
                width: isVerified || isHigh ? 1.5 : 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: isVerified
                      ? AppColors.healthy.withOpacity(0.15)
                      : (isHigh
                          ? AppColors.critical.withOpacity(0.15)
                          : AppColors.harvestGold.withOpacity(0.15)),
                  child: Icon(
                    isVerified
                        ? Icons.verified
                        : (isHigh ? Icons.warning_amber : Icons.notifications_active),
                    size: 22,
                    color: isVerified
                        ? AppColors.healthy
                        : (isHigh ? AppColors.critical : AppColors.harvestGold),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              alert['title'] ?? '',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.charcoal,
                              ),
                            ),
                          ),
                          Text(
                            alert['date'] ?? '',
                            style: const TextStyle(fontSize: 11, color: AppColors.muted),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        alert['message'] ?? '',
                        style: const TextStyle(fontSize: 12, height: 1.35, color: AppColors.charcoal),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
