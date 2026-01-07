// AgriVision NTB - Pesticide Detail Screen
// Detail pestisida/obat pertanian

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../models/pesticide.dart';
import '../../models/disease.dart';
import '../../models/agro_shop.dart';
import '../../services/content_service.dart';

class PesticideDetailScreen extends StatefulWidget {
  final Pesticide pesticide;

  const PesticideDetailScreen({super.key, required this.pesticide});

  @override
  State<PesticideDetailScreen> createState() => _PesticideDetailScreenState();
}

class _PesticideDetailScreenState extends State<PesticideDetailScreen> {
  final ContentService _contentService = ContentService();
  String? _localizedDescription;
  String? _localizedApplicationMethod;
  String? _localizedDosage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Don't call _loadLocalizedContent here - context is not ready yet
  }

  Future<void> _loadLocalizedContent() async {
    final langCode = context.locale.languageCode;

    // Untuk bahasa Indonesia, gunakan data default
    if (langCode == 'id') {
      setState(() {
        _localizedDescription = widget.pesticide.description;
        _localizedApplicationMethod = widget.pesticide.applicationMethod;
        _localizedDosage = widget.pesticide.dosage;
        _isLoading = false;
      });
      return;
    }

    // Untuk bahasa lain, ambil dari content service
    final content = await _contentService.getPesticideContent(
      widget.pesticide.id,
      langCode,
    );

    if (mounted) {
      setState(() {
        _localizedDescription =
            content?['description'] ?? widget.pesticide.description;
        _localizedApplicationMethod =
            content?['application_method'] ??
            widget.pesticide.applicationMethod;
        _localizedDosage = content?['dosage'] ?? widget.pesticide.dosage;
        _isLoading = false;
      });
    }
  }

  bool _didLoadContent = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didLoadContent) {
      _didLoadContent = true;
      _loadLocalizedContent();
    }
  }

  Pesticide get pesticide => widget.pesticide;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          // Header - Simplified to prevent overflow
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            backgroundColor: _getTypeColor(),
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(50),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [_getTypeColor(), _getTypeColor().withAlpha(220)],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 50, 24, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pesticide.typeEmoji,
                              style: const TextStyle(fontSize: 40),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withAlpha(50),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      pesticide.category.toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    pesticide.brandName,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
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

          // Price Card
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Harga di Toko NTB',
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        pesticide.priceRange,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: _getTypeColor(),
                        ),
                      ),
                      Text(
                        'per ${pesticide.packaging}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () => _showNearbyShops(context),
                    icon: const Icon(Icons.store, size: 18),
                    label: Text('common.find_store'.tr()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getTypeColor(),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
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
                children: [
                  // Description
                  _buildCard(
                    title: 'pesticide_section.description'.tr(),
                    icon: Icons.info_outline,
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Text(
                            _localizedDescription ?? pesticide.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                              height: 1.6,
                            ),
                          ),
                  ),

                  const SizedBox(height: 16),

                  // Usage Info
                  _buildCard(
                    title: 'pesticide_section.usage_instructions'.tr(),
                    icon: Icons.science,
                    child: Column(
                      children: [
                        _buildUsageRow(
                          '💧 Dosis',
                          _localizedDosage ?? pesticide.dosage,
                        ),
                        _buildUsageRow(
                          '🎯 Cara Aplikasi',
                          _localizedApplicationMethod ??
                              pesticide.applicationMethod,
                        ),
                        _buildUsageRow('📅 Frekuensi', pesticide.frequency),
                        _buildUsageRow(
                          '⏰ Sebelum Panen',
                          '${pesticide.harvestInterval} hari',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Target Diseases
                  if (pesticide.targetDiseases.isNotEmpty)
                    _buildCard(
                      title: 'pesticide_section.for_diseases'.tr(),
                      icon: Icons.bug_report,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: pesticide.targetDiseases.take(6).map((
                          diseaseId,
                        ) {
                          final disease = Disease.getById(diseaseId);
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red[50],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.red[200]!),
                            ),
                            child: Text(
                              disease?.nameIndonesia ??
                                  diseaseId.replaceAll('_', ' '),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.red[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                  if (pesticide.targetDiseases.isNotEmpty)
                    const SizedBox(height: 16),

                  // Target Pests
                  if (pesticide.targetPests.isNotEmpty)
                    _buildCard(
                      title: 'pesticide_section.for_pests'.tr(),
                      icon: Icons.pest_control,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: pesticide.targetPests.map((pest) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange[50],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.orange[200]!),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  '🐛',
                                  style: TextStyle(fontSize: 14),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  pest,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.orange[800],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                  if (pesticide.targetPests.isNotEmpty)
                    const SizedBox(height: 16),

                  // Warnings
                  if (pesticide.warnings.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.red[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.warning_amber,
                                color: Colors.red[700],
                                size: 22,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'pesticide_section.warnings'.tr(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red[700],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ...pesticide.warnings.map(
                            (w) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 6),
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: Colors.red[600],
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      w,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.red[800],
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 16),

                  // Organic Alternative
                  if (pesticide.organicAlternative != null)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.green[200]!),
                      ),
                      child: Row(
                        children: [
                          const Text('🌿', style: TextStyle(fontSize: 28)),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Alternatif Organik',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green[800],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Pertimbangkan ${pesticide.organicAlternative} sebagai pilihan ramah lingkungan',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.green[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
              Icon(icon, color: _getTypeColor(), size: 20),
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

  Widget _buildUsageRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  void _showNearbyShops(BuildContext context) {
    final shops = AgroShop.getVerifiedShops();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Text('🏪', style: TextStyle(fontSize: 26)),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Toko Terdekat',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: shops.length,
                itemBuilder: (context, index) {
                  final shop = shops[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                shop.name,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (shop.isVerified)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.verified,
                                      size: 12,
                                      color: Colors.blue[600],
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Terverifikasi',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.blue[600],
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          shop.fullAddress,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              shop.ratingText,
                              style: const TextStyle(fontSize: 12),
                            ),
                            const Spacer(),
                            Text(
                              shop.openHours,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.phone, size: 16),
                                label: Text('common.call'.tr()),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.grey[700],
                                  side: BorderSide(color: Colors.grey[300]!),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.directions, size: 16),
                                label: Text('common.route'.tr()),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _getTypeColor(),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getTypeColor() {
    switch (pesticide.type) {
      case 'fungisida':
        return const Color(0xFF7B1FA2);
      case 'insektisida':
        return const Color(0xFFE53935);
      case 'bakterisida':
        return const Color(0xFF00897B);
      case 'herbisida':
        return const Color(0xFF43A047);
      case 'akarisida':
        return const Color(0xFFFF7043);
      default:
        return const Color(0xFF5C6BC0);
    }
  }
}
