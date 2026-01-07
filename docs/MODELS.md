# 🌾 AgriVision NTB - Model Documentation

## Overview

AgriVision NTB memiliki **11 model data** yang komprehensif untuk mendukung petani di Nusa Tenggara Barat.

---

## 📊 Model Statistics

| Model | File Size | Records | Description |
|-------|-----------|---------|-------------|
| `Disease` | 32 KB | **80 penyakit** | Database penyakit tanaman |
| `Plant` | 22 KB | **10 tanaman** | Tanaman utama NTB |
| `Pesticide` | 17 KB | **20 pestisida** | Obat tersedia di toko |
| `Weather` | 12 KB | - | Data & prediksi cuaca |
| `Prediction` | 14 KB | - | Prediksi wabah AI |
| `AgroShop` | 10 KB | **12 toko** | Toko pertanian NTB |
| `Farm` | 8 KB | - | Manajemen lahan |
| `ScanResult` | 6 KB | - | Hasil scan penyakit |
| `User` | 6 KB | - | Data pengguna |
| `OutbreakData` | 4 KB | - | Data sebaran wabah |
| `TreatmentSchedule` | 4 KB | - | Jadwal perawatan |

**Total: ~135 KB of structured data**

---

## 🦠 Disease Model (80 Penyakit)

### Kategori Penyakit:
- 🌾 **Padi**: 12 penyakit (blast, tungro, BLB, dll)
- 🌽 **Jagung**: 12 penyakit (bulai, hawar daun, karat, dll)
- 🌶️ **Cabai**: 12 penyakit (antraknosa, layu bakteri, virus, dll)
- 🍅 **Tomat**: 10 penyakit (late blight, fusarium, TYLCV, dll)
- 🧅 **Bawang**: 8 penyakit (purple blotch, antraknosa, dll)
- 🫘 **Kedelai**: 8 penyakit (karat, antraknosa, mosaic, dll)
- 🥜 **Kacang**: 6 penyakit (leaf spot, karat, layu, dll)
- 🍌 **Buah**: 8 penyakit (fusarium, sigatoka, dll)
- 🥒 **Sayuran**: 4 penyakit (downy mildew, black rot, dll)

### Struktur Data:
```dart
Disease(
  id: 'rice_blast',
  name: 'Rice Blast',
  nameIndonesia: 'Blas Padi',
  description: '...',
  symptoms: '...',
  causes: 'Jamur Pyricularia oryzae',
  affectedPlants: ['Padi'],
)
```

### Methods:
- `Disease.getById(id)` - Cari penyakit by ID
- `Disease.getByPlant(plant)` - Filter by tanaman
- `Disease.search(query)` - Pencarian fuzzy
- `Disease.getAllPlants()` - Daftar semua tanaman

---

## 🌱 Plant Model (10 Tanaman NTB)

### Tanaman Tersedia:
1. 🌾 **Padi** (Pare) - 120 hari
2. 🌽 **Jagung** (Batar) - 100 hari
3. 🌶️ **Cabai** (Sebie) - 150 hari
4. 🧅 **Bawang Merah** (Kesuna Barak) - 70 hari
5. 🍅 **Tomat** - 100 hari
6. 🍉 **Semangka** (Semangke) - 75 hari
7. 🫘 **Kedelai** - 85 hari
8. 🥜 **Kacang Tanah** - 100 hari
9. 🫛 **Kacang Hijau** (Kacang Ijo) - 65 hari
10. 🍌 **Pisang** (Biu) - 365 hari

### Fitur:
- **Growth Stages**: Fase pertumbuhan lengkap
- **Planting Info**: Jarak tanam, kebutuhan air, dll
- **Nutrient Requirements**: NPK yang dibutuhkan
- **Common Diseases**: Penyakit yang sering menyerang
- **Best Regions NTB**: Lokasi budidaya terbaik

### Struktur Data:
```dart
Plant(
  id: 'rice',
  name: 'Padi',
  localName: 'Pare',
  growthDurationDays: 120,
  growthStages: [GrowthStage(...)],
  commonDiseases: ['rice_blast', 'rice_tungro'],
  plantingInfo: PlantingInfo(...),
  nutrientRequirement: NutrientRequirement(...),
)
```

---

## 💊 Pesticide Model (20 Produk)

### Kategori:
- 🍄 **Fungisida**: 7 produk (Dithane, Antracol, Score, dll)
- 🐛 **Insektisida**: 5 produk (Regent, Confidor, Decis, dll)
- 🦠 **Bakterisida**: 1 produk (Agrept)
- 🌿 **Organik/Hayati**: 6 produk (Trichoderma, Beauveria, Neem, dll)
- 🌾 **Herbisida**: 2 produk (Gramoxone, Roundup)

### Informasi per Produk:
- Nama dagang & bahan aktif
- Target penyakit/hama
- Dosis & cara aplikasi
- Harga kisaran di toko NTB
- Interval panen
- Peringatan keamanan
- Alternatif organik

### Methods:
- `Pesticide.getById(id)`
- `Pesticide.getByType(type)` - Filter by jenis
- `Pesticide.getByDisease(diseaseId)` - Obat untuk penyakit tertentu
- `Pesticide.getOrganicOptions()` - Pilihan organik

---

## 🌤️ Weather Model

### Fitur:
- **Current Weather**: Suhu, kelembaban, curah hujan
- **7-Day Forecast**: Prakiraan cuaca
- **Farming Recommendations**: Rekomendasi aktivitas
- **Disease Risk Analysis**: Risiko penyakit berdasarkan cuaca

### Farming Recommendation:
```dart
weather.farmingRecommendation
  .canSpray      // Boleh semprot?
  .canHarvest    // Boleh panen?
  .canPlant      // Boleh tanam?
  .canFertilize  // Boleh pupuk?
  .message       // Pesan rekomendasi
  .warnings      // Peringatan
```

### Disease Risk:
```dart
weather.diseaseRisks  // List<DiseaseRisk>
  - Blas Padi (tinggi) - Kelembaban tinggi
  - Antraknosa (sedang) - Setelah hujan
```

### Seasonal Data NTB:
- Bulan 1-3, 10-12: Musim Hujan
- Bulan 5-8: Musim Kemarau
- Bulan 4, 9: Musim Peralihan

---

## 🔮 Prediction Model (AI Prediction)

### Fitur:
- **Disease Outbreak Prediction**: Prediksi wabah
- **Early Warning Alerts**: Peringatan dini
- **Contributing Factors**: Faktor penyebab
- **Preventive Actions**: Tindakan pencegahan

### Prediction Engine Rules:
```
IF humidity > 85% AND temp 22-28°C AND rainfall > 100mm
THEN Rice Blast Risk = HIGH

IF dry season AND temp > 28°C
THEN Tungro Risk = MODERATE (wereng aktif)

IF humidity > 90% AND rainfall > 50mm
THEN Corn Downy Mildew Risk = CRITICAL
```

### Risk Levels:
- 🟢 Low - Risiko rendah
- 🟡 Moderate - Risiko sedang
- 🟠 High - Risiko tinggi
- 🔴 Critical - Risiko kritis

---

## 🌾 Farm Model

### Fitur:
- **Multi-Farm Management**: Kelola banyak lahan
- **Activity Tracking**: Catat aktivitas (pupuk, semprot, dll)
- **Growth Stage Tracking**: Fase pertumbuhan
- **Harvest Estimation**: Prediksi panen

### Farm Status:
- 🌱 Preparation - Persiapan lahan
- 🌿 Growing - Masa pertumbuhan
- 🌸 Flowering - Masa pembungaan
- 🌾 Harvesting - Masa panen
- 🏜️ Fallow - Bera/istirahat
- ⚠️ Problem - Ada masalah

### Activity Types:
- 🌱 Planting - Penanaman
- 💚 Fertilizing - Pemupukan
- 💨 Spraying - Penyemprotan
- 💧 Watering - Penyiraman
- 🌿 Weeding - Penyiangan
- 🌾 Harvesting - Panen

---

## 🏪 AgroShop Model (12 Toko NTB)

### Lokasi Toko:
- **Lombok Tengah**: 2 toko
- **Lombok Timur**: 3 toko (sentra bawang)
- **Lombok Barat**: 2 toko
- **Kota Mataram**: 2 toko (terlengkap)
- **Sumbawa**: 1 toko
- **Bima**: 1 toko
- **Dompu**: 1 toko

### Informasi per Toko:
- Nama, alamat, koordinat GPS
- Nomor telepon & WhatsApp
- Produk tersedia
- Jam buka
- Rating & review
- Status verifikasi

### Methods:
- `AgroShop.getById(id)`
- `AgroShop.getByRegency(regency)`
- `AgroShop.getNearby(lat, lng, radius)`
- `AgroShop.searchByProduct(product)`
- `AgroShop.getVerifiedShops()`

---

## 📱 Usage Example

```dart
// Import semua model
import 'package:agrivision_ntb/models/models.dart';

// Cari penyakit
final blast = Disease.getById('rice_blast');
print(blast?.nameIndonesia); // Blas Padi

// Cari obat untuk penyakit
final treatments = Pesticide.getByDisease('rice_blast');
print(treatments.first.brandName); // Dithane M-45

// Cek info tanaman
final padi = Plant.getById('rice');
print(padi?.growthDurationDays); // 120 hari

// Prediksi wabah
final predictions = PredictionEngine.generatePredictions(
  regency: 'Lombok Tengah',
  plantType: 'rice',
  temperature: 27,
  humidity: 88,
  rainfall: 120,
  month: 1,
);

// Cari toko terdekat
final shops = AgroShop.getNearby(-8.72, 116.27, radiusKm: 10);
```

---

## 🎯 For Imagine Cup 2025

Model-model ini dirancang untuk menunjukkan:

1. **AI & Machine Learning**: Prediksi penyakit berbasis cuaca dan pola historis
2. **Social Impact**: Membantu petani kecil di NTB
3. **Local Relevance**: Data spesifik untuk kondisi NTB
4. **Comprehensive Solution**: End-to-end dari deteksi hingga pengobatan
5. **Azure Integration**: Ready untuk Azure Custom Vision & OpenAI

---

*Last updated: December 2024*
