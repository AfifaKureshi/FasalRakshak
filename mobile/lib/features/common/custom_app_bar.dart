import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/state/app_state.dart';
import '../../services/sync/sync_service.dart';
import '../voice/voice_command_dialog.dart';

class FasalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showVoice;
  final bool showSyncBadge;

  const FasalAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showVoice = true,
    this.showSyncBadge = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 4);

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final syncService = Provider.of<SyncService>(context);
    final loc = AppLocalizations.of(context);
    final canPop = Navigator.canPop(context);

    return AppBar(
      leading: canPop
          ? const BackButton(color: Colors.white)
          : Padding(
              padding: const EdgeInsets.only(left: 12, top: 6, bottom: 6, right: 2),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(2),
                child: ClipOval(
                  child: Image.asset(
                    'assets/icons/app_logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          if (syncService.isOfflineMode)
            Container(
              margin: const EdgeInsets.only(top: 2),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.cloud_off, size: 10, color: Colors.white),
                  const SizedBox(width: 4),
                  Text(
                    loc.tr('offline_mode').toUpperCase(),
                    style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
        ],
      ),
      actions: [
        // Voice Command Button
        if (showVoice)
          IconButton(
            icon: const Icon(Icons.mic, color: Colors.white),
            tooltip: loc.tr('voice_command'),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const VoiceCommandSheet(),
              );
            },
          ),

        // Prominent Modern Language Switcher Button
        InkWell(
          onTap: () => _showLanguageModal(context, appState),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.35)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.g_translate, size: 15, color: Colors.white),
                const SizedBox(width: 5),
                Text(
                  _getLangLabel(appState.locale.languageCode),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const Icon(Icons.arrow_drop_down, size: 16, color: Colors.white),
              ],
            ),
          ),
        ),

        // Persona Switcher Menu (for judges)
        PopupMenuButton<UserRole>(
          icon: const Icon(Icons.switch_account_outlined, color: Colors.white),
          tooltip: loc.tr('switch_role'),
          onSelected: (role) {
            appState.switchRole(role);
          },
          itemBuilder: (ctx) => [
            PopupMenuItem(
              value: UserRole.farmer,
              child: Row(
                children: [
                  Icon(Icons.person, color: appState.currentRole == UserRole.farmer ? AppColors.forest : Colors.grey),
                  const SizedBox(width: 8),
                  Text('Farmer (${AppLocalizations.of(ctx).tr('farmer')})'),
                ],
              ),
            ),
            PopupMenuItem(
              value: UserRole.expert,
              child: Row(
                children: [
                  Icon(Icons.biotech, color: appState.currentRole == UserRole.expert ? AppColors.forest : Colors.grey),
                  const SizedBox(width: 8),
                  Text('Expert (${AppLocalizations.of(ctx).tr('expert')})'),
                ],
              ),
            ),
            PopupMenuItem(
              value: UserRole.officer,
              child: Row(
                children: [
                  Icon(Icons.dashboard, color: appState.currentRole == UserRole.officer ? AppColors.forest : Colors.grey),
                  const SizedBox(width: 8),
                  Text('Officer (${AppLocalizations.of(ctx).tr('officer')})'),
                ],
              ),
            ),
            PopupMenuItem(
              value: UserRole.admin,
              child: Row(
                children: [
                  Icon(Icons.admin_panel_settings, color: appState.currentRole == UserRole.admin ? AppColors.forest : Colors.grey),
                  const SizedBox(width: 8),
                  Text('Admin (${AppLocalizations.of(ctx).tr('admin')})'),
                ],
              ),
            ),
          ],
        ),

        if (actions != null) ...actions!,
      ],
    );
  }

  String _getLangLabel(String code) {
    switch (code) {
      case 'hi':
        return 'हिन्दी';
      case 'gu':
        return 'ગુજરાતી';
      case 'mr':
        return 'मराठी';
      default:
        return 'English';
    }
  }

  void _showLanguageModal(BuildContext context, AppState appState) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final current = appState.locale.languageCode;
        final languages = [
          {'code': 'en', 'title': 'English', 'sub': 'English'},
          {'code': 'hi', 'title': 'हिन्दी', 'sub': 'Hindi'},
          {'code': 'gu', 'title': 'ગુજરાતી', 'sub': 'Gujarati'},
          {'code': 'mr', 'title': 'मराठी', 'sub': 'Marathi'},
        ];

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.language, color: AppColors.primaryGreen, size: 22),
                    SizedBox(width: 8),
                    Text(
                      'Select Language / भाषा चुनें',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.charcoal),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ...languages.map((lang) {
                  final isSelected = current == lang['code'];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.lightMint : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? AppColors.primaryGreen : AppColors.border,
                        width: isSelected ? 1.8 : 1,
                      ),
                    ),
                    child: ListTile(
                      title: Text(
                        lang['title']!,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                          color: isSelected ? AppColors.primaryGreen : AppColors.charcoal,
                        ),
                      ),
                      subtitle: Text(
                        lang['sub']!,
                        style: const TextStyle(fontSize: 12, color: AppColors.muted),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle, color: AppColors.primaryGreen)
                          : null,
                      onTap: () {
                        appState.setLocale(lang['code']!);
                        Navigator.pop(ctx);
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
