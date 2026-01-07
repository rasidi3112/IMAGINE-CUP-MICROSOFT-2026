import 'disease.dart';

enum SeverityLevel { healthy, low, medium, high, critical }

class ScanResult {
  final String id;
  final String imagePath;
  final String? cloudImageUrl;
  final DateTime scanDate;
  final double latitude;
  final double longitude;
  final String? locationName;
  final String plantType;
  final Disease? detectedDisease;
  final double confidenceScore;
  final SeverityLevel severityLevel;
  final double severityPercentage;
  final bool isSynced;
  final String? aiConsultationResponse;
  final List<Treatment>? recommendedTreatments;

  ScanResult({
    required this.id,
    required this.imagePath,
    this.cloudImageUrl,
    required this.scanDate,
    required this.latitude,
    required this.longitude,
    this.locationName,
    required this.plantType,
    this.detectedDisease,
    required this.confidenceScore,
    required this.severityLevel,
    required this.severityPercentage,
    this.isSynced = false,
    this.aiConsultationResponse,
    this.recommendedTreatments,
  });

  String get severityText {
    switch (severityLevel) {
      case SeverityLevel.healthy:
        return 'Sehat';
      case SeverityLevel.low:
        return 'Ringan';
      case SeverityLevel.medium:
        return 'Sedang';
      case SeverityLevel.high:
        return 'Parah';
      case SeverityLevel.critical:
        return 'Kritis';
    }
  }

  String get severityEmoji {
    switch (severityLevel) {
      case SeverityLevel.healthy:
        return '✅';
      case SeverityLevel.low:
        return '🟡';
      case SeverityLevel.medium:
        return '🟠';
      case SeverityLevel.high:
        return '🔴';
      case SeverityLevel.critical:
        return '⚠️';
    }
  }

  factory ScanResult.fromJson(Map<String, dynamic> json) {
    return ScanResult(
      id: json['id'] ?? '',
      imagePath: json['image_path'] ?? '',
      cloudImageUrl: json['cloud_image_url'],
      scanDate: DateTime.parse(
        json['scan_date'] ?? DateTime.now().toIso8601String(),
      ),
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      locationName: json['location_name'],
      plantType: json['plant_type'] ?? '',
      detectedDisease: json['disease'] != null
          ? Disease.fromJson(json['disease'])
          : null,
      confidenceScore: (json['confidence_score'] ?? 0).toDouble(),
      severityLevel: SeverityLevel.values[json['severity_level'] ?? 0],
      severityPercentage: (json['severity_percentage'] ?? 0).toDouble(),
      isSynced: _parseBool(json['is_synced'], false),
      aiConsultationResponse: json['ai_response'],
      recommendedTreatments: json['treatments'] != null
          ? (json['treatments'] as List)
                .map((t) => Treatment.fromJson(t))
                .toList()
          : null,
    );
  }

  static bool _parseBool(dynamic value, bool defaultValue) {
    if (value == null) return defaultValue;
    if (value is bool) return value;
    if (value is int) return value == 1;
    return defaultValue;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_path': imagePath,
      'cloud_image_url': cloudImageUrl,
      'scan_date': scanDate.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'location_name': locationName,
      'plant_type': plantType,
      'disease': detectedDisease?.toJson(),
      'confidence_score': confidenceScore,
      'severity_level': severityLevel.index,
      'severity_percentage': severityPercentage,
      'is_synced': isSynced ? 1 : 0, // Convert bool to int for sqflite
      'ai_response': aiConsultationResponse,
      'treatments': recommendedTreatments?.map((t) => t.toJson()).toList(),
    };
  }

  ScanResult copyWith({
    String? id,
    String? imagePath,
    String? cloudImageUrl,
    DateTime? scanDate,
    double? latitude,
    double? longitude,
    String? locationName,
    String? plantType,
    Disease? detectedDisease,
    double? confidenceScore,
    SeverityLevel? severityLevel,
    double? severityPercentage,
    bool? isSynced,
    String? aiConsultationResponse,
    List<Treatment>? recommendedTreatments,
  }) {
    return ScanResult(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      cloudImageUrl: cloudImageUrl ?? this.cloudImageUrl,
      scanDate: scanDate ?? this.scanDate,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      locationName: locationName ?? this.locationName,
      plantType: plantType ?? this.plantType,
      detectedDisease: detectedDisease ?? this.detectedDisease,
      confidenceScore: confidenceScore ?? this.confidenceScore,
      severityLevel: severityLevel ?? this.severityLevel,
      severityPercentage: severityPercentage ?? this.severityPercentage,
      isSynced: isSynced ?? this.isSynced,
      aiConsultationResponse:
          aiConsultationResponse ?? this.aiConsultationResponse,
      recommendedTreatments:
          recommendedTreatments ?? this.recommendedTreatments,
    );
  }
}

class Treatment {
  final String id;
  final String name;
  final String type; // pesticide, fungicide, organic, cultural
  final String description;
  final String dosage;
  final String applicationMethod;
  final String frequency;
  final int daysUntilNextApplication;
  final List<String> warnings;
  final double estimatedCost;

  Treatment({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.dosage,
    required this.applicationMethod,
    required this.frequency,
    this.daysUntilNextApplication = 7,
    this.warnings = const [],
    this.estimatedCost = 0,
  });

  factory Treatment.fromJson(Map<String, dynamic> json) {
    return Treatment(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      description: json['description'] ?? '',
      dosage: json['dosage'] ?? '',
      applicationMethod: json['application_method'] ?? '',
      frequency: json['frequency'] ?? '',
      daysUntilNextApplication: json['days_until_next'] ?? 7,
      warnings: List<String>.from(json['warnings'] ?? []),
      estimatedCost: (json['estimated_cost'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'description': description,
      'dosage': dosage,
      'application_method': applicationMethod,
      'frequency': frequency,
      'days_until_next': daysUntilNextApplication,
      'warnings': warnings,
      'estimated_cost': estimatedCost,
    };
  }
}
