class RiskFactorItem {
  final String factor;
  final String impact;
  final int points;
  final String description;

  RiskFactorItem({
    required this.factor,
    required this.impact,
    required this.points,
    required this.description,
  });

  factory RiskFactorItem.fromMap(Map<String, dynamic> map) {
    return RiskFactorItem(
      factor: map['factor'] ?? '',
      impact: map['impact'] ?? 'Moderate',
      points: map['points'] ?? 0,
      description: map['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'factor': factor,
      'impact': impact,
      'points': points,
      'description': description,
    };
  }
}

class RiskAssessmentResult {
  final String riskLevel; // LOW, MODERATE, HIGH
  final double riskScore; // 0-100
  final List<RiskFactorItem> factors;
  final String explanation;
  final String advisorySummary;

  RiskAssessmentResult({
    required this.riskLevel,
    required this.riskScore,
    required this.factors,
    required this.explanation,
    required this.advisorySummary,
  });

  factory RiskAssessmentResult.fromMap(Map<String, dynamic> map) {
    final rawFactors = map['risk_factors'] as List? ?? [];
    return RiskAssessmentResult(
      riskLevel: map['risk_level'] ?? 'MODERATE',
      riskScore: (map['risk_score'] as num?)?.toDouble() ?? 65.0,
      factors: rawFactors.map((f) => RiskFactorItem.fromMap(f)).toList(),
      explanation: map['explanation'] ?? '',
      advisorySummary: map['advisory_summary'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'risk_level': riskLevel,
      'risk_score': riskScore,
      'risk_factors': factors.map((f) => f.toMap()).toList(),
      'explanation': explanation,
      'advisory_summary': advisorySummary,
    };
  }
}

class RiskAssessmentService {
  static final RiskAssessmentService instance = RiskAssessmentService._();
  RiskAssessmentService._();

  RiskAssessmentResult evaluate({
    required String disease,
    required String severity,
    required double confidence,
    double humidity = 78.0,
    double rainChance = 65.0,
    double soilMoisture = 64.0,
    int pestCount = 18,
  }) {
    double score = 0.0;
    final List<RiskFactorItem> factors = [];

    // 1. Disease Pathogen Factor
    if (disease.toLowerCase().contains('healthy')) {
      factors.add(RiskFactorItem(
        factor: 'Disease Symptoms',
        impact: 'Low',
        points: 5,
        description: 'Healthy foliage; low baseline pathogen pressure.',
      ));
      score += 5;
    } else if (severity.toLowerCase() == 'high') {
      factors.add(RiskFactorItem(
        factor: 'High Severity Pathogen',
        impact: 'High',
        points: 35,
        description: '$disease confirmed at ${int.parse((confidence * 100).toStringAsFixed(0))}% AI confidence.',
      ));
      score += 35;
    } else {
      factors.add(RiskFactorItem(
        factor: 'Moderate Pathogen Lesions',
        impact: 'Moderate',
        points: 25,
        description: 'Early Blight lesions detected with ${int.parse((confidence * 100).toStringAsFixed(0))}% AI confidence.',
      ));
      score += 25;
    }

    // 2. Humidity Factor
    if (humidity >= 75) {
      factors.add(RiskFactorItem(
        factor: 'Elevated Relative Humidity',
        impact: 'High',
        points: 25,
        description: 'Sustained microclimate humidity (${humidity.toStringAsFixed(0)}%) accelerates spore germination.',
      ));
      score += 25;
    } else {
      factors.add(RiskFactorItem(
        factor: 'Moderate Humidity',
        impact: 'Moderate',
        points: 12,
        description: 'Relative humidity is at ${humidity.toStringAsFixed(0)}%.',
      ));
      score += 12;
    }

    // 3. Rain Forecast
    if (rainChance >= 60) {
      factors.add(RiskFactorItem(
        factor: 'Imminent Rain Probability',
        impact: 'High',
        points: 15,
        description: 'Precipitation forecast (${rainChance.toStringAsFixed(0)}%) prolongs canopy wetness.',
      ));
      score += 15;
    } else {
      factors.add(RiskFactorItem(
        factor: 'Dry Weather',
        impact: 'Low',
        points: 4,
        description: 'Low precipitation chance (${rainChance.toStringAsFixed(0)}%).',
      ));
      score += 4;
    }

    // 4. Soil Moisture
    if (soilMoisture >= 60) {
      factors.add(RiskFactorItem(
        factor: 'Soil Moisture',
        impact: 'Moderate',
        points: 6,
        description: 'Black cotton soil moisture is at ${soilMoisture.toStringAsFixed(0)}%.',
      ));
      score += 6;
    }

    // 5. Pest Trap
    if (pestCount >= 15) {
      factors.add(RiskFactorItem(
        factor: 'Pest Vector Pressure',
        impact: 'Moderate',
        points: 10,
        description: 'Sticky trap captured $pestCount Whiteflies.',
      ));
      score += 10;
    }

    String level = 'LOW';
    String explanation = 'Environmental conditions do not favor disease spread.';
    String advisory = 'Continue standard cultivation practices and weekly scouting.';

    if (score >= 70) {
      level = 'HIGH';
      explanation =
          'Multiple co-occurring stress factors: high atmospheric humidity, rainfall, and active foliar lesions significantly elevate overall crop vulnerability.';
      advisory =
          'Prune lower canopy leaves immediately, suspend furrow flooding, and consult expert validation.';
    } else if (score >= 40) {
      level = 'MODERATE';
      explanation =
          'Moderate disease symptoms detected alongside elevated humidity. Weather conditions are conducive to localized spread if left unaddressed.';
      advisory =
          'Maintain canopy ventilation, avoid evening irrigation, and apply bio-protectant within 48 hours.';
    }

    return RiskAssessmentResult(
      riskLevel: level,
      riskScore: score,
      factors: factors,
      explanation: explanation,
      advisorySummary: advisory,
    );
  }
}
