// AgriVision NTB - Plant Detail Screen
// Detail informasi tanaman

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../config/app_theme.dart';
import '../../models/plant.dart';
import '../../models/disease.dart';
import '../../services/content_service.dart';
import '../encyclopedia/disease_detail_screen.dart';

class PlantDetailScreen extends StatefulWidget {
  final Plant plant;

  const PlantDetailScreen({super.key, required this.plant});

  @override
  State<PlantDetailScreen> createState() => _PlantDetailScreenState();
}

class _PlantDetailScreenState extends State<PlantDetailScreen> {
  final ContentService _contentService = ContentService();
  String? _localizedDescription;
  String? _localizedName;
  String? _localizedLocalName;
  bool _isLoading = true;
  // Note: Localizing deeply nested objects like PlantingInfo and NutrientRequirement
  // would ideally require creating new object instances, but for simplicity we will
  // focus on the main description fields or map them dynamically in the UI if we parsed them.
  // For now, we'll localize the main description and names.

  @override
  void initState() {
    super.initState();
    _loadLocalizedContent();
  }

  Future<void> _loadLocalizedContent() async {
    final langCode = context.locale.languageCode;

    if (langCode == 'id') {
      setState(() {
        _localizedDescription = widget.plant.description;
        _localizedName = widget.plant.name;
        _localizedLocalName = widget.plant.localName;
        _isLoading = false;
      });
      return;
    }

    final content = await _contentService.getPlantContent(
      widget.plant.id,
      langCode,
    );

    if (mounted) {
      setState(() {
        _localizedDescription =
            content?['description'] ?? widget.plant.description;
        _localizedName = content?['name'] ?? widget.plant.name;
        _localizedLocalName = content?['local_name'] ?? widget.plant.localName;
        _isLoading = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadLocalizedContent();
  }

  Plant get plant => widget.plant;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: _getCategoryColor(),
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
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _getCategoryColor(),
                      _getCategoryColor().withOpacity(0.8),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 50, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Text(
                              plant.iconEmoji,
                              style: const TextStyle(fontSize: 56),
                            ).animate().scale(delay: 200.ms),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _localizedName ?? plant.name,
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    _localizedLocalName ?? plant.localName,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    plant.scientificName,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white.withOpacity(0.8),
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Quick Stats
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                children: [
                  _buildQuickStat(
                    '⏱️',
                    '${plant.growthDurationDays}',
                    'plant_section.days'.tr(),
                  ),
                  _buildDivider(),
                  _buildQuickStat(
                    '🌡️',
                    plant.plantingInfo.altitude.split(' ')[0],
                    'plant_section.altitude'.tr(),
                  ),
                  _buildDivider(),
                  _buildQuickStat(
                    '💧',
                    plant.plantingInfo.waterRequirement.split(' ')[0],
                    'plant_section.water'.tr(),
                  ),
                  _buildDivider(),
                  _buildQuickStat(
                    '🦠',
                    '${plant.commonDiseases.length}',
                    'plant_section.common_diseases'.tr(),
                  ),
                ],
              ),
            ).animate().fadeIn().slideY(begin: 0.1, end: 0),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description
                  _buildCard(
                    title: 'plant_section.about'.tr(),
                    icon: Icons.info_outline,
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Text(
                            _localizedDescription ?? plant.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                              height: 1.6,
                            ),
                          ),
                  ),

                  const SizedBox(height: 16),

                  // Growth Stages
                  _buildCard(
                    title: 'plant_section.growth_phases'.tr(),
                    icon: Icons.timeline,
                    child: Column(
                      children: plant.growthStages.asMap().entries.map((entry) {
                        final index = entry.key;
                        final stage = entry.value;
                        final isLast = index == plant.growthStages.length - 1;

                        return _GrowthStageItem(
                          stage: stage,
                          index: index,
                          isLast: isLast,
                          color: _getCategoryColor(),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Planting Info
                  _buildCard(
                    title: 'plant_section.planting_info'.tr(),
                    icon: Icons.agriculture,
                    child: Column(
                      children: [
                        _buildInfoRow(
                          '📅 Waktu Tanam',
                          plant.plantingInfo.bestPlantingMonths.join(', '),
                        ),
                        _buildInfoRow(
                          '📏 Jarak Tanam',
                          plant.plantingInfo.plantSpacing,
                        ),
                        _buildInfoRow(
                          '🌱 Benih/Ha',
                          '${plant.plantingInfo.seedPerHectare} kg',
                        ),
                        _buildInfoRow(
                          '🌍 Jenis Tanah',
                          plant.plantingInfo.soilType,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Nutrient Requirements
                  _buildCard(
                    title: 'plant_section.fertilizer_needs'.tr(),
                    icon: Icons.science,
                    child: Column(
                      children: [
                        _buildNutrientBar(
                          'N (Nitrogen)',
                          plant.nutrientRequirement.nitrogen,
                          Colors.blue,
                        ),
                        _buildNutrientBar(
                          'P (Fosfor)',
                          plant.nutrientRequirement.phosphorus,
                          Colors.orange,
                        ),
                        _buildNutrientBar(
                          'K (Kalium)',
                          plant.nutrientRequirement.potassium,
                          Colors.purple,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              const Text('🌿', style: TextStyle(fontSize: 20)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  plant.nutrientRequirement.organicMatter,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.green[800],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Common Diseases
                  _buildCard(
                    title: 'plant_section.common_diseases'.tr(),
                    icon: Icons.bug_report,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: plant.commonDiseases.take(5).map((diseaseId) {
                        final disease = Disease.getById(diseaseId);
                        if (disease == null) return const SizedBox();

                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  DiseaseDetailScreen(disease: disease),
                            ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red[50],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.red[200]!),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  '🦠',
                                  style: TextStyle(fontSize: 14),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  disease.nameIndonesia,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.red[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Best Regions
                  _buildCard(
                    title: 'plant_section.best_locations_ntb'.tr(),
                    icon: Icons.location_on,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: plant.bestRegionsNTB.map((region) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: _getCategoryColor().withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('📍', style: TextStyle(fontSize: 14)),
                              const SizedBox(width: 6),
                              Text(
                                region,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: _getCategoryColor(),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(String emoji, String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(height: 40, width: 1, color: Colors.grey[200]);
  }

  Widget _buildCard({
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
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: _getCategoryColor(), size: 20),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientBar(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              ),
              Text(
                value.split(' ')[0],
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: _getNutrientLevel(value),
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _getNutrientLevel(String value) {
    final lower = value.toLowerCase();
    if (lower.contains('sangat tinggi')) return 1.0;
    if (lower.contains('tinggi')) return 0.8;
    if (lower.contains('sedang')) return 0.6;
    if (lower.contains('rendah')) return 0.3;
    return 0.5;
  }

  Color _getCategoryColor() {
    switch (plant.category) {
      case 'pangan':
        return const Color(0xFFFF9800);
      case 'hortikultura':
        return AppTheme.primaryGreen;
      default:
        return Colors.blue;
    }
  }
}

class _GrowthStageItem extends StatelessWidget {
  final GrowthStage stage;
  final int index;
  final bool isLast;
  final Color color;

  const _GrowthStageItem({
    required this.stage,
    required this.index,
    required this.isLast,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 2),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: color.withOpacity(0.3),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),

          // Content
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: isLast ? 0 : 16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        stage.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${stage.durationDays} hari',
                          style: TextStyle(
                            fontSize: 11,
                            color: color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    stage.description,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.tips_and_updates,
                        size: 14,
                        color: Colors.amber[700],
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          stage.careInstructions,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.amber[800],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
