import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/weather_alert_service.dart';
import '../config/app_theme.dart';

/// Widget card untuk single alert
class WeatherAlertCard extends StatelessWidget {
  final WeatherAlert alert;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  const WeatherAlertCard({
    super.key,
    required this.alert,
    this.onTap,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(alert.id),
      direction: onDismiss != null
          ? DismissDirection.endToStart
          : DismissDirection.none,
      onDismissed: (_) => onDismiss?.call(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: alert.level.color.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: alert.level.color.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with level indicator
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: alert.level.color.withOpacity(0.1),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(14),
                  ),
                ),
                child: Row(
                  children: [
                    // Level icon
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: alert.level.color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        alert.level.icon,
                        color: alert.level.color,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Title
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            alert.title,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Icon(
                                alert.category.icon,
                                size: 12,
                                color: Colors.grey.shade500,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                alert.category.name,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Level badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: alert.level.color,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        alert.level.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alert.message,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                        height: 1.4,
                      ),
                    ),
                    // Affected plants
                    if (alert.affectedPlants.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: alert.affectedPlants.map((plant) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryGreen.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppTheme.primaryGreen.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  '🌱',
                                  style: TextStyle(fontSize: 12),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  plant,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppTheme.primaryGreen,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                    // Action button
                    if (alert.actionText != null) ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: onTap,
                          icon: Icon(Icons.arrow_forward, size: 16),
                          label: Text(alert.actionText!),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: alert.level.color,
                            side: BorderSide(color: alert.level.color),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Summary card untuk menampilkan ringkasan alerts
class WeatherAlertSummary extends StatelessWidget {
  final List<WeatherAlert> alerts;
  final VoidCallback? onViewAll;

  const WeatherAlertSummary({super.key, required this.alerts, this.onViewAll});

  @override
  Widget build(BuildContext context) {
    final counts = WeatherAlertService().getAlertCounts(alerts);
    final dangerCount = counts[AlertLevel.danger] ?? 0;
    final warningCount = counts[AlertLevel.warning] ?? 0;

    Color cardColor;
    IconData cardIcon;
    String cardTitle;
    String cardSubtitle;

    if (dangerCount > 0) {
      cardColor = AlertLevel.danger.color;
      cardIcon = Icons.dangerous_rounded;
      cardTitle = '$dangerCount Peringatan Bahaya!';
      cardSubtitle = 'Perlu tindakan segera';
    } else if (warningCount > 0) {
      cardColor = AlertLevel.warning.color;
      cardIcon = Icons.warning_amber_rounded;
      cardTitle = '$warningCount Perlu Perhatian';
      cardSubtitle = 'Pantau kondisi tanaman Anda';
    } else {
      cardColor = AppTheme.successGreen;
      cardIcon = Icons.check_circle_outline;
      cardTitle = 'Kondisi Aman';
      cardSubtitle = 'Tidak ada peringatan saat ini';
    }

    return GestureDetector(
      onTap: onViewAll,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [cardColor, cardColor.withOpacity(0.8)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: cardColor.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(cardIcon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cardTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    cardSubtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            // Count badges
            Row(
              children: [
                if (dangerCount > 0)
                  _buildCountBadge(dangerCount, AlertLevel.danger),
                if (warningCount > 0)
                  _buildCountBadge(warningCount, AlertLevel.warning),
              ],
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white.withOpacity(0.7),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountBadge(int count, AlertLevel level) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(level.icon, size: 14, color: level.color),
          const SizedBox(width: 4),
          Text(
            '$count',
            style: TextStyle(
              color: level.color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

/// Full-screen bottom sheet untuk list semua alerts
class WeatherAlertsSheet extends StatelessWidget {
  final List<WeatherAlert> alerts;

  const WeatherAlertsSheet({super.key, required this.alerts});

  static void show(BuildContext context, List<WeatherAlert> alerts) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => WeatherAlertsSheet(alerts: alerts),
    );
  }

  @override
  Widget build(BuildContext context) {
    final counts = WeatherAlertService().getAlertCounts(alerts);

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Icon(
                  Icons.notifications_active,
                  color: AppTheme.primaryGreen,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Smart Weather Alerts',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${alerts.length} peringatan aktif',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          // Alert count summary
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _buildSummaryChip(
                  '🚨',
                  '${counts[AlertLevel.danger] ?? 0} Bahaya',
                  AlertLevel.danger.color,
                ),
                const SizedBox(width: 10),
                _buildSummaryChip(
                  '⚠️',
                  '${counts[AlertLevel.warning] ?? 0} Perhatian',
                  AlertLevel.warning.color,
                ),
                const SizedBox(width: 10),
                _buildSummaryChip(
                  'ℹ️',
                  '${counts[AlertLevel.info] ?? 0} Info',
                  AlertLevel.info.color,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          // Alerts list
          Expanded(
            child: alerts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 64,
                          color: AppTheme.successGreen.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Tidak ada peringatan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Kondisi cuaca aman untuk pertanian',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: alerts.length,
                    itemBuilder: (context, index) {
                      final alert = alerts[index];
                      return WeatherAlertCard(
                            alert: alert,
                            onTap: () => _handleAlertTap(context, alert),
                          )
                          .animate()
                          .fadeIn(delay: Duration(milliseconds: index * 100))
                          .slideY(begin: 0.1);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryChip(String emoji, String text, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
            Text(
              text,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleAlertTap(BuildContext context, WeatherAlert alert) {
    // Close the bottom sheet first
    Navigator.pop(context);

    // Show detailed prevention/action bottom sheet - TO THE POINT!
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _DiseasePreventionSheet(alert: alert),
    );
  }
}

/// Compact alert banner untuk home screen
class WeatherAlertBanner extends StatelessWidget {
  final WeatherAlert alert;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  const WeatherAlertBanner({
    super.key,
    required this.alert,
    this.onTap,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: alert.level.color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: alert.level.color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(alert.level.icon, color: alert.level.color, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    alert.title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    alert.message,
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (onDismiss != null)
              GestureDetector(
                onTap: onDismiss,
                child: Icon(Icons.close, size: 18, color: Colors.grey.shade400),
              )
            else
              Icon(Icons.chevron_right, size: 20, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}

/// Direct prevention info sheet - TO THE POINT!
class _DiseasePreventionSheet extends StatelessWidget {
  final WeatherAlert alert;

  const _DiseasePreventionSheet({required this.alert});

  @override
  Widget build(BuildContext context) {
    final prevention = _getPreventionData(alert.diseaseId ?? '');

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header with alert level color
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [alert.level.color, alert.level.color.withOpacity(0.8)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    alert.category == AlertCategory.disease
                        ? Icons.coronavirus
                        : alert.category.icon,
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
                        prevention['name'] ?? alert.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        alert.message,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Content - scrollable
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Affected Plants
                  if (alert.affectedPlants.isNotEmpty) ...[
                    _buildSection(
                      icon: Icons.eco,
                      title: 'Tanaman Terdampak',
                      color: AppTheme.primaryGreen,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: alert.affectedPlants.map((plant) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryGreen.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppTheme.primaryGreen.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              '🌱 $plant',
                              style: const TextStyle(
                                color: AppTheme.primaryGreen,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Symptoms
                  if (prevention['symptoms'] != null) ...[
                    _buildSection(
                      icon: Icons.search,
                      title: 'Gejala',
                      color: Colors.orange,
                      child: Column(
                        children: (prevention['symptoms'] as List<String>)
                            .map((s) => _buildBulletPoint(s, Colors.orange))
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Prevention Steps
                  _buildSection(
                    icon: Icons.shield,
                    title: 'Langkah Pencegahan',
                    color: AppTheme.primaryGreen,
                    child: Column(
                      children: (prevention['prevention'] as List<String>)
                          .asMap()
                          .entries
                          .map((e) => _buildNumberedStep(e.key + 1, e.value))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Treatment
                  if (prevention['treatment'] != null) ...[
                    _buildSection(
                      icon: Icons.medical_services,
                      title: 'Pengobatan',
                      color: Colors.blue,
                      child: Column(
                        children: (prevention['treatment'] as List<String>)
                            .map((t) => _buildBulletPoint(t, Colors.blue))
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Quick Tip
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.amber.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.lightbulb,
                          color: Colors.amber.shade700,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tips Cepat',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber.shade800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                prevention['quickTip'] ??
                                    alert.actionText ??
                                    'Pantau tanaman secara rutin.',
                                style: TextStyle(
                                  color: Colors.amber.shade900,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          // Action Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.check_circle),
                label: const Text('Mengerti'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required Color color,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        child,
      ],
    );
  }

  Widget _buildBulletPoint(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.grey.shade700, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberedStep(int number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                '$number',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.grey.shade700, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  /// Get prevention data based on disease ID
  Map<String, dynamic> _getPreventionData(String diseaseId) {
    final data = {
      'rice_blast': {
        'name': 'Penyakit Blas Padi',
        'symptoms': [
          'Bercak berbentuk belah ketupat pada daun',
          'Bercak berwarna abu-abu atau coklat',
          'Leher malai busuk dan patah',
        ],
        'prevention': [
          'Gunakan varietas padi tahan blas',
          'Atur jarak tanam yang tepat (25x25 cm)',
          'Hindari pemupukan nitrogen berlebihan',
          'Jaga sanitasi lahan dengan membersihkan jerami',
          'Pantau kelembaban dengan drainase yang baik',
        ],
        'treatment': [
          'Semprotkan fungisida berbahan aktif Tricyclazole',
          'Aplikasi fungisida pada pagi atau sore hari',
          'Ulangi penyemprotan setiap 7-10 hari jika perlu',
        ],
        'quickTip':
            'Segera cabut dan musnahkan tanaman terinfeksi berat untuk mencegah penyebaran.',
      },
      'corn_downy_mildew': {
        'name': 'Penyakit Bulai Jagung',
        'symptoms': [
          'Garis-garis putih/kuning sejajar tulang daun',
          'Daun menggulung dan kerdil',
          'Tanaman tidak berbuah atau tongkol kecil',
        ],
        'prevention': [
          'Gunakan benih jagung berlabel dan bersertifikat',
          'Tanam varietas toleran bulai',
          'Perlakukan benih dengan fungisida sebelum tanam',
          'Rotasi tanaman dengan non-serealia',
          'Eradikasi gulma inang di sekitar lahan',
        ],
        'treatment': [
          'Aplikasi fungisida Metalaxyl pada awal gejala',
          'Cabut tanaman terinfeksi berat',
          'Jangan menanam jagung di lahan yang sama 2 musim berturut',
        ],
        'quickTip':
            'Periksa tanaman setiap pagi saat embun - gejala bulai lebih jelas terlihat.',
      },
      'chili_anthracnose': {
        'name': 'Penyakit Antraknosa Cabai',
        'symptoms': [
          'Bercak cekung berwarna coklat pada buah',
          'Bercak membesar dengan titik hitam konsentris',
          'Buah busuk dan rontok prematur',
        ],
        'prevention': [
          'Gunakan benih sehat dan bebas penyakit',
          'Atur jarak tanam minimal 60x50 cm',
          'Hindari penyiraman dari atas (gunakan drip)',
          'Mulsa plastik untuk mencegah percikan tanah',
          'Panen buah matang tepat waktu',
        ],
        'treatment': [
          'Semprotkan fungisida Mankozeb atau Propineb',
          'Buang dan musnahkan buah terinfeksi',
          'Aplikasi setiap 5-7 hari saat musim hujan',
        ],
        'quickTip':
            'Jangan menyentuh tanaman sehat setelah memegang yang sakit tanpa cuci tangan!',
      },
      'onion_purple_blotch': {
        'name': 'Penyakit Bercak Ungu Bawang',
        'symptoms': [
          'Bercak lonjong berwarna ungu pada daun',
          'Bercak dengan zona konsentris',
          'Daun mengering dari ujung',
        ],
        'prevention': [
          'Rotasi tanaman minimal 2 tahun',
          'Gunakan bibit sehat dari umbi berkualitas',
          'Atur drainase yang baik',
          'Jarak tanam yang cukup untuk sirkulasi udara',
          'Hindari luka mekanis saat penyiangan',
        ],
        'treatment': [
          'Semprotkan fungisida Klorotalonil',
          'Aplikasi saat gejala awal muncul',
          'Kombinasi dengan Mankozeb untuk hasil lebih baik',
        ],
        'quickTip':
            'Panen saat cuaca cerah dan keringkan umbi sebelum penyimpanan.',
      },
    };

    // Default prevention for non-disease alerts or unknown diseases
    return data[diseaseId] ??
        {
          'name': alert.title,
          'symptoms': null,
          'prevention': [
            'Pantau kondisi cuaca secara rutin',
            'Periksa tanaman setiap pagi',
            'Jaga kebersihan lahan',
            'Gunakan pupuk seimbang',
            'Konsultasi dengan penyuluh pertanian',
          ],
          'treatment': null,
          'quickTip':
              alert.actionText ?? 'Tetap waspada dan pantau kondisi tanaman.',
        };
  }
}
