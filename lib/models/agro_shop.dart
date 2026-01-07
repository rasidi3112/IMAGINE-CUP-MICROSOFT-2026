/// AgriVision NTB - Agro Shop Model
/// Database toko pertanian dan saprotan di NTB

class AgroShop {
  final String id;
  final String name;
  final String address;
  final String village;
  final String district;
  final String regency;
  final double latitude;
  final double longitude;
  final String phone;
  final String? whatsapp;
  final List<String> availableProducts; // pesticides, seeds, fertilizers
  final List<String> openDays;
  final String openHours;
  final double rating;
  final int reviewCount;
  final bool isVerified;
  final String? imagePath;
  final String? notes;

  AgroShop({
    required this.id,
    required this.name,
    required this.address,
    required this.village,
    required this.district,
    required this.regency,
    required this.latitude,
    required this.longitude,
    required this.phone,
    this.whatsapp,
    required this.availableProducts,
    required this.openDays,
    required this.openHours,
    this.rating = 0,
    this.reviewCount = 0,
    this.isVerified = false,
    this.imagePath,
    this.notes,
  });

  factory AgroShop.fromJson(Map<String, dynamic> json) => AgroShop(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    address: json['address'] ?? '',
    village: json['village'] ?? '',
    district: json['district'] ?? '',
    regency: json['regency'] ?? '',
    latitude: (json['latitude'] ?? 0).toDouble(),
    longitude: (json['longitude'] ?? 0).toDouble(),
    phone: json['phone'] ?? '',
    whatsapp: json['whatsapp'],
    availableProducts: List<String>.from(json['available_products'] ?? []),
    openDays: List<String>.from(json['open_days'] ?? []),
    openHours: json['open_hours'] ?? '',
    rating: (json['rating'] ?? 0).toDouble(),
    reviewCount: json['review_count'] ?? 0,
    isVerified: json['is_verified'] ?? false,
    imagePath: json['image_path'],
    notes: json['notes'],
  );

  Map<String, dynamic> toJson() => {
    'id': id, 'name': name, 'address': address,
    'village': village, 'district': district, 'regency': regency,
    'latitude': latitude, 'longitude': longitude,
    'phone': phone, 'whatsapp': whatsapp,
    'available_products': availableProducts, 'open_days': openDays,
    'open_hours': openHours, 'rating': rating, 'review_count': reviewCount,
    'is_verified': isVerified, 'image_path': imagePath, 'notes': notes,
  };

  String get fullAddress => '$address, $village, $district, $regency, NTB';
  String get ratingText => rating > 0 ? '⭐ ${rating.toStringAsFixed(1)}' : 'Belum ada rating';
  bool get hasWhatsApp => whatsapp != null && whatsapp!.isNotEmpty;
  String get whatsAppLink => 'https://wa.me/62${whatsapp?.replaceFirst('0', '')}';

  bool hasProduct(String productType) => 
      availableProducts.any((p) => p.toLowerCase().contains(productType.toLowerCase()));

  // Contoh toko pertanian di NTB
  static List<AgroShop> ntbShops = [
    // ========== LOMBOK TENGAH ==========
    AgroShop(
      id: 'shop_1', name: 'Toko Tani Makmur',
      address: 'Jl. Ahmad Yani No. 15', village: 'Praya', district: 'Praya', regency: 'Lombok Tengah',
      latitude: -8.7218, longitude: 116.2769,
      phone: '0370-655123', whatsapp: '081234567890',
      availableProducts: ['pestisida', 'pupuk', 'benih padi', 'benih jagung', 'alat pertanian'],
      openDays: ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'],
      openHours: '07:00 - 17:00', rating: 4.5, reviewCount: 48, isVerified: true,
    ),
    AgroShop(
      id: 'shop_2', name: 'Saprotan Sejahtera',
      address: 'Jl. Raya Kopang No. 8', village: 'Kopang', district: 'Kopang', regency: 'Lombok Tengah',
      latitude: -8.6789, longitude: 116.3456,
      phone: '0370-641234',
      availableProducts: ['pestisida', 'pupuk', 'benih sayuran', 'mulsa'],
      openDays: ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'],
      openHours: '08:00 - 16:00', rating: 4.2, reviewCount: 32, isVerified: true,
    ),

    // ========== LOMBOK TIMUR ==========
    AgroShop(
      id: 'shop_3', name: 'Toko Pertanian Bawang Mas',
      address: 'Jl. Pasar Selong', village: 'Selong', district: 'Selong', regency: 'Lombok Timur',
      latitude: -8.6513, longitude: 116.5247,
      phone: '0376-21456', whatsapp: '082345678901',
      availableProducts: ['pestisida', 'pupuk', 'benih bawang', 'benih cabai', 'fungisida'],
      openDays: ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'],
      openHours: '06:00 - 18:00', rating: 4.7, reviewCount: 89, isVerified: true,
    ),
    AgroShop(
      id: 'shop_4', name: 'CV Agro Sakti',
      address: 'Jl. TGH Zainuddin', village: 'Pancor', district: 'Selong', regency: 'Lombok Timur',
      latitude: -8.6589, longitude: 116.5312,
      phone: '0376-23789', whatsapp: '081987654321',
      availableProducts: ['pestisida', 'pupuk', 'benih', 'alat semprot', 'mulsa', 'tali rafia'],
      openDays: ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'],
      openHours: '07:30 - 17:00', rating: 4.4, reviewCount: 56, isVerified: true,
    ),
    AgroShop(
      id: 'shop_5', name: 'Kios Tani Aikmel',
      address: 'Pasar Aikmel', village: 'Aikmel', district: 'Aikmel', regency: 'Lombok Timur',
      latitude: -8.5934, longitude: 116.5678,
      phone: '081234123456',
      availableProducts: ['pestisida', 'pupuk', 'benih'],
      openDays: ['Senin', 'Rabu', 'Sabtu'],
      openHours: '07:00 - 14:00', rating: 4.0, reviewCount: 15,
    ),

    // ========== LOMBOK BARAT ==========
    AgroShop(
      id: 'shop_6', name: 'Toko Pertanian Narmada',
      address: 'Jl. Raya Narmada', village: 'Lembuak', district: 'Narmada', regency: 'Lombok Barat',
      latitude: -8.5789, longitude: 116.2134,
      phone: '0370-671234', whatsapp: '085678901234',
      availableProducts: ['pestisida', 'pupuk', 'benih', 'agen hayati', 'pupuk organik'],
      openDays: ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'],
      openHours: '07:00 - 17:00', rating: 4.3, reviewCount: 41, isVerified: true,
    ),
    AgroShop(
      id: 'shop_7', name: 'Saprotan Gerung Jaya',
      address: 'Jl. Pasar Gerung', village: 'Gerung', district: 'Gerung', regency: 'Lombok Barat',
      latitude: -8.6567, longitude: 116.1234,
      phone: '0370-681567',
      availableProducts: ['pestisida', 'pupuk', 'benih padi', 'benih jagung'],
      openDays: ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'],
      openHours: '07:30 - 16:30', rating: 4.1, reviewCount: 27,
    ),

    // ========== MATARAM ==========
    AgroShop(
      id: 'shop_8', name: 'CV Agro Mandiri Mataram',
      address: 'Jl. Pejanggik No. 45', village: 'Cakranegara', district: 'Cakranegara', regency: 'Kota Mataram',
      latitude: -8.6013, longitude: 116.1456,
      phone: '0370-632456', whatsapp: '081345678912',
      availableProducts: ['pestisida lengkap', 'pupuk', 'benih import', 'alat pertanian', 'greenhouse'],
      openDays: ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'],
      openHours: '08:00 - 17:00', rating: 4.8, reviewCount: 124, isVerified: true,
      notes: 'Toko terlengkap di Mataram',
    ),
    AgroShop(
      id: 'shop_9', name: 'Toko Saprotan Selaparang',
      address: 'Jl. Langko No. 12', village: 'Ampenan', district: 'Ampenan', regency: 'Kota Mataram',
      latitude: -8.5845, longitude: 116.0823,
      phone: '0370-621789',
      availableProducts: ['pestisida', 'pupuk', 'benih sayuran'],
      openDays: ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'],
      openHours: '07:00 - 16:00', rating: 4.0, reviewCount: 18,
    ),

    // ========== SUMBAWA ==========
    AgroShop(
      id: 'shop_10', name: 'Toko Tani Sumbawa',
      address: 'Jl. Garuda No. 8', village: 'Sumbawa', district: 'Sumbawa', regency: 'Sumbawa',
      latitude: -8.4889, longitude: 117.4234,
      phone: '0371-21345', whatsapp: '082456789012',
      availableProducts: ['pestisida', 'pupuk', 'benih jagung', 'benih kedelai', 'benih kacang'],
      openDays: ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'],
      openHours: '07:00 - 17:00', rating: 4.4, reviewCount: 52, isVerified: true,
    ),

    // ========== BIMA ==========
    AgroShop(
      id: 'shop_11', name: 'CV Pertanian Bima Sakti',
      address: 'Jl. Sultan Hasanuddin', village: 'Raba', district: 'Raba', regency: 'Kota Bima',
      latitude: -8.4634, longitude: 118.7289,
      phone: '0374-43567', whatsapp: '081567890123',
      availableProducts: ['pestisida', 'pupuk', 'benih bawang', 'benih jagung'],
      openDays: ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'],
      openHours: '07:00 - 17:00', rating: 4.5, reviewCount: 38, isVerified: true,
    ),

    // ========== DOMPU ==========
    AgroShop(
      id: 'shop_12', name: 'Toko Saprotan Dompu',
      address: 'Jl. Lintas Sumbawa', village: 'Dompu', district: 'Dompu', regency: 'Dompu',
      latitude: -8.5345, longitude: 118.4567,
      phone: '0373-21456',
      availableProducts: ['pestisida', 'pupuk', 'benih'],
      openDays: ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'],
      openHours: '07:30 - 16:00', rating: 4.2, reviewCount: 24,
    ),
  ];

  static AgroShop? getById(String id) {
    try { return ntbShops.firstWhere((s) => s.id == id); }
    catch (e) { return null; }
  }

  static List<AgroShop> getByRegency(String regency) =>
      ntbShops.where((s) => s.regency.toLowerCase().contains(regency.toLowerCase())).toList();

  static List<AgroShop> getNearby(double lat, double lng, {double radiusKm = 20}) {
    return ntbShops.where((shop) {
      final distance = _calculateDistance(lat, lng, shop.latitude, shop.longitude);
      return distance <= radiusKm;
    }).toList()
      ..sort((a, b) {
        final distA = _calculateDistance(lat, lng, a.latitude, a.longitude);
        final distB = _calculateDistance(lat, lng, b.latitude, b.longitude);
        return distA.compareTo(distB);
      });
  }

  static double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295;
    final a = 0.5 - 
        (((lat2 - lat1) * p) / 2).abs() * 0.5 +
        ((lon1 * p).abs() * (lon2 * p).abs() * 
        (1 - (((lon2 - lon1) * p) / 2).abs()) / 2);
    return 12742 * (a > 0 ? a : -a); // Approximate km
  }

  static List<AgroShop> searchByProduct(String product) =>
      ntbShops.where((s) => s.hasProduct(product)).toList();

  static List<AgroShop> getVerifiedShops() =>
      ntbShops.where((s) => s.isVerified).toList();
}
