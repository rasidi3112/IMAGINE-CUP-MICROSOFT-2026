// AgriVision NTB - Farm Management Screen
// Layar untuk mengelola lahan pertanian

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uuid/uuid.dart';
import '../../models/farm.dart';
import '../../services/local_storage_service.dart';
import '../../data/ntb_regions.dart';
import '../scan/scan_screen.dart';
import '../calendar/calendar_screen.dart';
import '../history/history_screen.dart';

class FarmManagementScreen extends StatefulWidget {
  const FarmManagementScreen({super.key});

  @override
  State<FarmManagementScreen> createState() => _FarmManagementScreenState();
}

class _FarmManagementScreenState extends State<FarmManagementScreen> {
  final LocalStorageService _storageService = LocalStorageService();
  List<Farm> _farms = [];
  bool _isLoading = true;

  // Sample data - langsung muncul
  final List<Farm> _sampleFarms = [
    Farm(
      id: 'farm_1',
      userId: 'user_1',
      name: 'Sawah Utama',
      plantType: 'padi',
      area: 2.5,
      latitude: -8.7234,
      longitude: 116.2847,
      village: 'Batujai',
      district: 'Praya Barat',
      regency: 'Lombok Tengah',
      plantingDate: DateTime.now().subtract(const Duration(days: 45)),
      currentGrowthStage: 'Vegetatif',
      status: FarmStatus.growing,
    ),
    Farm(
      id: 'farm_2',
      userId: 'user_1',
      name: 'Kebun Jagung',
      plantType: 'jagung',
      area: 1.2,
      latitude: -8.6123,
      longitude: 116.4521,
      village: 'Sukadana',
      district: 'Terara',
      regency: 'Lombok Timur',
      plantingDate: DateTime.now().subtract(const Duration(days: 30)),
      currentGrowthStage: 'Vegetatif Awal',
      status: FarmStatus.growing,
    ),
    Farm(
      id: 'farm_3',
      userId: 'user_1',
      name: 'Lahan Cabai',
      plantType: 'cabai',
      area: 0.8,
      latitude: -8.5892,
      longitude: 116.3127,
      village: 'Mantang',
      district: 'Batukliang',
      regency: 'Lombok Tengah',
      plantingDate: DateTime.now().subtract(const Duration(days: 60)),
      currentGrowthStage: 'Generatif',
      status: FarmStatus.flowering,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadFarms();
  }

  Future<void> _loadFarms() async {
    // Langsung pakai sample data
    setState(() {
      _farms = List.from(_sampleFarms);
      _isLoading = false;
    });
  }

  Future<void> _saveFarm(Farm farm) async {
    await _storageService.saveFarm({
      'id': farm.id,
      'user_id': farm.userId,
      'name': farm.name,
      'plant_type': farm.plantType,
      'area': farm.area,
      'latitude': farm.latitude,
      'longitude': farm.longitude,
      'village': farm.village,
      'district': farm.district,
      'regency': farm.regency,
      'planting_date': farm.plantingDate.toIso8601String(),
      'current_growth_stage': farm.currentGrowthStage,
      'status': farm.status.name,
      'notes': farm.notes,
    });
    await _loadFarms();
  }

  Future<void> _deleteFarm(String id) async {
    await _storageService.deleteFarm(id);
    await _loadFarms();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF5F7F5),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final stats = FarmStats.fromFarms(_farms);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F5),
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            expandedHeight: 220,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF2E7D32),
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 18,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(50),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                '🌾',
                                style: TextStyle(fontSize: 28),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'farm.title'.tr(),
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    '${stats.totalFarms} ${'farm.total_farms'.tr().toLowerCase().replaceAll('total ', '')} • ${stats.totalArea.toStringAsFixed(1)} ${'units.hectare'.tr()}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white.withAlpha(200),
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

          // Summary Cards
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      icon: '📍',
                      label: 'farm.total_farms'.tr(),
                      value: '${stats.totalFarms}',
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSummaryCard(
                      icon: '📐',
                      label: 'farm.total_area'.tr(),
                      value:
                          '${stats.totalArea.toStringAsFixed(1)} ${'units.hectare'.tr()}',
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSummaryCard(
                      icon: '🌱',
                      label: 'farm.active'.tr(),
                      value: '${stats.activeFarms}',
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Farms List
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final farm = _farms[index];
                return _FarmCard(
                  farm: farm,
                  index: index,
                  onTap: () => _showFarmDetail(context, farm),
                  onEdit: () => _showEditFarm(context, farm),
                );
              }, childCount: _farms.length),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddFarm(context),
        backgroundColor: const Color(0xFF2E7D32),
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'farm.add_farm'.tr(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required String icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
        ],
      ),
    ).animate().fadeIn().scale(begin: const Offset(0.9, 0.9));
  }

  void _showFarmDetail(BuildContext context, Farm farm) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: _getPlantColor(farm.plantType).withAlpha(30),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        farm.statusEmoji,
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          farm.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 14,
                              color: Colors.grey[500],
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                farm.fullLocation,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Info Grid
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoTile(
                            '🌱',
                            'farm.crop_type'.tr(),
                            _getPlantName(farm.plantType),
                          ),
                        ),
                        Expanded(
                          child: _buildInfoTile(
                            '📐',
                            'farm.area'.tr(),
                            '${farm.area} ${'units.hectare'.tr()}',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoTile(
                            '📅',
                            'farm.hst'.tr(),
                            farm.dapText,
                          ),
                        ),
                        Expanded(
                          child: _buildInfoTile(
                            '🔄',
                            'farm.status'.tr(),
                            farm.statusText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Growth Stage
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.trending_up,
                                color: Colors.green[700],
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'farm.growth_phase'.tr(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[800],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            farm.currentGrowthStage,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.green[700],
                            ),
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: _getGrowthProgress(farm),
                            backgroundColor: Colors.green[100],
                            valueColor: AlwaysStoppedAnimation(
                              Colors.green[600],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${'farm.days_after_planting'.tr()}: ${farm.daysAfterPlanting}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green[600],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Quick Actions
                    Text(
                      'farm.quick_actions'.tr(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildActionButton(
                            icon: Icons.camera_alt,
                            label: 'farm.scan'.tr(),
                            color: Colors.green,
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ScanScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildActionButton(
                            icon: Icons.calendar_today,
                            label: 'farm.schedule'.tr(),
                            color: Colors.blue,
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const CalendarScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildActionButton(
                            icon: Icons.history,
                            label: 'farm.history'.tr(),
                            color: Colors.orange,
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const HistoryScreen(),
                                ),
                              );
                            },
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
      ),
    );
  }

  Widget _buildInfoTile(String emoji, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(right: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color.withAlpha(20),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getPlantColor(String plantType) {
    switch (plantType) {
      case 'padi':
        return Colors.amber;
      case 'jagung':
        return Colors.yellow;
      case 'cabai':
        return Colors.red;
      case 'bawang':
        return Colors.purple;
      case 'tomat':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  String _getPlantName(String plantType) {
    switch (plantType) {
      case 'padi':
        return 'Padi';
      case 'jagung':
        return 'Jagung';
      case 'cabai':
        return 'Cabai';
      case 'bawang':
        return 'Bawang';
      case 'tomat':
        return 'Tomat';
      default:
        return plantType;
    }
  }

  double _getGrowthProgress(Farm farm) {
    // Estimated based on plant type
    int totalDays;
    switch (farm.plantType) {
      case 'padi':
        totalDays = 120;
        break;
      case 'jagung':
        totalDays = 100;
        break;
      case 'cabai':
        totalDays = 150;
        break;
      default:
        totalDays = 90;
    }
    return (farm.daysAfterPlanting / totalDays).clamp(0.0, 1.0);
  }

  void _showAddFarm(BuildContext context) {
    _showFarmForm(context, null);
  }

  void _showEditFarm(BuildContext context, Farm farm) {
    _showFarmForm(context, farm);
  }

  void _showFarmForm(BuildContext context, Farm? existingFarm) {
    final isEditing = existingFarm != null;
    final nameController = TextEditingController(
      text: existingFarm?.name ?? '',
    );
    final areaController = TextEditingController(
      text: existingFarm?.area.toString() ?? '',
    );
    final villageController = TextEditingController(
      text: existingFarm?.village ?? '',
    );
    final notesController = TextEditingController(
      text: existingFarm?.notes ?? '',
    );

    String selectedPlantType = existingFarm?.plantType ?? 'padi';
    String selectedKabupaten = existingFarm?.regency ?? 'Lombok Tengah';
    String selectedKecamatan = existingFarm?.district ?? '';
    DateTime plantingDate = existingFarm?.plantingDate ?? DateTime.now();
    FarmStatus selectedStatus = existingFarm?.status ?? FarmStatus.preparation;

    final plantTypes = [
      'padi',
      'jagung',
      'cabai',
      'bawang',
      'tomat',
      'kedelai',
      'kacang',
    ];
    final statuses = FarmStatus.values;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => StatefulBuilder(
        builder: (modalContext, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isEditing ? 'Edit Lahan' : 'farm.add_farm'.tr(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (isEditing)
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          Navigator.pop(context);
                          _confirmDeleteFarm(context, existingFarm);
                        },
                      ),
                  ],
                ),
              ),
              const Divider(),
              // Form
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nama Lahan
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'farm.farm_name'.tr(),
                          hintText: 'Contoh: Sawah Utama',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.agriculture),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Jenis Tanaman
                      DropdownButtonFormField<String>(
                        value: selectedPlantType,
                        decoration: InputDecoration(
                          labelText: 'farm.crop_type'.tr(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.eco),
                        ),
                        items: plantTypes
                            .map(
                              (type) => DropdownMenuItem(
                                value: type,
                                child: Text(_getPlantName(type)),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setModalState(() => selectedPlantType = value!);
                        },
                      ),
                      const SizedBox(height: 16),

                      // Luas Lahan
                      TextField(
                        controller: areaController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'farm.area'.tr(),
                          hintText: 'Contoh: 2.5',
                          suffixText: 'ha',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.square_foot),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Kabupaten
                      DropdownButtonFormField<String>(
                        value: selectedKabupaten,
                        decoration: InputDecoration(
                          labelText: 'Kabupaten',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.location_city),
                        ),
                        items: NTBRegions.getKabupatenList()
                            .map(
                              (kab) => DropdownMenuItem(
                                value: kab,
                                child: Text(kab),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setModalState(() {
                            selectedKabupaten = value!;
                            selectedKecamatan = NTBRegions.getKecamatanList(
                              value,
                            ).first;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // Kecamatan
                      DropdownButtonFormField<String>(
                        value: selectedKecamatan.isEmpty
                            ? NTBRegions.getKecamatanList(
                                selectedKabupaten,
                              ).first
                            : selectedKecamatan,
                        decoration: InputDecoration(
                          labelText: 'Kecamatan',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.location_on),
                        ),
                        items: NTBRegions.getKecamatanList(selectedKabupaten)
                            .map(
                              (kec) => DropdownMenuItem(
                                value: kec,
                                child: Text(kec),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setModalState(() => selectedKecamatan = value!);
                        },
                      ),
                      const SizedBox(height: 16),

                      // Desa
                      TextField(
                        controller: villageController,
                        decoration: InputDecoration(
                          labelText: 'Desa/Dusun',
                          hintText: 'Contoh: Dusun Timur',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.home),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Tanggal Tanam
                      InkWell(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: plantingDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now().add(
                              const Duration(days: 30),
                            ),
                          );
                          if (picked != null) {
                            setModalState(() => plantingDate = picked);
                          }
                        },
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Tanggal Tanam',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(Icons.calendar_today),
                          ),
                          child: Text(
                            '${plantingDate.day}/${plantingDate.month}/${plantingDate.year}',
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Status
                      DropdownButtonFormField<FarmStatus>(
                        value: selectedStatus,
                        decoration: InputDecoration(
                          labelText: 'farm.status'.tr(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.info),
                        ),
                        items: statuses
                            .map(
                              (status) => DropdownMenuItem(
                                value: status,
                                child: Text(_getStatusName(status)),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setModalState(() => selectedStatus = value!);
                        },
                      ),
                      const SizedBox(height: 16),

                      // Catatan
                      TextField(
                        controller: notesController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Catatan (opsional)',
                          hintText: 'Catatan tambahan...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.notes),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Save Button
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (nameController.text.isEmpty ||
                          areaController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Nama dan luas lahan wajib diisi'),
                          ),
                        );
                        return;
                      }

                      final farm = Farm(
                        id: existingFarm?.id ?? const Uuid().v4(),
                        userId: 'user_1',
                        name: nameController.text,
                        plantType: selectedPlantType,
                        area: double.tryParse(areaController.text) ?? 0,
                        latitude: 0,
                        longitude: 0,
                        village: villageController.text,
                        district: selectedKecamatan,
                        regency: selectedKabupaten,
                        plantingDate: plantingDate,
                        currentGrowthStage: _getGrowthStage(
                          selectedPlantType,
                          plantingDate,
                        ),
                        status: selectedStatus,
                        notes: notesController.text.isEmpty
                            ? null
                            : notesController.text,
                      );

                      Navigator.pop(modalContext);
                      await _saveFarm(farm);

                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isEditing
                                  ? 'Lahan berhasil diperbarui'
                                  : 'Lahan berhasil ditambahkan',
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      isEditing ? 'Simpan Perubahan' : 'farm.add_farm'.tr(),
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDeleteFarm(BuildContext context, Farm farm) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Lahan?'),
        content: Text('Apakah Anda yakin ingin menghapus "${farm.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await _deleteFarm(farm.id);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Lahan berhasil dihapus'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _getGrowthStage(String plantType, DateTime plantingDate) {
    final days = DateTime.now().difference(plantingDate).inDays;
    if (days < 0) return 'Persiapan';
    if (days < 14) return 'Perkecambahan';
    if (days < 45) return 'Vegetatif';
    if (days < 75) return 'Generatif';
    if (days < 100) return 'Pematangan';
    return 'Siap Panen';
  }

  String _getStatusName(FarmStatus status) {
    switch (status) {
      case FarmStatus.preparation:
        return 'Persiapan Lahan';
      case FarmStatus.growing:
        return 'Masa Pertumbuhan';
      case FarmStatus.flowering:
        return 'Masa Pembungaan';
      case FarmStatus.harvesting:
        return 'Masa Panen';
      case FarmStatus.fallow:
        return 'Bera/Istirahat';
      case FarmStatus.problem:
        return 'Ada Masalah';
    }
  }
}

class _FarmCard extends StatelessWidget {
  final Farm farm;
  final int index;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  const _FarmCard({
    required this.farm,
    required this.index,
    required this.onTap,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    // Crop Icon
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: _getPlantColor(farm.plantType).withAlpha(30),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(
                          farm.statusEmoji,
                          style: const TextStyle(fontSize: 28),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    // Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            farm.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 12,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  farm.fullLocation,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Actions
                    IconButton(
                      icon: Icon(Icons.more_vert, color: Colors.grey[400]),
                      onPressed: onEdit,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // Stats Row
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStat('🌱', _getPlantName(farm.plantType)),
                      Container(width: 1, height: 24, color: Colors.grey[300]),
                      _buildStat('📐', '${farm.area} ha'),
                      Container(width: 1, height: 24, color: Colors.grey[300]),
                      _buildStat('📅', farm.dapText),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: (80 * index).ms).slideX(begin: 0.05, end: 0);
  }

  Widget _buildStat(String emoji, String text) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 14)),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Color _getPlantColor(String plantType) {
    switch (plantType) {
      case 'padi':
        return Colors.amber;
      case 'jagung':
        return Colors.yellow;
      case 'cabai':
        return Colors.red;
      case 'bawang':
        return Colors.purple;
      case 'tomat':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  String _getPlantName(String plantType) {
    switch (plantType) {
      case 'padi':
        return 'Padi';
      case 'jagung':
        return 'Jagung';
      case 'cabai':
        return 'Cabai';
      case 'bawang':
        return 'Bawang';
      case 'tomat':
        return 'Tomat';
      default:
        return plantType;
    }
  }
}
