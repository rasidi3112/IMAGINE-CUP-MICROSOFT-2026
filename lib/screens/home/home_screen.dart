// AgriVision NTB - Home Screen
// Layar utama aplikasi

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../config/app_theme.dart';
import '../../providers/app_provider.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/weather_alert_widgets.dart';
import '../../services/weather_alert_service.dart';
import '../scan/scan_screen.dart';
import '../consultation/consultation_screen.dart';
import '../map/outbreak_map_screen.dart';
import '../calendar/calendar_screen.dart';
import '../history/history_screen.dart';
import '../encyclopedia/encyclopedia_screen.dart';
import '../plant_guide/plant_guide_screen.dart';
import '../pesticide/pesticide_finder_screen.dart';
import '../weather/weather_dashboard_screen.dart';
import '../prediction/prediction_alert_screen.dart';
import '../farm/farm_management_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  final WeatherAlertService _alertService = WeatherAlertService();
  List<WeatherAlert> _weatherAlerts = [];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _loadWeatherAlerts();
  }

  Future<void> _loadWeatherAlerts() async {
    // Generate alerts based on current weather conditions
    // In production, this would use real weather API data
    final weather = _alertService.generateHighRiskWeather();
    final alerts = _alertService.generateAlerts(weather);
    if (mounted) {
      setState(() {
        _weatherAlerts = alerts;
      });
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 10) return '${'home.greeting_morning'.tr()} 🌅';
    if (hour < 15) return '${'home.greeting_afternoon'.tr()} ☀️';
    if (hour < 18) return '${'home.greeting_evening'.tr()} 🌇';
    return '${'home.greeting_night'.tr()} 🌙';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          return Stack(
            children: [
              // Background gradient
              Container(
                height: 280,
                decoration: const BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                ),
              ),

              // Main content
              SafeArea(
                child: CustomScrollView(
                  slivers: [
                    // Header
                    SliverToBoxAdapter(child: _buildHeader(provider)),

                    // Connectivity Banner
                    if (!provider.isOnline)
                      const SliverToBoxAdapter(
                        child: ConnectivityBanner(isOnline: false),
                      ),

                    // Quick Stats
                    SliverToBoxAdapter(child: _buildQuickStats(provider)),

                    // Weather Smart Alerts
                    if (_weatherAlerts.isNotEmpty)
                      SliverToBoxAdapter(child: _buildWeatherAlerts()),

                    // Main Features
                    SliverToBoxAdapter(child: _buildMainFeatures(context)),

                    // Recent Scans
                    SliverToBoxAdapter(child: _buildRecentScans(provider)),

                    // Upcoming Treatments
                    SliverToBoxAdapter(
                      child: _buildUpcomingTreatments(provider),
                    ),

                    // More Features Section
                    SliverToBoxAdapter(child: _buildMoreFeatures(context)),

                    // Bottom padding
                    const SliverToBoxAdapter(child: SizedBox(height: 100)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: _buildScanFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildHeader(AppProvider provider) {
    final userName = provider.currentUser?.name ?? 'Petani';

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getGreeting(),
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ).animate().fadeIn(duration: 500.ms),
                  const SizedBox(height: 4),
                  Text(
                    userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ).animate().fadeIn(delay: 200.ms, duration: 500.ms),
                ],
              ),
              Row(
                children: [
                  // Sync indicator
                  if (provider.isSyncing)
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(50),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(width: 8),
                  // Notification button
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CalendarScreen(),
                        ),
                      );
                    },
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(50),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.notifications_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Search bar (decorative)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(50),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withAlpha(100)),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.white70),
                const SizedBox(width: 12),
                Text(
                  'home.search_placeholder'.tr(),
                  style: TextStyle(
                    color: Colors.white.withAlpha(180),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 400.ms, duration: 500.ms),
        ],
      ),
    );
  }

  Widget _buildQuickStats(AppProvider provider) {
    final stats = provider.statistics;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 120,
        child: Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'home.total_scans'.tr(),
                value: '${stats['total_scans'] ?? 0}',
                icon: Icons.document_scanner,
                color: AppTheme.primaryGreen,
              ).animate().fadeIn(delay: 500.ms).slideX(begin: -0.2),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                title: 'home.diseased'.tr(),
                value: '${stats['diseases_detected'] ?? 0}',
                icon: Icons.bug_report,
                color: AppTheme.warningOrange,
              ).animate().fadeIn(delay: 600.ms).slideX(begin: 0.2),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                title: 'home.schedules'.tr(),
                value: '${stats['upcoming_treatments'] ?? 0}',
                icon: Icons.calendar_today,
                color: AppTheme.infoBlue,
              ).animate().fadeIn(delay: 700.ms).slideX(begin: 0.2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherAlerts() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.thunderstorm,
                color: AppTheme.warningOrange,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Smart Weather Alert',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          WeatherAlertSummary(
            alerts: _weatherAlerts,
            onViewAll: () => WeatherAlertsSheet.show(context, _weatherAlerts),
          ).animate().fadeIn(delay: 750.ms).slideY(begin: 0.1),
        ],
      ),
    );
  }

  Widget _buildMainFeatures(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'home.main_features'.tr(),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.1,
            children: [
              FeatureCard(
                    icon: Icons.camera_alt,
                    title: 'scan.title'.tr(),
                    subtitle: 'scan.take_photo'.tr(),
                    color: AppTheme.primaryGreen,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ScanScreen()),
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 800.ms)
                  .scale(begin: const Offset(0.8, 0.8)),
              FeatureCard(
                    icon: Icons.chat_bubble,
                    title: 'consultation.title'.tr(),
                    subtitle: 'consultation.ask_ai'.tr(),
                    color: AppTheme.infoBlue,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ConsultationScreen(),
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 900.ms)
                  .scale(begin: const Offset(0.8, 0.8)),
              FeatureCard(
                    icon: Icons.map,
                    title: 'map.title'.tr(),
                    subtitle: 'map.subtitle'.tr(),
                    color: AppTheme.warningOrange,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const OutbreakMapScreen(),
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 1000.ms)
                  .scale(begin: const Offset(0.8, 0.8)),
              FeatureCard(
                    icon: Icons.calendar_month,
                    title: 'calendar.title'.tr(),
                    subtitle: 'calendar.upcoming'.tr(),
                    color: AppTheme.dangerRed,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CalendarScreen()),
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 1100.ms)
                  .scale(begin: const Offset(0.8, 0.8)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentScans(AppProvider provider) {
    final recentScans = provider.scanResults.take(3).toList();

    if (recentScans.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'home.recent_scans'.tr(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HistoryScreen()),
                ),
                child: Text('home.view_all'.tr()),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...recentScans.map(
            (scan) => GlassCard(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              onTap: () {
                provider.setCurrentScanResult(scan);
                // Navigate to detail
              },
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen.withAlpha(30),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.eco,
                      color: AppTheme.primaryGreen,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          scan.detectedDisease?.nameIndonesia ??
                              'scan.healthy_plant'.tr(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          scan.plantType,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      StatusBadge(
                        text: scan.severityText,
                        color: scan.detectedDisease != null
                            ? AppTheme.dangerRed
                            : AppTheme.successGreen,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${scan.confidenceScore.toStringAsFixed(0)}%',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
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

  Widget _buildUpcomingTreatments(AppProvider provider) {
    final upcoming = provider.upcomingSchedules.take(2).toList();

    if (upcoming.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'home.upcoming_treatments'.tr(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CalendarScreen()),
                ),
                child: Text('home.view_all'.tr()),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...upcoming.map(
            (schedule) => GlassCard(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppTheme.infoBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getTreatmentIcon(schedule.treatmentType),
                      color: AppTheme.infoBlue,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          schedule.treatmentName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          schedule.dosage,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  StatusBadge(
                    text: schedule.statusText,
                    color:
                        schedule.scheduledDate
                                .difference(DateTime.now())
                                .inDays ==
                            0
                        ? AppTheme.dangerRed
                        : AppTheme.infoBlue,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoreFeatures(BuildContext context) {
    final features = [
      {
        'icon': Icons.menu_book_rounded,
        'title': 'more_features.encyclopedia'.tr(),
        'subtitle': 'more_features.encyclopedia_desc'.tr(),
        'color': const Color(0xFF7B1FA2),
        'screen': const EncyclopediaScreen(),
      },
      {
        'icon': Icons.local_florist_rounded,
        'title': 'more_features.plant_guide'.tr(),
        'subtitle': 'more_features.plant_guide_desc'.tr(),
        'color': const Color(0xFF43A047),
        'screen': const PlantGuideScreen(),
      },
      {
        'icon': Icons.medication_liquid_rounded,
        'title': 'more_features.pesticide'.tr(),
        'subtitle': 'more_features.pesticide_desc'.tr(),
        'color': const Color(0xFF5C6BC0),
        'screen': const PesticideFinderScreen(),
      },
      {
        'icon': Icons.cloud_sync_rounded,
        'title': 'more_features.weather'.tr(),
        'subtitle': 'more_features.weather_desc'.tr(),
        'color': const Color(0xFF0288D1),
        'screen': const WeatherDashboardScreen(),
      },
      {
        'icon': Icons.auto_graph_rounded,
        'title': 'more_features.prediction'.tr(),
        'subtitle': 'more_features.prediction_desc'.tr(),
        'color': const Color(0xFFE53935),
        'screen': const PredictionAlertScreen(),
      },
      {
        'icon': Icons.landscape_rounded,
        'title': 'more_features.farm'.tr(),
        'subtitle': 'more_features.farm_desc'.tr(),
        'color': const Color(0xFF2E7D32),
        'screen': const FarmManagementScreen(),
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'more_features.title'.tr(),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 110,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: features.length,
              itemBuilder: (context, index) {
                final feature = features[index];
                return Container(
                      width: 100,
                      margin: const EdgeInsets.only(right: 12),
                      child: Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        elevation: 2,
                        shadowColor: Colors.black12,
                        child: InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => feature['screen'] as Widget,
                            ),
                          ),
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: (feature['color'] as Color)
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      feature['icon'] as IconData,
                                      color: feature['color'] as Color,
                                      size: 24,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  feature['title'] as String,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                    .animate()
                    .fadeIn(delay: (100 * index).ms)
                    .slideX(begin: 0.1, end: 0);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanFAB() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (_pulseController.value * 0.05),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryGreen.withAlpha(
                    (100 + (_pulseController.value * 50)).toInt(),
                  ),
                  blurRadius: 20 + (_pulseController.value * 10),
                  spreadRadius: 2,
                ),
              ],
            ),
            child: FloatingActionButton.large(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ScanScreen()),
              ),
              backgroundColor: AppTheme.primaryGreen,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt, size: 32, color: Colors.white),
                  SizedBox(height: 4),
                  Text(
                    'SCAN',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _getTreatmentIcon(String type) {
    switch (type.toLowerCase()) {
      case 'pesticide':
      case 'pestisida':
        return Icons.science_outlined;
      case 'fungicide':
      case 'fungisida':
        return Icons.coronavirus_outlined;
      case 'fertilizer':
      case 'pupuk':
        return Icons.compost;
      case 'organic':
      case 'organik':
        return Icons.eco_outlined;
      case 'watering':
      case 'penyiraman':
        return Icons.water_drop_outlined;
      default:
        return Icons.agriculture_outlined;
    }
  }
}
