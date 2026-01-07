/// AgriVision NTB - Weather Alert Service
/// Service untuk smart alerts berbasis cuaca dan risiko penyakit
///
/// Fitur:
/// - Generate alerts berdasarkan kondisi cuaca
/// - Prediksi risiko penyakit
/// - Notifikasi cerdas untuk petani

import 'package:flutter/material.dart';
import '../models/weather.dart';

/// Tingkat urgensi alert
enum AlertLevel {
  info, // Informasi umum
  warning, // Perlu perhatian
  danger, // Bahaya, perlu tindakan segera
}

extension AlertLevelExtension on AlertLevel {
  String get name {
    switch (this) {
      case AlertLevel.info:
        return 'Info';
      case AlertLevel.warning:
        return 'Peringatan';
      case AlertLevel.danger:
        return 'Bahaya';
    }
  }

  Color get color {
    switch (this) {
      case AlertLevel.info:
        return const Color(0xFF2196F3); // Blue
      case AlertLevel.warning:
        return const Color(0xFFFF9800); // Orange
      case AlertLevel.danger:
        return const Color(0xFFF44336); // Red
    }
  }

  IconData get icon {
    switch (this) {
      case AlertLevel.info:
        return Icons.info_outline;
      case AlertLevel.warning:
        return Icons.warning_amber_rounded;
      case AlertLevel.danger:
        return Icons.dangerous_rounded;
    }
  }

  String get emoji {
    switch (this) {
      case AlertLevel.info:
        return 'ℹ️';
      case AlertLevel.warning:
        return '⚠️';
      case AlertLevel.danger:
        return '🚨';
    }
  }
}

/// Kategori alert
enum AlertCategory {
  disease, // Risiko penyakit
  weather, // Kondisi cuaca
  activity, // Rekomendasi aktivitas
  seasonal, // Musim/kalender tanam
}

extension AlertCategoryExtension on AlertCategory {
  String get name {
    switch (this) {
      case AlertCategory.disease:
        return 'Risiko Penyakit';
      case AlertCategory.weather:
        return 'Kondisi Cuaca';
      case AlertCategory.activity:
        return 'Aktivitas Pertanian';
      case AlertCategory.seasonal:
        return 'Musim Tanam';
    }
  }

  IconData get icon {
    switch (this) {
      case AlertCategory.disease:
        return Icons.coronavirus_outlined;
      case AlertCategory.weather:
        return Icons.thunderstorm_outlined;
      case AlertCategory.activity:
        return Icons.agriculture_outlined;
      case AlertCategory.seasonal:
        return Icons.calendar_month_outlined;
    }
  }
}

/// Model untuk single alert
class WeatherAlert {
  final String id;
  final String title;
  final String message;
  final AlertLevel level;
  final AlertCategory category;
  final DateTime timestamp;
  final String? actionText;
  final String? diseaseId;
  final List<String> affectedPlants;
  final Map<String, dynamic>? metadata;

  const WeatherAlert({
    required this.id,
    required this.title,
    required this.message,
    required this.level,
    required this.category,
    required this.timestamp,
    this.actionText,
    this.diseaseId,
    this.affectedPlants = const [],
    this.metadata,
  });

  String get emoji {
    return '${level.emoji} ${_getCategoryEmoji()}';
  }

  String _getCategoryEmoji() {
    switch (category) {
      case AlertCategory.disease:
        return '🦠';
      case AlertCategory.weather:
        return '🌦️';
      case AlertCategory.activity:
        return '🌾';
      case AlertCategory.seasonal:
        return '📅';
    }
  }
}

/// Service untuk generate weather-based alerts
class WeatherAlertService {
  static final WeatherAlertService _instance = WeatherAlertService._internal();
  factory WeatherAlertService() => _instance;
  WeatherAlertService._internal();

  /// Generate alerts berdasarkan data cuaca
  List<WeatherAlert> generateAlerts(
    Weather weather, {
    List<String>? userPlants,
  }) {
    final alerts = <WeatherAlert>[];
    final now = DateTime.now();
    // User plants can be used for filtering in future versions
    final _ = userPlants ?? ['Padi', 'Jagung', 'Cabai'];

    // 1. Disease Risk Alerts
    final diseaseRisks = weather.diseaseRisks;
    for (final risk in diseaseRisks) {
      alerts.add(
        WeatherAlert(
          id: 'disease_${risk.diseaseId}_${now.millisecondsSinceEpoch}',
          title: '${risk.riskEmoji} Waspada ${risk.diseaseName}!',
          message: risk.reason,
          level: risk.riskLevel == 'tinggi'
              ? AlertLevel.danger
              : risk.riskLevel == 'sedang'
              ? AlertLevel.warning
              : AlertLevel.info,
          category: AlertCategory.disease,
          timestamp: now,
          actionText: 'Lihat pencegahan',
          diseaseId: risk.diseaseId,
          affectedPlants: _getAffectedPlants(risk.diseaseId),
        ),
      );
    }

    // 2. Weather Condition Alerts
    alerts.addAll(_generateWeatherAlerts(weather, now));

    // 3. Activity Recommendations
    final recommendation = weather.farmingRecommendation;
    if (recommendation.warnings.isNotEmpty) {
      alerts.add(
        WeatherAlert(
          id: 'activity_warning_${now.millisecondsSinceEpoch}',
          title: '${recommendation.statusEmoji} Kondisi Aktivitas Pertanian',
          message: recommendation.message,
          level: recommendation.warnings.isEmpty
              ? AlertLevel.info
              : AlertLevel.warning,
          category: AlertCategory.activity,
          timestamp: now,
          actionText: recommendation.recommendations.isNotEmpty
              ? recommendation.recommendations.first
              : null,
          metadata: {
            'canSpray': recommendation.canSpray,
            'canHarvest': recommendation.canHarvest,
            'canPlant': recommendation.canPlant,
            'canFertilize': recommendation.canFertilize,
          },
        ),
      );
    }

    // 4. Seasonal Alerts
    final season = NTBSeasonalData.getCurrentSeason();
    alerts.add(
      WeatherAlert(
        id: 'seasonal_${now.month}_${now.day}',
        title: '${season.seasonEmoji} ${season.seasonName} di NTB',
        message: 'Rekomendasi: ${season.plantingRecommendation}',
        level: AlertLevel.info,
        category: AlertCategory.seasonal,
        timestamp: now,
        metadata: {'avgRain': season.avgRain, 'avgTemp': season.avgTemp},
      ),
    );

    // Sort by level (danger first)
    alerts.sort((a, b) {
      final levelOrder = {
        AlertLevel.danger: 0,
        AlertLevel.warning: 1,
        AlertLevel.info: 2,
      };
      return levelOrder[a.level]!.compareTo(levelOrder[b.level]!);
    });

    return alerts;
  }

  /// Generate weather-specific alerts
  List<WeatherAlert> _generateWeatherAlerts(Weather weather, DateTime now) {
    final alerts = <WeatherAlert>[];

    // Heavy rain
    if (weather.rainfall > 20) {
      alerts.add(
        WeatherAlert(
          id: 'rain_heavy_${now.millisecondsSinceEpoch}',
          title: '⛈️ Hujan Lebat Diprediksi!',
          message:
              'Curah hujan ${weather.rainfall.toStringAsFixed(1)} mm. '
              'Persiapkan drainase dan lindungi tanaman.',
          level: AlertLevel.danger,
          category: AlertCategory.weather,
          timestamp: now,
          actionText: 'Periksa drainase sawah',
        ),
      );
    } else if (weather.rainfall > 10) {
      alerts.add(
        WeatherAlert(
          id: 'rain_moderate_${now.millisecondsSinceEpoch}',
          title: '🌧️ Hujan Sedang Diprediksi',
          message:
              'Curah hujan ${weather.rainfall.toStringAsFixed(1)} mm. '
              'Tunda aktivitas penyemprotan.',
          level: AlertLevel.warning,
          category: AlertCategory.weather,
          timestamp: now,
          actionText: 'Reschedule penyemprotan',
        ),
      );
    }

    // High temperature
    if (weather.temperature > 35) {
      alerts.add(
        WeatherAlert(
          id: 'temp_high_${now.millisecondsSinceEpoch}',
          title: '🥵 Suhu Sangat Tinggi!',
          message:
              'Suhu ${weather.temperature.toStringAsFixed(1)}°C. '
              'Tanaman bisa stres panas. Tingkatkan penyiraman.',
          level: AlertLevel.danger,
          category: AlertCategory.weather,
          timestamp: now,
          actionText: 'Jadwalkan penyiraman',
        ),
      );
    } else if (weather.temperature > 32) {
      alerts.add(
        WeatherAlert(
          id: 'temp_warm_${now.millisecondsSinceEpoch}',
          title: '☀️ Cuaca Panas',
          message:
              'Suhu ${weather.temperature.toStringAsFixed(1)}°C. '
              'Semprot pestisida pagi/sore saja.',
          level: AlertLevel.warning,
          category: AlertCategory.weather,
          timestamp: now,
        ),
      );
    }

    // High humidity
    if (weather.humidity > 90) {
      alerts.add(
        WeatherAlert(
          id: 'humidity_high_${now.millisecondsSinceEpoch}',
          title: '💧 Kelembaban Sangat Tinggi!',
          message:
              'Kelembaban ${weather.humidity.toStringAsFixed(0)}%. '
              'Risiko penyakit jamur meningkat drastis!',
          level: AlertLevel.danger,
          category: AlertCategory.weather,
          timestamp: now,
          actionText: 'Semprotkan fungisida preventif',
        ),
      );
    } else if (weather.humidity > 80) {
      alerts.add(
        WeatherAlert(
          id: 'humidity_moderate_${now.millisecondsSinceEpoch}',
          title: '💨 Kelembaban Tinggi',
          message:
              'Kelembaban ${weather.humidity.toStringAsFixed(0)}%. '
              'Pantau tanda-tanda penyakit jamur.',
          level: AlertLevel.warning,
          category: AlertCategory.weather,
          timestamp: now,
        ),
      );
    }

    // Strong wind
    if (weather.windSpeed > 25) {
      alerts.add(
        WeatherAlert(
          id: 'wind_strong_${now.millisecondsSinceEpoch}',
          title: '🌀 Angin Kencang!',
          message:
              'Kecepatan angin ${weather.windSpeed.toStringAsFixed(1)} km/jam. '
              'Pasang penyangga tanaman.',
          level: AlertLevel.danger,
          category: AlertCategory.weather,
          timestamp: now,
          actionText: 'Pasang ajir penyangga',
        ),
      );
    } else if (weather.windSpeed > 15) {
      alerts.add(
        WeatherAlert(
          id: 'wind_moderate_${now.millisecondsSinceEpoch}',
          title: '💨 Angin Cukup Kencang',
          message:
              'Kecepatan angin ${weather.windSpeed.toStringAsFixed(1)} km/jam. '
              'Hindari penyemprotan pestisida.',
          level: AlertLevel.warning,
          category: AlertCategory.weather,
          timestamp: now,
        ),
      );
    }

    return alerts;
  }

  /// Get plants affected by a disease
  List<String> _getAffectedPlants(String diseaseId) {
    switch (diseaseId) {
      case 'rice_blast':
      case 'rice_tungro':
        return ['Padi'];
      case 'corn_downy_mildew':
        return ['Jagung'];
      case 'chili_anthracnose':
      case 'chili_yellow_leaf_curl':
        return ['Cabai'];
      case 'onion_purple_blotch':
        return ['Bawang Merah', 'Bawang Putih'];
      default:
        return [];
    }
  }

  /// Get alerts count by level
  Map<AlertLevel, int> getAlertCounts(List<WeatherAlert> alerts) {
    return {
      AlertLevel.danger: alerts
          .where((a) => a.level == AlertLevel.danger)
          .length,
      AlertLevel.warning: alerts
          .where((a) => a.level == AlertLevel.warning)
          .length,
      AlertLevel.info: alerts.where((a) => a.level == AlertLevel.info).length,
    };
  }

  /// Generate sample weather for demo/testing
  Weather generateSampleWeather({
    String condition = 'Cerah Berawan',
    double? temperature,
    double? humidity,
    double? rainfall,
    double? windSpeed,
  }) {
    return Weather(
      date: DateTime.now(),
      temperature: temperature ?? 28.0,
      humidity: humidity ?? 75.0,
      rainfall: rainfall ?? 0.0,
      windSpeed: windSpeed ?? 8.0,
      condition: condition,
      description: 'Cuaca ${condition.toLowerCase()} dengan suhu nyaman',
      uvIndex: 6,
      cloudCover: 40,
      locationName: 'Lombok Tengah, NTB',
      latitude: -8.5833,
      longitude: 116.1167,
    );
  }

  /// Generate high-risk weather scenario for demo
  Weather generateHighRiskWeather() {
    return Weather(
      date: DateTime.now(),
      temperature: 28.0,
      humidity: 92.0, // High humidity = fungal risk
      rainfall: 15.0, // After rain = disease spread
      windSpeed: 8.0,
      condition: 'Hujan Ringan',
      description: 'Cuaca lembab setelah hujan, waspada penyakit',
      uvIndex: 3,
      cloudCover: 80,
      locationName: 'Lombok Tengah, NTB',
      latitude: -8.5833,
      longitude: 116.1167,
    );
  }
}
