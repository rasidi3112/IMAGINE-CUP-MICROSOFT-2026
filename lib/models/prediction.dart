class DiseasePrediction {
  final String id;
  final String diseaseId;
  final String diseaseName;
  final String plantType;
  final String regency;
  final String district;
  final double latitude;
  final double longitude;
  final DateTime predictionDate;
  final DateTime predictedOutbreakStart;
  final DateTime predictedOutbreakEnd;
  final PredictionConfidence confidence;
  final RiskLevel riskLevel;
  final List<String> contributingFactors;
  final List<String> preventiveActions;
  final String? weatherCondition;
  final double? predictedSeverity;
  final int? estimatedAffectedArea; // hektar

  DiseasePrediction({
    required this.id,
    required this.diseaseId,
    required this.diseaseName,
    required this.plantType,
    required this.regency,
    required this.district,
    required this.latitude,
    required this.longitude,
    required this.predictionDate,
    required this.predictedOutbreakStart,
    required this.predictedOutbreakEnd,
    required this.confidence,
    required this.riskLevel,
    required this.contributingFactors,
    required this.preventiveActions,
    this.weatherCondition,
    this.predictedSeverity,
    this.estimatedAffectedArea,
  });

  factory DiseasePrediction.fromJson(Map<String, dynamic> json) =>
      DiseasePrediction(
        id: json['id'] ?? '',
        diseaseId: json['disease_id'] ?? '',
        diseaseName: json['disease_name'] ?? '',
        plantType: json['plant_type'] ?? '',
        regency: json['regency'] ?? '',
        district: json['district'] ?? '',
        latitude: (json['latitude'] ?? 0).toDouble(),
        longitude: (json['longitude'] ?? 0).toDouble(),
        predictionDate: DateTime.parse(
          json['prediction_date'] ?? DateTime.now().toIso8601String(),
        ),
        predictedOutbreakStart: DateTime.parse(
          json['outbreak_start'] ?? DateTime.now().toIso8601String(),
        ),
        predictedOutbreakEnd: DateTime.parse(
          json['outbreak_end'] ?? DateTime.now().toIso8601String(),
        ),
        confidence: PredictionConfidence.values[json['confidence'] ?? 0],
        riskLevel: RiskLevel.values[json['risk_level'] ?? 0],
        contributingFactors: List<String>.from(
          json['contributing_factors'] ?? [],
        ),
        preventiveActions: List<String>.from(json['preventive_actions'] ?? []),
        weatherCondition: json['weather_condition'],
        predictedSeverity: json['predicted_severity']?.toDouble(),
        estimatedAffectedArea: json['affected_area'],
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'disease_id': diseaseId,
    'disease_name': diseaseName,
    'plant_type': plantType,
    'regency': regency,
    'district': district,
    'latitude': latitude,
    'longitude': longitude,
    'prediction_date': predictionDate.toIso8601String(),
    'outbreak_start': predictedOutbreakStart.toIso8601String(),
    'outbreak_end': predictedOutbreakEnd.toIso8601String(),
    'confidence': confidence.index,
    'risk_level': riskLevel.index,
    'contributing_factors': contributingFactors,
    'preventive_actions': preventiveActions,
    'weather_condition': weatherCondition,
    'predicted_severity': predictedSeverity,
    'affected_area': estimatedAffectedArea,
  };

  String get riskEmoji {
    switch (riskLevel) {
      case RiskLevel.low:
        return '🟢';
      case RiskLevel.moderate:
        return '🟡';
      case RiskLevel.high:
        return '🟠';
      case RiskLevel.critical:
        return '🔴';
    }
  }

  String get riskText {
    switch (riskLevel) {
      case RiskLevel.low:
        return 'Risiko Rendah';
      case RiskLevel.moderate:
        return 'Risiko Sedang';
      case RiskLevel.high:
        return 'Risiko Tinggi';
      case RiskLevel.critical:
        return 'Risiko Kritis';
    }
  }

  String get confidenceText {
    switch (confidence) {
      case PredictionConfidence.low:
        return 'Kepercayaan Rendah (< 50%)';
      case PredictionConfidence.moderate:
        return 'Kepercayaan Sedang (50-70%)';
      case PredictionConfidence.high:
        return 'Kepercayaan Tinggi (70-85%)';
      case PredictionConfidence.veryHigh:
        return 'Kepercayaan Sangat Tinggi (> 85%)';
    }
  }

  int get daysUntilOutbreak {
    return predictedOutbreakStart.difference(DateTime.now()).inDays;
  }

  bool get isImminent => daysUntilOutbreak <= 7;
  bool get isActive =>
      DateTime.now().isAfter(predictedOutbreakStart) &&
      DateTime.now().isBefore(predictedOutbreakEnd);
}

enum PredictionConfidence { low, moderate, high, veryHigh }

enum RiskLevel { low, moderate, high, critical }

// Early Warning Alert
class EarlyWarningAlert {
  final String id;
  final String title;
  final String message;
  final AlertType type;
  final AlertSeverity severity;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final String? diseaseId;
  final String? regionAffected;
  final List<String> actionItems;
  final bool isRead;
  final String? sourceUrl;

  EarlyWarningAlert({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.severity,
    required this.createdAt,
    this.expiresAt,
    this.diseaseId,
    this.regionAffected,
    required this.actionItems,
    this.isRead = false,
    this.sourceUrl,
  });

  factory EarlyWarningAlert.fromJson(Map<String, dynamic> json) =>
      EarlyWarningAlert(
        id: json['id'] ?? '',
        title: json['title'] ?? '',
        message: json['message'] ?? '',
        type: AlertType.values[json['type'] ?? 0],
        severity: AlertSeverity.values[json['severity'] ?? 0],
        createdAt: DateTime.parse(
          json['created_at'] ?? DateTime.now().toIso8601String(),
        ),
        expiresAt: json['expires_at'] != null
            ? DateTime.parse(json['expires_at'])
            : null,
        diseaseId: json['disease_id'],
        regionAffected: json['region_affected'],
        actionItems: List<String>.from(json['action_items'] ?? []),
        isRead: json['is_read'] ?? false,
        sourceUrl: json['source_url'],
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'message': message,
    'type': type.index,
    'severity': severity.index,
    'created_at': createdAt.toIso8601String(),
    'expires_at': expiresAt?.toIso8601String(),
    'disease_id': diseaseId,
    'region_affected': regionAffected,
    'action_items': actionItems,
    'is_read': isRead,
    'source_url': sourceUrl,
  };

  String get typeEmoji {
    switch (type) {
      case AlertType.diseaseOutbreak:
        return '🦠';
      case AlertType.pestInfestation:
        return '🐛';
      case AlertType.weatherWarning:
        return '⛈️';
      case AlertType.marketPrice:
        return '💰';
      case AlertType.generalInfo:
        return 'ℹ️';
    }
  }

  String get severityEmoji {
    switch (severity) {
      case AlertSeverity.info:
        return '🔵';
      case AlertSeverity.warning:
        return '🟡';
      case AlertSeverity.urgent:
        return '🟠';
      case AlertSeverity.emergency:
        return '🔴';
    }
  }

  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);
}

enum AlertType {
  diseaseOutbreak,
  pestInfestation,
  weatherWarning,
  marketPrice,
  generalInfo,
}

enum AlertSeverity { info, warning, urgent, emergency }

// Prediction Engine - Logika Prediksi Sederhana
class PredictionEngine {
  // Generate predictions based on historical data and weather
  static List<DiseasePrediction> generatePredictions({
    required String regency,
    required String plantType,
    required double temperature,
    required double humidity,
    required double rainfall,
    required int month,
  }) {
    List<DiseasePrediction> predictions = [];

    // Rules-based prediction system

    // Rice diseases
    if (plantType == 'rice' || plantType == 'padi') {
      // Blast risk high in humid conditions
      if (humidity > 85 &&
          temperature >= 22 &&
          temperature <= 28 &&
          rainfall > 100) {
        predictions.add(
          _createPrediction(
            diseaseId: 'rice_blast',
            diseaseName: 'Blas Padi',
            plantType: 'Padi',
            regency: regency,
            riskLevel: RiskLevel.high,
            confidence: PredictionConfidence.high,
            daysAhead: 7,
            contributingFactors: [
              'Kelembaban tinggi > 85%',
              'Suhu optimal untuk spora (22-28°C)',
              'Curah hujan tinggi menyebarkan spora',
            ],
            preventiveActions: [
              'Semprot fungisida preventif (Dithane/Score)',
              'Kurangi pemupukan nitrogen berlebihan',
              'Pastikan drainase lahan baik',
            ],
          ),
        );
      }

      // Tungro risk in dry season with vector presence
      if (rainfall < 50 && temperature > 28 && (month >= 6 && month <= 9)) {
        predictions.add(
          _createPrediction(
            diseaseId: 'rice_tungro',
            diseaseName: 'Tungro Padi',
            plantType: 'Padi',
            regency: regency,
            riskLevel: RiskLevel.moderate,
            confidence: PredictionConfidence.moderate,
            daysAhead: 14,
            contributingFactors: [
              'Musim kemarau - wereng hijau aktif',
              'Suhu tinggi mempercepat siklus vektor',
            ],
            preventiveActions: [
              'Pantau populasi wereng hijau',
              'Pasang perangkap lampu',
              'Gunakan varietas tahan tungro',
            ],
          ),
        );
      }
    }

    // Corn diseases
    if (plantType == 'corn' || plantType == 'jagung') {
      // Downy mildew risk
      if (humidity > 90 &&
          temperature >= 20 &&
          temperature <= 27 &&
          rainfall > 50) {
        predictions.add(
          _createPrediction(
            diseaseId: 'corn_downy_mildew',
            diseaseName: 'Bulai Jagung',
            plantType: 'Jagung',
            regency: regency,
            riskLevel: RiskLevel.critical,
            confidence: PredictionConfidence.veryHigh,
            daysAhead: 5,
            contributingFactors: [
              'Kelembaban sangat tinggi > 90%',
              'Suhu dingin pagi hari',
              'Kondisi embun panjang',
            ],
            preventiveActions: [
              'Gunakan benih berbalut fungisida',
              'Semprot Ridomil Gold preventif',
              'Cabut tanaman terinfeksi segera',
              'Tanam varietas tahan bulai',
            ],
          ),
        );
      }
    }

    // Chili diseases
    if (plantType == 'chili' || plantType == 'cabai') {
      // Anthracnose risk after rain
      if (rainfall > 30 && humidity > 80) {
        predictions.add(
          _createPrediction(
            diseaseId: 'chili_anthracnose',
            diseaseName: 'Antraknosa Cabai',
            plantType: 'Cabai',
            regency: regency,
            riskLevel: humidity > 90 ? RiskLevel.high : RiskLevel.moderate,
            confidence: PredictionConfidence.high,
            daysAhead: 3,
            contributingFactors: [
              'Hujan menyebarkan spora Colletotrichum',
              'Kelembaban tinggi',
              'Buah lembab mudah terinfeksi',
            ],
            preventiveActions: [
              'Semprot Antracol/Score setelah hujan reda',
              'Panen buah matang segera',
              'Sanitasi buah busuk',
              'Mulsa untuk cegah percikan air',
            ],
          ),
        );
      }

      // Yellow leaf curl virus risk in dry weather
      if (rainfall < 20 && temperature > 30) {
        predictions.add(
          _createPrediction(
            diseaseId: 'chili_yellow_leaf_curl',
            diseaseName: 'Keriting Kuning Cabai',
            plantType: 'Cabai',
            regency: regency,
            riskLevel: RiskLevel.moderate,
            confidence: PredictionConfidence.moderate,
            daysAhead: 10,
            contributingFactors: [
              'Cuaca panas dan kering',
              'Populasi kutu kebul meningkat',
            ],
            preventiveActions: [
              'Pasang perangkap kuning',
              'Semprot insektisida sistemik (Confidor)',
              'Gunakan mulsa perak untuk tolak kutu',
            ],
          ),
        );
      }
    }

    // Onion diseases
    if (plantType == 'onion' || plantType == 'bawang') {
      // Purple blotch after rain
      if (rainfall > 20 && humidity > 75) {
        predictions.add(
          _createPrediction(
            diseaseId: 'onion_purple_blotch',
            diseaseName: 'Bercak Ungu Bawang',
            plantType: 'Bawang Merah',
            regency: regency,
            riskLevel: RiskLevel.high,
            confidence: PredictionConfidence.high,
            daysAhead: 5,
            contributingFactors: [
              'Hujan menyebarkan spora Alternaria',
              'Kelembaban tinggi pada malam hari',
              'Daun lembab terlalu lama',
            ],
            preventiveActions: [
              'Semprot Dithane/Antracol preventif',
              'Jangan semprot saat hujan',
              'Perbaiki drainase',
              'Jarak tanam tidak terlalu rapat',
            ],
          ),
        );
      }
    }

    return predictions;
  }

  static DiseasePrediction _createPrediction({
    required String diseaseId,
    required String diseaseName,
    required String plantType,
    required String regency,
    required RiskLevel riskLevel,
    required PredictionConfidence confidence,
    required int daysAhead,
    required List<String> contributingFactors,
    required List<String> preventiveActions,
  }) {
    final now = DateTime.now();
    return DiseasePrediction(
      id: '${diseaseId}_${now.millisecondsSinceEpoch}',
      diseaseId: diseaseId,
      diseaseName: diseaseName,
      plantType: plantType,
      regency: regency,
      district: '',
      latitude: 0,
      longitude: 0,
      predictionDate: now,
      predictedOutbreakStart: now.add(Duration(days: daysAhead)),
      predictedOutbreakEnd: now.add(Duration(days: daysAhead + 21)),
      confidence: confidence,
      riskLevel: riskLevel,
      contributingFactors: contributingFactors,
      preventiveActions: preventiveActions,
    );
  }
}
