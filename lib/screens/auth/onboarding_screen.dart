/// AgriVision NTB - Onboarding Screen
/// Layar onboarding untuk pengguna baru

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../models/user.dart';
import '../../providers/app_provider.dart';
import '../../widgets/common_widgets.dart';
import '../main_navigation.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<OnboardingData> get _pages => [
    OnboardingData(
      icon: Icons.eco_rounded,
      title: 'onboarding.welcome_title'.tr(),
      subtitle: 'onboarding.welcome_desc'.tr(),
      color: AppTheme.primaryGreen,
    ),
    OnboardingData(
      icon: Icons.camera_alt_rounded,
      title: 'onboarding.scan_title'.tr(),
      subtitle: 'onboarding.scan_desc'.tr(),
      color: AppTheme.infoBlue,
    ),
    OnboardingData(
      icon: Icons.chat_rounded,
      title: 'onboarding.consult_title'.tr(),
      subtitle: 'onboarding.consult_desc'.tr(),
      color: AppTheme.warningOrange,
    ),
    OnboardingData(
      icon: Icons.map_rounded,
      title: 'onboarding.map_title'.tr(),
      subtitle: 'onboarding.map_desc'.tr(),
      color: AppTheme.dangerRed,
    ),
    OnboardingData(
      icon: Icons.cloud_off_rounded,
      title: 'onboarding.offline_title'.tr(),
      subtitle: 'onboarding.offline_desc'.tr(),
      color: AppTheme.primaryGreen,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _pages[_currentPage].color.withAlpha(30),
                  Colors.white,
                ],
              ),
            ),
          ),

          // Page content
          SafeArea(
            child: Column(
              children: [
                // Skip button
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: _goToRegistration,
                    child: Text(
                      _currentPage == _pages.length - 1
                          ? ''
                          : 'onboarding.skip'.tr(),
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                ),

                // Page view
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _pages.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return _buildPage(_pages[index]);
                    },
                  ),
                ),

                // Page indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 32 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? _pages[index].color
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Next/Start button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: GradientButton(
                    text: _currentPage == _pages.length - 1
                        ? 'onboarding.start_now'.tr()
                        : 'onboarding.next'.tr(),
                    gradientColors: [
                      _pages[_currentPage].color,
                      _pages[_currentPage].color.withAlpha(200),
                    ],
                    onPressed: () {
                      if (_currentPage == _pages.length - 1) {
                        _goToRegistration();
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingData data) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: data.color.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: Center(child: Icon(data.icon, size: 70, color: data.color)),
          ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
          const SizedBox(height: 48),
          // Title
          Text(
            data.title,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
          const SizedBox(height: 16),
          // Subtitle
          Text(
            data.subtitle,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
        ],
      ),
    );
  }

  void _goToRegistration() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const RegistrationScreen()),
    );
  }
}

class OnboardingData {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  OnboardingData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });
}

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _villageController = TextEditingController();

  String _selectedRegency = 'Lombok Tengah';
  String _selectedDistrict = 'Praya';
  final List<String> _selectedFarmTypes = [];
  bool _isLoading = false;

  final List<String> _farmTypeOptions = [
    'Jagung',
    'Padi',
    'Cabai',
    'Tomat',
    'Kedelai',
    'Kacang',
    'Lainnya',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.primaryGreen.withAlpha(30), Colors.white],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Header
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen.withAlpha(30),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.agriculture_rounded,
                        size: 50,
                        color: AppTheme.primaryGreen,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      'auth.farmer_data'.tr(),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      'auth.farmer_data_desc'.tr(),
                      style: TextStyle(color: Colors.grey.shade600),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Name field
                  _buildFormField(
                    controller: _nameController,
                    icon: Icons.person,
                    label: 'profile.name'.tr(),
                    hint: 'profile.name'
                        .tr(), // Reuse key or use specific hint key
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '${'profile.name'.tr()} ${'common.required'.tr()}';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Phone field
                  _buildFormField(
                    controller: _phoneController,
                    icon: Icons.phone,
                    label: 'profile.phone'.tr(),
                    hint: '08xxxxxxxxxx',
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '${'profile.phone'.tr()} ${'common.required'.tr()}';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Regency dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedRegency,
                    decoration: InputDecoration(
                      labelText: 'profile.regency'.tr(),
                      prefixIcon: const Icon(
                        Icons.location_city,
                        color: AppTheme.primaryGreen,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: AppTheme.primaryGreen,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    items: NTBRegions.regencies.map((regency) {
                      return DropdownMenuItem(
                        value: regency,
                        child: Text(regency),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedRegency = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Village field
                  _buildFormField(
                    controller: _villageController,
                    icon: Icons.home,
                    label: 'profile.village'.tr(),
                    hint: 'profile.village'.tr(),
                  ),
                  const SizedBox(height: 24),

                  // Farm types
                  Text(
                    'profile.farm_types'.tr(),
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _farmTypeOptions.map((type) {
                      final isSelected = _selectedFarmTypes.contains(type);
                      return FilterChip(
                        key: ValueKey('farm_$type'),
                        label: Text(type),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedFarmTypes.add(type);
                            } else {
                              _selectedFarmTypes.remove(type);
                            }
                          });
                        },
                        selectedColor: AppTheme.primaryGreen.withAlpha(50),
                        checkmarkColor: AppTheme.primaryGreen,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? AppTheme.primaryGreen
                              : Colors.grey.shade700,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),

                  // Submit button
                  GradientButton(
                    text: 'onboarding.start'.tr(),
                    isLoading: _isLoading,
                    onPressed: _submitForm,
                  ),
                  const SizedBox(height: 16),

                  // Skip option
                  Center(
                    child: TextButton(
                      onPressed: _skipRegistration,
                      child: Text(
                        'onboarding.skip'.tr(),
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required IconData icon,
    required String label,
    String? hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppTheme.primaryGreen),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppTheme.primaryGreen, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppTheme.dangerRed),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppTheme.dangerRed, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      validator: validator,
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final provider = Provider.of<AppProvider>(context, listen: false);

      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        phone: _phoneController.text,
        village: _villageController.text,
        district: _selectedDistrict,
        regency: _selectedRegency,
        farmTypes: _selectedFarmTypes,
        registeredAt: DateTime.now(),
      );

      await provider.setUser(user);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainNavigation()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${'common.error_occurred'.tr()}: $e'),
            backgroundColor: AppTheme.dangerRed,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _skipRegistration() async {
    final provider = Provider.of<AppProvider>(context, listen: false);

    // Create a guest user
    final user = User(
      id: 'guest_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Petani NTB',
      phone: '',
      village: '',
      district: '',
      regency: 'Lombok Tengah',
      registeredAt: DateTime.now(),
    );

    await provider.setUser(user);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigation()),
      );
    }
  }
}
