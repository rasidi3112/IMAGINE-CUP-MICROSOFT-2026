/// AgriVision NTB - Scan Result Screen
/// Layar hasil scan daun

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../models/scan_result.dart';
import '../../providers/app_provider.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/gamification_widgets.dart';
import '../../services/voice_output_service.dart';
import '../../services/pdf_export_service.dart';
import '../../services/gamification_service.dart';
import '../consultation/consultation_screen.dart';

class ScanResultScreen extends StatelessWidget {
  final ScanResult scanResult;

  const ScanResultScreen({super.key, required this.scanResult});

  Color _getSeverityColor() {
    switch (scanResult.severityLevel) {
      case SeverityLevel.healthy:
        return AppTheme.successGreen;
      case SeverityLevel.low:
        return AppTheme.severityLow;
      case SeverityLevel.medium:
        return AppTheme.severityMedium;
      case SeverityLevel.high:
        return AppTheme.severityHigh;
      case SeverityLevel.critical:
        return AppTheme.severityCritical;
    }
  }

  IconData _getSeverityIcon() {
    switch (scanResult.severityLevel) {
      case SeverityLevel.healthy:
        return Icons.check_circle;
      case SeverityLevel.low:
        return Icons.info;
      case SeverityLevel.medium:
        return Icons.warning;
      case SeverityLevel.high:
        return Icons.error;
      case SeverityLevel.critical:
        return Icons.dangerous;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isHealthy = scanResult.detectedDisease == null;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Image Header
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppTheme.primaryGreen,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(50),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Image
                  if (File(scanResult.imagePath).existsSync())
                    Image.file(File(scanResult.imagePath), fit: BoxFit.cover)
                  else
                    Container(
                      color: AppTheme.primaryGreen.withAlpha(50),
                      child: const Icon(
                        Icons.eco,
                        size: 100,
                        color: AppTheme.primaryGreen,
                      ),
                    ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withAlpha(150),
                        ],
                      ),
                    ),
                  ),
                  // Result badge
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: _getSeverityColor(),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getSeverityIcon(),
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isHealthy
                                    ? 'common.healthy'.tr()
                                    : scanResult.severityText,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        if (!scanResult.isSynced)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.warningOrange,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.cloud_off,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'profile.offline'.tr(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Disease Name or Healthy status
                  Text(
                    isHealthy
                        ? 'scan.healthy_plant'.tr()
                        : scanResult.detectedDisease!.nameIndonesia,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2),

                  if (!isHealthy) ...[
                    const SizedBox(height: 4),
                    Text(
                      scanResult.detectedDisease!.name,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Confidence & Severity
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          title: 'scan.confidence'.tr(),
                          value:
                              '${scanResult.confidenceScore.toStringAsFixed(1)}%',
                          icon: Icons.analytics,
                          color: AppTheme.infoBlue,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildInfoCard(
                          title: 'scan.severity'.tr(),
                          value:
                              '${scanResult.severityPercentage.toStringAsFixed(0)}%',
                          icon: Icons.speed,
                          color: _getSeverityColor(),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 200.ms, duration: 500.ms),

                  const SizedBox(height: 16),

                  // Plant Type & Location
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          title: 'history.sort_plant'.tr(),
                          value: scanResult.plantType,
                          icon: Icons.eco,
                          color: AppTheme.primaryGreen,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildInfoCard(
                          title: 'Lokasi', // TODO: Add key 'common.location'
                          value: scanResult.locationName ?? 'NTB',
                          icon: Icons.location_on,
                          color: AppTheme.warningOrange,
                          isSmallText: true,
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 300.ms, duration: 500.ms),

                  if (!isHealthy) ...[
                    const SizedBox(height: 32),

                    // Disease Description
                    _buildSection(
                      title: 'disease_section.about_disease'.tr(),
                      content: scanResult.detectedDisease!.description,
                    ).animate().fadeIn(delay: 400.ms, duration: 500.ms),

                    const SizedBox(height: 24),

                    // Symptoms
                    _buildSection(
                      title: 'disease.symptoms'.tr(),
                      content: scanResult.detectedDisease!.symptoms,
                    ).animate().fadeIn(delay: 500.ms, duration: 500.ms),

                    const SizedBox(height: 24),

                    // Causes
                    _buildSection(
                      title: 'disease.causes'.tr(),
                      content: scanResult.detectedDisease!.causes,
                    ).animate().fadeIn(delay: 600.ms, duration: 500.ms),

                    const SizedBox(height: 24),

                    // Affected Plants
                    if (scanResult.detectedDisease!.affectedPlants.isNotEmpty)
                      _buildAffectedPlants(
                        scanResult.detectedDisease!.affectedPlants,
                      ).animate().fadeIn(delay: 700.ms, duration: 500.ms),
                  ] else ...[
                    const SizedBox(height: 32),
                    // Healthy plant message
                    GlassCard(
                          margin: EdgeInsets.zero,
                          child: Column(
                            children: [
                              const Text('🎉', style: TextStyle(fontSize: 64)),
                              const SizedBox(height: 16),
                              Text(
                                'scan.congratulations'.tr(),
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.successGreen,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'scan.healthy_message'.tr().replaceAll(
                                  '{plant}',
                                  scanResult.plantType,
                                ),
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        )
                        .animate()
                        .fadeIn(delay: 400.ms, duration: 500.ms)
                        .scale(begin: const Offset(0.9, 0.9)),
                  ],

                  const SizedBox(height: 32),

                  // Voice Output Button for elderly farmers
                  Builder(
                    builder: (context) {
                      final voiceService = VoiceOutputService();

                      // Hide button if voice feature is disabled
                      if (!voiceService.isEnabled) {
                        return const SizedBox.shrink();
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: OutlinedButton.icon(
                          onPressed: () {
                            final diseaseName =
                                scanResult.detectedDisease?.nameIndonesia ??
                                'common.healthy'.tr();

                            // Initialize language first to be sure
                            voiceService.initialize().then((_) {
                              final message = isHealthy
                                  ? 'voice.scan_result_healthy'.tr(
                                      namedArgs: {
                                        'plant': scanResult.plantType,
                                      },
                                    )
                                  : 'voice.scan_result_disease'.tr(
                                      namedArgs: {
                                        'plant': scanResult.plantType,
                                        'disease': diseaseName,
                                        'severity': scanResult
                                            .severityPercentage
                                            .toStringAsFixed(0),
                                      },
                                    );
                              voiceService.speak(
                                message,
                                ignoreEnabledState: true,
                              );
                            });
                          },
                          icon: const Icon(Icons.volume_up, size: 24),
                          label: Text(
                            'voice.speak_button'.tr(),
                            style: const TextStyle(fontSize: 16),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            foregroundColor: AppTheme.primaryGreen,
                            backgroundColor: AppTheme.primaryGreen.withAlpha(
                              20,
                            ),
                            side: const BorderSide(
                              color: AppTheme.primaryGreen,
                              width: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ).animate().fadeIn(delay: 750.ms, duration: 500.ms);
                    },
                  ),

                  // Action Buttons
                  if (!isHealthy)
                    GradientButton(
                      text: 'consultation.title'.tr(),
                      icon: Icons.chat,
                      onPressed: () {
                        Provider.of<AppProvider>(
                          context,
                          listen: false,
                        ).setCurrentScanResult(scanResult);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ConsultationScreen(),
                          ),
                        );
                      },
                    ).animate().fadeIn(delay: 800.ms, duration: 500.ms),

                  const SizedBox(height: 16),

                  // Secondary actions
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            // Share result with image
                            final diseaseText =
                                scanResult.detectedDisease?.nameIndonesia ??
                                'Tidak terdeteksi';
                            final severityText =
                                '${(scanResult.severityPercentage * 100).toStringAsFixed(0)}%';
                            final shareText =
                                '''
🌿 Hasil Scan AgriVision NTB

📋 Penyakit: $diseaseText
📊 Tingkat Keparahan: $severityText
📅 Tanggal: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}

${scanResult.detectedDisease?.description ?? ''}

Download AgriVision NTB untuk deteksi penyakit tanaman dengan AI!
''';

                            // Copy to clipboard
                            await Clipboard.setData(
                              ClipboardData(text: shareText),
                            );
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    'Hasil scan disalin ke clipboard!',
                                  ),
                                  backgroundColor: AppTheme.primaryGreen,
                                  behavior: SnackBarBehavior.floating,
                                  action: SnackBarAction(
                                    label: 'OK',
                                    textColor: Colors.white,
                                    onPressed: () {},
                                  ),
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.share),
                          label: Text('common.share'.tr()),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            foregroundColor: AppTheme.primaryGreen,
                            side: const BorderSide(
                              color: AppTheme.primaryGreen,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Export PDF Button
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            // Show loading
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (ctx) => const Center(
                                child: CircularProgressIndicator(
                                  color: AppTheme.primaryGreen,
                                ),
                              ),
                            );

                            // Generate PDF
                            final pdfService = PdfExportService();
                            final langCode = context.locale.languageCode;
                            final pdfFile = await pdfService.generateScanReport(
                              scanResult,
                              languageCode: langCode,
                            );

                            // Close loading
                            if (context.mounted) Navigator.pop(context);

                            if (pdfFile != null && context.mounted) {
                              // Show options dialog
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                builder: (ctx) => Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(24),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 4,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius: BorderRadius.circular(
                                            2,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      const Icon(
                                        Icons.picture_as_pdf,
                                        size: 48,
                                        color: Colors.red,
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        'pdf.pdf_success'.tr(),
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade800,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'pdf.pdf_action'.tr(),
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ElevatedButton.icon(
                                              onPressed: () {
                                                Navigator.pop(ctx);
                                                pdfService.openPdf(pdfFile);
                                              },
                                              icon: const Icon(
                                                Icons.open_in_new,
                                              ),
                                              label: Text('pdf.open'.tr()),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppTheme.primaryGreen,
                                                foregroundColor: Colors.white,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 14,
                                                    ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: ElevatedButton.icon(
                                              onPressed: () async {
                                                Navigator.pop(ctx);
                                                pdfService.sharePdf(
                                                  pdfFile,
                                                  languageCode: langCode,
                                                );
                                                // Track share for gamification
                                                final gamificationService =
                                                    GamificationService();
                                                final newBadges =
                                                    await gamificationService
                                                        .recordShare();
                                                if (newBadges.isNotEmpty &&
                                                    context.mounted) {
                                                  for (final badge
                                                      in newBadges) {
                                                    BadgeUnlockedPopup.show(
                                                      context,
                                                      badge,
                                                    );
                                                  }
                                                }
                                              },
                                              icon: const Icon(Icons.share),
                                              label: Text('common.share'.tr()),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.blue,
                                                foregroundColor: Colors.white,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 14,
                                                    ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                    ],
                                  ),
                                ),
                              );
                            } else if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('pdf.pdf_failed'.tr()),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          icon: const Icon(
                            Icons.picture_as_pdf,
                            color: Colors.red,
                          ),
                          label: const Text('PDF'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Scan Again Button
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.camera_alt),
                          label: Text('common.scan_again'.tr()),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            foregroundColor: AppTheme.primaryGreen,
                            side: const BorderSide(
                              color: AppTheme.primaryGreen,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 900.ms, duration: 500.ms),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    bool isSmallText = false,
  }) {
    return GlassCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: isSmallText ? 14 : 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        GlassCard(
          margin: EdgeInsets.zero,
          child: Text(
            content,
            style: TextStyle(color: Colors.grey.shade700, height: 1.5),
          ),
        ),
      ],
    );
  }

  Widget _buildAffectedPlants(List<String> plants) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'disease_section.infected_plants'.tr(),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: plants
              .map(
                (plant) => StatusBadge(
                  text: plant,
                  color: AppTheme.primaryGreen,
                  icon: Icons.eco,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
