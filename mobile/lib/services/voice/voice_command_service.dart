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

    // 1. Check Crop Health / Upload Image / Doctor
    if (lower.contains('crop health') ||
        lower.contains('check crop') ||
        lower.contains('upload image') ||
        lower.contains('crop doctor') ||
        lower.contains('doctor') ||
        lower.contains('disease') ||
        lower.contains('health') ||
        lower.contains('फसल स्वास्थ्य') ||
        lower.contains('फसल की जांच') ||
        lower.contains('डॉक्टर') ||
        lower.contains('रोग') ||
        lower.contains('जांच') ||
        lower.contains('પાકનું આરોગ્ય') ||
        lower.contains('આરોગ્ય') ||
        lower.contains('તપાસો') ||
        lower.contains('पिकाची तपासणी') ||
        lower.contains('पिक आरोग्य') ||
        lower.contains('तपासणी')) {
      return VoiceIntent.checkCropHealth;
    }

    // 2. Alerts
    if (lower.contains('alert') ||
        lower.contains('notification') ||
        lower.contains('अलर्ट') ||
        lower.contains('चेतावनी') ||
        lower.contains('सूचना') ||
        lower.contains('ચેતવણી')) {
      return VoiceIntent.showAlerts;
    }

    // 3. Weather
    if (lower.contains('weather') ||
        lower.contains('rain') ||
        lower.contains('temperature') ||
        lower.contains('मौसम') ||
        lower.contains('बारिश') ||
        lower.contains('હવામાન') ||
        lower.contains('વરસાદ') ||
        lower.contains('हवामान') ||
        lower.contains('पाऊस')) {
      return VoiceIntent.showWeather;
    }

    // 4. Risk
    if (lower.contains('risk') ||
        lower.contains('danger') ||
        lower.contains('जोखिम') ||
        lower.contains('खतरा') ||
        lower.contains('જોખમ') ||
        lower.contains('धोका')) {
      return VoiceIntent.showRisk;
    }

    // 5. My Farm
    if (lower.contains('my farm') ||
        lower.contains('soil') ||
        lower.contains('plot') ||
        lower.contains('खेत') ||
        lower.contains('मिट्टी') ||
        lower.contains('ખેતર') ||
        lower.contains('शेत') ||
        lower.contains('माती')) {
      return VoiceIntent.showFarm;
    }

    // 6. Pest Trap
    if (lower.contains('pest trap') ||
        lower.contains('sticky trap') ||
        lower.contains('insects') ||
        lower.contains('कीट') ||
        lower.contains('जाल') ||
        lower.contains('જીવાત') ||
        lower.contains('ટ્રેપ') ||
        lower.contains('कीड') ||
        lower.contains('सापळा')) {
      return VoiceIntent.showPestTrap;
    }

    return VoiceIntent.unknown;
  }
}
