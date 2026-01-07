// AgriVision NTB - Outbreak Map Screen
// Layar peta sebaran penyakit di NTB

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../config/app_config.dart';
import '../../config/app_theme.dart';
import '../../models/outbreak_data.dart';
import '../../widgets/common_widgets.dart';

class OutbreakMapScreen extends StatefulWidget {
  const OutbreakMapScreen({super.key});

  @override
  State<OutbreakMapScreen> createState() => _OutbreakMapScreenState();
}

class _OutbreakMapScreenState extends State<OutbreakMapScreen> {
  final MapController _mapController = MapController();
  String _selectedFilter = 'all';
  bool _showHeatmap = true;
  OutbreakData? _selectedOutbreak;

  // Sample outbreak data for NTB
  final List<OutbreakData> _sampleOutbreaks = [
    OutbreakData(
      id: '1',
      diseaseId: 'leaf_blight',
      diseaseName: 'Hawar Daun',
      latitude: -8.5833,
      longitude: 116.1167,
      locationName: 'Mataram',
      regency: 'Kota Mataram',
      district: 'Mataram',
      reportCount: 24,
      averageSeverity: 65,
      firstReportedAt: DateTime.now().subtract(const Duration(days: 14)),
      lastReportedAt: DateTime.now().subtract(const Duration(days: 1)),
      status: OutbreakStatus.active,
      affectedCrop: 'Jagung',
    ),
    OutbreakData(
      id: '2',
      diseaseId: 'rust',
      diseaseName: 'Penyakit Karat',
      latitude: -8.7167,
      longitude: 116.2833,
      locationName: 'Praya',
      regency: 'Lombok Tengah',
      district: 'Praya',
      reportCount: 18,
      averageSeverity: 45,
      firstReportedAt: DateTime.now().subtract(const Duration(days: 10)),
      lastReportedAt: DateTime.now().subtract(const Duration(days: 2)),
      status: OutbreakStatus.monitoring,
      affectedCrop: 'Padi',
    ),
    OutbreakData(
      id: '3',
      diseaseId: 'downy_mildew',
      diseaseName: 'Bulai',
      latitude: -8.5000,
      longitude: 116.4500,
      locationName: 'Aikmel',
      regency: 'Lombok Timur',
      district: 'Aikmel',
      reportCount: 42,
      averageSeverity: 78,
      firstReportedAt: DateTime.now().subtract(const Duration(days: 21)),
      lastReportedAt: DateTime.now(),
      status: OutbreakStatus.spreading,
      affectedCrop: 'Jagung',
    ),
    OutbreakData(
      id: '4',
      diseaseId: 'anthracnose',
      diseaseName: 'Antraknosa',
      latitude: -8.4500,
      longitude: 116.0667,
      locationName: 'Senggigi',
      regency: 'Lombok Barat',
      district: 'Batulayar',
      reportCount: 8,
      averageSeverity: 35,
      firstReportedAt: DateTime.now().subtract(const Duration(days: 5)),
      lastReportedAt: DateTime.now().subtract(const Duration(days: 1)),
      status: OutbreakStatus.contained,
      affectedCrop: 'Cabai',
    ),
    OutbreakData(
      id: '5',
      diseaseId: 'bacterial_wilt',
      diseaseName: 'Layu Bakteri',
      latitude: -8.6500,
      longitude: 117.4167,
      locationName: 'Sumbawa Besar',
      regency: 'Sumbawa',
      district: 'Sumbawa',
      reportCount: 31,
      averageSeverity: 72,
      firstReportedAt: DateTime.now().subtract(const Duration(days: 18)),
      lastReportedAt: DateTime.now(),
      status: OutbreakStatus.critical,
      affectedCrop: 'Cabai',
    ),
  ];

  List<OutbreakData> get _filteredOutbreaks {
    if (_selectedFilter == 'all') return _sampleOutbreaks;
    return _sampleOutbreaks.where((o) {
      switch (_selectedFilter) {
        case 'critical':
          return o.status == OutbreakStatus.critical ||
              o.status == OutbreakStatus.spreading;
        case 'jagung':
          return o.affectedCrop.toLowerCase() == 'jagung';
        case 'padi':
          return o.affectedCrop.toLowerCase() == 'padi';
        case 'cabai':
          return o.affectedCrop.toLowerCase() == 'cabai';
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: LatLng(AppConfig.defaultLat, AppConfig.defaultLng),
              initialZoom: 8.5,
              minZoom: 7,
              maxZoom: 15,
              onTap: (_, __) {
                setState(() {
                  _selectedOutbreak = null;
                });
              },
            ),
            children: [
              // Base tile layer
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.agrivision.ntb',
              ),

              // Heatmap circles
              if (_showHeatmap)
                CircleLayer(
                  circles: _filteredOutbreaks.map((outbreak) {
                    return CircleMarker(
                      point: LatLng(outbreak.latitude, outbreak.longitude),
                      radius: 30 + (outbreak.reportCount * 0.5),
                      color: Color(outbreak.severityColor).withAlpha(100),
                      borderColor: Color(outbreak.severityColor),
                      borderStrokeWidth: 2,
                    );
                  }).toList(),
                ),

              // Markers
              MarkerLayer(
                markers: _filteredOutbreaks.map((outbreak) {
                  return Marker(
                    point: LatLng(outbreak.latitude, outbreak.longitude),
                    width: 50,
                    height: 50,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedOutbreak = outbreak;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(outbreak.severityColor),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Color(
                                outbreak.severityColor,
                              ).withAlpha(100),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            '${outbreak.reportCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          // Top bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Header card
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryGreen.withAlpha(80),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        if (Navigator.canPop(context)) ...[
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            style: IconButton.styleFrom(
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(40),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.map_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'map.title'.tr(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                'map.subtitle'.tr(),
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppTheme.successGreen,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'LIVE',
                                style: TextStyle(
                                  color: AppTheme.primaryGreen,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Filter chips
                  SizedBox(
                    height: 44,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildFilterChip(
                          'all',
                          'history.filter_all'.tr(),
                          _filteredOutbreaks.length,
                        ),
                        _buildFilterChip(
                          'critical',
                          'map.critical'.tr(),
                          _sampleOutbreaks
                              .where(
                                (o) =>
                                    o.status == OutbreakStatus.critical ||
                                    o.status == OutbreakStatus.spreading,
                              )
                              .length,
                        ),
                        _buildFilterChip(
                          'jagung',
                          'Jagung',
                          _sampleOutbreaks
                              .where(
                                (o) => o.affectedCrop.toLowerCase() == 'jagung',
                              )
                              .length,
                        ),
                        _buildFilterChip(
                          'padi',
                          'Padi',
                          _sampleOutbreaks
                              .where(
                                (o) => o.affectedCrop.toLowerCase() == 'padi',
                              )
                              .length,
                        ),
                        _buildFilterChip(
                          'cabai',
                          'Cabai',
                          _sampleOutbreaks
                              .where(
                                (o) => o.affectedCrop.toLowerCase() == 'cabai',
                              )
                              .length,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Legend
          Positioned(
            right: 16,
            bottom: _selectedOutbreak != null ? 280 : 180,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: AppTheme.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'map.legend'.tr(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildLegendItem(AppTheme.severityLow, 'map.low'.tr()),
                  _buildLegendItem(AppTheme.severityMedium, 'map.medium'.tr()),
                  _buildLegendItem(AppTheme.severityHigh, 'map.high'.tr()),
                  _buildLegendItem(
                    AppTheme.severityCritical,
                    'map.critical'.tr(),
                  ),
                  const Divider(),
                  Row(
                    children: [
                      Switch(
                        value: _showHeatmap,
                        onChanged: (value) {
                          setState(() {
                            _showHeatmap = value;
                          });
                        },
                        activeColor: AppTheme.primaryGreen,
                      ),
                      Text(
                        'common.heatmap'.tr(),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Quick stats
          Positioned(
            left: 16,
            bottom: _selectedOutbreak != null ? 280 : 32,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppTheme.buttonShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'home.statistics'.tr(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildStatRow(
                    'map.affected_crop'.tr(),
                    '${_sampleOutbreaks.length}',
                  ),
                  _buildStatRow(
                    'map.reports'.tr(),
                    '${_sampleOutbreaks.fold<int>(0, (sum, o) => sum + o.reportCount)}',
                  ),
                  _buildStatRow(
                    'map.critical'.tr(),
                    '${_sampleOutbreaks.where((o) => o.status == OutbreakStatus.critical).length}',
                  ),
                ],
              ),
            ),
          ),

          // Selected outbreak detail
          if (_selectedOutbreak != null)
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: _buildOutbreakDetail(_selectedOutbreak!),
            ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            heroTag: 'zoom_in',
            onPressed: () {
              _mapController.move(
                _mapController.camera.center,
                _mapController.camera.zoom + 1,
              );
            },
            backgroundColor: Colors.white,
            child: const Icon(Icons.add, color: AppTheme.primaryGreen),
          ),
          const SizedBox(height: 8),
          FloatingActionButton.small(
            heroTag: 'zoom_out',
            onPressed: () {
              _mapController.move(
                _mapController.camera.center,
                _mapController.camera.zoom - 1,
              );
            },
            backgroundColor: Colors.white,
            child: const Icon(Icons.remove, color: AppTheme.primaryGreen),
          ),
          const SizedBox(height: 8),
          FloatingActionButton.small(
            heroTag: 'my_location',
            onPressed: () {
              _mapController.move(
                LatLng(AppConfig.defaultLat, AppConfig.defaultLng),
                8.5,
              );
            },
            backgroundColor: AppTheme.primaryGreen,
            child: const Icon(Icons.my_location, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String value, String label, int count) {
    final isSelected = _selectedFilter == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Material(
        color: isSelected ? AppTheme.primaryGreen : Colors.white,
        borderRadius: BorderRadius.circular(25),
        elevation: 2,
        shadowColor: Colors.black26,
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: () {
            setState(() {
              _selectedFilter = value;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withAlpha(50)
                        : AppTheme.primaryGreen.withAlpha(30),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$count',
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppTheme.primaryGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.white.withAlpha(200), fontSize: 12),
          ),
          const SizedBox(width: 16),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutbreakDetail(OutbreakData outbreak) {
    return GlassCard(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(outbreak.severityColor).withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  outbreak.statusEmoji,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      outbreak.diseaseName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${outbreak.locationName}, ${outbreak.regency}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              StatusBadge(
                text: outbreak.statusText,
                color: Color(outbreak.severityColor),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildDetailStat(
                'Laporan',
                '${outbreak.reportCount}',
                Icons.report,
              ),
              _buildDetailStat(
                'Keparahan',
                '${outbreak.averageSeverity.toStringAsFixed(0)}%',
                Icons.speed,
              ),
              _buildDetailStat('Tanaman', outbreak.affectedCrop, Icons.eco),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Navigate to outbreak detail
                  },
                  icon: const Icon(Icons.info_outline),
                  label: Text('common.detail'.tr()),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryGreen,
                    side: const BorderSide(color: AppTheme.primaryGreen),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Report new case
                  },
                  icon: const Icon(Icons.add_a_photo),
                  label: Text('common.report'.tr()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primaryGreen),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
        ),
      ],
    );
  }
}
