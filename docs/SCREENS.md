# AgriVision NTB - Screens Documentation

## Overview

AgriVision NTB memiliki berbagai layar (screens) yang dirancang untuk memberikan pengalaman pengguna yang profesional dan modern untuk petani di NTB.

---

## 📱 Daftar Screens

### 1. Authentication Screens

#### OnboardingScreen
- **Path**: `lib/screens/auth/onboarding_screen.dart`
- **Deskripsi**: Layar pengenalan aplikasi untuk pengguna baru
- **Fitur**:
  - Carousel pengenalan fitur
  - Animasi halus
  - Tombol navigasi ke registrasi

---

### 2. Home & Navigation

#### HomeScreen
- **Path**: `lib/screens/home/home_screen.dart`
- **Deskripsi**: Dashboard utama aplikasi
- **Fitur**:
  - Greeting dinamis berdasarkan waktu
  - Quick stats (total scan, penyakit, jadwal)
  - Akses cepat ke fitur utama
  - Recent scans
  - Upcoming treatments
  - **NEW**: Fitur Lainnya (navigasi ke Encyclopedia, Plant Guide, dll.)

---

### 3. Scan Features

#### ScanScreen
- **Path**: `lib/screens/scan/scan_screen.dart`
- **Deskripsi**: Layar untuk memindai tanaman menggunakan kamera
- **Fitur**:
  - Camera preview
  - Capture & gallery option
  - Flash toggle
  - Tips pengambilan gambar

#### ScanResultScreen
- **Path**: `lib/screens/scan/scan_result_screen.dart`
- **Deskripsi**: Menampilkan hasil analisis penyakit tanaman
- **Fitur**:
  - Detected disease info
  - Confidence score
  - Severity level
  - AI consultation
  - Treatment recommendations

---

### 4. Encyclopedia (BARU) 📚

#### EncyclopediaScreen
- **Path**: `lib/screens/encyclopedia/encyclopedia_screen.dart`
- **Deskripsi**: Ensiklopedia lengkap 80 penyakit tanaman
- **Fitur**:
  - Pencarian penyakit
  - Filter berdasarkan tanaman
  - Kartu penyakit informatif dengan emoji
  - Navigasi ke detail penyakit
- **Statistik**: 80 penyakit, 10 jenis tanaman

#### DiseaseDetailScreen
- **Path**: `lib/screens/encyclopedia/disease_detail_screen.dart`
- **Deskripsi**: Detail lengkap penyakit tanaman
- **Fitur**:
  - Header dengan gradient warna tingkat keparahan
  - Deskripsi lengkap
  - Gejala visual
  - Penyebab penyakit
  - Tanaman yang terpengaruh
  - Rekomendasi pestisida
  - Tombol konsultasi AI

---

### 5. Plant Guide (BARU) 🌱

#### PlantGuideScreen
- **Path**: `lib/screens/plant_guide/plant_guide_screen.dart`
- **Deskripsi**: Panduan 10 tanaman utama NTB
- **Fitur**:
  - Tab kategori (Pangan, Hortikultura)
  - Grid view tanaman
  - Kartu tanaman dengan ikon dan warna kategori
  - Info durasi tanam
  - Navigasi ke detail tanaman

#### PlantDetailScreen
- **Path**: `lib/screens/plant_guide/plant_detail_screen.dart`
- **Deskripsi**: Detail lengkap tanaman
- **Fitur**:
  - Header dinamis dengan warna kategori
  - Fase pertumbuhan dengan timeline
  - Info penanaman (jarak, kedalaman, waktu)
  - Kebutuhan nutrisi dengan progress bar
  - Penyakit umum dengan navigasi ke detail
  - Lokasi terbaik di NTB

---

### 6. Pesticide Finder (BARU) 💊

#### PesticideFinderScreen
- **Path**: `lib/screens/pesticide/pesticide_finder_screen.dart`
- **Deskripsi**: Pencari obat pertanian/pestisida
- **Fitur**:
  - Pencarian produk
  - Filter berdasarkan tipe (fungisida, insektisida, dll.)
  - Filter kategori (kimia, hayati, organik)
  - Highlight pilihan organik
  - Kartu pestisida dengan harga
  - Navigasi ke detail

#### PesticideDetailScreen
- **Path**: `lib/screens/pesticide/pesticide_detail_screen.dart`
- **Deskripsi**: Detail lengkap pestisida
- **Fitur**:
  - Header dengan warna sesuai tipe
  - Harga dan packaging
  - Tombol cari toko terdekat
  - Cara penggunaan (dosis, aplikasi, frekuensi)
  - Target penyakit dan hama
  - Peringatan keamanan
  - Alternatif organik

---

### 7. Weather Dashboard (BARU) 🌤️

#### WeatherDashboardScreen
- **Path**: `lib/screens/weather/weather_dashboard_screen.dart`
- **Deskripsi**: Dashboard cuaca dan rekomendasi pertanian
- **Fitur**:
  - Cuaca saat ini dengan emoji kondisi
  - Statistik (kelembaban, curah hujan, angin, UV)
  - Rekomendasi farming (bisa semprot, panen, tanam, pupuk)
  - Peringatan risiko penyakit berdasarkan cuaca
  - Prakiraan 7 hari dengan kartu horizontal
  - Info musim NTB saat ini
  - Tips harian

---

### 8. Prediction & Alerts (BARU) 🔮

#### PredictionAlertScreen
- **Path**: `lib/screens/prediction/prediction_alert_screen.dart`
- **Deskripsi**: Sistem prediksi wabah dan peringatan dini AI
- **Fitur**:
  - **Tab Prediksi Wabah**:
    - Selector wilayah (7 kabupaten NTB)
    - Kartu prediksi dengan level risiko
    - Timeline hingga outbreak
    - Faktor penyebab
    - Tindakan pencegahan
    - Link ke detail penyakit
  - **Tab Peringatan Aktif**:
    - Alert hama, cuaca, harga pasar
    - Severity levels (info, warning, urgent, emergency)
    - Action items
    - Timestamp relatif

---

### 9. Farm Management (BARU) 🌾

#### FarmManagementScreen
- **Path**: `lib/screens/farm/farm_management_screen.dart`
- **Deskripsi**: Manajemen lahan pertanian
- **Fitur**:
  - Ringkasan lahan (jumlah, luas total, aktif)
  - Daftar lahan dengan kartu informatif
  - Detail lahan (tanaman, luas, jenis tanah, irigasi)
  - Fase pertumbuhan dengan progress bar
  - Aksi cepat (scan, jadwal, riwayat)
  - FAB tambah lahan baru

---

### 10. Other Screens

#### ConsultationScreen
- **Path**: `lib/screens/consultation/consultation_screen.dart`
- **Deskripsi**: Konsultasi AI dengan ahli agronomi virtual

#### OutbreakMapScreen
- **Path**: `lib/screens/map/outbreak_map_screen.dart`
- **Deskripsi**: Peta persebaran wabah penyakit

#### CalendarScreen
- **Path**: `lib/screens/calendar/calendar_screen.dart`
- **Deskripsi**: Kalender jadwal perawatan tanaman

#### HistoryScreen
- **Path**: `lib/screens/history/history_screen.dart`
- **Deskripsi**: Riwayat hasil scan

#### ProfileScreen
- **Path**: `lib/screens/profile/profile_screen.dart`
- **Deskripsi**: Profil pengguna dan pengaturan

---

## 🎨 Design System

### Warna Utama
- **Primary Green**: `#4CAF50` - Warna utama aplikasi
- **Success Green**: `#43A047` - Status sukses
- **Warning Orange**: `#FF9800` - Peringatan
- **Danger Red**: `#E53935` - Bahaya/error
- **Info Blue**: `#2196F3` - Informasi

### Komponen UI
- **BorderRadius**: 12-20px untuk kartu
- **Shadow**: Subtle shadow dengan opacity 4-10%
- **Animasi**: flutter_animate untuk transisi halus
- **Emoji**: Digunakan sebagai visual indicator

### Typography
- **Heading**: Bold, 20-24px
- **Body**: Regular, 14-16px
- **Caption**: Light, 11-13px

---

## 📊 Statistik

| Screen Category | Jumlah Screen | Status |
|-----------------|---------------|--------|
| Authentication | 1 | ✅ |
| Home | 1 | ✅ |
| Scan | 2 | ✅ |
| Encyclopedia | 2 | ✅ NEW |
| Plant Guide | 2 | ✅ NEW |
| Pesticide | 2 | ✅ NEW |
| Weather | 1 | ✅ NEW |
| Prediction | 1 | ✅ NEW |
| Farm | 1 | ✅ NEW |
| Other | 5 | ✅ |
| **Total** | **18** | |

---

## 🔗 Navigasi

### Dari HomeScreen
```
HomeScreen
├── ScanScreen → ScanResultScreen
├── ConsultationScreen
├── OutbreakMapScreen
├── CalendarScreen
├── HistoryScreen
├── EncyclopediaScreen → DiseaseDetailScreen
├── PlantGuideScreen → PlantDetailScreen
├── PesticideFinderScreen → PesticideDetailScreen
├── WeatherDashboardScreen
└── PredictionAlertScreen
```

### Cross-Navigation
- `DiseaseDetailScreen` → `PesticideDetailScreen` (rekomendasi treatment)
- `PredictionAlertScreen` → `DiseaseDetailScreen` (detail penyakit)
- `PlantDetailScreen` → `DiseaseDetailScreen` (penyakit umum)

---

*Dokumentasi terakhir diupdate: 21 Desember 2024*
