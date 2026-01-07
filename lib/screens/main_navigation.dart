// AgriVision NTB - Main Navigation
// Bottom navigation untuk navigasi utama

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../config/app_theme.dart';
import '../providers/app_provider.dart';
import '../widgets/common_widgets.dart';
import 'home/home_screen.dart';
import 'history/history_screen.dart';
import 'map/outbreak_map_screen.dart';
import 'calendar/calendar_screen.dart';
import 'profile/profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  // Screens are recreated when widget rebuilds (e.g., locale change)
  // IndexedStack keeps only current screen mounted, avoiding GlobalKey issues
  List<Widget> get _screens => [
    const HomeScreen(),
    const HistoryScreen(),
    const OutbreakMapScreen(),
    const CalendarScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Current screen - IndexedStack preserves state
          IndexedStack(index: _currentIndex, children: _screens),

          // Connectivity banner - uses Consumer only for this part
          Consumer<AppProvider>(
            builder: (context, provider, child) {
              if (!provider.isOnline) {
                return const Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(child: ConnectivityBanner(isOnline: false)),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(25),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home_rounded, 'nav.home'.tr()),
                _buildNavItem(1, Icons.history, 'nav.history'.tr()),
                _buildNavItem(2, Icons.map_rounded, 'nav.map'.tr()),
                _buildNavItem(3, Icons.calendar_month, 'nav.calendar'.tr()),
                _buildNavItem(4, Icons.person, 'nav.profile'.tr()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 14 : 10,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryGreen.withAlpha(30)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.primaryGreen : Colors.grey.shade400,
              size: 22,
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: AppTheme.primaryGreen,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
