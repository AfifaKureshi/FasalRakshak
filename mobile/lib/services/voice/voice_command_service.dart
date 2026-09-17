enum VoiceIntent {
  checkCropHealth,
  showAlerts,
  showWeather,
  showRisk,
  showFarm,
  showPestTrap,
  unknown,
}

class VoiceCommandService {
  static final VoiceCommandService instance = VoiceCommandService._();
  VoiceCommandService._();

  VoiceIntent parseCommand(String text) {
    final lower = text.toLowerCase().trim();

    // 1. Check Crop Health / Upload Image
    if (lower.contains('crop health') ||
        lower.contains('check crop') ||
        lower.contains('upload image') ||
        lower.contains('health') ||
        lower.contains('स्वास्थ्य') ||
        lower.contains('जांच') ||
        lower.contains('આરોગ્ય') ||
        lower.contains('તપાસો')) {
      return VoiceIntent.checkCropHealth;
    }

    // 2. Alerts
    if (lower.contains('alert') ||
        lower.contains('notification') ||
        lower.contains('अलर्ट') ||
        lower.contains('चेतावनी') ||
        lower.contains('ચેતવણી')) {
      return VoiceIntent.showAlerts;
    }

    // 3. Weather
    if (lower.contains('weather') ||
        lower.contains('rain') ||
        lower.contains('मौसम') ||
        lower.contains('बारिश') ||
        lower.contains('હવામાન') ||
        lower.contains('વરસાદ')) {
      return VoiceIntent.showWeather;
    }

    // 4. Risk
    if (lower.contains('risk') ||
        lower.contains('danger') ||
        lower.contains('जोखिम') ||
        lower.contains('खतरा') ||
        lower.contains('જોખમ')) {
      return VoiceIntent.showRisk;
    }

    // 5. My Farm
    if (lower.contains('farm') ||
        lower.contains('soil') ||
        lower.contains('खेत') ||
        lower.contains('मिट्टी') ||
        lower.contains('ખેતર')) {
      return VoiceIntent.showFarm;
    }

    // 6. Pest Trap
    if (lower.contains('pest') ||
        lower.contains('trap') ||
        lower.contains('कीट') ||
        lower.contains('जाल') ||
        lower.contains('જીવાત') ||
        lower.contains('ટ્રેપ')) {
      return VoiceIntent.showPestTrap;
    }

    return VoiceIntent.unknown;
  }
}
