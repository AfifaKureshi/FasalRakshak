import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../services/voice/voice_command_service.dart';

class VoiceCommandSheet extends StatefulWidget {
  const VoiceCommandSheet({super.key});

  @override
  State<VoiceCommandSheet> createState() => _VoiceCommandSheetState();
}

class _VoiceCommandSheetState extends State<VoiceCommandSheet> {
  bool _isListening = false;
  String _recognizedText = '';
  String _statusText = 'Tap mic or pick a sample command';

  void _triggerCommand(String text) {
    setState(() {
      _recognizedText = text;
      _isListening = false;
      _statusText = 'Processing intent...';
    });

    final intent = VoiceCommandService.instance.parseCommand(text);

    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      Navigator.of(context).pop();

      switch (intent) {
        case VoiceIntent.checkCropHealth:
          Navigator.of(context).pushNamed('/check-crop-health');
          break;
        case VoiceIntent.showAlerts:
          Navigator.of(context).pushNamed('/alerts');
          break;
        case VoiceIntent.showWeather:
          Navigator.of(context).pushNamed('/weather');
          break;
        case VoiceIntent.showRisk:
          Navigator.of(context).pushNamed('/risk-details');
          break;
        case VoiceIntent.showFarm:
          Navigator.of(context).pushNamed('/my-farm');
          break;
        case VoiceIntent.showPestTrap:
          Navigator.of(context).pushNamed('/pest-trap');
          break;
        case VoiceIntent.unknown:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Command recognized: "$text"')),
          );
          break;
      }
    });
  }

  void _simulateListening() {
    setState(() {
      _isListening = true;
      _statusText = 'Listening... (Speak now)';
    });

    Future.delayed(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      _triggerCommand('Check my crop health');
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.ivory,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 5,
            decoration: BoxDecoration(
              color: AppColors.stone,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            loc.tr('voice_command'),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.charcoal,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _statusText,
            style: const TextStyle(fontSize: 13, color: AppColors.muted),
          ),
          const SizedBox(height: 24),

          // Animated Mic Button
          GestureDetector(
            onTap: _simulateListening,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _isListening ? 90 : 80,
              height: _isListening ? 90 : 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isListening ? AppColors.critical : AppColors.deepPine,
                boxShadow: [
                  BoxShadow(
                    color: (_isListening ? AppColors.critical : AppColors.deepPine)
                        .withOpacity(0.3),
                    blurRadius: 16,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Icon(
                _isListening ? Icons.mic : Icons.mic_none,
                color: Colors.white,
                size: 38,
              ),
            ),
          ),
          const SizedBox(height: 24),

          if (_recognizedText.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.warmSand,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '"$_recognizedText"',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.deepPine,
                ),
              ),
            ),

          const SizedBox(height: 20),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Sample Voice Commands:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.muted,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Quick command suggestion chips in English, Hindi, and Gujarati
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ActionChip(
                label: const Text('Check my crop health'),
                onPressed: () => _triggerCommand('Check my crop health'),
              ),
              ActionChip(
                label: const Text('फसल स्वास्थ्य जांचें'),
                onPressed: () => _triggerCommand('फसल स्वास्थ्य जांचें'),
              ),
              ActionChip(
                label: const Text('પાકનું આરોગ્ય તપાસો'),
                onPressed: () => _triggerCommand('પાકનું આરોગ્ય તપાસો'),
              ),
              ActionChip(
                label: const Text('Show my alerts'),
                onPressed: () => _triggerCommand('Show my alerts'),
              ),
              ActionChip(
                label: const Text('Today\'s weather'),
                onPressed: () => _triggerCommand('Show today\'s weather'),
              ),
              ActionChip(
                label: const Text('What is my crop risk?'),
                onPressed: () => _triggerCommand('What is my crop risk?'),
              ),
              ActionChip(
                label: const Text('Upload Pest Trap'),
                onPressed: () => _triggerCommand('Upload Pest Trap'),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
