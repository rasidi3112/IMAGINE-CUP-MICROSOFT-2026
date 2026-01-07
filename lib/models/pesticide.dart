/// AgriVision NTB - Pesticide Model
/// Database pestisida/obat yang tersedia di toko pertanian NTB

class Pesticide {
  final String id;
  final String brandName;
  final String activeIngredient;
  final String type; // fungisida, insektisida, herbisida, bakterisida
  final String category; // kimia, organik, hayati
  final String description;
  final List<String> targetDiseases;
  final List<String> targetPests;
  final String dosage;
  final String applicationMethod;
  final String frequency;
  final int harvestInterval; // hari sebelum panen
  final double priceRangeMin;
  final double priceRangeMax;
  final String packaging;
  final List<String> warnings;
  final String? organicAlternative;
  final bool availableInNTB;

  Pesticide({
    required this.id,
    required this.brandName,
    required this.activeIngredient,
    required this.type,
    required this.category,
    required this.description,
    required this.targetDiseases,
    required this.targetPests,
    required this.dosage,
    required this.applicationMethod,
    required this.frequency,
    required this.harvestInterval,
    required this.priceRangeMin,
    required this.priceRangeMax,
    required this.packaging,
    required this.warnings,
    this.organicAlternative,
    this.availableInNTB = true,
  });

  factory Pesticide.fromJson(Map<String, dynamic> json) => Pesticide(
    id: json['id'] ?? '',
    brandName: json['brand_name'] ?? '',
    activeIngredient: json['active_ingredient'] ?? '',
    type: json['type'] ?? '',
    category: json['category'] ?? '',
    description: json['description'] ?? '',
    targetDiseases: List<String>.from(json['target_diseases'] ?? []),
    targetPests: List<String>.from(json['target_pests'] ?? []),
    dosage: json['dosage'] ?? '',
    applicationMethod: json['application_method'] ?? '',
    frequency: json['frequency'] ?? '',
    harvestInterval: json['harvest_interval'] ?? 0,
    priceRangeMin: (json['price_min'] ?? 0).toDouble(),
    priceRangeMax: (json['price_max'] ?? 0).toDouble(),
    packaging: json['packaging'] ?? '',
    warnings: List<String>.from(json['warnings'] ?? []),
    organicAlternative: json['organic_alternative'],
    availableInNTB: json['available_ntb'] ?? true,
  );

  Map<String, dynamic> toJson() => {
    'id': id, 'brand_name': brandName, 'active_ingredient': activeIngredient,
    'type': type, 'category': category, 'description': description,
    'target_diseases': targetDiseases, 'target_pests': targetPests,
    'dosage': dosage, 'application_method': applicationMethod,
    'frequency': frequency, 'harvest_interval': harvestInterval,
    'price_min': priceRangeMin, 'price_max': priceRangeMax,
    'packaging': packaging, 'warnings': warnings,
    'organic_alternative': organicAlternative, 'available_ntb': availableInNTB,
  };

  String get priceRange => 'Rp ${(priceRangeMin/1000).toStringAsFixed(0)}rb - ${(priceRangeMax/1000).toStringAsFixed(0)}rb';
  String get typeEmoji {
    switch (type) {
      case 'fungisida': return '🍄';
      case 'insektisida': return '🐛';
      case 'bakterisida': return '🦠';
      case 'herbisida': return '🌿';
      case 'akarisida': return '🕷️';
      default: return '💊';
    }
  }

  static Pesticide? getById(String id) {
    try { return pesticidesNTB.firstWhere((p) => p.id == id); }
    catch (e) { return null; }
  }

  static List<Pesticide> getByType(String type) =>
      pesticidesNTB.where((p) => p.type == type).toList();

  static List<Pesticide> getByDisease(String diseaseId) =>
      pesticidesNTB.where((p) => p.targetDiseases.contains(diseaseId)).toList();

  static List<Pesticide> getOrganicOptions() =>
      pesticidesNTB.where((p) => p.category == 'organik' || p.category == 'hayati').toList();

  // Database Pestisida Tersedia di NTB
  static List<Pesticide> pesticidesNTB = [
    // ========== FUNGISIDA ==========
    Pesticide(
      id: 'dithane_m45', brandName: 'Dithane M-45',
      activeIngredient: 'Mankozeb 80%', type: 'fungisida', category: 'kimia',
      description: 'Fungisida kontak berspektrum luas untuk berbagai penyakit jamur.',
      targetDiseases: ['rice_blast', 'rice_brown_spot', 'corn_leaf_blight', 'tomato_late_blight', 'onion_purple_blotch', 'chili_anthracnose'],
      targetPests: [], dosage: '2-3 g/liter air', applicationMethod: 'Semprot merata ke seluruh daun',
      frequency: 'Setiap 7-10 hari', harvestInterval: 7,
      priceRangeMin: 35000, priceRangeMax: 45000, packaging: '250 g',
      warnings: ['Gunakan APD', 'Jauhkan dari anak-anak'], organicAlternative: 'trichoderma',
    ),
    Pesticide(
      id: 'antracol', brandName: 'Antracol 70 WP',
      activeIngredient: 'Propineb 70%', type: 'fungisida', category: 'kimia',
      description: 'Fungisida protektan untuk pencegahan penyakit jamur.',
      targetDiseases: ['tomato_late_blight', 'tomato_early_blight', 'chili_anthracnose', 'onion_purple_blotch', 'watermelon_anthracnose'],
      targetPests: [], dosage: '2 g/liter air', applicationMethod: 'Semprot preventif sebelum gejala muncul',
      frequency: 'Setiap 5-7 hari', harvestInterval: 5,
      priceRangeMin: 45000, priceRangeMax: 55000, packaging: '250 g',
      warnings: ['Hindari kontak kulit', 'Jangan campur dengan insektisida'],
    ),
    Pesticide(
      id: 'score', brandName: 'Score 250 EC',
      activeIngredient: 'Difenokonazol 250 g/l', type: 'fungisida', category: 'kimia',
      description: 'Fungisida sistemik untuk penyakit bercak daun dan karat.',
      targetDiseases: ['rice_blast', 'corn_rust', 'soybean_rust', 'peanut_rust', 'onion_purple_blotch', 'mango_anthracnose'],
      targetPests: [], dosage: '0.5 ml/liter air', applicationMethod: 'Semprot saat gejala awal muncul',
      frequency: 'Setiap 10-14 hari', harvestInterval: 14,
      priceRangeMin: 85000, priceRangeMax: 110000, packaging: '100 ml',
      warnings: ['Sangat beracun untuk ikan', 'Jangan buang sisa ke sungai'],
    ),
    Pesticide(
      id: 'amistar_top', brandName: 'Amistar Top 325 SC',
      activeIngredient: 'Azoksistrobin + Difenokonazol', type: 'fungisida', category: 'kimia',
      description: 'Fungisida sistemik premium untuk pengendalian berbagai jamur.',
      targetDiseases: ['rice_blast', 'rice_sheath_blight', 'corn_rust', 'chili_anthracnose', 'tomato_late_blight'],
      targetPests: [], dosage: '0.5-1 ml/liter air', applicationMethod: 'Semprot merata',
      frequency: 'Setiap 14-21 hari', harvestInterval: 14,
      priceRangeMin: 150000, priceRangeMax: 185000, packaging: '100 ml',
      warnings: ['Produk mahal, gunakan sesuai dosis'],
    ),
    Pesticide(
      id: 'nordox', brandName: 'Nordox 56 WP',
      activeIngredient: 'Tembaga Oksida 56%', type: 'fungisida', category: 'kimia',
      description: 'Fungisida berbahan tembaga untuk bakteri dan jamur.',
      targetDiseases: ['rice_bacterial_leaf_blight', 'tomato_bacterial_wilt', 'chili_bacterial_wilt', 'chili_bacterial_spot'],
      targetPests: [], dosage: '2-3 g/liter air', applicationMethod: 'Semprot preventif',
      frequency: 'Setiap 7-10 hari', harvestInterval: 3,
      priceRangeMin: 55000, priceRangeMax: 70000, packaging: '250 g',
      warnings: ['Dapat menyebabkan fitotoksik jika overdosis'],
    ),
    Pesticide(
      id: 'ridomil_gold', brandName: 'Ridomil Gold MZ 4/64 WG',
      activeIngredient: 'Metalaksil-M + Mankozeb', type: 'fungisida', category: 'kimia',
      description: 'Fungisida sistemik untuk oomycetes seperti Phytophthora.',
      targetDiseases: ['tomato_late_blight', 'chili_phytophthora_blight', 'corn_downy_mildew', 'onion_downy_mildew'],
      targetPests: [], dosage: '2-3 g/liter air', applicationMethod: 'Kocor atau semprot',
      frequency: 'Setiap 7-14 hari', harvestInterval: 14,
      priceRangeMin: 120000, priceRangeMax: 150000, packaging: '250 g',
      warnings: ['Jangan gunakan berturut-turut untuk hindari resistensi'],
    ),

    // ========== INSEKTISIDA ==========
    Pesticide(
      id: 'regent', brandName: 'Regent 50 SC',
      activeIngredient: 'Fipronil 50 g/l', type: 'insektisida', category: 'kimia',
      description: 'Insektisida sistemik untuk penggerek dan wereng.',
      targetDiseases: [], targetPests: ['Penggerek Batang', 'Wereng Coklat', 'Wereng Hijau', 'Lalat Bibit'],
      dosage: '2 ml/liter air', applicationMethod: 'Semprot atau kocor',
      frequency: 'Saat serangan ditemukan', harvestInterval: 21,
      priceRangeMin: 85000, priceRangeMax: 100000, packaging: '100 ml',
      warnings: ['Sangat beracun untuk lebah', 'Hindari aplikasi saat tanaman berbunga'],
    ),
    Pesticide(
      id: 'confidor', brandName: 'Confidor 200 SL',
      activeIngredient: 'Imidakloprid 200 g/l', type: 'insektisida', category: 'kimia',
      description: 'Insektisida sistemik untuk hama penghisap.',
      targetDiseases: [], targetPests: ['Kutu Daun', 'Kutu Kebul', 'Thrips', 'Wereng'],
      dosage: '0.5-1 ml/liter air', applicationMethod: 'Semprot atau kocor',
      frequency: 'Setiap 7-10 hari', harvestInterval: 14,
      priceRangeMin: 75000, priceRangeMax: 95000, packaging: '100 ml',
      warnings: ['Beracun untuk lebah'],
    ),
    Pesticide(
      id: 'decis', brandName: 'Decis 25 EC',
      activeIngredient: 'Deltametrin 25 g/l', type: 'insektisida', category: 'kimia',
      description: 'Insektisida piretroid untuk ulat dan hama penggerek.',
      targetDiseases: [], targetPests: ['Ulat Grayak', 'Penggerek Batang', 'Ulat Buah', 'Kumbang'],
      dosage: '1-2 ml/liter air', applicationMethod: 'Semprot sore hari',
      frequency: 'Saat populasi tinggi', harvestInterval: 7,
      priceRangeMin: 45000, priceRangeMax: 60000, packaging: '100 ml',
      warnings: ['Beracun untuk ikan'],
    ),
    Pesticide(
      id: 'prevathon', brandName: 'Prevathon 50 SC',
      activeIngredient: 'Klorantraniliprol 50 g/l', type: 'insektisida', category: 'kimia',
      description: 'Insektisida modern untuk ulat dengan toksisitas rendah pada musuh alami.',
      targetDiseases: [], targetPests: ['Ulat Grayak', 'Penggerek Batang', 'Ulat Buah'],
      dosage: '0.5-1 ml/liter air', applicationMethod: 'Semprot merata',
      frequency: 'Setiap 7-14 hari', harvestInterval: 3,
      priceRangeMin: 180000, priceRangeMax: 220000, packaging: '100 ml',
      warnings: ['Aman untuk lebah jika diaplikasikan sesuai aturan'],
    ),
    Pesticide(
      id: 'demolish', brandName: 'Demolish 18 EC',
      activeIngredient: 'Abamektin 18 g/l', type: 'akarisida', category: 'kimia',
      description: 'Akarisida-insektisida untuk tungau dan lalat pengorok.',
      targetDiseases: [], targetPests: ['Tungau', 'Lalat Pengorok', 'Thrips'],
      dosage: '0.5-1 ml/liter air', applicationMethod: 'Semprot bawah daun',
      frequency: 'Setiap 7-10 hari', harvestInterval: 7,
      priceRangeMin: 65000, priceRangeMax: 85000, packaging: '100 ml',
      warnings: ['Sangat beracun untuk ikan'],
    ),

    // ========== BAKTERISIDA ==========
    Pesticide(
      id: 'agrept', brandName: 'Agrept 20 WP',
      activeIngredient: 'Streptomisin Sulfat 20%', type: 'bakterisida', category: 'kimia',
      description: 'Bakterisida untuk penyakit layu bakteri.',
      targetDiseases: ['tomato_bacterial_wilt', 'chili_bacterial_wilt', 'rice_bacterial_leaf_blight', 'peanut_bacterial_wilt'],
      targetPests: [], dosage: '1-2 g/liter air', applicationMethod: 'Kocor ke pangkal batang',
      frequency: 'Setiap 5-7 hari saat serangan', harvestInterval: 7,
      priceRangeMin: 55000, priceRangeMax: 70000, packaging: '25 g',
      warnings: ['Gunakan protektif sebelum serangan'],
    ),

    // ========== ORGANIK/HAYATI ==========
    Pesticide(
      id: 'trichoderma', brandName: 'Trichoderma sp.',
      activeIngredient: 'Trichoderma harzianum', type: 'fungisida', category: 'hayati',
      description: 'Agen hayati untuk pengendalian jamur tular tanah.',
      targetDiseases: ['tomato_fusarium_wilt', 'chili_fusarium_wilt', 'watermelon_fusarium_wilt', 'banana_fusarium_wilt', 'onion_fusarium_basal_rot'],
      targetPests: [], dosage: '5-10 g/liter atau 250 g/ha', applicationMethod: 'Kocor ke tanah atau campur media tanam',
      frequency: 'Saat tanam dan 2 minggu kemudian', harvestInterval: 0,
      priceRangeMin: 25000, priceRangeMax: 40000, packaging: '250 g',
      warnings: ['Simpan di tempat sejuk', 'Jangan campur fungisida kimia'], organicAlternative: null,
    ),
    Pesticide(
      id: 'beauveria', brandName: 'Beauveria bassiana',
      activeIngredient: 'Beauveria bassiana', type: 'insektisida', category: 'hayati',
      description: 'Jamur entomopatogen untuk pengendalian hama.',
      targetDiseases: [], targetPests: ['Wereng Coklat', 'Kutu Daun', 'Thrips', 'Ulat'],
      dosage: '5-10 g/liter air', applicationMethod: 'Semprot sore hari',
      frequency: 'Setiap 7 hari', harvestInterval: 0,
      priceRangeMin: 25000, priceRangeMax: 35000, packaging: '250 g',
      warnings: ['Aplikasi sore untuk hindari UV', 'Jangan campur insektisida kimia'],
    ),
    Pesticide(
      id: 'metarhizium', brandName: 'Metarhizium anisopliae',
      activeIngredient: 'Metarhizium anisopliae', type: 'insektisida', category: 'hayati',
      description: 'Jamur entomopatogen untuk ulat dan penggerek.',
      targetDiseases: [], targetPests: ['Penggerek Batang', 'Ulat Grayak', 'Uret', 'Rayap'],
      dosage: '5-10 g/liter atau dalam umpan', applicationMethod: 'Semprot atau tabur',
      frequency: 'Setiap 7-14 hari', harvestInterval: 0,
      priceRangeMin: 25000, priceRangeMax: 35000, packaging: '250 g',
      warnings: ['Simpan di tempat sejuk'],
    ),
    Pesticide(
      id: 'pgpr', brandName: 'PGPR (Plant Growth Promoting Rhizobacteria)',
      activeIngredient: 'Bacillus sp., Pseudomonas sp.', type: 'bakterisida', category: 'hayati',
      description: 'Bakteri menguntungkan untuk kesehatan akar dan induksi ketahanan.',
      targetDiseases: ['tomato_bacterial_wilt', 'chili_bacterial_wilt', 'chili_damping_off'],
      targetPests: [], dosage: '5-10 ml/liter air', applicationMethod: 'Rendam benih atau kocor',
      frequency: 'Saat semai dan pindah tanam', harvestInterval: 0,
      priceRangeMin: 30000, priceRangeMax: 50000, packaging: '250 ml',
      warnings: ['Gunakan dalam 6 bulan'],
    ),
    Pesticide(
      id: 'neem_oil', brandName: 'Minyak Nimba/Neem',
      activeIngredient: 'Azadirachtin', type: 'insektisida', category: 'organik',
      description: 'Pestisida nabati dari biji mimba.',
      targetDiseases: [], targetPests: ['Kutu Daun', 'Thrips', 'Ulat kecil', 'Tungau'],
      dosage: '3-5 ml/liter air + sabun', applicationMethod: 'Semprot merata',
      frequency: 'Setiap 5-7 hari', harvestInterval: 0,
      priceRangeMin: 35000, priceRangeMax: 60000, packaging: '250 ml',
      warnings: ['Bau menyengat', 'Tambahkan emulsifier'],
    ),
    Pesticide(
      id: 'biopestisida_daun', brandName: 'Pestisida Nabati Daun',
      activeIngredient: 'Ekstrak bawang putih, cabe, tembakau', type: 'insektisida', category: 'organik',
      description: 'Pestisida nabati buatan sendiri untuk hama ringan.',
      targetDiseases: [], targetPests: ['Kutu Daun', 'Ulat kecil', 'Hama ringan'],
      dosage: 'Sesuai resep lokal', applicationMethod: 'Semprot',
      frequency: 'Setiap 3-5 hari', harvestInterval: 0,
      priceRangeMin: 0, priceRangeMax: 10000, packaging: 'Buatan sendiri',
      warnings: ['Efektivitas bervariasi', 'Untuk serangan ringan'],
    ),

    // ========== HERBISIDA ==========
    Pesticide(
      id: 'gramoxone', brandName: 'Gramoxone 276 SL',
      activeIngredient: 'Parakuat Diklorida 276 g/l', type: 'herbisida', category: 'kimia',
      description: 'Herbisida kontak untuk gulma di pematang dan lahan kosong.',
      targetDiseases: [], targetPests: [],
      dosage: '2-3 ml/liter air', applicationMethod: 'Semprot gulma, hindari tanaman',
      frequency: 'Sebelum tanam', harvestInterval: 0,
      priceRangeMin: 65000, priceRangeMax: 80000, packaging: '1 liter',
      warnings: ['Sangat beracun!', 'Tidak ada antidot', 'Gunakan APD lengkap'],
    ),
    Pesticide(
      id: 'roundup', brandName: 'Roundup 486 SL',
      activeIngredient: 'Isopropilamin Glifosat 486 g/l', type: 'herbisida', category: 'kimia',
      description: 'Herbisida sistemik untuk gulma tahunan.',
      targetDiseases: [], targetPests: [],
      dosage: '3-5 ml/liter air', applicationMethod: 'Semprot gulma',
      frequency: '2 minggu sebelum tanam', harvestInterval: 0,
      priceRangeMin: 75000, priceRangeMax: 95000, packaging: '1 liter',
      warnings: ['Jangan kena tanaman budidaya'],
    ),
  ];
}
