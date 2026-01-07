/// AgriVision NTB - Outbreak Data Model
/// Model untuk data wabah penyakit

class OutbreakData {
  final String id;
  final String diseaseId;
  final String diseaseName;
  final double latitude;
  final double longitude;
  final String locationName;
  final String regency;
  final String district;
  final int reportCount;
  final double averageSeverity;
  final DateTime firstReportedAt;
  final DateTime lastReportedAt;
  final OutbreakStatus status;
  final String affectedCrop;

  OutbreakData({
    required this.id,
    required this.diseaseId,
    required this.diseaseName,
    required this.latitude,
    required this.longitude,
    required this.locationName,
    required this.regency,
    required this.district,
    required this.reportCount,
    required this.averageSeverity,
    required this.firstReportedAt,
    required this.lastReportedAt,
    required this.status,
    required this.affectedCrop,
  });

  factory OutbreakData.fromJson(Map<String, dynamic> json) {
    return OutbreakData(
      id: json['id'] ?? '',
      diseaseId: json['disease_id'] ?? '',
      diseaseName: json['disease_name'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      locationName: json['location_name'] ?? '',
      regency: json['regency'] ?? '',
      district: json['district'] ?? '',
      reportCount: json['report_count'] ?? 0,
      averageSeverity: (json['average_severity'] ?? 0).toDouble(),
      firstReportedAt: DateTime.parse(
        json['first_reported_at'] ?? DateTime.now().toIso8601String(),
      ),
      lastReportedAt: DateTime.parse(
        json['last_reported_at'] ?? DateTime.now().toIso8601String(),
      ),
      status: OutbreakStatus.values[json['status'] ?? 0],
      affectedCrop: json['affected_crop'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'disease_id': diseaseId,
      'disease_name': diseaseName,
      'latitude': latitude,
      'longitude': longitude,
      'location_name': locationName,
      'regency': regency,
      'district': district,
      'report_count': reportCount,
      'average_severity': averageSeverity,
      'first_reported_at': firstReportedAt.toIso8601String(),
      'last_reported_at': lastReportedAt.toIso8601String(),
      'status': status.index,
      'affected_crop': affectedCrop,
    };
  }

  String get statusText {
    switch (status) {
      case OutbreakStatus.monitoring:
        return 'Pemantauan';
      case OutbreakStatus.active:
        return 'Aktif';
      case OutbreakStatus.spreading:
        return 'Menyebar';
      case OutbreakStatus.critical:
        return 'Kritis';
      case OutbreakStatus.contained:
        return 'Terkendali';
      case OutbreakStatus.resolved:
        return 'Teratasi';
    }
  }

  String get statusEmoji {
    switch (status) {
      case OutbreakStatus.monitoring:
        return '👁️';
      case OutbreakStatus.active:
        return '🟡';
      case OutbreakStatus.spreading:
        return '🟠';
      case OutbreakStatus.critical:
        return '🔴';
      case OutbreakStatus.contained:
        return '🟢';
      case OutbreakStatus.resolved:
        return '✅';
    }
  }

  int get severityColor {
    if (averageSeverity < 25) return 0xFF8BC34A; // Green
    if (averageSeverity < 50) return 0xFFFFEB3B; // Yellow
    if (averageSeverity < 75) return 0xFFFF9800; // Orange
    return 0xFFE53935; // Red
  }
}

enum OutbreakStatus {
  monitoring,
  active,
  spreading,
  critical,
  contained,
  resolved,
}

class OutbreakCluster {
  final String id;
  final double centerLatitude;
  final double centerLongitude;
  final double radiusKm;
  final List<OutbreakData> outbreaks;
  final String primaryDisease;
  final int totalReports;

  OutbreakCluster({
    required this.id,
    required this.centerLatitude,
    required this.centerLongitude,
    required this.radiusKm,
    required this.outbreaks,
    required this.primaryDisease,
    required this.totalReports,
  });

  double get averageSeverity {
    if (outbreaks.isEmpty) return 0;
    return outbreaks.map((o) => o.averageSeverity).reduce((a, b) => a + b) /
        outbreaks.length;
  }
}
