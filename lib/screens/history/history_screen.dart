// AgriVision NTB - History Screen
// Layar riwayat scan

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:io';
import '../../config/app_theme.dart';
import '../../providers/app_provider.dart';
import '../../widgets/common_widgets.dart';
import '../../utils/helpers.dart';
import '../scan/scan_result_screen.dart';
import '../scan/scan_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _selectedFilter = 'all';
  String _sortBy = 'date';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          var scanResults = provider.scanResults;

          // Apply filter
          if (_selectedFilter == 'disease') {
            scanResults = scanResults
                .where((r) => r.detectedDisease != null)
                .toList();
          } else if (_selectedFilter == 'healthy') {
            scanResults = scanResults
                .where((r) => r.detectedDisease == null)
                .toList();
          } else if (_selectedFilter == 'unsynced') {
            scanResults = scanResults.where((r) => !r.isSynced).toList();
          }

          // Sort
          if (_sortBy == 'severity') {
            scanResults.sort(
              (a, b) => b.severityPercentage.compareTo(a.severityPercentage),
            );
          } else if (_sortBy == 'plant') {
            scanResults.sort((a, b) => a.plantType.compareTo(b.plantType));
          }

          return CustomScrollView(
            slivers: [
              // App bar
              SliverAppBar(
                expandedHeight: 160,
                pinned: true,
                backgroundColor: AppTheme.primaryGreen,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            // Title
                            Text(
                              'history.title'.tr(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Stats row
                            Row(
                              children: [
                                _buildStatBubble(
                                  '${provider.scanResults.length}',
                                  'history.filter_all'.tr(),
                                  Icons.document_scanner,
                                ),
                                const SizedBox(width: 12),
                                _buildStatBubble(
                                  '${provider.scanResults.where((r) => r.detectedDisease != null).length}',
                                  'home.diseased'.tr(),
                                  Icons.bug_report,
                                ),
                                const SizedBox(width: 12),
                                _buildStatBubble(
                                  '${provider.scanResults.where((r) => !r.isSynced).length}',
                                  'status.pending'.tr(),
                                  Icons.cloud_upload,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                actions: [
                  if (provider.scanResults.any((r) => !r.isSynced))
                    IconButton(
                      onPressed: () async {
                        final result = await provider.syncPendingData();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(result.message),
                              backgroundColor: result.success
                                  ? AppTheme.successGreen
                                  : AppTheme.warningOrange,
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.cloud_sync),
                    ),
                ],
              ),

              // Filter & Sort
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Filter chips
                      SizedBox(
                        height: 40,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildFilterChip('all', 'history.filter_all'.tr()),
                            _buildFilterChip(
                              'disease',
                              'history.filter_diseased'.tr(),
                            ),
                            _buildFilterChip(
                              'healthy',
                              'history.filter_healthy'.tr(),
                            ),
                            _buildFilterChip(
                              'unsynced',
                              'history.unsynced'.tr(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Sort dropdown
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${scanResults.length} ${'history.results_found'.tr()}',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                          DropdownButton<String>(
                            value: _sortBy,
                            underline: const SizedBox(),
                            icon: const Icon(Icons.sort),
                            items: [
                              DropdownMenuItem(
                                value: 'date',
                                child: Text('history.sort_latest'.tr()),
                              ),
                              DropdownMenuItem(
                                value: 'severity',
                                child: Text('history.sort_severity'.tr()),
                              ),
                              DropdownMenuItem(
                                value: 'plant',
                                child: Text('history.sort_plant'.tr()),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _sortBy = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Results list
              if (scanResults.isEmpty)
                SliverFillRemaining(
                  child: EmptyStateWidget(
                    icon: Icons.history,
                    title: 'history.no_history'.tr(),
                    subtitle: 'history.scan_history_empty'.tr(),
                    buttonText: 'scan.scan_now'.tr(),
                    onButtonPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ScanScreen()),
                      );
                    },
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final result = scanResults[index];
                    return _buildHistoryCard(result, provider, index);
                  }, childCount: scanResults.length),
                ),

              // Bottom padding
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatBubble(String value, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(30),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withAlpha(200),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = _selectedFilter == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        key: ValueKey('chip_$value'),
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedFilter = value;
          });
        },
        backgroundColor: Colors.white,
        selectedColor: AppTheme.primaryGreen.withAlpha(30),
        checkmarkColor: AppTheme.primaryGreen,
        labelStyle: TextStyle(
          color: isSelected ? AppTheme.primaryGreen : Colors.grey.shade700,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 13,
        ),
        side: BorderSide(
          color: isSelected ? AppTheme.primaryGreen : Colors.grey.shade300,
        ),
      ),
    );
  }

  Widget _buildHistoryCard(dynamic result, AppProvider provider, int index) {
    final hasDisease = result.detectedDisease != null;

    return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: GlassCard(
            margin: EdgeInsets.zero,
            onTap: () {
              provider.setCurrentScanResult(result);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ScanResultScreen(scanResult: result),
                ),
              );
            },
            child: Row(
              children: [
                // Image thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 70,
                    height: 70,
                    child: File(result.imagePath).existsSync()
                        ? Image.file(File(result.imagePath), fit: BoxFit.cover)
                        : Container(
                            color: AppTheme.primaryGreen.withAlpha(30),
                            child: const Icon(
                              Icons.eco,
                              color: AppTheme.primaryGreen,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 16),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              hasDisease
                                  ? result.detectedDisease!.nameIndonesia
                                  : 'scan.healthy_plant'.tr(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (!result.isSynced)
                            const Icon(
                              Icons.cloud_off,
                              size: 16,
                              color: AppTheme.warningOrange,
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.eco,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            result.plantType,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat(
                              'd MMM',
                              getSafeDateLocale(context),
                            ).format(result.scanDate),
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      if (result.locationName != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 14,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                result.locationName!,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 11,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                // Severity indicator
                Column(
                  children: [
                    SeverityIndicator(
                      percentage: hasDisease ? result.severityPercentage : 0,
                      size: 50,
                    ),
                    const SizedBox(height: 4),
                    StatusBadge(
                      text: hasDisease
                          ? result.severityText
                          : 'common.healthy'.tr(),
                      color: hasDisease
                          ? _getSeverityColor(result.severityLevel)
                          : AppTheme.successGreen,
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
        .animate(delay: Duration(milliseconds: index * 50))
        .fadeIn()
        .slideX(begin: 0.1);
  }

  Color _getSeverityColor(dynamic severityLevel) {
    switch (severityLevel.index) {
      case 0:
        return AppTheme.successGreen;
      case 1:
        return AppTheme.severityLow;
      case 2:
        return AppTheme.severityMedium;
      case 3:
        return AppTheme.severityHigh;
      case 4:
        return AppTheme.severityCritical;
      default:
        return AppTheme.successGreen;
    }
  }
}
