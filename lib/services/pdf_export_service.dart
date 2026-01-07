/// AgriVision NTB - PDF Export Service
/// Generate professional PDF reports for scan results
///
/// Features:
/// - Scan result report with disease details
/// - Treatment recommendations
/// - Professional formatting with AgriVision branding

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:barcode/barcode.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:open_filex/open_filex.dart';
import '../models/scan_result.dart';
import '../utils/helpers.dart';

class PdfExportService {
  static final PdfExportService _instance = PdfExportService._internal();
  factory PdfExportService() => _instance;
  PdfExportService._internal();

  /// Generate PDF report for a scan result
  Future<File?> generateScanReport(
    ScanResult result, {
    String languageCode = 'id',
  }) async {
    try {
      final pdf = pw.Document();

      // Get translations based on language
      final translations = _getTranslations(languageCode);

      // Format date - use safe locale for local languages
      final safeDateLocale = getSafeDateLocaleFromCode(languageCode);
      final dateFormatter = DateFormat('dd MMMM yyyy, HH:mm', safeDateLocale);
      final formattedDate = dateFormatter.format(result.scanDate);

      // Load app logo from assets
      pw.MemoryImage? logoImage;
      try {
        final ByteData logoData = await rootBundle.load(
          'assets/images/app_icon.png',
        );
        logoImage = pw.MemoryImage(logoData.buffer.asUint8List());
      } catch (e) {
        // Logo loading failed, will use text fallback
        logoImage = null;
      }

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          header: (context) => _buildHeader(translations, logoImage),
          footer: (context) => _buildFooter(context, translations),
          build: (context) => [
            _buildTitle(result, translations),
            pw.SizedBox(height: 20),
            _buildScanInfo(result, formattedDate, translations),
            pw.SizedBox(height: 20),
            _buildDiseaseDetails(result, translations),
            pw.SizedBox(height: 20),
            if (result.detectedDisease != null) ...[
              _buildSymptoms(result, translations),
              pw.SizedBox(height: 20),
              _buildCauses(result, translations),
              pw.SizedBox(height: 20),
              _buildTreatmentRecommendations(result, translations),
            ],
            pw.SizedBox(height: 30),
            _buildDisclaimer(translations),
            pw.SizedBox(height: 30),
            _buildQRCodeSection(result, translations),
          ],
        ),
      );

      // Save to file
      final outputDir = await getApplicationDocumentsDirectory();
      final fileName =
          'AgriVision_Report_${result.id.substring(0, 8)}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File('${outputDir.path}/$fileName');
      await file.writeAsBytes(await pdf.save());

      return file;
    } catch (e) {
      print('PdfExportService: Error generating PDF - $e');
      return null;
    }
  }

  /// Share PDF via system share dialog
  Future<void> sharePdf(File pdfFile, {String languageCode = 'id'}) async {
    final translations = _getTranslations(languageCode);
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(pdfFile.path)],
        text: translations['shareText'],
        subject: translations['shareSubject'],
      ),
    );
  }

  /// Open PDF with default viewer
  Future<void> openPdf(File pdfFile) async {
    await OpenFilex.open(pdfFile.path);
  }

  // ============ PDF COMPONENTS ============

  pw.Widget _buildHeader(Map<String, String> t, pw.MemoryImage? logoImage) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 10),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: PdfColors.green800, width: 2),
        ),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'AgriVision NTB',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.green800,
                ),
              ),
              pw.Text(
                t['tagline']!,
                style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
              ),
            ],
          ),
          // App Logo
          logoImage != null
              ? pw.Container(width: 50, height: 50, child: pw.Image(logoImage))
              : pw.Container(
                  padding: const pw.EdgeInsets.all(8),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.green50,
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Text(
                    'AV',
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.green800,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  pw.Widget _buildFooter(pw.Context context, Map<String, String> t) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(top: 10),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          top: pw.BorderSide(color: PdfColors.grey300, width: 1),
        ),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            '© ${DateTime.now().year} AgriVision NTB - IMAGE CUP Microsoft 2025',
            style: pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
          ),
          pw.Text(
            '${t['page']} ${context.pageNumber} ${t['of']} ${context.pagesCount}',
            style: pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildTitle(ScanResult result, Map<String, String> t) {
    final isHealthy = result.severityLevel == SeverityLevel.healthy;
    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        color: isHealthy ? PdfColors.green50 : PdfColors.red50,
        borderRadius: pw.BorderRadius.circular(12),
        border: pw.Border.all(
          color: isHealthy ? PdfColors.green200 : PdfColors.red200,
          width: 1,
        ),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            t['reportTitle']!,
            style: pw.TextStyle(
              fontSize: 20,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.grey800,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            children: [
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: pw.BoxDecoration(
                  color: isHealthy
                      ? PdfColors.green600
                      : _getSeverityColor(result.severityLevel),
                  borderRadius: pw.BorderRadius.circular(20),
                ),
                child: pw.Text(
                  isHealthy
                      ? t['healthy']!
                      : result.detectedDisease?.nameIndonesia ??
                            t['diseaseDetected']!,
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              pw.SizedBox(width: 10),
              pw.Text(
                '${t['confidence']}: ${(result.confidenceScore * 100).toStringAsFixed(1)}%',
                style: pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildScanInfo(
    ScanResult result,
    String formattedDate,
    Map<String, String> t,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            t['scanInfo']!,
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.grey800,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Table(
            columnWidths: {
              0: const pw.FlexColumnWidth(1),
              1: const pw.FlexColumnWidth(2),
            },
            children: [
              _buildTableRow(t['scanDate']!, formattedDate),
              _buildTableRow(t['plantType']!, result.plantType),
              _buildTableRow(
                t['location']!,
                result.locationName ??
                    '${result.latitude.toStringAsFixed(4)}, ${result.longitude.toStringAsFixed(4)}',
              ),
              _buildTableRow(
                t['severity']!,
                '${result.severityText} (${result.severityPercentage.toStringAsFixed(1)}%)',
              ),
              _buildTableRow(
                t['scanId']!,
                result.id.substring(0, 8).toUpperCase(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.TableRow _buildTableRow(String label, String value) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 4),
          child: pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.grey700,
            ),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 4),
          child: pw.Text(
            value,
            style: pw.TextStyle(fontSize: 10, color: PdfColors.grey800),
          ),
        ),
      ],
    );
  }

  pw.Widget _buildDiseaseDetails(ScanResult result, Map<String, String> t) {
    if (result.detectedDisease == null) {
      return pw.Container(
        padding: const pw.EdgeInsets.all(15),
        decoration: pw.BoxDecoration(
          color: PdfColors.green50,
          borderRadius: pw.BorderRadius.circular(8),
          border: pw.Border.all(color: PdfColors.green200),
        ),
        child: pw.Text(
          t['healthyMessage']!,
          style: pw.TextStyle(fontSize: 12, color: PdfColors.green800),
        ),
      );
    }

    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        borderRadius: pw.BorderRadius.circular(8),
        border: pw.Border.all(color: PdfColors.grey300),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            t['diseaseDetails']!,
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.grey800,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            result.detectedDisease!.nameIndonesia,
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.red800,
            ),
          ),
          pw.Text(
            result.detectedDisease!.name,
            style: pw.TextStyle(
              fontSize: 10,
              fontStyle: pw.FontStyle.italic,
              color: PdfColors.grey600,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            result.detectedDisease!.description,
            style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
            textAlign: pw.TextAlign.justify,
          ),
        ],
      ),
    );
  }

  pw.Widget _buildSymptoms(ScanResult result, Map<String, String> t) {
    if (result.detectedDisease == null) return pw.SizedBox();

    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: PdfColors.orange50,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            t['symptoms']!,
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.orange800,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            result.detectedDisease!.symptoms,
            style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildCauses(ScanResult result, Map<String, String> t) {
    if (result.detectedDisease == null) return pw.SizedBox();

    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue50,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            t['causes']!,
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue800,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            result.detectedDisease!.causes,
            style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildTreatmentRecommendations(
    ScanResult result,
    Map<String, String> t,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: PdfColors.green50,
        borderRadius: pw.BorderRadius.circular(8),
        border: pw.Border.all(color: PdfColors.green200),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            t['treatmentRecommendations']!,
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.green800,
            ),
          ),
          pw.SizedBox(height: 10),
          if (result.recommendedTreatments != null &&
              result.recommendedTreatments!.isNotEmpty)
            ...result.recommendedTreatments!.map(
              (treatment) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 8),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(
                      width: 6,
                      height: 6,
                      margin: const pw.EdgeInsets.only(top: 4, right: 8),
                      decoration: const pw.BoxDecoration(
                        color: PdfColors.green600,
                        shape: pw.BoxShape.circle,
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            treatment.name,
                            style: pw.TextStyle(
                              fontSize: 11,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.grey800,
                            ),
                          ),
                          pw.Text(
                            '${t['dosage']}: ${treatment.dosage}',
                            style: pw.TextStyle(
                              fontSize: 9,
                              color: PdfColors.grey600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            pw.Text(
              t['consultExpert']!,
              style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
            ),
        ],
      ),
    );
  }

  pw.Widget _buildDisclaimer(Map<String, String> t) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColors.amber50,
        borderRadius: pw.BorderRadius.circular(8),
        border: pw.Border.all(color: PdfColors.amber200),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('⚠️ ', style: pw.TextStyle(fontSize: 14)),
          pw.Expanded(
            child: pw.Text(
              t['disclaimer']!,
              style: pw.TextStyle(fontSize: 8, color: PdfColors.amber900),
            ),
          ),
        ],
      ),
    );
  }

  /// Build QR Code section for report verification
  pw.Widget _buildQRCodeSection(ScanResult result, Map<String, String> t) {
    // Generate unique verification code
    final verificationCode =
        'AGRI-${result.id.substring(0, 8).toUpperCase()}-${result.scanDate.millisecondsSinceEpoch.toString().substring(7)}';

    // QR data contains scan info for verification
    final qrData =
        '''
AgriVision NTB Report
ID: ${result.id}
Date: ${result.scanDate.toIso8601String()}
Plant: ${result.plantType}
Status: ${result.severityLevel.name}
Confidence: ${(result.confidenceScore * 100).toStringAsFixed(1)}%
Verify: $verificationCode
''';

    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(12),
        border: pw.Border.all(color: PdfColors.grey300),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // QR Code
          pw.Container(
            width: 100,
            height: 100,
            child: pw.BarcodeWidget(
              barcode: Barcode.qrCode(
                errorCorrectLevel: BarcodeQRCorrectionLevel.medium,
              ),
              data: qrData,
              color: PdfColors.grey800,
            ),
          ),
          pw.SizedBox(width: 20),
          // Verification Info
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  t['verificationTitle']!,
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.grey800,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  t['verificationDesc']!,
                  style: pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
                ),
                pw.SizedBox(height: 12),
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.green50,
                    borderRadius: pw.BorderRadius.circular(6),
                    border: pw.Border.all(color: PdfColors.green200),
                  ),
                  child: pw.Text(
                    verificationCode,
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.green800,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  '${t['reportGenerated']!} ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
                  style: pw.TextStyle(
                    fontSize: 8,
                    color: PdfColors.grey500,
                    fontStyle: pw.FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PdfColor _getSeverityColor(SeverityLevel level) {
    switch (level) {
      case SeverityLevel.healthy:
        return PdfColors.green600;
      case SeverityLevel.low:
        return PdfColors.yellow700;
      case SeverityLevel.medium:
        return PdfColors.orange600;
      case SeverityLevel.high:
        return PdfColors.red600;
      case SeverityLevel.critical:
        return PdfColors.red900;
    }
  }

  Map<String, String> _getTranslations(String langCode) {
    switch (langCode) {
      case 'en':
        return {
          'tagline': 'Smart Farmers, Healthy Agriculture',
          'reportTitle': 'Plant Disease Scan Report',
          'healthy': 'Healthy',
          'diseaseDetected': 'Disease Detected',
          'confidence': 'Confidence',
          'scanInfo': 'Scan Information',
          'scanDate': 'Scan Date',
          'plantType': 'Plant Type',
          'location': 'Location',
          'severity': 'Severity',
          'scanId': 'Scan ID',
          'diseaseDetails': 'Disease Details',
          'healthyMessage':
              'Great news! Your plant is healthy. Continue with proper care and maintenance.',
          'symptoms': 'Symptoms',
          'causes': 'Causes',
          'treatmentRecommendations': 'Treatment Recommendations',
          'dosage': 'Dosage',
          'consultExpert':
              'Please consult with a local agricultural expert for specific treatment recommendations.',
          'disclaimer':
              'DISCLAIMER: This report is generated by AI analysis and should be used as a reference only. For accurate diagnosis, please consult with agricultural experts or local extension officers.',
          'page': 'Page',
          'of': 'of',
          'shareText': 'Scan report from AgriVision NTB',
          'shareSubject': 'AgriVision NTB - Plant Disease Report',
          'verificationTitle': 'Report Verification',
          'verificationDesc':
              'Scan this QR code to verify the authenticity of this report. Each report has a unique verification code.',
          'reportGenerated': 'Report generated:',
        };
      case 'sas':
        return {
          'tagline': 'Petani Pinter, Pertanian Sehat',
          'reportTitle': 'Laporan Scan Penyakit Taneman',
          'healthy': 'Sehat',
          'diseaseDetected': 'Penyakit Tedaitan',
          'confidence': 'Keyakinan',
          'scanInfo': 'Informasi Scan',
          'scanDate': 'Tanggal Scan',
          'plantType': 'Jenis Taneman',
          'location': 'Lokasi',
          'severity': 'Keparahan',
          'scanId': 'ID Scan',
          'diseaseDetails': 'Detail Penyakit',
          'healthyMessage':
              'Berita bagus! Taneman side sehat. Terusang perawatan dengan baik.',
          'symptoms': 'Gejala',
          'causes': 'Penyebab',
          'treatmentRecommendations': 'Rekomendasi Pengobatan',
          'dosage': 'Dosis',
          'consultExpert': 'Silakan konsultasi dengan ahli pertanian lokal.',
          'disclaimer':
              'PERINGATAN: Laporan ini dihasilkan oleh analisis AI dan harus digunakan sebagai referensi saja.',
          'page': 'Halaman',
          'of': 'dari',
          'shareText': 'Laporan scan dari AgriVision NTB',
          'shareSubject': 'AgriVision NTB - Laporan Penyakit Taneman',
          'verificationTitle': 'Verifikasi Laporan',
          'verificationDesc':
              'Scan kode QR ini untuk verifikasi keaslian laporan. Setiap laporan memiliki kode verifikasi unik.',
          'reportGenerated': 'Laporan dibuat:',
        };
      default: // Indonesian
        return {
          'tagline': 'Petani Cerdas, Pertanian Sehat',
          'reportTitle': 'Laporan Scan Penyakit Tanaman',
          'healthy': 'Sehat',
          'diseaseDetected': 'Penyakit Terdeteksi',
          'confidence': 'Keyakinan',
          'scanInfo': 'Informasi Scan',
          'scanDate': 'Tanggal Scan',
          'plantType': 'Jenis Tanaman',
          'location': 'Lokasi',
          'severity': 'Keparahan',
          'scanId': 'ID Scan',
          'diseaseDetails': 'Detail Penyakit',
          'healthyMessage':
              'Berita bagus! Tanaman Anda dalam kondisi sehat. Lanjutkan perawatan dengan baik.',
          'symptoms': 'Gejala',
          'causes': 'Penyebab',
          'treatmentRecommendations': 'Rekomendasi Pengobatan',
          'dosage': 'Dosis',
          'consultExpert':
              'Silakan konsultasi dengan ahli pertanian lokal untuk rekomendasi pengobatan spesifik.',
          'disclaimer':
              'PERINGATAN: Laporan ini dihasilkan oleh analisis AI dan sebaiknya digunakan sebagai referensi saja. Untuk diagnosis akurat, silakan konsultasikan dengan ahli pertanian atau petugas penyuluh setempat.',
          'page': 'Halaman',
          'of': 'dari',
          'shareText': 'Laporan scan dari AgriVision NTB',
          'shareSubject': 'AgriVision NTB - Laporan Penyakit Tanaman',
          'verificationTitle': 'Verifikasi Laporan',
          'verificationDesc':
              'Scan kode QR ini untuk memverifikasi keaslian laporan. Setiap laporan memiliki kode verifikasi unik.',
          'reportGenerated': 'Laporan dibuat:',
        };
    }
  }
}
