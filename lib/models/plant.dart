/// AgriVision NTB - Plant Model
/// Model untuk tanaman pertanian di NTB

class Plant {
  final String id;
  final String name;
  final String localName;
  final String scientificName;
  final String description;
  final String category;
  final String iconEmoji;
  final String imagePath;
  final int growthDurationDays;
  final List<GrowthStage> growthStages;
  final List<String> commonDiseases;
  final List<String> commonPests;
  final PlantingInfo plantingInfo;
  final NutrientRequirement nutrientRequirement;
  final List<String> bestRegionsNTB;

  Plant({
    required this.id,
    required this.name,
    required this.localName,
    required this.scientificName,
    required this.description,
    required this.category,
    required this.iconEmoji,
    this.imagePath = '',
    required this.growthDurationDays,
    required this.growthStages,
    required this.commonDiseases,
    required this.commonPests,
    required this.plantingInfo,
    required this.nutrientRequirement,
    required this.bestRegionsNTB,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      localName: json['local_name'] ?? '',
      scientificName: json['scientific_name'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      iconEmoji: json['icon_emoji'] ?? '��',
      imagePath: json['image_path'] ?? '',
      growthDurationDays: json['growth_duration_days'] ?? 0,
      growthStages: (json['growth_stages'] as List?)
              ?.map((s) => GrowthStage.fromJson(s))
              .toList() ?? [],
      commonDiseases: List<String>.from(json['common_diseases'] ?? []),
      commonPests: List<String>.from(json['common_pests'] ?? []),
      plantingInfo: PlantingInfo.fromJson(json['planting_info'] ?? {}),
      nutrientRequirement: NutrientRequirement.fromJson(json['nutrient_requirement'] ?? {}),
      bestRegionsNTB: List<String>.from(json['best_regions_ntb'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'local_name': localName,
    'scientific_name': scientificName,
    'description': description,
    'category': category,
    'icon_emoji': iconEmoji,
    'image_path': imagePath,
    'growth_duration_days': growthDurationDays,
    'growth_stages': growthStages.map((s) => s.toJson()).toList(),
    'common_diseases': commonDiseases,
    'common_pests': commonPests,
    'planting_info': plantingInfo.toJson(),
    'nutrient_requirement': nutrientRequirement.toJson(),
    'best_regions_ntb': bestRegionsNTB,
  };

  static Plant? getById(String id) {
    try {
      return ntbPlants.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<Plant> getByCategory(String category) =>
      ntbPlants.where((p) => p.category == category).toList();

  static List<Plant> search(String query) {
    final lowerQuery = query.toLowerCase();
    return ntbPlants.where((p) =>
        p.name.toLowerCase().contains(lowerQuery) ||
        p.localName.toLowerCase().contains(lowerQuery)).toList();
  }

  // 10 Tanaman Utama NTB
  static List<Plant> ntbPlants = [
    _rice, _corn, _chili, _onion, _tomato,
    _watermelon, _soybean, _peanut, _mungbean, _banana,
  ];

  static final Plant _rice = Plant(
    id: 'rice', name: 'Padi', localName: 'Pare',
    scientificName: 'Oryza sativa',
    description: 'Tanaman pangan utama di NTB dengan varietas lokal terkenal.',
    category: 'pangan', iconEmoji: '🌾', growthDurationDays: 120,
    growthStages: [
      GrowthStage(name: 'Persemaian', durationDays: 21, description: 'Benih disemai',
          careInstructions: 'Jaga kelembaban', vulnerableDiseases: ['rice_bakanae']),
      GrowthStage(name: 'Vegetatif', durationDays: 50, description: 'Fase anakan aktif',
          careInstructions: 'Pemupukan urea', vulnerableDiseases: ['rice_blast', 'rice_tungro']),
      GrowthStage(name: 'Generatif', durationDays: 35, description: 'Bunting dan berbunga',
          careInstructions: 'Jaga air, hindari stress', vulnerableDiseases: ['rice_blast']),
      GrowthStage(name: 'Pematangan', durationDays: 14, description: 'Gabah matang',
          careInstructions: 'Keringkan lahan', vulnerableDiseases: []),
    ],
    commonDiseases: ['rice_blast', 'rice_brown_spot', 'rice_tungro', 'rice_bacterial_leaf_blight'],
    commonPests: ['Wereng Coklat', 'Penggerek Batang', 'Tikus', 'Walang Sangit'],
    plantingInfo: PlantingInfo(bestPlantingMonths: ['Oktober', 'November', 'Maret'],
        seedPerHectare: 25, plantSpacing: '25x25 cm', waterRequirement: 'Tinggi',
        soilType: 'Lempung berliat', altitude: '0-800 mdpl'),
    nutrientRequirement: NutrientRequirement(nitrogen: 'Urea 200-250 kg/ha',
        phosphorus: 'SP-36 100 kg/ha', potassium: 'KCl 100 kg/ha',
        organicMatter: 'Kompos 2 ton/ha', additionalNotes: 'Pemupukan 3x'),
    bestRegionsNTB: ['Lombok Tengah', 'Lombok Timur', 'Sumbawa', 'Dompu'],
  );

  static final Plant _corn = Plant(
    id: 'corn', name: 'Jagung', localName: 'Jagung/Batar',
    scientificName: 'Zea mays',
    description: 'Komoditas pangan kedua terpenting di NTB, banyak di Sumbawa dan Bima.',
    category: 'pangan', iconEmoji: '🌽', growthDurationDays: 100,
    growthStages: [
      GrowthStage(name: 'Perkecambahan', durationDays: 10, description: 'Benih berkecambah',
          careInstructions: 'Jaga kelembaban', vulnerableDiseases: ['corn_downy_mildew']),
      GrowthStage(name: 'Vegetatif', durationDays: 50, description: 'Pertumbuhan daun',
          careInstructions: 'Penyiangan, pemupukan N', vulnerableDiseases: ['corn_leaf_blight', 'corn_rust']),
      GrowthStage(name: 'Generatif', durationDays: 40, description: 'Penyerbukan dan pengisian biji',
          careInstructions: 'Jaga air', vulnerableDiseases: ['corn_ear_rot', 'corn_smut']),
    ],
    commonDiseases: ['corn_downy_mildew', 'corn_leaf_blight', 'corn_rust', 'corn_ear_rot'],
    commonPests: ['Penggerek Batang', 'Ulat Grayak', 'Lalat Bibit'],
    plantingInfo: PlantingInfo(bestPlantingMonths: ['Oktober', 'November', 'Maret'],
        seedPerHectare: 20, plantSpacing: '75x25 cm', waterRequirement: 'Sedang',
        soilType: 'Lempung berpasir', altitude: '0-1000 mdpl'),
    nutrientRequirement: NutrientRequirement(nitrogen: 'Urea 300 kg/ha',
        phosphorus: 'SP-36 150 kg/ha', potassium: 'KCl 100 kg/ha',
        organicMatter: 'Pupuk kandang 5 ton/ha', additionalNotes: 'Pemupukan 2x'),
    bestRegionsNTB: ['Sumbawa', 'Dompu', 'Bima', 'Lombok Timur'],
  );

  static final Plant _chili = Plant(
    id: 'chili', name: 'Cabai', localName: 'Sebie/Lombok',
    scientificName: 'Capsicum annuum',
    description: 'Komoditas hortikultura bernilai tinggi di NTB.',
    category: 'hortikultura', iconEmoji: '🌶️', growthDurationDays: 150,
    growthStages: [
      GrowthStage(name: 'Persemaian', durationDays: 28, description: 'Semai di tray',
          careInstructions: 'Naungi 60%', vulnerableDiseases: ['chili_damping_off']),
      GrowthStage(name: 'Vegetatif', durationDays: 35, description: 'Pertumbuhan batang daun',
          careInstructions: 'Pindah tanam, mulsa', vulnerableDiseases: ['chili_mosaic_virus']),
      GrowthStage(name: 'Generatif', durationDays: 87, description: 'Pembungaan dan pembuahan',
          careInstructions: 'Panen bertahap', vulnerableDiseases: ['chili_anthracnose', 'chili_bacterial_wilt']),
    ],
    commonDiseases: ['chili_anthracnose', 'chili_bacterial_wilt', 'chili_mosaic_virus', 'chili_yellow_leaf_curl'],
    commonPests: ['Thrips', 'Kutu Daun', 'Lalat Buah', 'Tungau'],
    plantingInfo: PlantingInfo(bestPlantingMonths: ['April', 'Mei', 'September'],
        seedPerHectare: 0.5, plantSpacing: '60x50 cm', waterRequirement: 'Sedang',
        soilType: 'Lempung gembur', altitude: '0-1200 mdpl'),
    nutrientRequirement: NutrientRequirement(nitrogen: 'Urea 150-200 kg/ha',
        phosphorus: 'SP-36 200 kg/ha', potassium: 'KCl 200 kg/ha',
        organicMatter: 'Pupuk kandang 10-15 ton/ha', additionalNotes: 'Pupuk bertahap 2 minggu'),
    bestRegionsNTB: ['Lombok Timur', 'Lombok Tengah', 'Bima'],
  );

  static final Plant _onion = Plant(
    id: 'onion', name: 'Bawang Merah', localName: 'Kesuna Barak',
    scientificName: 'Allium cepa var. aggregatum',
    description: 'Komoditas strategis nasional. Lombok Timur sentra terbesar.',
    category: 'hortikultura', iconEmoji: '🧅', growthDurationDays: 70,
    growthStages: [
      GrowthStage(name: 'Pertunasan', durationDays: 10, description: 'Umbi bertunas',
          careInstructions: 'Tanam 2/3 umbi', vulnerableDiseases: ['onion_fusarium_basal_rot']),
      GrowthStage(name: 'Vegetatif', durationDays: 25, description: 'Pertumbuhan daun',
          careInstructions: 'Pupuk NPK, penyiangan', vulnerableDiseases: ['onion_purple_blotch']),
      GrowthStage(name: 'Pembentukan Umbi', durationDays: 35, description: 'Umbi membesar hingga panen',
          careInstructions: 'Kurangi N, tambah K', vulnerableDiseases: ['onion_purple_blotch', 'onion_anthracnose']),
    ],
    commonDiseases: ['onion_purple_blotch', 'onion_anthracnose', 'onion_fusarium_basal_rot'],
    commonPests: ['Ulat Bawang', 'Thrips', 'Lalat Pengorok'],
    plantingInfo: PlantingInfo(bestPlantingMonths: ['Mei', 'Juni', 'Juli'],
        seedPerHectare: 1000, plantSpacing: '20x15 cm', waterRequirement: 'Sedang',
        soilType: 'Lempung berpasir', altitude: '0-800 mdpl'),
    nutrientRequirement: NutrientRequirement(nitrogen: 'Urea 150 kg/ha',
        phosphorus: 'SP-36 200 kg/ha', potassium: 'KCl 150 kg/ha',
        organicMatter: 'Pupuk kandang 10-20 ton/ha', additionalNotes: 'Pupuk dasar + susulan'),
    bestRegionsNTB: ['Lombok Timur', 'Lombok Tengah'],
  );

  static final Plant _tomato = Plant(
    id: 'tomato', name: 'Tomat', localName: 'Tomat',
    scientificName: 'Solanum lycopersicum',
    description: 'Sayuran buah populer di dataran menengah NTB.',
    category: 'hortikultura', iconEmoji: '🍅', growthDurationDays: 100,
    growthStages: [
      GrowthStage(name: 'Persemaian', durationDays: 25, description: 'Semai benih',
          careInstructions: 'Naungi 50%', vulnerableDiseases: ['chili_damping_off']),
      GrowthStage(name: 'Vegetatif', durationDays: 25, description: 'Pertumbuhan batang',
          careInstructions: 'Ajir, pangkas tunas air', vulnerableDiseases: ['tomato_early_blight']),
      GrowthStage(name: 'Generatif', durationDays: 50, description: 'Bunga dan buah',
          careInstructions: 'Panen bertahap', vulnerableDiseases: ['tomato_late_blight', 'tomato_bacterial_wilt']),
    ],
    commonDiseases: ['tomato_late_blight', 'tomato_early_blight', 'tomato_bacterial_wilt', 'tomato_yellow_leaf_curl'],
    commonPests: ['Kutu Kebul', 'Ulat Buah', 'Lalat Buah'],
    plantingInfo: PlantingInfo(bestPlantingMonths: ['April', 'Mei', 'September'],
        seedPerHectare: 0.15, plantSpacing: '60x50 cm', waterRequirement: 'Sedang',
        soilType: 'Lempung gembur', altitude: '300-1200 mdpl'),
    nutrientRequirement: NutrientRequirement(nitrogen: 'Urea 200 kg/ha',
        phosphorus: 'SP-36 250 kg/ha', potassium: 'KCl 200 kg/ha',
        organicMatter: 'Pupuk kandang 15-20 ton/ha', additionalNotes: 'Kalsium penting'),
    bestRegionsNTB: ['Lombok Timur', 'Lombok Utara'],
  );

  static final Plant _watermelon = Plant(
    id: 'watermelon', name: 'Semangka', localName: 'Semangke',
    scientificName: 'Citrullus lanatus',
    description: 'Buah populer di lahan kering NTB saat musim kemarau.',
    category: 'hortikultura', iconEmoji: '��', growthDurationDays: 75,
    growthStages: [
      GrowthStage(name: 'Perkecambahan', durationDays: 7, description: 'Benih berkecambah',
          careInstructions: 'Rendam 12 jam', vulnerableDiseases: []),
      GrowthStage(name: 'Vegetatif', durationDays: 25, description: 'Pertumbuhan sulur',
          careInstructions: 'Mulsa plastik', vulnerableDiseases: ['cucumber_downy_mildew']),
      GrowthStage(name: 'Generatif', durationDays: 43, description: 'Bunga dan buah',
          careInstructions: 'Seleksi 2-3 buah/tanaman', vulnerableDiseases: ['watermelon_fusarium_wilt']),
    ],
    commonDiseases: ['watermelon_fusarium_wilt', 'watermelon_anthracnose', 'cucumber_downy_mildew'],
    commonPests: ['Kutu Daun', 'Lalat Buah', 'Kumbang Daun'],
    plantingInfo: PlantingInfo(bestPlantingMonths: ['Mei', 'Juni', 'Juli'],
        seedPerHectare: 0.5, plantSpacing: '300x60 cm', waterRequirement: 'Sedang',
        soilType: 'Lempung berpasir', altitude: '0-500 mdpl'),
    nutrientRequirement: NutrientRequirement(nitrogen: 'Urea 150 kg/ha',
        phosphorus: 'SP-36 200 kg/ha', potassium: 'KCl 250 kg/ha',
        organicMatter: 'Pupuk kandang 15 ton/ha', additionalNotes: 'Kalium tinggi untuk manis'),
    bestRegionsNTB: ['Lombok Barat', 'Lombok Tengah'],
  );

  static final Plant _soybean = Plant(
    id: 'soybean', name: 'Kedelai', localName: 'Kedelai',
    scientificName: 'Glycine max',
    description: 'Tanaman sumber protein nabati potensial di lahan kering NTB.',
    category: 'pangan', iconEmoji: '🫘', growthDurationDays: 85,
    growthStages: [
      GrowthStage(name: 'Perkecambahan', durationDays: 7, description: 'Benih berkecambah',
          careInstructions: 'Tanam 3-5 cm', vulnerableDiseases: []),
      GrowthStage(name: 'Vegetatif', durationDays: 30, description: 'Pertumbuhan daun',
          careInstructions: 'Penyiangan, pupuk NPK', vulnerableDiseases: ['soybean_mosaic']),
      GrowthStage(name: 'Generatif', durationDays: 48, description: 'Bunga dan polong',
          careInstructions: 'Hindari kekeringan', vulnerableDiseases: ['soybean_rust', 'soybean_anthracnose']),
    ],
    commonDiseases: ['soybean_rust', 'soybean_anthracnose', 'soybean_mosaic'],
    commonPests: ['Ulat Grayak', 'Kepik Hijau', 'Penggerek Polong'],
    plantingInfo: PlantingInfo(bestPlantingMonths: ['Maret', 'April', 'Oktober'],
        seedPerHectare: 40, plantSpacing: '40x15 cm', waterRequirement: 'Sedang',
        soilType: 'Lempung drainase baik', altitude: '0-600 mdpl'),
    nutrientRequirement: NutrientRequirement(nitrogen: 'Rendah (Rhizobium)',
        phosphorus: 'SP-36 150 kg/ha', potassium: 'KCl 100 kg/ha',
        organicMatter: 'Pupuk kandang 5 ton/ha', additionalNotes: 'Inokulasi Rhizobium'),
    bestRegionsNTB: ['Lombok Timur', 'Sumbawa', 'Bima'],
  );

  static final Plant _peanut = Plant(
    id: 'peanut', name: 'Kacang Tanah', localName: 'Kacang Tanah',
    scientificName: 'Arachis hypogaea',
    description: 'Tanaman palawija cocok untuk rotasi setelah padi.',
    category: 'pangan', iconEmoji: '🥜', growthDurationDays: 100,
    growthStages: [
      GrowthStage(name: 'Perkecambahan', durationDays: 10, description: 'Benih berkecambah',
          careInstructions: 'Tanam dengan kulit ari', vulnerableDiseases: []),
      GrowthStage(name: 'Vegetatif', durationDays: 25, description: 'Pertumbuhan daun',
          careInstructions: 'Penyiangan, pembumbunan', vulnerableDiseases: ['peanut_leaf_spot']),
      GrowthStage(name: 'Generatif', durationDays: 65, description: 'Bunga dan polong',
          careInstructions: 'Pembumbunan untuk ginofor', vulnerableDiseases: ['peanut_rust', 'peanut_bacterial_wilt']),
    ],
    commonDiseases: ['peanut_leaf_spot', 'peanut_rust', 'peanut_bacterial_wilt'],
    commonPests: ['Ulat Grayak', 'Aphid', 'Thrips'],
    plantingInfo: PlantingInfo(bestPlantingMonths: ['Maret', 'April', 'Oktober'],
        seedPerHectare: 60, plantSpacing: '40x15 cm', waterRequirement: 'Sedang',
        soilType: 'Lempung berpasir gembur', altitude: '0-500 mdpl'),
    nutrientRequirement: NutrientRequirement(nitrogen: 'Rendah (fiksasi sendiri)',
        phosphorus: 'SP-36 100 kg/ha', potassium: 'KCl 50 kg/ha',
        organicMatter: 'Pupuk kandang 5 ton/ha', additionalNotes: 'Kapur untuk kalsium'),
    bestRegionsNTB: ['Lombok Timur', 'Lombok Tengah', 'Sumbawa'],
  );

  static final Plant _mungbean = Plant(
    id: 'mungbean', name: 'Kacang Hijau', localName: 'Kacang Ijo',
    scientificName: 'Vigna radiata',
    description: 'Tanaman palawija pendek umur untuk tumpang sari dan rotasi.',
    category: 'pangan', iconEmoji: '🫛', growthDurationDays: 65,
    growthStages: [
      GrowthStage(name: 'Perkecambahan', durationDays: 5, description: 'Cepat berkecambah',
          careInstructions: 'Tanam 3-4 cm', vulnerableDiseases: []),
      GrowthStage(name: 'Vegetatif', durationDays: 25, description: 'Pertumbuhan cepat',
          careInstructions: 'Penyiangan awal', vulnerableDiseases: ['mungbean_cercospora_leaf_spot']),
      GrowthStage(name: 'Generatif', durationDays: 35, description: 'Bunga dan polong',
          careInstructions: 'Panen bertahap 2-3x', vulnerableDiseases: ['mungbean_powdery_mildew']),
    ],
    commonDiseases: ['mungbean_powdery_mildew', 'mungbean_cercospora_leaf_spot'],
    commonPests: ['Penggerek Polong', 'Kutu Daun', 'Thrips'],
    plantingInfo: PlantingInfo(bestPlantingMonths: ['Maret', 'April', 'September'],
        seedPerHectare: 20, plantSpacing: '40x20 cm', waterRequirement: 'Rendah-Sedang',
        soilType: 'Berbagai jenis', altitude: '0-500 mdpl'),
    nutrientRequirement: NutrientRequirement(nitrogen: 'Rendah',
        phosphorus: 'SP-36 75 kg/ha', potassium: 'KCl 50 kg/ha',
        organicMatter: 'Pupuk kandang 3 ton/ha', additionalNotes: 'Hemat input'),
    bestRegionsNTB: ['Lombok Timur', 'Lombok Tengah', 'Sumbawa', 'Bima'],
  );

  static final Plant _banana = Plant(
    id: 'banana', name: 'Pisang', localName: 'Biu',
    scientificName: 'Musa spp.',
    description: 'Buah yang banyak di pekarangan dan kebun NTB.',
    category: 'hortikultura', iconEmoji: '🍌', growthDurationDays: 365,
    growthStages: [
      GrowthStage(name: 'Anakan', durationDays: 60, description: 'Bibit tumbuh',
          careInstructions: 'Pilih anakan pedang', vulnerableDiseases: ['banana_fusarium_wilt']),
      GrowthStage(name: 'Vegetatif', durationDays: 180, description: 'Batang semu dan daun',
          careInstructions: 'Pupuk rutin, pangkas anakan', vulnerableDiseases: ['banana_sigatoka']),
      GrowthStage(name: 'Generatif', durationDays: 125, description: 'Jantung dan tandan',
          careInstructions: 'Potong jantung, penyangga', vulnerableDiseases: ['banana_bunchy_top']),
    ],
    commonDiseases: ['banana_fusarium_wilt', 'banana_sigatoka', 'banana_bunchy_top'],
    commonPests: ['Penggerek Bonggol', 'Nematoda'],
    plantingInfo: PlantingInfo(bestPlantingMonths: ['Awal musim hujan'],
        seedPerHectare: 1600, plantSpacing: '3x3 m', waterRequirement: 'Tinggi',
        soilType: 'Lempung gembur subur', altitude: '0-1000 mdpl'),
    nutrientRequirement: NutrientRequirement(nitrogen: 'Urea 400 g/pohon/tahun',
        phosphorus: 'SP-36 200 g/pohon/tahun', potassium: 'KCl 500 g/pohon/tahun',
        organicMatter: 'Pupuk kandang 20 kg/pohon/tahun', additionalNotes: 'Kalium sangat penting'),
    bestRegionsNTB: ['Lombok Barat', 'Lombok Timur', 'Lombok Utara'],
  );
}

class GrowthStage {
  final String name;
  final int durationDays;
  final String description;
  final String careInstructions;
  final List<String> vulnerableDiseases;

  GrowthStage({
    required this.name,
    required this.durationDays,
    required this.description,
    required this.careInstructions,
    required this.vulnerableDiseases,
  });

  factory GrowthStage.fromJson(Map<String, dynamic> json) => GrowthStage(
    name: json['name'] ?? '',
    durationDays: json['duration_days'] ?? 0,
    description: json['description'] ?? '',
    careInstructions: json['care_instructions'] ?? '',
    vulnerableDiseases: List<String>.from(json['vulnerable_diseases'] ?? []),
  );

  Map<String, dynamic> toJson() => {
    'name': name, 'duration_days': durationDays, 'description': description,
    'care_instructions': careInstructions, 'vulnerable_diseases': vulnerableDiseases,
  };
}

class PlantingInfo {
  final List<String> bestPlantingMonths;
  final double seedPerHectare;
  final String plantSpacing;
  final String waterRequirement;
  final String soilType;
  final String altitude;

  PlantingInfo({
    required this.bestPlantingMonths,
    required this.seedPerHectare,
    required this.plantSpacing,
    required this.waterRequirement,
    required this.soilType,
    required this.altitude,
  });

  factory PlantingInfo.fromJson(Map<String, dynamic> json) => PlantingInfo(
    bestPlantingMonths: List<String>.from(json['best_planting_months'] ?? []),
    seedPerHectare: (json['seed_per_hectare'] ?? 0).toDouble(),
    plantSpacing: json['plant_spacing'] ?? '',
    waterRequirement: json['water_requirement'] ?? '',
    soilType: json['soil_type'] ?? '',
    altitude: json['altitude'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'best_planting_months': bestPlantingMonths, 'seed_per_hectare': seedPerHectare,
    'plant_spacing': plantSpacing, 'water_requirement': waterRequirement,
    'soil_type': soilType, 'altitude': altitude,
  };
}

class NutrientRequirement {
  final String nitrogen;
  final String phosphorus;
  final String potassium;
  final String organicMatter;
  final String additionalNotes;

  NutrientRequirement({
    required this.nitrogen,
    required this.phosphorus,
    required this.potassium,
    required this.organicMatter,
    required this.additionalNotes,
  });

  factory NutrientRequirement.fromJson(Map<String, dynamic> json) => NutrientRequirement(
    nitrogen: json['nitrogen'] ?? '',
    phosphorus: json['phosphorus'] ?? '',
    potassium: json['potassium'] ?? '',
    organicMatter: json['organic_matter'] ?? '',
    additionalNotes: json['additional_notes'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'nitrogen': nitrogen, 'phosphorus': phosphorus, 'potassium': potassium,
    'organic_matter': organicMatter, 'additional_notes': additionalNotes,
  };
}
