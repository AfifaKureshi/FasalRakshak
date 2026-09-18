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
    final intent = VoiceCommandService.instance.parseCommand(text);
    String targetName = 'Crop Doctor';
    switch (intent) {
      case VoiceIntent.checkCropHealth:
        targetName = 'Crop Doctor / फसल जांच';
        break;
      case VoiceIntent.showAlerts:
        targetName = 'Alerts / अलर्ट्स';
        break;
      case VoiceIntent.showWeather:
        targetName = 'Agro Weather / मौसम';
        break;
      case VoiceIntent.showRisk:
        targetName = 'Farm Risk / खेत जोखिम';
        break;
      case VoiceIntent.showFarm:
        targetName = 'My Farm / मेरा खेत';
        break;
      case VoiceIntent.showPestTrap:
        targetName = 'Pest Trap / कीट जाल';
        break;
      case VoiceIntent.unknown:
        targetName = 'Command Not Recognized';
        break;
    }

    setState(() {
      _recognizedText = text;
      _isListening = false;
      _statusText = '✓ Recognized! Navigating to: $targetName';
    });

    Future.delayed(const Duration(milliseconds: 1200), () {
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
            SnackBar(content: Text('Unrecognized command: "$text". Please pick from samples below.')),
          );
          break;
      }
    });
  }

  void _simulateListening() {
    if (_isListening) {
      setState(() {
        _isListening = false;
        _statusText = 'Listening stopped. Tap a sample below or tap mic again.';
      });
      return;
    }

    setState(() {
      _isListening = true;
      _statusText = 'Listening... Speak in Hindi, Gujarati, Marathi or English';
    });

    // Provide helpful prompts if mic tapped
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (!mounted || !_isListening) return;
      setState(() {
        _statusText = 'Tap any sample command below to test voice navigation.';
        _isListening = false;
      });
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
                label: const Text('पिकाचे आरोग्य तपासा'),
                onPressed: () => _triggerCommand('पिकाचे आरोग्य तपासा'),
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
