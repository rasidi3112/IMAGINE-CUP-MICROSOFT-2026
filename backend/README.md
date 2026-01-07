# 🐍 AgriVision Backend API

Backend service untuk analisis tingkat keparahan penyakit tanaman menggunakan Computer Vision.

## Tech Stack
- **Framework:** FastAPI
- **Image Processing:** OpenCV, NumPy
- **Language:** Python 3.9+

## Instalasi

```bash
# 1. Masuk ke folder backend
cd backend

# 2. Buat virtual environment
python -m venv venv

# 3. Aktifkan virtual environment
# Windows:
venv\Scripts\activate
# macOS/Linux:
source venv/bin/activate

# 4. Install dependencies
pip install -r requirements.txt
```

## Menjalankan Server

```bash
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

Server akan berjalan di: `http://localhost:8000`

## API Endpoints

### `GET /`
Health check endpoint.

**Response:**
```json
{
  "status": "AgriVision AI Service Running",
  "version": "1.0.0"
}
```

### `POST /analyze-severity`
Menganalisis gambar daun untuk menghitung tingkat keparahan penyakit.

**Request:**
- Method: `POST`
- Content-Type: `multipart/form-data`
- Body: `file` (image file)

**Response:**
```json
{
  "severity_percentage": 35.2,
  "severity_level": "High",
  "details": {
    "green_pixels": 162400,
    "diseased_pixels": 87600,
    "total_leaf_pixels": 250000
  },
  "method": "HSV Color Segmentation Algorithm"
}
```

## Algoritma

Backend ini menggunakan **HSV Color Segmentation** untuk:
1. Mengidentifikasi area daun yang sehat (warna hijau)
2. Mengidentifikasi area daun yang sakit (warna kuning/coklat)
3. Menghitung rasio area sakit terhadap total area daun

## Integrasi dengan Frontend Flutter

Untuk memanggil API ini dari Flutter, gunakan endpoint:
```dart
final response = await http.post(
  Uri.parse('http://YOUR_SERVER_IP:8000/analyze-severity'),
  headers: {'Content-Type': 'multipart/form-data'},
  body: imageFile,
);
```

## License
MIT License - AgriVision NTB Team
