import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import '../../services/sync/sync_service.dart';
import '../../services/ai/disease_detection_service.dart';
import '../../services/risk/risk_service.dart';
import '../../services/weather/weather_service.dart';
import '../../data/local/local_storage_service.dart';

enum UserRole { farmer, expert, officer, admin }

class AppState extends ChangeNotifier {
  UserRole _currentRole = UserRole.farmer;
  Locale _locale = const Locale('en');
  String _userName = 'Ramesh Patel';
  String _userEmail = 'farmer@fasalrakshak.com';
  String _userSubtitle = 'Patel Krishi Farm, Sihor, Bhavnagar';

  // Farm details
  String _farmName = 'Patel Krishi Farm';
  String _crop = 'Tomato';
  String _variety = 'Abhinav Hybrid';
  String _cropStage = 'Flowering to Fruit Setting';
  double _soilMoisture = 64.0;
  double _soilPh = 7.4;
  double _soilTemp = 26.5;
  String _soilType = 'Deep Black Cotton Clay';

  // Uploaded leaf image
  Uint8List? _pickedImageBytes;
  String? _pickedImageName;

  // Intelligence & Diagnosis state
  DiseaseResult? _currentDiagnosis;
  RiskAssessmentResult? _currentRisk;
  WeatherData _weather = WeatherData.cachedDefault();
  List<Map<String, dynamic>> _diagnosisHistory = [];
  List<Map<String, dynamic>> _alerts = [];
  List<Map<String, dynamic>> _pendingExpertReviews = [];

  // Continuous monitoring
  bool _day7Completed = false;
  String _monitoringProgression = 'PENDING';
  String _monitoringNotes = '';

  // Getters
  UserRole get currentRole => _currentRole;
  Locale get locale => _locale;
  String get userName => _userName;
  String get userEmail => _userEmail;
  String get userSubtitle => _userSubtitle;
  String get farmName => _farmName;
  String get crop => _crop;
  String get variety => _variety;
  String get cropStage => _cropStage;
  double get soilMoisture => _soilMoisture;
  double get soilPh => _soilPh;
  double get soilTemp => _soilTemp;
  String get soilType => _soilType;

  Uint8List? get pickedImageBytes => _pickedImageBytes;
  String? get pickedImageName => _pickedImageName;

  DiseaseResult? get currentDiagnosis => _currentDiagnosis;
  RiskAssessmentResult? get currentRisk => _currentRisk;
  WeatherData get weather => _weather;
  List<Map<String, dynamic>> get diagnosisHistory => _diagnosisHistory;
  List<Map<String, dynamic>> get alerts => _alerts;
  List<Map<String, dynamic>> get pendingExpertReviews => _pendingExpertReviews;
  bool get day7Completed => _day7Completed;
  String get monitoringProgression => _monitoringProgression;
  String get monitoringNotes => _monitoringNotes;

  void setPickedImage(Uint8List? bytes, String? name) {
    _pickedImageBytes = bytes;
    _pickedImageName = name;
    notifyListeners();
  }

  AppState() {
    _initDefaults();
  }

  void _initDefaults() {
    // Default baseline diagnosis (Day 0) - Simple farmer friendly terms
    _currentDiagnosis = DiseaseResult(
      crop: 'Tomato',
      disease: 'Tomato Early Blight',
      confidence: 0.54, // Shows Hackathon confidence check (<70%) -> Doctor Review
      severity: 'Moderate',
      explanation:
          'Brown circular spots with rings found on lower leaves. Disease spreads faster in cloudy and humid weather.',
      recommendations:
          '• Pluck and safely destroy yellow/spotted leaves immediately.\n• Water directly at the root base; avoid spraying water on leaves.\n• Case sent to Crop Specialist for exact medicine prescription.',
      prevention: 'Maintain gap between plants for sunlight and airflow. Avoid stagnant water around roots.',
      modelVersion: 'AI Plant Doctor v1.0',
      requiresExpertReview: true,
      isOfflineResult: false,
    );

    _currentRisk = RiskAssessmentService.instance.evaluate(
      disease: 'Tomato Early Blight',
      severity: 'Moderate',
      confidence: 0.54,
      humidity: 78.0,
      rainChance: 65.0,
      soilMoisture: 64.0,
      pestCount: 18,
    );

    _alerts = [
      {
        'id': '1',
        'type': 'EXPERT_REVIEW',
        'title': 'Expert Review Recommended',
        'message':
            'AI confidence is 54% for Tomato foliage observation. Case forwarded to Dr. Meena Sharma.',
        'severity': 'MODERATE',
        'date': '2 hours ago',
      },
      {
        'id': '2',
        'type': 'WEATHER_ALERT',
        'title': 'High Humidity Alert (>75%)',
        'message':
            'Ambient humidity is 78%. Fungal spore germination risk is elevated in Sihor block.',
        'severity': 'HIGH',
        'date': 'Today, 8:30 AM',
      },
      {
        'id': '3',
        'type': 'MONITORING_ALERT',
        'title': '7-Day Follow-Up Due',
        'message':
            'Upload Day 7 comparative leaf image to verify symptom regression.',
        'severity': 'LOW',
        'date': 'Yesterday',
      },
    ];

    _pendingExpertReviews = [
      {
        'id': 1,
        'farmer_name': 'Ramesh Patel',
        'farm_name': 'Patel Krishi Farm (Sihor)',
        'crop': 'Tomato',
        'ai_result': 'Tomato Early Blight',
        'confidence': 0.54,
        'severity': 'Moderate',
        'risk_level': 'HIGH',
        'location': 'Sihor, Bhavnagar',
        'date': 'Today, 10:15 AM',
        'status': 'PENDING',
        'notes': '',
        'recommendations': '',
      },
      {
        'id': 2,
        'farmer_name': 'Bhavesh Gohil',
        'farm_name': 'Gohil Agro Plot',
        'crop': 'Cotton',
        'ai_result': 'Bacterial Blight',
        'confidence': 0.62,
        'severity': 'High',
        'risk_level': 'HIGH',
        'location': 'Palitana, Bhavnagar',
        'date': 'Yesterday',
        'status': 'PENDING',
        'notes': '',
        'recommendations': '',
      },
    ];

    _diagnosisHistory = [
      {
        'date': '16 Sep',
        'crop': 'Tomato',
        'disease': 'Tomato Early Blight',
        'confidence': '54%',
        'risk': 'High',
        'status': 'Under Expert Review',
      },
      {
        'date': '09 Sep',
        'crop': 'Tomato',
        'disease': 'Tomato Early Blight',
        'confidence': '87%',
        'risk': 'Moderate',
        'status': 'Verified',
      },
      {
        'date': '28 Aug',
        'crop': 'Tomato',
        'disease': 'Healthy Foliage',
        'confidence': '95%',
        'risk': 'Low',
        'status': 'Completed',
      },
    ];
  }

  // --- LANGUAGE SWITCHER ---
  void setLocale(String languageCode) {
    _locale = Locale(languageCode);
    notifyListeners();
  }

  // --- PERSONA SWITCHER (For Presentation Ease) ---
  void switchRole(UserRole role) {
    _currentRole = role;
    switch (role) {
      case UserRole.farmer:
        _userName = AppConstants.demoAccounts['farmer']!['name']!;
        _userEmail = AppConstants.demoAccounts['farmer']!['email']!;
        _userSubtitle = AppConstants.demoAccounts['farmer']!['subtitle']!;
        break;
      case UserRole.expert:
        _userName = AppConstants.demoAccounts['expert']!['name']!;
        _userEmail = AppConstants.demoAccounts['expert']!['email']!;
        _userSubtitle = AppConstants.demoAccounts['expert']!['subtitle']!;
        break;
      case UserRole.officer:
        _userName = AppConstants.demoAccounts['officer']!['name']!;
        _userEmail = AppConstants.demoAccounts['officer']!['email']!;
        _userSubtitle = AppConstants.demoAccounts['officer']!['subtitle']!;
        break;
      case UserRole.admin:
        _userName = AppConstants.demoAccounts['admin']!['name']!;
        _userEmail = AppConstants.demoAccounts['admin']!['email']!;
        _userSubtitle = AppConstants.demoAccounts['admin']!['subtitle']!;
        break;
    }
    notifyListeners();
  }

  // --- RUN CROP ANALYSIS ---
  Future<void> runAnalysis({
    required String cropHint,
    bool forceLowConfidence = false,
  }) async {
    final isOffline = SyncService.instance.isOfflineMode;

    // Use Mock/On-Device AI service
    final result = await MockDiseaseDetectionService().analyzeImage(
      imagePath: 'demo_leaf_image.png',
      cropHint: cropHint,
      forceLowConfidence: forceLowConfidence,
    );

    _currentDiagnosis = result;

    // Compute multi-factor risk
    _currentRisk = RiskAssessmentService.instance.evaluate(
      disease: result.disease,
      severity: result.severity,
      confidence: result.confidence,
      humidity: _weather.humidityPct,
      rainChance: _weather.rainChancePct,
      soilMoisture: _soilMoisture,
      pestCount: 18,
    );

    // Save locally
    await LocalStorageService.instance.saveDiagnosisLocally(result.toMap());

    // Queue sync operation if offline
    if (isOffline) {
      await LocalStorageService.instance.addPendingSyncItem(
        entityType: 'diagnosis',
        entityId: DateTime.now().millisecondsSinceEpoch.toString(),
        operation: 'CREATE',
        payload: result.toMap(),
      );
      await SyncService.instance.refreshPendingCount();
    }

    _diagnosisHistory.insert(0, {
      'date': 'Today',
      'crop': result.crop,
      'disease': result.disease,
      'confidence': '${(result.confidence * 100).toStringAsFixed(0)}%',
      'risk': _currentRisk!.riskLevel,
      'status': result.requiresExpertReview ? 'Under Expert Review' : 'AI Verified',
    });

    notifyListeners();
  }

  // --- EXPERT VALIDATE OR OVERRIDE ---
  void validateExpertCase({
    required int reviewId,
    required String action, // VALIDATE or OVERRIDE
    String? overriddenDisease,
    required String notes,
    required String recommendations,
  }) {
    final idx = _pendingExpertReviews.indexWhere((r) => r['id'] == reviewId);
    if (idx != -1) {
      _pendingExpertReviews[idx]['status'] = action == 'OVERRIDE' ? 'OVERRIDDEN' : 'VALIDATED';
      _pendingExpertReviews[idx]['notes'] = notes;
      _pendingExpertReviews[idx]['recommendations'] = recommendations;
      if (overriddenDisease != null) {
        _pendingExpertReviews[idx]['ai_result'] = overriddenDisease;
      }
    }

    // Update farmer diagnosis state if this corresponds to case #1
    if (reviewId == 1 && _currentDiagnosis != null) {
      _currentDiagnosis = DiseaseResult(
        crop: _currentDiagnosis!.crop,
        disease: overriddenDisease ?? _currentDiagnosis!.disease,
        confidence: 0.95, // Expert validated!
        severity: _currentDiagnosis!.severity,
        explanation: 'Expert Validated by Dr. Meena Sharma: $notes',
        recommendations: '• [Doctor Recommendation]: $recommendations\n• ${_currentDiagnosis!.recommendations}',
        prevention: _currentDiagnosis!.prevention,
        modelVersion: 'Expert Verified (AAU Anand)',
        requiresExpertReview: false,
        isOfflineResult: false,
      );

      _alerts.insert(0, {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'type': 'EXPERT_VALIDATED',
        'title': 'Expert Recommendation Received',
        'message':
            'Dr. Meena Sharma verified your Tomato observation and updated your advisory.',
        'severity': 'LOW',
        'date': 'Just now',
      });
    }

    notifyListeners();
  }

  // --- COMPLETE CONTINUOUS MONITORING (DAY 0 vs DAY 7) ---
  void completeDay7Monitoring({
    required String progression, // IMPROVED, STABLE, WORSENED
  }) {
    _day7Completed = true;
    _monitoringProgression = progression;

    if (progression == 'IMPROVED') {
      _monitoringNotes =
          'Foliar necrotic lesion margins have halted expansion and dried out following lower canopy pruning. New apical flush is healthy and vibrant green.';
    } else if (progression == 'WORSENED') {
      _monitoringNotes =
          'Secondary lesions have migrated to mid-canopy foliage. Immediate contact bio-copper fungicide recommended.';
    } else {
      _monitoringNotes =
          'Pathogen symptoms stabilized without outward migration to younger leaves.';
    }

    notifyListeners();
  }
}
