// AgriVision NTB - Disease Detail Screen
// Detail penyakit tanaman

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../config/app_theme.dart';
import '../../models/disease.dart';
import '../../models/pesticide.dart';
import '../../services/content_service.dart';
import '../pesticide/pesticide_detail_screen.dart';

class DiseaseDetailScreen extends StatefulWidget {
  final Disease disease;

  const DiseaseDetailScreen({super.key, required this.disease});

  @override
  State<DiseaseDetailScreen> createState() => _DiseaseDetailScreenState();
}

class _DiseaseDetailScreenState extends State<DiseaseDetailScreen> {
  final ContentService _contentService = ContentService();
  String? _localizedDescription;
  String? _localizedSymptoms;
  String? _localizedCauses;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Don't call _loadLocalizedContent here - context is not ready yet
    // It will be called in didChangeDependencies()
  }

  Future<void> _loadLocalizedContent() async {
    final langCode = context.locale.languageCode;

    // Untuk bahasa Indonesia, gunakan data default
    if (langCode == 'id') {
      setState(() {
        _localizedDescription = widget.disease.description;
        _localizedSymptoms = widget.disease.symptoms;
        _localizedCauses = widget.disease.causes;
        _isLoading = false;
      });
      return;
    }

    // Untuk bahasa lain, ambil dari content service
    final content = await _contentService.getDiseaseContent(
      widget.disease.id,
      langCode,
    );

    if (mounted) {
      setState(() {
        _localizedDescription =
            content?['description'] ?? widget.disease.description;
        _localizedSymptoms = content?['symptoms'] ?? widget.disease.symptoms;
        _localizedCauses = content?['causes'] ?? widget.disease.causes;
        _isLoading = false;
      });
    }
  }

  bool _didLoadContent = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Load content when dependencies are ready (and on language change)
    if (!_didLoadContent) {
      _didLoadContent = true;
      _loadLocalizedContent();
    }
  }

  Disease get disease => widget.disease;

  @override
  Widget build(BuildContext context) {
    final treatments = Pesticide.getByDisease(disease.id);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: _getSeverityColor(),
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      _getSeverityColor(),
                      _getSeverityColor().withOpacity(0.85),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            _getDiseaseIcon(),
                            size: 36,
                            color: Colors.white,
                          ),
                        ).animate().scale(delay: 200.ms),
                        const SizedBox(height: 12),
                        Flexible(
                          child: Text(
                            disease.nameIndonesia,
                            style: TextStyle(
                              fontSize: disease.nameIndonesia.length > 25
                                  ? 22
                                  : 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          disease.name,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                            fontStyle: FontStyle.italic,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
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
                  // Deskripsi
                  _buildSection(
                    title: 'disease_section.about_disease'.tr(),
                    icon: Icons.info_outline,
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Text(
                            _localizedDescription ?? disease.description,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[700],
                              height: 1.6,
                            ),
                          ),
                  ),

                  const SizedBox(height: 20),

                  // Gejala
                  _buildSection(
                    title: 'disease_section.symptoms'.tr(),
                    icon: Icons.visibility_outlined,
                    child: _buildBulletPoints(
                      (_localizedSymptoms ?? disease.symptoms).split(', '),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Penyebab
                  _buildSection(
                    title: 'disease_section.causes'.tr(),
                    icon: Icons.science_outlined,
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.amber[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.amber[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.biotech,
                            size: 24,
                            color: Colors.amber[700],
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _localizedCauses ?? disease.causes,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.amber[900],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Tanaman yang terinfeksi
                  _buildSection(
                    title: 'disease_section.infected_plants'.tr(),
                    icon: Icons.eco_outlined,
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: disease.affectedPlants.map((plant) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryGreen.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.primaryGreen.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.grass,
                                size: 18,
                                color: AppTheme.primaryGreen,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                plant,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.primaryGreen,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  if (treatments.isNotEmpty) ...[
                    const SizedBox(height: 24),

                    // Rekomendasi Pengobatan
                    Row(
                      children: [
                        Icon(
                          Icons.medical_services_outlined,
                          color: AppTheme.primaryGreen,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'disease_detail.recommended_treatment'.tr(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    ...treatments
                        .take(4)
                        .map(
                          (pesticide) => _PesticideCard(
                            pesticide: pesticide,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    PesticideDetailScreen(pesticide: pesticide),
                              ),
                            ),
                          ),
                        ),
                  ],

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom Action
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton.icon(
            onPressed: () {
              // Navigate to consultation with this disease context
              Navigator.pop(context);
            },
            icon: const Icon(Icons.chat_bubble_outline),
            label: Text('common.consult_ai'.tr()),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.grey[600], size: 20),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05, end: 0);
  }

  Widget _buildBulletPoints(List<String> points) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: points.map((point) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 7),
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _getSeverityColor(),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  point.trim(),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Color _getSeverityColor() {
    final name = disease.name.toLowerCase();
    if (name.contains('wilt') ||
        name.contains('virus') ||
        name.contains('tungro')) {
      return const Color(0xFFE53935);
    } else if (name.contains('blight') || name.contains('rot')) {
      return const Color(0xFFFF7043);
    } else if (name.contains('spot') || name.contains('rust')) {
      return const Color(0xFFFFB300);
    }
    return AppTheme.primaryGreen;
  }

  IconData _getDiseaseIcon() {
    final name = disease.name.toLowerCase();
    if (name.contains('blast') || name.contains('blight'))
      return Icons.local_fire_department;
    if (name.contains('rust')) return Icons.blur_on;
    if (name.contains('virus') || name.contains('mosaic'))
      return Icons.coronavirus;
    if (name.contains('wilt')) return Icons.trending_down;
    if (name.contains('rot')) return Icons.warning_amber;
    if (name.contains('mildew')) return Icons.cloud;
    if (name.contains('spot')) return Icons.lens_blur;
    return Icons.bug_report;
  }
}

class _PesticideCard extends StatelessWidget {
  final Pesticide pesticide;
  final VoidCallback onTap;

  const _PesticideCard({required this.pesticide, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _getTypeColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      pesticide.typeEmoji,
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pesticide.brandName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        pesticide.activeIngredient,
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getTypeColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        pesticide.category,
                        style: TextStyle(
                          fontSize: 11,
                          color: _getTypeColor(),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pesticide.priceRange,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getTypeColor() {
    switch (pesticide.category) {
      case 'kimia':
        return Colors.blue[600]!;
      case 'hayati':
        return Colors.green[600]!;
      case 'organik':
        return Colors.orange[600]!;
      default:
        return Colors.grey[600]!;
    }
  }
}
