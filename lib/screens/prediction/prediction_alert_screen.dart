// AgriVision NTB - Prediction Alert Screen
// Screen untuk prediksi wabah dan peringatan dini

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../models/prediction.dart';
import '../../models/disease.dart';
import '../encyclopedia/disease_detail_screen.dart';

class PredictionAlertScreen extends StatefulWidget {
  const PredictionAlertScreen({super.key});

  @override
  State<PredictionAlertScreen> createState() => _PredictionAlertScreenState();
}

class _PredictionAlertScreenState extends State<PredictionAlertScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedRegency = 'Lombok Tengah';

  final List<String> _regencies = [
    'Lombok Tengah',
    'Lombok Timur',
    'Lombok Barat',
    'Lombok Utara',
    'Sumbawa',
    'Dompu',
    'Bima',
  ];

  // Simulated predictions based on current conditions
  List<DiseasePrediction> get _predictions {
    return PredictionEngine.generatePredictions(
      regency: _selectedRegency,
      plantType: 'rice', // Could be dynamic based on user's farms
      temperature: 27,
      humidity: 88,
      rainfall: 120,
      month: DateTime.now().month,
    );
  }

  // Simulated alerts
  final List<EarlyWarningAlert> _alerts = [
    EarlyWarningAlert(
      id: 'alert_1',
      title: 'Waspada Serangan Wereng di Lombok Tengah',
      message:
          'Populasi wereng coklat meningkat di beberapa titik Kecamatan Praya. Lakukan monitoring intensif dan siapkan insektisida.',
      type: AlertType.pestInfestation,
      severity: AlertSeverity.warning,
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      regionAffected: 'Lombok Tengah',
      actionItems: [
        'Pasang perangkap lampu',
        'Monitor populasi harian',
        'Siapkan insektisida sistemik',
      ],
    ),
    EarlyWarningAlert(
      id: 'alert_2',
      title: 'Potensi Hujan Lebat 3 Hari ke Depan',
      message:
          'BMKG memprediksi curah hujan tinggi di wilayah NTB. Hindari penyemprotan dan amankan hasil panen.',
      type: AlertType.weatherWarning,
      severity: AlertSeverity.urgent,
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
      actionItems: [
        'Tunda aktivitas penyemprotan',
        'Percepat panen jika sudah siap',
        'Periksa drainase lahan',
      ],
    ),
    EarlyWarningAlert(
      id: 'alert_3',
      title: 'Harga Bawang Merah Naik 15%',
      message:
          'Harga bawang merah di pasar NTB naik signifikan. Petani bawang disarankan mempertimbangkan waktu panen optimal.',
      type: AlertType.marketPrice,
      severity: AlertSeverity.info,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      actionItems: ['Pantau harga pasar harian', 'Koordinasi dengan pengepul'],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 220,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFFE53935),
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
                tooltip: 'Kembali',
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFE53935), Color(0xFFC62828)],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 80, 24, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.auto_graph_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'prediction.title'.tr(),
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'prediction.subtitle'.tr(),
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white70,
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
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: Container(
                color: Colors.white,
                child: TabBar(
                  controller: _tabController,
                  labelColor: const Color(0xFFE53935),
                  unselectedLabelColor: Colors.grey[500],
                  indicatorColor: const Color(0xFFE53935),
                  indicatorWeight: 3,
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  tabs: [
                    Tab(
                      icon: Icon(Icons.auto_graph_rounded),
                      text: 'prediction.tab_predictions'.tr(),
                    ),
                    Tab(
                      icon: Icon(Icons.warning_amber_rounded),
                      text: 'prediction.tab_alerts'.tr(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [_buildPredictionsTab(), _buildAlertsTab()],
        ),
      ),
    );
  }

  Widget _buildPredictionsTab() {
    return Column(
      children: [
        // Region Selector
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            children: [
              Icon(Icons.location_on, color: Colors.grey[600], size: 20),
              const SizedBox(width: 8),
              Text('prediction.select_region'.tr() + ': '),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedRegency,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: _regencies
                          .map(
                            (r) => DropdownMenuItem(value: r, child: Text(r)),
                          )
                          .toList(),
                      onChanged: (v) {
                        if (v != null) setState(() => _selectedRegency = v);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Predictions List
        Expanded(
          child: _predictions.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _predictions.length,
                  itemBuilder: (context, index) {
                    return _PredictionCard(
                      prediction: _predictions[index],
                      index: index,
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildAlertsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _alerts.length,
      itemBuilder: (context, index) {
        return _AlertCard(alert: _alerts[index], index: index);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline, size: 80, color: Colors.green[200]),
          const SizedBox(height: 16),
          Text(
            'prediction.no_predictions'.tr(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${'prediction.safe_condition'.tr()} $_selectedRegency',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

class _PredictionCard extends StatelessWidget {
  final DiseasePrediction prediction;
  final int index;

  const _PredictionCard({required this.prediction, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _getRiskColor().withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _getRiskColor().withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _getRiskColor().withOpacity(0.2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Icon(
                      PredictionUIHelper.getRiskIcon(prediction.riskLevel),
                      size: 28,
                      color: _getRiskColor(),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prediction.diseaseName,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: _getRiskColor(),
                        ),
                      ),
                      Text(
                        prediction.plantType,
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
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
                    color: _getRiskColor(),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    prediction.riskText,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Timeline
                Row(
                  children: [
                    Icon(Icons.schedule, size: 18, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Text(
                      prediction.isImminent
                          ? '${'prediction.in_days'.tr()} ${prediction.daysUntilOutbreak} ${'prediction.days'.tr()}'
                          : '${prediction.daysUntilOutbreak} ${'prediction.days_until'.tr()}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: prediction.isImminent
                            ? Colors.red[700]
                            : Colors.grey[700],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      prediction.confidenceText.split(' ')[0],
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Contributing Factors
                Text(
                  'prediction.contributing_factors'.tr() + ':',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                ...prediction.contributingFactors.take(3).map((factor) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 6),
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            color: _getRiskColor(),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            factor,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 16),

                // Preventive Actions
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.verified_user,
                            color: Colors.green[700],
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'prediction.preventive_actions'.tr(),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[800],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ...prediction.preventiveActions
                          .take(3)
                          .toList()
                          .asMap()
                          .entries
                          .map((entry) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: Colors.green[100],
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${entry.key + 1}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green[800],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      entry.value,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.green[800],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Action Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      final disease = Disease.getById(prediction.diseaseId);
                      if (disease != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                DiseaseDetailScreen(disease: disease),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.info_outline, size: 18),
                    label: Text('prediction.view_disease_detail'.tr()),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _getRiskColor(),
                      side: BorderSide(color: _getRiskColor()),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: (100 * index).ms).slideY(begin: 0.1, end: 0);
  }

  Color _getRiskColor() {
    switch (prediction.riskLevel) {
      case RiskLevel.low:
        return Colors.green[600]!;
      case RiskLevel.moderate:
        return Colors.amber[700]!;
      case RiskLevel.high:
        return Colors.orange[700]!;
      case RiskLevel.critical:
        return Colors.red[700]!;
    }
  }
}

class _AlertCard extends StatelessWidget {
  final EarlyWarningAlert alert;
  final int index;

  const _AlertCard({required this.alert, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _getSeverityColor().withOpacity(0.3)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _getSeverityColor().withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  PredictionUIHelper.getAlertTypeIcon(alert.type),
                  size: 24,
                  color: _getSeverityColor(),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    alert.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: _getSeverityColor(),
                    ),
                  ),
                ),
                Icon(
                  Icons.warning_amber_rounded,
                  size: 20,
                  color: _getSeverityColor(),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert.message,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),

                // Action Items
                if (alert.actionItems.isNotEmpty) ...[
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: alert.actionItems.map((item) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 6),
                            Text(
                              item,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                ],

                // Timestamp
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14, color: Colors.grey[400]),
                    const SizedBox(width: 6),
                    Text(
                      _formatTime(alert.createdAt),
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                    if (alert.regionAffected != null) ...[
                      const SizedBox(width: 16),
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        alert.regionAffected!,
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: (80 * index).ms).slideX(begin: 0.05, end: 0);
  }

  Color _getSeverityColor() {
    switch (alert.severity) {
      case AlertSeverity.info:
        return Colors.blue[600]!;
      case AlertSeverity.warning:
        return Colors.amber[700]!;
      case AlertSeverity.urgent:
        return Colors.orange[700]!;
      case AlertSeverity.emergency:
        return Colors.red[700]!;
    }
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60)
      return '${diff.inMinutes} ${'prediction.minutes_ago'.tr()}';
    if (diff.inHours < 24)
      return '${diff.inHours} ${'prediction.hours_ago'.tr()}';
    return '${diff.inDays} ${'prediction.days_ago'.tr()}';
  }
}

class PredictionUIHelper {
  static IconData getRiskIcon(RiskLevel level) {
    switch (level) {
      case RiskLevel.critical:
        return Icons.dangerous;
      case RiskLevel.high:
        return Icons.warning;
      case RiskLevel.moderate:
        return Icons.info_outline;
      case RiskLevel.low:
        return Icons.check_circle_outline;
    }
  }

  static IconData getAlertTypeIcon(AlertType type) {
    switch (type) {
      case AlertType.pestInfestation:
        return Icons.bug_report;
      case AlertType.diseaseOutbreak:
        return Icons.coronavirus;
      case AlertType.weatherWarning:
        return Icons.thunderstorm;
      case AlertType.marketPrice:
        return Icons.attach_money;
      case AlertType.generalInfo:
        return Icons.info;
    }
  }
}
