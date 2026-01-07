from fastapi import FastAPI, File, UploadFile
from fastapi.middleware.cors import CORSMiddleware
import cv2
import numpy as np
import io
# from PIL import Image # Optional if needed

app = FastAPI(title="AgriVision Severity Analyzer")

# Allow CORS for mobile app connectivity
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
def read_root():
    return {"status": "AgriVision AI Service Running", "version": "1.0.0"}

@app.post("/analyze-severity")
async def analyze_severity(file: UploadFile = File(...)):
    """
    Endpoint ini menerima gambar daun dan menghitung persentase
    area yang terinfeksi penyakit menggunakan analisis warna HSV.
    """
    try:
        # 1. Read Image
        contents = await file.read()
        nparr = np.frombuffer(contents, np.uint8)
        img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)

        if img is None:
            return {"error": "Invalid image format"}

        # 2. Preprocessing (Resize for speed)
        img = cv2.resize(img, (500, 500))
        
        # 3. Convert to HSV Color Space (Better for color segmentation)
        hsv = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)

        # 4. Define Green Color Range (Healthy Leaf)
        # Range hijau dalam HSV OpenCV (H: 0-179, S: 0-255, V: 0-255)
        # H=35-85 adalah rentang hijau umum
        lower_green = np.array([30, 40, 40])
        upper_green = np.array([90, 255, 255])

        # 5. Define Brown/Yellow Color Range (Diseased Area)
        # Kuning/Coklat biasanya di H < 30 atau H > 15 (arah merah/oranye)
        lower_yellow = np.array([10, 40, 40])
        upper_yellow = np.array([30, 255, 255])

        # 6. Create Masks
        mask_green = cv2.inRange(hsv, lower_green, upper_green)
        mask_yellow = cv2.inRange(hsv, lower_yellow, upper_yellow)

        # 7. Calculate Pixels
        green_pixels = cv2.countNonZero(mask_green)
        yellow_pixels = cv2.countNonZero(mask_yellow)
        
        # Asumsi: Leaf Area = Green + Yellow
        leaf_area = green_pixels + yellow_pixels

        if leaf_area == 0:
            return {
                "severity_percentage": 0,
                "severity_level": "Unknown",
                "message": "No leaf detected"
            }

        # 8. Calculate Severity
        severity_ratio = (yellow_pixels / leaf_area) * 100
        
        # Determine Level
        level = "Healthy"
        if severity_ratio > 50:
            level = "Critical"
        elif severity_ratio > 20:
            level = "High"
        elif severity_ratio > 5:
            level = "Moderate"
        elif severity_ratio > 0:
            level = "Low"

        return {
            "severity_percentage": round(severity_ratio, 2),
            "severity_level": level,
            "details": {
                "green_pixels": int(green_pixels),
                "diseased_pixels": int(yellow_pixels),
                "total_leaf_pixels": int(leaf_area)
            },
            "method": "HSV Color Segmentation Algorithm"
        }

    except Exception as e:
        return {"error": str(e)}
