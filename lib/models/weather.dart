/// AgriVision NTB - Weather Model
/// Model untuk data cuaca dan rekomendasi pertanian

class Weather {
  final DateTime date;
  final double temperature;
  final double humidity;
  final double rainfall;
  final double windSpeed;
  final String condition;
  final String description;
  final int uvIndex;
  final double cloudCover;
  final String? locationName;
  final double? latitude;
  final double? longitude;

  Weather({
    required this.date,
    required this.temperature,
    required this.humidity,
    required this.rainfall,
    required this.windSpeed,
    required this.condition,
    required this.description,
    required this.uvIndex,
    required this.cloudCover,
    this.locationName,
    this.latitude,
    this.longitude,
  });

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
    date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
    temperature: (json['temperature'] ?? 0).toDouble(),
    humidity: (json['humidity'] ?? 0).toDouble(),
    rainfall: (json['rainfall'] ?? 0).toDouble(),
    windSpeed: (json['wind_speed'] ?? 0).toDouble(),
    condition: json['condition'] ?? '',
    description: json['description'] ?? '',
    uvIndex: json['uv_index'] ?? 0,
    cloudCover: (json['cloud_cover'] ?? 0).toDouble(),
    locationName: json['location_name'],
    latitude: json['latitude']?.toDouble(),
    longitude: json['longitude']?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'temperature': temperature,
    'humidity': humidity,
    'rainfall': rainfall,
    'wind_speed': windSpeed,
    'condition': condition,
    'description': description,
    'uv_index': uvIndex,
    'cloud_cover': cloudCover,
    'location_name': locationName,
    'latitude': latitude,
    'longitude': longitude,
  };

  String get conditionEmoji {
    final c = condition.toLowerCase();

    // Matahari & Normal
    if (c.contains('cerah') && !c.contains('berawan')) return '☀️';
    if (c.contains('cerah berawan') || c.contains('berawan tipis'))
      return '🌤️';
    if (c.contains('berawan') || c.contains('mendung')) return '☁️';

    // Hujan Ringan/Sedang/Lokal
    if (c.contains('gerimis') ||
        c.contains('hujan ringan') ||
        c.contains('hujan lokal') ||
        c.contains('hujan tropis ringan'))
      return '🌦️';

    // Hujan Lebat/Bias
    if (c.contains('hujan sedang') ||
        c.contains('hujan tropis') ||
        c == 'hujan')
      return '🌧️';
    if (c.contains('hujan lebat') || c.contains('hujan deras')) return '⛈️';

    // Petir & Badai
    if (c.contains('petir') || c.contains('kilatan')) return '⚡';
    if (c.contains('badai petir') || c.contains('badai hujan')) return '🌩️';
    if (c.contains('badai tropis') ||
        c.contains('badai angin') ||
        c.contains('topan') ||
        c.contains('squall'))
      return '🌀';
    if (c.contains('tornado') ||
        c.contains('puting beliung') ||
        c.contains('waterspout'))
      return '�️';

    // Angin
    if (c.contains('angin') ||
        c.contains('derecho') ||
        c.contains('mikroburst'))
      return '💨';

    // Kabut & Asap
    if (c.contains('kabut') || c.contains('asap')) return '🌫️';
    if (c.contains('debu') || c.contains('pasir')) return '�️';

    // Suhu
    if (c.contains('panas') || c.contains('kering')) return '🥵';
    if (c.contains('dingin') || c.contains('lembap')) return '🥶';

    // Salju & Es
    if (c.contains('hujan es') || c.contains('hailstorm')) return '🧊';
    if (c.contains('salju') || c.contains('badai salju')) return '❄️';

    // Fenomena Alam
    if (c.contains('pelangi')) return '🌈';
    if (c.contains('aurora')) return '🌌';
    if (c.contains('halos')) return '🔆';

    switch (c) {
      case 'sunny':
        return '☀️';
      case 'partly_cloudy':
        return '�️';
      case 'cloudy':
        return '☁️';
      case 'light_rain':
        return '🌦️';
      case 'rain':
        return '�️';
      case 'heavy_rain':
        return '⛈️';
      case 'thunderstorm':
        return '🌩️';
      case 'fog':
        return '🌫️';
      case 'windy':
        return '💨';
      default:
        return '🌤️'; // Default fallback
    }
  }

  String get conditionText {
    // English codes fallback
    switch (condition.toLowerCase()) {
      case 'sunny':
        return 'Cerah';
      case 'partly_cloudy':
        return 'Berawan Sebagian';
      case 'cloudy':
        return 'Berawan';
      case 'light_rain':
        return 'Hujan Ringan';
      case 'rain':
        return 'Hujan';
      case 'heavy_rain':
        return 'Hujan Lebat';
      case 'thunderstorm':
        return 'Badai Petir';
      case 'fog':
        return 'Berkabut';
      case 'windy':
        return 'Berangin';
    }

    // Jika input sudah bahasa Indonesia (seperti dari user), kembalikan aslinya dengan Title Case
    // atau biarkan apa adanya jika sudah rapi.
    // List kategori lengkap yang diminta pengguna:
    const specificCategories = {
      'Cerah',
      'Cerah Berawan',
      'Berawan',
      'Mendung',
      'Hujan Gerimis',
      'Hujan Ringan',
      'Hujan Sedang',
      'Hujan Lebat',
      'Hujan Lokal',
      'Hujan Petir',
      'Badai Petir',
      'Badai Hujan',
      'Badai Angin',
      'Angin Kencang',
      'Angin Puting Beliung',
      'Angin Topan',
      'Angin Tornado',
      'Angin Muson',
      'Angin Föhn',
      'Angin Sirocco',
      'Angin Harmattan',
      'Angin Chinook',
      'Kabut Tipis',
      'Kabut Tebal',
      'Kabut Asap',
      'Kabut Asap Industri',
      'Asap Tipis',
      'Asap Tebal',
      'Asap Vulkanik',
      'Udara Panas',
      'Udara Sangat Panas',
      'Udara Dingin',
      'Udara Sangat Dingin',
      'Udara Lembap',
      'Udara Kering',
      'Salju Ringan',
      'Salju Sedang',
      'Salju Tebal',
      'Badai Salju',
      'Hujan Es Ringan',
      'Hujan Es Sedang',
      'Hujan Es Lebat',
      'Hailstorm',
      'Badai Tropis',
      'Hujan Asam',
      'Badai Pasir',
      'Debu Gurun',
      'Angin Puting Debu',
      'Cuaca Berawan Tebal',
      'Cuaca Berawan Tipis',
      'Kabut Asap Hutan',
      'Petir Saja',
      'Kilatan Petir Tunggal',
      'Kilatan Petir Berganda',
      'Angin Badai Salju',
      'Hujan Salju Basah',
      'Hujan Salju Kering',
      'Badai Salju Kristal',
      'Fenomena Aurora',
      'Fenomena Halos Matahari',
      'Fenomena Halos Bulan',
      'Fenomena Pelangi',
      'Pelangi Ganda',
      'Pelangi Kabut',
      'Hujan Panas',
      'Badai Tropis Super',
      'Gelombang Panas',
      'Gelombang Dingin',
      'Cuaca Ekstrem',
      'Fenomena Tornado Air (Waterspout)',
      'Hujan Lumpur',
      'Badai Tropis Ekstrem',
      'Hujan Tropis Lebat',
      'Badai Petir Tropis',
      'Hujan Tropis Ringan',
      'Fenomena Mikroburst',
      'Fenomena Derecho',
      'Fenomena Squall Line',
      'Hujan Tropis Lokal',
      'Hujan Tropis Hujan Lebat Malam Hari',
      'Badai Tropis Kategori 1–5',
    };

    // Cek case-insensitive match
    for (var cat in specificCategories) {
      if (cat.toLowerCase() == condition.toLowerCase()) return cat;
    }

    return condition; // Return original if not matched specific english codes
  }

  // Rekomendasi aktivitas pertanian berdasarkan cuaca
  FarmingRecommendation get farmingRecommendation {
    if (rainfall > 20) {
      return FarmingRecommendation(
        canSpray: false,
        canHarvest: false,
        canPlant: false,
        canFertilize: false,
        message:
            'Tidak disarankan aktivitas lapangan. Hujan lebat dapat mencuci pestisida dan merusak hasil panen.',
        warnings: ['Risiko penyakit jamur meningkat', 'Periksa drainase lahan'],
        recommendations: [
          'Persiapkan fungisida preventif',
          'Pantau genangan air',
        ],
      );
    } else if (rainfall > 5) {
      return FarmingRecommendation(
        canSpray: false,
        canHarvest: false,
        canPlant: true,
        canFertilize: false,
        message: 'Hujan ringan. Baik untuk tanam, hindari penyemprotan.',
        warnings: ['Tunggu 2-3 jam setelah hujan untuk semprot'],
        recommendations: [
          'Waktu baik untuk pindah tanam',
          'Periksa kesehatan tanaman',
        ],
      );
    } else if (temperature > 35) {
      return FarmingRecommendation(
        canSpray: false,
        canHarvest: true,
        canPlant: false,
        canFertilize: false,
        message: 'Cuaca sangat panas. Semprot pagi atau sore hari saja.',
        warnings: [
          'Stres panas pada tanaman',
          'Penyemprotan siang tidak efektif',
        ],
        recommendations: [
          'Semprot sebelum jam 8 atau setelah jam 4',
          'Tingkatkan penyiraman',
        ],
      );
    } else if (windSpeed > 20) {
      return FarmingRecommendation(
        canSpray: false,
        canHarvest: true,
        canPlant: true,
        canFertilize: true,
        message: 'Angin kencang. Tidak disarankan semprot pestisida.',
        warnings: ['Drift pestisida tinggi', 'Tanaman bisa rusak'],
        recommendations: ['Tunda penyemprotan', 'Pasang ajir/penyangga'],
      );
    } else if (humidity > 90) {
      return FarmingRecommendation(
        canSpray: false,
        canHarvest: false,
        canPlant: true,
        canFertilize: true,
        message: 'Kelembaban sangat tinggi. Risiko penyakit jamur.',
        warnings: [
          'Waspadai penyakit blast, bercak daun',
          'Kurangi penyiraman',
        ],
        recommendations: [
          'Semprot fungisida preventif',
          'Perbaiki sirkulasi udara',
        ],
      );
    }

    // Kondisi ideal
    return FarmingRecommendation(
      canSpray: true,
      canHarvest: true,
      canPlant: true,
      canFertilize: true,
      message: 'Cuaca ideal untuk aktivitas pertanian.',
      warnings: [],
      recommendations: [
        'Waktu terbaik untuk penyemprotan: pagi jam 6-9',
        'Semua aktivitas bisa dilakukan',
      ],
    );
  }

  // Disease risk berdasarkan cuaca
  List<DiseaseRisk> get diseaseRisks {
    List<DiseaseRisk> risks = [];

    // High humidity + moderate temp = fungal diseases
    if (humidity > 80 && temperature > 20 && temperature < 30) {
      risks.add(
        DiseaseRisk(
          diseaseId: 'rice_blast',
          diseaseName: 'Blas Padi',
          riskLevel: 'tinggi',
          reason: 'Kelembaban tinggi dan suhu optimal untuk jamur Pyricularia',
        ),
      );
      risks.add(
        DiseaseRisk(
          diseaseId: 'corn_downy_mildew',
          diseaseName: 'Bulai Jagung',
          riskLevel: 'tinggi',
          reason: 'Kondisi lembab mendukung spora bulai',
        ),
      );
    }

    // After rain = bacterial diseases
    if (rainfall > 10) {
      risks.add(
        DiseaseRisk(
          diseaseId: 'chili_anthracnose',
          diseaseName: 'Antraknosa Cabai',
          riskLevel: 'tinggi',
          reason: 'Hujan menyebarkan spora antraknosa',
        ),
      );
      risks.add(
        DiseaseRisk(
          diseaseId: 'onion_purple_blotch',
          diseaseName: 'Bercak Ungu Bawang',
          riskLevel: 'tinggi',
          reason: 'Air hujan menyebarkan spora Alternaria',
        ),
      );
    }

    // Dry + hot = virus spread via vectors
    if (rainfall < 2 && temperature > 30) {
      risks.add(
        DiseaseRisk(
          diseaseId: 'chili_yellow_leaf_curl',
          diseaseName: 'Keriting Kuning Cabai',
          riskLevel: 'sedang',
          reason: 'Populasi kutu kebul meningkat saat kering',
        ),
      );
      risks.add(
        DiseaseRisk(
          diseaseId: 'rice_tungro',
          diseaseName: 'Tungro Padi',
          riskLevel: 'sedang',
          reason: 'Wereng hijau aktif saat cuaca kering',
        ),
      );
    }

    return risks;
  }
}

class WeatherForecast {
  final List<Weather> dailyForecast;
  final String locationName;
  final DateTime lastUpdated;

  WeatherForecast({
    required this.dailyForecast,
    required this.locationName,
    required this.lastUpdated,
  });

  Weather? get today => dailyForecast.isNotEmpty ? dailyForecast.first : null;
  Weather? get tomorrow => dailyForecast.length > 1 ? dailyForecast[1] : null;

  bool get willRainSoon => dailyForecast.take(3).any((w) => w.rainfall > 5);

  String get weeklyOutlook {
    final totalRain = dailyForecast.fold<double>(
      0,
      (sum, w) => sum + w.rainfall,
    );
    final avgTemp =
        dailyForecast.fold<double>(0, (sum, w) => sum + w.temperature) /
        dailyForecast.length;

    if (totalRain > 100) return 'Minggu ini hujan lebat. Persiapkan drainase.';
    if (totalRain > 50)
      return 'Curah hujan sedang. Tunda penyemprotan saat hujan.';
    if (avgTemp > 32) return 'Minggu yang panas. Tingkatkan penyiraman.';
    return 'Cuaca relatif baik untuk aktivitas pertanian.';
  }

  // Best day for spraying in next 7 days
  Weather? get bestDayForSpraying {
    try {
      return dailyForecast.firstWhere(
        (w) =>
            w.rainfall < 2 &&
            w.windSpeed < 15 &&
            w.humidity < 85 &&
            w.temperature < 33,
      );
    } catch (e) {
      return null;
    }
  }
}

class FarmingRecommendation {
  final bool canSpray;
  final bool canHarvest;
  final bool canPlant;
  final bool canFertilize;
  final String message;
  final List<String> warnings;
  final List<String> recommendations;

  FarmingRecommendation({
    required this.canSpray,
    required this.canHarvest,
    required this.canPlant,
    required this.canFertilize,
    required this.message,
    required this.warnings,
    required this.recommendations,
  });

  String get statusEmoji {
    final canDo = [
      canSpray,
      canHarvest,
      canPlant,
      canFertilize,
    ].where((b) => b).length;
    if (canDo == 4) return '✅';
    if (canDo >= 2) return '⚠️';
    return '❌';
  }
}

class DiseaseRisk {
  final String diseaseId;
  final String diseaseName;
  final String riskLevel; // rendah, sedang, tinggi
  final String reason;

  DiseaseRisk({
    required this.diseaseId,
    required this.diseaseName,
    required this.riskLevel,
    required this.reason,
  });

  String get riskEmoji {
    switch (riskLevel) {
      case 'tinggi':
        return '🔴';
      case 'sedang':
        return '🟡';
      case 'rendah':
        return '🟢';
      default:
        return '⚪';
    }
  }
}

// Data cuaca musim di NTB
class NTBSeasonalData {
  static const Map<int, SeasonInfo> monthlySeasons = {
    1: SeasonInfo(
      season: 'hujan',
      avgRain: 250,
      avgTemp: 27,
      plantingRecommendation: 'Tanam padi, jagung',
    ),
    2: SeasonInfo(
      season: 'hujan',
      avgRain: 280,
      avgTemp: 27,
      plantingRecommendation: 'Perawatan tanaman',
    ),
    3: SeasonInfo(
      season: 'hujan',
      avgRain: 220,
      avgTemp: 27,
      plantingRecommendation: 'Tanam padi II',
    ),
    4: SeasonInfo(
      season: 'peralihan',
      avgRain: 120,
      avgTemp: 28,
      plantingRecommendation: 'Tanam cabai, tomat',
    ),
    5: SeasonInfo(
      season: 'kemarau',
      avgRain: 50,
      avgTemp: 28,
      plantingRecommendation: 'Tanam bawang merah',
    ),
    6: SeasonInfo(
      season: 'kemarau',
      avgRain: 30,
      avgTemp: 27,
      plantingRecommendation: 'Tanam bawang, semangka',
    ),
    7: SeasonInfo(
      season: 'kemarau',
      avgRain: 20,
      avgTemp: 26,
      plantingRecommendation: 'Panen padi, tanam palawija',
    ),
    8: SeasonInfo(
      season: 'kemarau',
      avgRain: 15,
      avgTemp: 26,
      plantingRecommendation: 'Tanam kedelai, kacang',
    ),
    9: SeasonInfo(
      season: 'peralihan',
      avgRain: 40,
      avgTemp: 27,
      plantingRecommendation: 'Persiapan tanam padi',
    ),
    10: SeasonInfo(
      season: 'hujan',
      avgRain: 100,
      avgTemp: 28,
      plantingRecommendation: 'Tanam padi I',
    ),
    11: SeasonInfo(
      season: 'hujan',
      avgRain: 180,
      avgTemp: 28,
      plantingRecommendation: 'Tanam jagung',
    ),
    12: SeasonInfo(
      season: 'hujan',
      avgRain: 230,
      avgTemp: 27,
      plantingRecommendation: 'Perawatan tanaman',
    ),
  };

  static SeasonInfo getCurrentSeason() {
    return monthlySeasons[DateTime.now().month] ?? monthlySeasons[1]!;
  }

  static String getPlantingCalendarAdvice() {
    final month = DateTime.now().month;
    return monthlySeasons[month]?.plantingRecommendation ??
        'Periksa kondisi lahan';
  }
}

class SeasonInfo {
  final String season;
  final double avgRain;
  final double avgTemp;
  final String plantingRecommendation;

  const SeasonInfo({
    required this.season,
    required this.avgRain,
    required this.avgTemp,
    required this.plantingRecommendation,
  });

  String get seasonEmoji {
    switch (season) {
      case 'hujan':
        return '🌧️';
      case 'kemarau':
        return '☀️';
      case 'peralihan':
        return '⛅';
      default:
        return '🌤️';
    }
  }

  String get seasonName {
    switch (season) {
      case 'hujan':
        return 'Musim Hujan';
      case 'kemarau':
        return 'Musim Kemarau';
      case 'peralihan':
        return 'Musim Peralihan';
      default:
        return season;
    }
  }
}
