// AgriVision NTB - Plant Guide Screen
// Panduan tanaman NTB

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../config/app_theme.dart';
import '../../models/plant.dart';
import 'plant_detail_screen.dart';

class PlantGuideScreen extends StatefulWidget {
  const PlantGuideScreen({super.key});

  @override
  State<PlantGuideScreen> createState() => _PlantGuideScreenState();
}

class _PlantGuideScreenState extends State<PlantGuideScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<String> get _categories => [
    'plant_guide.filter_all'.tr(),
    'plant_guide.tab_food'.tr(),
    'plant_guide.tab_horticulture'.tr(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // FIXED: Logic now relies on index, not translated string comparison
  List<Plant> _getPlantsByIndex(int index) {
    switch (index) {
      case 0:
        return Plant.ntbPlants;
      case 1:
        return Plant.getByCategory('pangan');
      case 2:
        return Plant.getByCategory('hortikultura');
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F5),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 160, // Sedikit dikurangi
            floating: false,
            pinned: true,
            backgroundColor: AppTheme.primaryGreen,
            elevation: 0,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                color: Colors.white,
                onPressed: () => Navigator.pop(context),
                tooltip: 'common.back'.tr(),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [const Color(0xFF43A047), AppTheme.primaryGreen],
                  ),
                ),
                child: Stack(
                  children: [
                    // Background pattern
                    Positioned(
                      right: -20,
                      bottom: 0,
                      child: Icon(
                        Icons.eco,
                        size: 140,
                        color: Colors.white.withOpacity(0.15),
                      ),
                    ),
                    // Content
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons
                                      .local_florist_rounded, // Ganti icon biar beda
                                  color: Colors.white.withOpacity(0.95),
                                  size: 28,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'plant_guide.title'.tr(),
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'plant_guide.subtitle'.tr(
                                namedArgs: {
                                  'count': '${Plant.ntbPlants.length}',
                                },
                              ),
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withOpacity(0.85),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: TabBar(
                  controller: _tabController,
                  labelColor: AppTheme.primaryGreen,
                  unselectedLabelColor: Colors.grey[400],
                  indicatorColor: AppTheme.primaryGreen,
                  indicatorWeight: 3,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  tabs: _categories.map((c) => Tab(text: c)).toList(),
                ),
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: List.generate(_categories.length, (index) {
            final plants = _getPlantsByIndex(index);
            return _PlantGrid(plants: plants);
          }),
        ),
      ),
    );
  }
}

class _PlantGrid extends StatelessWidget {
  final List<Plant> plants;

  const _PlantGrid({required this.plants});

  @override
  Widget build(BuildContext context) {
    if (plants.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              "empty_states.no_data".tr(),
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8, // Sedikit lebih tinggi untuk estetika
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: plants.length,
      itemBuilder: (context, index) {
        return _PlantCard(
          plant: plants[index],
          index: index,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PlantDetailScreen(plant: plants[index]),
            ),
          ),
        );
      },
    );
  }
}

class _PlantCard extends StatelessWidget {
  final Plant plant;
  final int index;
  final VoidCallback onTap;

  const _PlantCard({
    required this.plant,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: _getCategoryColor().withOpacity(0.12),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          plant.iconEmoji,
                          style: const TextStyle(fontSize: 32),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Name
                    Text(
                      plant.name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      plant.localName,
                      style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                    ),
                    const Spacer(),

                    // Duration badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: _getCategoryColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.schedule,
                            size: 14,
                            color: _getCategoryColor(),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${plant.growthDurationDays} ${'plant_section.days'.tr()}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _getCategoryColor(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 400.ms, delay: (80 * index).ms)
        .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1));
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
