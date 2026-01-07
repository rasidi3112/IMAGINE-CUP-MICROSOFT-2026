// AgriVision NTB - Encyclopedia Screen
// Ensiklopedia penyakit tanaman

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../config/app_theme.dart';
import '../../models/disease.dart';
import 'disease_detail_screen.dart';

class EncyclopediaScreen extends StatefulWidget {
  const EncyclopediaScreen({super.key});

  @override
  State<EncyclopediaScreen> createState() => _EncyclopediaScreenState();
}

class _EncyclopediaScreenState extends State<EncyclopediaScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedPlant = 'all';
  String _searchQuery = '';

  // Filter keys that map to translation keys
  final List<Map<String, String>> _plantFilters = [
    {'key': 'all', 'translationKey': 'filters.all'},
    {'key': 'rice', 'translationKey': 'filters.rice'},
    {'key': 'corn', 'translationKey': 'filters.corn'},
    {'key': 'chili', 'translationKey': 'filters.chili'},
    {'key': 'tomato', 'translationKey': 'filters.tomato'},
    {'key': 'onion', 'translationKey': 'filters.onion'},
    {'key': 'soybean', 'translationKey': 'filters.soybean'},
    {'key': 'bean', 'translationKey': 'filters.bean'},
    {'key': 'banana', 'translationKey': 'filters.banana'},
  ];

  // Map filter key to plant names for filtering
  String _getPlantNameForFilter(String filterKey) {
    switch (filterKey) {
      case 'rice':
        return 'Padi';
      case 'corn':
        return 'Jagung';
      case 'chili':
        return 'Cabai';
      case 'tomato':
        return 'Tomat';
      case 'onion':
        return 'Bawang';
      case 'soybean':
        return 'Kedelai';
      case 'bean':
        return 'Kacang';
      case 'banana':
        return 'Pisang';
      default:
        return '';
    }
  }

  List<Disease> get _filteredDiseases {
    var diseases = Disease.commonDiseases;

    if (_searchQuery.isNotEmpty) {
      diseases = Disease.search(_searchQuery);
    }

    if (_selectedPlant != 'all') {
      final plantName = _getPlantNameForFilter(_selectedPlant);
      diseases = diseases
          .where(
            (d) => d.affectedPlants.any(
              (p) => p.toLowerCase().contains(plantName.toLowerCase()),
            ),
          )
          .toList();
    }

    return diseases;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: AppTheme.primaryGreen,
            elevation: 0,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(50),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                color: Colors.white,
                onPressed: () => Navigator.pop(context),
                tooltip: 'Kembali',
              ),
            ),
            title: Row(
              children: [
                Icon(
                  Icons.menu_book_rounded,
                  color: Colors.white.withAlpha(230),
                  size: 24,
                ),
                const SizedBox(width: 10),
                Text(
                  'encyclopedia.title'.tr(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(25),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'home.search_placeholder'.tr(),
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey[400],
                      size: 22,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 20),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Filter Chips
          SliverToBoxAdapter(
            child: Container(
              height: 50,
              margin: const EdgeInsets.only(top: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _plantFilters.length,
                itemBuilder: (context, index) {
                  final filter = _plantFilters[index];
                  final filterKey = filter['key']!;
                  final translationKey = filter['translationKey']!;
                  final isSelected = _selectedPlant == filterKey;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(translationKey.tr()),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() => _selectedPlant = filterKey);
                      },
                      backgroundColor: Colors.grey[100],
                      selectedColor: AppTheme.primaryGreen.withOpacity(0.2),
                      labelStyle: TextStyle(
                        color: isSelected
                            ? AppTheme.primaryGreen
                            : Colors.grey[700],
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                      side: BorderSide(
                        color: isSelected
                            ? AppTheme.primaryGreen
                            : Colors.transparent,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Results Count
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Text(
                '${_filteredDiseases.length} ${'disease_section.disease_found'.tr()}',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          // Disease List
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final disease = _filteredDiseases[index];
                return _DiseaseCard(
                  disease: disease,
                  index: index,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DiseaseDetailScreen(disease: disease),
                    ),
                  ),
                );
              }, childCount: _filteredDiseases.length),
            ),
          ),
        ],
      ),
    );
  }
}

class _DiseaseCard extends StatelessWidget {
  final Disease disease;
  final int index;
  final VoidCallback onTap;

  const _DiseaseCard({
    required this.disease,
    required this.index,
    required this.onTap,
  });

  Color get _severityColor {
    final name = disease.name.toLowerCase();
    if (name.contains('wilt') ||
        name.contains('virus') ||
        name.contains('tungro')) {
      return Colors.red[400]!;
    } else if (name.contains('blight') || name.contains('rot')) {
      return Colors.orange[400]!;
    } else if (name.contains('spot') || name.contains('rust')) {
      return Colors.amber[600]!;
    }
    return Colors.green[400]!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
          margin: const EdgeInsets.only(bottom: 12),
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
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Icon
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: _severityColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Icon(
                          _getDiseaseIcon(),
                          size: 26,
                          color: _severityColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            disease.nameIndonesia,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            disease.name,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[500],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: disease.affectedPlants.take(3).map((
                              plant,
                            ) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  plant,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),

                    // Arrow
                    Icon(
                      Icons.chevron_right,
                      color: Colors.grey[300],
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 300.ms, delay: (50 * index).ms)
        .slideX(begin: 0.05, end: 0);
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
    if (name.contains('smut')) return Icons.circle;
    return Icons.bug_report;
  }
}
