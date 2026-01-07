
class User {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final String village;
  final String district;
  final String regency;
  final double? latitude;
  final double? longitude;
  final String? profileImagePath;
  final List<String> farmTypes; // jagung, padi, cabai
  final double farmArea; // dalam hektar
  final DateTime registeredAt;
  final int totalScans;
  final int diseasesDetected;

  User({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    required this.village,
    required this.district,
    required this.regency,
    this.latitude,
    this.longitude,
    this.profileImagePath,
    this.farmTypes = const [],
    this.farmArea = 0,
    required this.registeredAt,
    this.totalScans = 0,
    this.diseasesDetected = 0,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'],
      village: json['village'] ?? '',
      district: json['district'] ?? '',
      regency: json['regency'] ?? 'Lombok Tengah',
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      profileImagePath: json['profile_image'],
      farmTypes: List<String>.from(json['farm_types'] ?? []),
      farmArea: (json['farm_area'] ?? 0).toDouble(),
      registeredAt: DateTime.parse(
        json['registered_at'] ?? DateTime.now().toIso8601String(),
      ),
      totalScans: json['total_scans'] ?? 0,
      diseasesDetected: json['diseases_detected'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'village': village,
      'district': district,
      'regency': regency,
      'latitude': latitude,
      'longitude': longitude,
      'profile_image': profileImagePath,
      'farm_types': farmTypes,
      'farm_area': farmArea,
      'registered_at': registeredAt.toIso8601String(),
      'total_scans': totalScans,
      'diseases_detected': diseasesDetected,
    };
  }

  String get fullAddress => '$village, $district, $regency, NTB';

  User copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? village,
    String? district,
    String? regency,
    double? latitude,
    double? longitude,
    String? profileImagePath,
    List<String>? farmTypes,
    double? farmArea,
    DateTime? registeredAt,
    int? totalScans,
    int? diseasesDetected,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      village: village ?? this.village,
      district: district ?? this.district,
      regency: regency ?? this.regency,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      profileImagePath: profileImagePath ?? this.profileImagePath,
      farmTypes: farmTypes ?? this.farmTypes,
      farmArea: farmArea ?? this.farmArea,
      registeredAt: registeredAt ?? this.registeredAt,
      totalScans: totalScans ?? this.totalScans,
      diseasesDetected: diseasesDetected ?? this.diseasesDetected,
    );
  }
}

// Kabupaten/Kota di NTB
class NTBRegions {
  static const List<String> regencies = [
    'Lombok Barat',
    'Lombok Tengah',
    'Lombok Timur',
    'Lombok Utara',
    'Kota Mataram',
    'Sumbawa',
    'Sumbawa Barat',
    'Dompu',
    'Bima',
    'Kota Bima',
  ];

  static const Map<String, List<String>> districts = {
    'Lombok Barat': [
      'Gerung',
      'Kediri',
      'Narmada',
      'Sekotong',
      'Labuapi',
      'Gunungsari',
      'Lingsar',
      'Lembar',
      'Batu Layar',
      'Kuripan',
    ],
    'Lombok Tengah': [
      'Praya',
      'Praya Barat',
      'Praya Barat Daya',
      'Praya Timur',
      'Janapria',
      'Kopang',
      'Jonggat',
      'Pujut',
      'Batukliang',
      'Batukliang Utara',
      'Pringgarata',
      'Mantang',
    ],
    'Lombok Timur': [
      'Selong',
      'Labuhan Haji',
      'Pringgabaya',
      'Aikmel',
      'Wanasaba',
      'Sembalun',
      'Sukamulia',
      'Suralaga',
      'Sakra',
      'Keruak',
    ],
    'Lombok Utara': ['Tanjung', 'Gangga', 'Kayangan', 'Bayan', 'Pemenang'],
    'Kota Mataram': [
      'Ampenan',
      'Cakranegara',
      'Mataram',
      'Sandubaya',
      'Sekarbela',
      'Selaparang',
    ],
    'Sumbawa': [
      'Alas',
      'Alas Barat',
      'Batu Lanteh',
      'Buer',
      'Empang',
      'Labangka',
      'Labuhan Badas',
      'Lantung',
      'Lape',
      'Lenangguar',
      'Lopok',
      'Lunyuk',
      'Maronge',
      'Moyo Hilir',
      'Moyo Hulu',
      'Moyo Utara',
      'Orong Telu',
      'Plampang',
      'Rhee',
      'Ropang',
      'Sumbawa',
      'Tarano',
      'Unter Iwes',
      'Utan',
    ],
    'Sumbawa Barat': [
      'Brang Ene',
      'Brang Rea',
      'Jereweh',
      'Maluk',
      'Poto Tano',
      'Sekongkang',
      'Seteluk',
      'Taliwang',
    ],
    'Dompu': [
      'Dompu',
      'Hu\'u',
      'Kempo',
      'Kilo',
      'Manggelewa',
      'Pajo',
      'Pekat',
      'Woja',
    ],
    'Bima': [
      'Ambalawi',
      'Belo',
      'Bolo',
      'Donggo',
      'Lambitu',
      'Lambu',
      'Langgudu',
      'Madapangga',
      'Monta',
      'Palibelo',
      'Parado',
      'Sanggar',
      'Sape',
      'Soromandi',
      'Tambora',
      'Wawo',
      'Wera',
      'Woha',
    ],
    'Kota Bima': [
      'Rasanae Barat',
      'Rasanae Timur',
      'Raba',
      'Mpunda',
      'Asakota',
    ],
  };
}
