// AgriVision NTB - Pesticide Finder Screen
// Pencari obat pertanian

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../models/pesticide.dart';
import 'pesticide_detail_screen.dart';

class PesticideFinderScreen extends StatefulWidget {
  const PesticideFinderScreen({super.key});

  @override
  State<PesticideFinderScreen> createState() => _PesticideFinderScreenState();
}

class _PesticideFinderScreenState extends State<PesticideFinderScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedType = 'semua';
  String _selectedCategory = 'semua';
  String _searchQuery = '';

  final List<Map<String, dynamic>> _typeFilters = [
    {'id': 'semua', 'label': 'Semua', 'emoji': '📦'},
    {'id': 'fungisida', 'label': 'Fungisida', 'emoji': '🍄'},
    {'id': 'insektisida', 'label': 'Insektisida', 'emoji': '🐛'},
    {'id': 'bakterisida', 'label': 'Bakterisida', 'emoji': '🦠'},
    {'id': 'herbisida', 'label': 'Herbisida', 'emoji': '🌿'},
  ];

  final List<Map<String, dynamic>> _categoryFilters = [
    {'id': 'semua', 'label': 'Semua'},
    {'id': 'kimia', 'label': 'Kimia'},
    {'id': 'hayati', 'label': 'Hayati'},
    {'id': 'organik', 'label': 'Organik'},
  ];

  List<Pesticide> get _filteredPesticides {
    var pesticides = Pesticide.pesticidesNTB;

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      pesticides = pesticides
          .where(
            (p) =>
                p.brandName.toLowerCase().contains(query) ||
                p.activeIngredient.toLowerCase().contains(query) ||
                p.targetDiseases.any((d) => d.toLowerCase().contains(query)),
          )
          .toList();
    }

    if (_selectedType != 'semua') {
      pesticides = pesticides.where((p) => p.type == _selectedType).toList();
    }

    if (_selectedCategory != 'semua') {
      pesticides = pesticides
          .where((p) => p.category == _selectedCategory)
          .toList();
    }

    return pesticides;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F5),
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF5C6BC0),
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
                  Icons.medication_rounded,
                  color: Colors.white.withAlpha(230),
                  size: 24,
                ),
                const SizedBox(width: 10),
                const Text(
                  'Pestisida & Obat',
                  style: TextStyle(
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
                  onChanged: (v) => setState(() => _searchQuery = v),
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

          // Type Filters
          SliverToBoxAdapter(
            child: Container(
              height: 48,
              margin: const EdgeInsets.only(top: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _typeFilters.length,
                itemBuilder: (context, index) {
                  final filter = _typeFilters[index];
                  final isSelected = _selectedType == filter['id'];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            filter['emoji'],
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(width: 6),
                          Text(filter['label']),
                        ],
                      ),
                      selected: isSelected,
                      onSelected: (s) =>
                          setState(() => _selectedType = filter['id']),
                      backgroundColor: Colors.white,
                      selectedColor: const Color(0xFF5C6BC0).withOpacity(0.15),
                      labelStyle: TextStyle(
                        color: isSelected
                            ? const Color(0xFF5C6BC0)
                            : Colors.grey[700],
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                        fontSize: 13,
                      ),
                      side: BorderSide(
                        color: isSelected
                            ? const Color(0xFF5C6BC0)
                            : Colors.grey[300]!,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Category Chips
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Row(
                children: _categoryFilters.map((filter) {
                  final isSelected = _selectedCategory == filter['id'];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () =>
                          setState(() => _selectedCategory = filter['id']),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? _getCategoryColor(filter['id'])
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? _getCategoryColor(filter['id'])
                                : Colors.grey[300]!,
                          ),
                        ),
                        child: Text(
                          filter['label'],
                          style: TextStyle(
                            fontSize: 13,
                            color: isSelected ? Colors.white : Colors.grey[600],
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Results
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_filteredPesticides.length} produk',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showOrganicInfo(context),
                    child: Row(
                      children: [
                        Icon(Icons.eco, size: 16, color: Colors.green[600]),
                        const SizedBox(width: 4),
                        Text(
                          'Pilihan organik',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Pesticide List
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final pesticide = _filteredPesticides[index];
                return _PesticideCard(
                  pesticide: pesticide,
                  index: index,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          PesticideDetailScreen(pesticide: pesticide),
                    ),
                  ),
                );
              }, childCount: _filteredPesticides.length),
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
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

  void _showOrganicInfo(BuildContext context) {
    final organics = Pesticide.getOrganicOptions();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.eco_rounded,
                        color: Colors.green[700],
                        size: 24,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Pilihan Organik & Hayati',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Alternatif ramah lingkungan untuk pertanian berkelanjutan',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  ...organics
                      .take(4)
                      .map(
                        (p) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                p.typeEmoji,
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                          title: Text(
                            p.brandName,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            p.activeIngredient,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                          trailing: const Icon(
                            Icons.chevron_right,
                            color: Colors.grey,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    PesticideDetailScreen(pesticide: p),
                              ),
                            );
                          },
                        ),
                      ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PesticideCard extends StatelessWidget {
  final Pesticide pesticide;
  final int index;
  final VoidCallback onTap;

  const _PesticideCard({
    required this.pesticide,
    required this.index,
    required this.onTap,
  });

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Icon
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: _getTypeColor().withOpacity(0.12),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: Text(
                              pesticide.typeEmoji,
                              style: const TextStyle(fontSize: 26),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),

                        // Content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      pesticide.brandName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getCategoryColor().withOpacity(
                                        0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      pesticide.category.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: _getCategoryColor(),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(
                                pesticide.activeIngredient,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Info Row
                    Row(
                      children: [
                        _buildInfoChip(Icons.water_drop, pesticide.dosage),
                        const Spacer(),
                        Text(
                          pesticide.priceRange,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 300.ms, delay: (40 * index).ms)
        .slideX(begin: 0.03, end: 0);
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey[600]),
          const SizedBox(width: 5),
          Text(text, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
        ],
      ),
    );
  }

  Color _getTypeColor() {
    switch (pesticide.type) {
      case 'fungisida':
        return Colors.purple[400]!;
      case 'insektisida':
        return Colors.red[400]!;
      case 'bakterisida':
        return Colors.teal[400]!;
      case 'herbisida':
        return Colors.green[400]!;
      case 'akarisida':
        return Colors.orange[400]!;
      default:
        return Colors.grey[400]!;
    }
  }

  Color _getCategoryColor() {
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
