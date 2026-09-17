import 'package:flutter/foundation.dart';

class AppConstants {
  static const String appName = 'FasalRakshak';
  static const String appTagline = 'From Crop Detection to Early Action';
  static const String appVersion = '1.0.0 (Prototype Demo)';

  // Backend API Base URL (Auto-detects host for phone access or defaults to local network)
  static String get defaultApiBaseUrl {
    if (kIsWeb) {
      final host = Uri.base.host;
      if (host.isNotEmpty && host != 'localhost' && host != '127.0.0.1') {
        return 'http://$host:8000/api/v1';
      }
    }
    return 'http://10.14.140.107:8000/api/v1';
  }

  // Demo User Credentials
  static const Map<String, Map<String, String>> demoAccounts = {
    'farmer': {
      'email': 'farmer@fasalrakshak.com',
      'password': 'farmer123',
      'role': 'Farmer',
      'name': 'Ramesh Patel',
      'subtitle': 'Patel Krishi Farm, Sihor, Bhavnagar',
    },
    'expert': {
      'email': 'expert@fasalrakshak.com',
      'password': 'expert123',
      'role': 'Agricultural Expert',
      'name': 'Dr. Meena Sharma',
      'subtitle': 'Senior Plant Pathologist, AAU Anand',
    },
    'officer': {
      'email': 'officer@fasalrakshak.com',
      'password': 'officer123',
      'role': 'Agriculture Officer',
      'name': 'K. V. Joshi',
      'subtitle': 'District Agriculture Office, Bhavnagar',
    },
    'admin': {
      'email': 'admin@fasalrakshak.com',
      'password': 'admin123',
      'role': 'Administrator',
      'name': 'System Administrator',
      'subtitle': 'FasalRakshak Platform Operations',
    },
  };

  // Supported crops
  static const List<String> supportedCrops = [
    'Tomato',
    'Cotton',
    'Potato',
    'Corn',
    'Groundnut',
    'Soybean'
  ];
}
