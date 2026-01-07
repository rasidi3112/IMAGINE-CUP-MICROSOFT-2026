// AgriVision NTB - Profile Screen
// Layar profil pengguna dengan fitur edit

import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../config/app_theme.dart';
import '../../models/user.dart';
import '../../models/gamification.dart';
import '../../providers/app_provider.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/language_switcher.dart';
import '../../widgets/gamification_widgets.dart';
import '../../services/notification_service.dart';
import '../../services/local_storage_service.dart';
import '../../services/voice_output_service.dart';
import '../../services/gamification_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;
  bool _voiceEnabled = false;

  final NotificationService _notificationService = NotificationService();
  final LocalStorageService _localStorage = LocalStorageService();
  final VoiceOutputService _voiceService = VoiceOutputService();
  final GamificationService _gamificationService = GamificationService();

  GamificationData _gamificationData = const GamificationData();

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _loadGamificationData();
  }

  Future<void> _loadGamificationData() async {
    await _gamificationService.initialize();
    if (mounted) {
      setState(() {
        _gamificationData = _gamificationService.data;
      });
    }
  }

  Future<void> _loadSettings() async {
    final notifEnabled = await _localStorage.getNotificationSetting();
    await _voiceService.initialize();
    setState(() {
      _notificationsEnabled = notifEnabled;
      _voiceEnabled = _voiceService.isEnabled;
    });
    _notificationService.setNotificationsEnabled(notifEnabled);
  }

  Future<void> _toggleNotifications(bool value) async {
    setState(() {
      _notificationsEnabled = value;
    });
    await _localStorage.saveNotificationSetting(value);
    _notificationService.setNotificationsEnabled(value);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            value ? 'Notifikasi diaktifkan' : 'Notifikasi dinonaktifkan',
          ),
          backgroundColor: value
              ? AppTheme.successGreen
              : AppTheme.warningOrange,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _toggleVoiceOutput(bool value) async {
    await _voiceService.setEnabled(value);
    setState(() {
      _voiceEnabled = value;
    });

    if (value) {
      _voiceService.speak('voice.activated_message'.tr());
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(value ? 'voice.enabled'.tr() : 'voice.disabled'.tr()),
          backgroundColor: value
              ? AppTheme.successGreen
              : AppTheme.warningOrange,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          final user = provider.currentUser;

          if (user == null) {
            return Center(child: Text('common.login_required'.tr()));
          }

          return CustomScrollView(
            slivers: [
              // Header with profile
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                backgroundColor: AppTheme.primaryGreen,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                    ),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),
                          // Profile avatar
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(50),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.person,
                                size: 50,
                                color: AppTheme.primaryGreen,
                              ),
                            ),
                          ).animate().scale(
                            duration: 500.ms,
                            curve: Curves.elasticOut,
                          ),
                          const SizedBox(height: 16),
                          // Name
                          Text(
                            user.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ).animate().fadeIn(delay: 200.ms),
                          const SizedBox(height: 4),
                          // Location
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.white70,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${user.regency}, NTB',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ).animate().fadeIn(delay: 300.ms),
                        ],
                      ),
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () => _showEditProfile(context, user, provider),
                    icon: const Icon(Icons.edit, color: Colors.white),
                  ),
                ],
              ),

              // Stats cards
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.camera_alt,
                          value: '${user.totalScans}',
                          label: 'profile.total_scan'.tr(),
                          color: AppTheme.infoBlue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.coronavirus,
                          value: '${user.diseasesDetected}',
                          label: 'profile.diseases'.tr(),
                          color: AppTheme.warningOrange,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.calendar_month,
                          value: '${provider.schedules.length}',
                          label: 'profile.schedule'.tr(),
                          color: AppTheme.primaryGreen,
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
                ),
              ),

              // Gamification Section - Level & Badges
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Level Progress Card
                      LevelProgressCard(
                        data: _gamificationData,
                        onTap: () => _showBadgesSheet(context),
                      ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2),
                      const SizedBox(height: 20),

                      // Badges Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Badge Saya',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          TextButton(
                            onPressed: () => _showBadgesSheet(context),
                            child: Text(
                              'Lihat Semua',
                              style: TextStyle(
                                color: AppTheme.primaryGreen,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Badge Grid (only unlocked, max 8)
                      _buildBadgePreview(),
                    ],
                  ),
                ),
              ),

              // Info sections
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'profile.title'.tr(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      _buildInfoTile(
                        icon: Icons.phone,
                        title: 'profile.phone'.tr(),
                        value: user.phone.isNotEmpty ? user.phone : '-',
                      ),
                      _buildInfoTile(
                        icon: Icons.home,
                        title: 'profile.village'.tr(),
                        value: user.village.isNotEmpty
                            ? '${user.village}, ${user.district}'
                            : '-',
                      ),
                      _buildInfoTile(
                        icon: Icons.location_city,
                        title: 'profile.regency'.tr(),
                        value: user.regency,
                      ),

                      const SizedBox(height: 24),

                      Text(
                        'profile.farm_info'.tr(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      _buildInfoTile(
                        icon: Icons.eco,
                        title: 'profile.farm_types'.tr(),
                        value: user.farmTypes.isNotEmpty
                            ? user.farmTypes.join(', ')
                            : '-',
                      ),
                      _buildInfoTile(
                        icon: Icons.square_foot,
                        title: 'profile.farm_area'.tr(),
                        value: user.farmArea > 0
                            ? '${user.farmArea} Hektar'
                            : '-',
                      ),
                      _buildInfoTile(
                        icon: Icons.calendar_today,
                        title: 'profile.joined_since'.tr(),
                        value: _formatDate(user.registeredAt),
                      ),

                      const SizedBox(height: 24),

                      Text(
                        'profile.settings'.tr(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),

              // Settings options
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      _buildSettingsTile(
                        icon: Icons.notifications,
                        title: 'profile.notifications'.tr(),
                        subtitle: 'calendar.upcoming'.tr(),
                        onTap: () =>
                            _toggleNotifications(!_notificationsEnabled),
                        trailing: Switch(
                          value: _notificationsEnabled,
                          onChanged: _toggleNotifications,
                          activeColor: AppTheme.primaryGreen,
                        ),
                      ),
                      // Voice Output for elderly farmers
                      _buildSettingsTile(
                        icon: Icons.record_voice_over,
                        title: 'voice.title'.tr(),
                        subtitle: 'voice.subtitle'.tr(),
                        onTap: () => _toggleVoiceOutput(!_voiceEnabled),
                        trailing: Switch(
                          value: _voiceEnabled,
                          onChanged: _toggleVoiceOutput,
                          activeColor: AppTheme.primaryGreen,
                        ),
                      ),
                      _buildSettingsTile(
                        icon: Icons.dark_mode,
                        title: 'profile.dark_mode'.tr(),
                        subtitle: 'profile.settings'.tr(),
                        onTap: () => provider.toggleTheme(),
                        trailing: Switch(
                          value: provider.themeMode == ThemeMode.dark,
                          onChanged: (value) {
                            provider.toggleTheme();
                          },
                          activeColor: AppTheme.primaryGreen,
                        ),
                      ),
                      _buildLanguageSwitcher(context),

                      _buildSettingsTile(
                        icon: Icons.cloud_sync,
                        title: 'profile.sync'.tr(),
                        subtitle: provider.isOnline
                            ? 'profile.connected'.tr()
                            : 'profile.offline'.tr(),
                        trailing: Icon(
                          provider.isOnline
                              ? Icons.cloud_done
                              : Icons.cloud_off,
                          color: provider.isOnline
                              ? AppTheme.successGreen
                              : AppTheme.warningOrange,
                        ),
                      ),
                      _buildSettingsTile(
                        icon: Icons.help_outline,
                        title: 'profile.help'.tr(),
                        subtitle: 'profile.faq_guide'.tr(),
                        onTap: () => _showHelpDialog(context),
                      ),
                      _buildSettingsTile(
                        icon: Icons.info_outline,
                        title: 'profile.about'.tr(),
                        subtitle: 'about.version'.tr(),
                        onTap: () => _showAboutDialog(context),
                      ),

                      const SizedBox(height: 24),

                      // Logout button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () =>
                              _showLogoutConfirmation(context, provider),
                          icon: const Icon(
                            Icons.logout,
                            color: AppTheme.dangerRed,
                          ),
                          label: Text(
                            'profile.logout'.tr(),
                            style: const TextStyle(color: AppTheme.dangerRed),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: AppTheme.dangerRed),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return GlassCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Icon(icon, size: 28, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withAlpha(20),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppTheme.primaryGreen, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.primaryGreen.withAlpha(20),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppTheme.primaryGreen, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        trailing: trailing ?? const Icon(Icons.chevron_right),
      ),
    );
  }

  Widget _buildLanguageSwitcher(BuildContext context) {
    final currentLocale = context.locale;
    final currentLang = AppLanguages.getByCode(currentLocale.languageCode);

    return GlassCard(
      margin: const EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.zero,
      onTap: () => LanguageSelectorDialog.show(context),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.primaryGreen.withAlpha(20),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.language,
            color: AppTheme.primaryGreen,
            size: 20,
          ),
        ),
        title: Text(
          'profile.language'.tr(),
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          '${currentLang.nativeName} (${currentLang.region})',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.primaryGreen.withAlpha(20),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            currentLang.code.toUpperCase(),
            style: const TextStyle(
              color: AppTheme.primaryGreen,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  void _showEditProfile(BuildContext context, User user, AppProvider provider) {
    final nameController = TextEditingController(text: user.name);
    final phoneController = TextEditingController(text: user.phone);
    final villageController = TextEditingController(text: user.village);
    String selectedRegency = user.regency;
    String selectedDistrict = user.district;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Container(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'profile.edit_profile'.tr(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'profile.name'.tr(),
                    prefixIcon: const Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'profile.phone'.tr(),
                    prefixIcon: const Icon(Icons.phone),
                  ),
                ),
                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  value: NTBRegions.regencies.contains(selectedRegency)
                      ? selectedRegency
                      : NTBRegions.regencies.first,
                  decoration: InputDecoration(
                    labelText: 'profile.regency'.tr(),
                    prefixIcon: const Icon(Icons.location_city),
                  ),
                  items: NTBRegions.regencies.map((regency) {
                    return DropdownMenuItem(
                      value: regency,
                      child: Text(regency),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setSheetState(() {
                      selectedRegency = value!;
                      final districts = NTBRegions.districts[selectedRegency];
                      if (districts != null && districts.isNotEmpty) {
                        selectedDistrict = districts.first;
                      }
                    });
                  },
                ),
                const SizedBox(height: 16),

                if (NTBRegions.districts[selectedRegency] != null)
                  DropdownButtonFormField<String>(
                    value:
                        NTBRegions.districts[selectedRegency]!.contains(
                          selectedDistrict,
                        )
                        ? selectedDistrict
                        : NTBRegions.districts[selectedRegency]!.first,
                    decoration: InputDecoration(
                      labelText: 'profile.district'.tr(),
                      prefixIcon: const Icon(Icons.map),
                    ),
                    items: NTBRegions.districts[selectedRegency]!.map((
                      district,
                    ) {
                      return DropdownMenuItem(
                        value: district,
                        child: Text(district),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setSheetState(() {
                        selectedDistrict = value!;
                      });
                    },
                  ),
                const SizedBox(height: 16),

                TextField(
                  controller: villageController,
                  decoration: InputDecoration(
                    labelText: 'profile.village'.tr(),
                    prefixIcon: const Icon(Icons.home),
                  ),
                ),
                const SizedBox(height: 24),

                GradientButton(
                  text: 'common.save'.tr(),
                  onPressed: () async {
                    final updatedUser = user.copyWith(
                      name: nameController.text,
                      phone: phoneController.text,
                      village: villageController.text,
                      regency: selectedRegency,
                      district: selectedDistrict,
                    );

                    await provider.setUser(updatedUser);

                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('common.success_update'.tr()),
                          backgroundColor: AppTheme.successGreen,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.help_outline),
            const SizedBox(width: 8),
            Text('help.title'.tr()),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'help.scan_leaf'.tr(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('help.step_1'.tr()),
              Text('help.step_2'.tr()),
              Text('help.step_3'.tr()),
              Text('help.step_4'.tr()),
              const SizedBox(height: 16),
              Text(
                'help.ai_consult'.tr(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('help.ai_desc'.tr()),
              const SizedBox(height: 16),
              Text(
                'help.offline_mode'.tr(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('help.offline_desc'.tr()),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('common.close'.tr()),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.eco, size: 32, color: AppTheme.primaryGreen),
            const SizedBox(width: 12),
            Text('app_name'.tr()),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('about.version'.tr()),
            const SizedBox(height: 16),
            Text('about.description'.tr()),
            const SizedBox(height: 16),
            Text(
              'about.developed_for'.tr(),
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'about.powered_by'.tr(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryGreen,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('common.close'.tr()),
          ),
        ],
      ),
    );
  }

  // Build badge preview grid (max 8 badges)
  Widget _buildBadgePreview() {
    final unlockedBadges = _gamificationService.getUnlockedBadges();
    final lockedBadges = _gamificationService.getLockedBadges();

    // Show up to 8 badges (unlocked first, then locked)
    final List<Badge> previewBadges = <Badge>[
      ...unlockedBadges,
      ...lockedBadges,
    ].take(8).toList();

    if (previewBadges.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.emoji_events_outlined,
                size: 48,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 12),
              Text(
                'Mulai scan untuk dapat badge!',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      );
    }

    return BadgeGrid(
      badges: previewBadges,
      onBadgeTap: (badge) {
        showDialog(
          context: context,
          builder: (ctx) => BadgeDetailDialog(badge: badge),
        );
      },
    );
  }

  // Show all badges in bottom sheet
  void _showBadgesSheet(BuildContext context) {
    final allBadges = _gamificationService.getAllBadges();
    final unlockedCount = _gamificationService.getUnlockedBadges().length;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
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
                  const Icon(Icons.emoji_events, color: Colors.amber, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Koleksi Badge',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '$unlockedCount / ${allBadges.length} terbuka',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(ctx),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Gamification Stats
            Padding(
              padding: const EdgeInsets.all(16),
              child: GamificationStatsRow(data: _gamificationData),
            ),
            const Divider(height: 1),
            // Badge Grid
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Group by category
                    for (final category in BadgeCategory.values) ...[
                      _buildBadgeCategorySection(category, allBadges),
                      const SizedBox(height: 20),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeCategorySection(
    BadgeCategory category,
    List<Badge> allBadges,
  ) {
    final categoryBadges = allBadges
        .where((b) => b.category == category)
        .toList();
    if (categoryBadges.isEmpty) return const SizedBox();

    final unlockedInCategory = categoryBadges.where((b) => b.isUnlocked).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(category.icon, size: 20, color: AppTheme.primaryGreen),
            const SizedBox(width: 8),
            Text(
              category.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$unlockedInCategory/${categoryBadges.length}',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.primaryGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        BadgeGrid(
          badges: categoryBadges,
          onBadgeTap: (badge) {
            showDialog(
              context: context,
              builder: (ctx) => BadgeDetailDialog(badge: badge),
            );
          },
        ),
      ],
    );
  }

  void _showLogoutConfirmation(BuildContext context, AppProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('profile.logout'.tr()),
        content: Text('common.confirm'.tr()), // Or better: 'Are you sure?'
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('common.cancel'.tr()),
          ),
          ElevatedButton(
            onPressed: () async {
              await provider.logout();
              if (context.mounted) {
                Navigator.pop(context);
                // Navigate to onboarding
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.dangerRed,
            ),
            child: Text('profile.logout'.tr()),
          ),
        ],
      ),
    );
  }
}
