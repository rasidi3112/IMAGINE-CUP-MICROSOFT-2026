/// AgriVision NTB - Farm Model
/// Model untuk lahan pertanian petani

class Farm {
  final String id;
  final String userId;
  final String name;
  final String plantType; // ID tanaman dari Plant model
  final double area; // dalam hektar
  final double latitude;
  final double longitude;
  final String village;
  final String district;
  final String regency;
  final DateTime plantingDate;
  final String currentGrowthStage;
  final List<FarmActivity> activities;
  final List<String> scanResultIds;
  final FarmStatus status;
  final String? notes;
  final String? imagePath;

  Farm({
    required this.id,
    required this.userId,
    required this.name,
    required this.plantType,
    required this.area,
    required this.latitude,
    required this.longitude,
    required this.village,
    required this.district,
    required this.regency,
    required this.plantingDate,
    required this.currentGrowthStage,
    this.activities = const [],
    this.scanResultIds = const [],
    required this.status,
    this.notes,
    this.imagePath,
  });

  factory Farm.fromJson(Map<String, dynamic> json) => Farm(
    id: json['id'] ?? '',
    userId: json['user_id'] ?? '',
    name: json['name'] ?? '',
    plantType: json['plant_type'] ?? '',
    area: (json['area'] ?? 0).toDouble(),
    latitude: (json['latitude'] ?? 0).toDouble(),
    longitude: (json['longitude'] ?? 0).toDouble(),
    village: json['village'] ?? '',
    district: json['district'] ?? '',
    regency: json['regency'] ?? '',
    plantingDate: DateTime.parse(json['planting_date'] ?? DateTime.now().toIso8601String()),
    currentGrowthStage: json['current_growth_stage'] ?? '',
    activities: (json['activities'] as List?)?.map((a) => FarmActivity.fromJson(a)).toList() ?? [],
    scanResultIds: List<String>.from(json['scan_result_ids'] ?? []),
    status: FarmStatus.values[json['status'] ?? 0],
    notes: json['notes'],
    imagePath: json['image_path'],
  );

  Map<String, dynamic> toJson() => {
    'id': id, 'user_id': userId, 'name': name, 'plant_type': plantType,
    'area': area, 'latitude': latitude, 'longitude': longitude,
    'village': village, 'district': district, 'regency': regency,
    'planting_date': plantingDate.toIso8601String(),
    'current_growth_stage': currentGrowthStage,
    'activities': activities.map((a) => a.toJson()).toList(),
    'scan_result_ids': scanResultIds, 'status': status.index,
    'notes': notes, 'image_path': imagePath,
  };

  String get fullLocation => '$village, $district, $regency';
  
  int get daysAfterPlanting => DateTime.now().difference(plantingDate).inDays;
  
  String get dapText => '$daysAfterPlanting HST';

  String get statusEmoji {
    switch (status) {
      case FarmStatus.preparation: return '🌱';
      case FarmStatus.growing: return '🌿';
      case FarmStatus.flowering: return '🌸';
      case FarmStatus.harvesting: return '🌾';
      case FarmStatus.fallow: return '🏜️';
      case FarmStatus.problem: return '⚠️';
    }
  }

  String get statusText {
    switch (status) {
      case FarmStatus.preparation: return 'Persiapan Lahan';
      case FarmStatus.growing: return 'Masa Pertumbuhan';
      case FarmStatus.flowering: return 'Masa Pembungaan';
      case FarmStatus.harvesting: return 'Masa Panen';
      case FarmStatus.fallow: return 'Bera/Istirahat';
      case FarmStatus.problem: return 'Ada Masalah';
    }
  }


  // Estimated harvest date
  DateTime? getEstimatedHarvestDate(int totalGrowthDays) {
    return plantingDate.add(Duration(days: totalGrowthDays));
  }

  // Days until harvest
  int? getDaysUntilHarvest(int totalGrowthDays) {
    final harvestDate = getEstimatedHarvestDate(totalGrowthDays);
    if (harvestDate == null) return null;
    final days = harvestDate.difference(DateTime.now()).inDays;
    return days > 0 ? days : 0;
  }

  Farm copyWith({
    String? id, String? userId, String? name, String? plantType,
    double? area, double? latitude, double? longitude,
    String? village, String? district, String? regency,
    DateTime? plantingDate, String? currentGrowthStage,
    List<FarmActivity>? activities, List<String>? scanResultIds,
    FarmStatus? status, String? notes, String? imagePath,
  }) => Farm(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    name: name ?? this.name,
    plantType: plantType ?? this.plantType,
    area: area ?? this.area,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    village: village ?? this.village,
    district: district ?? this.district,
    regency: regency ?? this.regency,
    plantingDate: plantingDate ?? this.plantingDate,
    currentGrowthStage: currentGrowthStage ?? this.currentGrowthStage,
    activities: activities ?? this.activities,
    scanResultIds: scanResultIds ?? this.scanResultIds,
    status: status ?? this.status,
    notes: notes ?? this.notes,
    imagePath: imagePath ?? this.imagePath,
  );
}

enum FarmStatus {
  preparation,
  growing,
  flowering,
  harvesting,
  fallow,
  problem,
}

class FarmActivity {
  final String id;
  final String farmId;
  final DateTime date;
  final ActivityType type;
  final String description;
  final double? cost;
  final String? pesticideId;
  final String? notes;
  final String? imagePath;

  FarmActivity({
    required this.id,
    required this.farmId,
    required this.date,
    required this.type,
    required this.description,
    this.cost,
    this.pesticideId,
    this.notes,
    this.imagePath,
  });

  factory FarmActivity.fromJson(Map<String, dynamic> json) => FarmActivity(
    id: json['id'] ?? '',
    farmId: json['farm_id'] ?? '',
    date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
    type: ActivityType.values[json['type'] ?? 0],
    description: json['description'] ?? '',
    cost: json['cost']?.toDouble(),
    pesticideId: json['pesticide_id'],
    notes: json['notes'],
    imagePath: json['image_path'],
  );

  Map<String, dynamic> toJson() => {
    'id': id, 'farm_id': farmId, 'date': date.toIso8601String(),
    'type': type.index, 'description': description, 'cost': cost,
    'pesticide_id': pesticideId, 'notes': notes, 'image_path': imagePath,
  };

  String get typeEmoji {
    switch (type) {
      case ActivityType.planting: return '🌱';
      case ActivityType.fertilizing: return '💚';
      case ActivityType.spraying: return '💨';
      case ActivityType.watering: return '💧';
      case ActivityType.weeding: return '🌿';
      case ActivityType.harvesting: return '🌾';
      case ActivityType.observation: return '👁️';
      case ActivityType.other: return '📝';
    }
  }

  String get typeText {
    switch (type) {
      case ActivityType.planting: return 'Penanaman';
      case ActivityType.fertilizing: return 'Pemupukan';
      case ActivityType.spraying: return 'Penyemprotan';
      case ActivityType.watering: return 'Penyiraman';
      case ActivityType.weeding: return 'Penyiangan';
      case ActivityType.harvesting: return 'Panen';
      case ActivityType.observation: return 'Pengamatan';
      case ActivityType.other: return 'Lainnya';
    }
  }
}

enum ActivityType {
  planting,
  fertilizing,
  spraying,
  watering,
  weeding,
  harvesting,
  observation,
  other,
}

// Farm Statistics Summary
class FarmStats {
  final int totalFarms;
  final double totalArea;
  final int activeFarms;
  final int problemFarms;
  final Map<String, int> farmsByPlant;
  final Map<String, double> areaByPlant;

  FarmStats({
    required this.totalFarms,
    required this.totalArea,
    required this.activeFarms,
    required this.problemFarms,
    required this.farmsByPlant,
    required this.areaByPlant,
  });

  factory FarmStats.fromFarms(List<Farm> farms) {
    final farmsByPlant = <String, int>{};
    final areaByPlant = <String, double>{};
    int problems = 0;
    int active = 0;
    double total = 0;

    for (final farm in farms) {
      total += farm.area;
      farmsByPlant[farm.plantType] = (farmsByPlant[farm.plantType] ?? 0) + 1;
      areaByPlant[farm.plantType] = (areaByPlant[farm.plantType] ?? 0) + farm.area;
      
      if (farm.status == FarmStatus.problem) problems++;
      if (farm.status != FarmStatus.fallow) active++;
    }

    return FarmStats(
      totalFarms: farms.length,
      totalArea: total,
      activeFarms: active,
      problemFarms: problems,
      farmsByPlant: farmsByPlant,
      areaByPlant: areaByPlant,
    );
  }
}
