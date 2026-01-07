/// AgriVision NTB - Gamification Widgets
/// Widget untuk menampilkan badge, level, dan XP

import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_animate/flutter_animate.dart';
import '../models/gamification.dart';
import '../config/app_theme.dart';

/// Card yang menampilkan level dan XP progress
class LevelProgressCard extends StatelessWidget {
  final GamificationData data;
  final VoidCallback? onTap;

  const LevelProgressCard({super.key, required this.data, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [data.level.color, data.level.color.withOpacity(0.7)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: data.level.color.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Level Badge
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    data.level.emoji,
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.level.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${data.totalXP} XP',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                // Arrow to see more
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white.withOpacity(0.7),
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Progress Bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Progress ke level berikutnya',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                      ),
                    ),
                    if (data.level != FarmerLevel.petaniMaster)
                      Text(
                        '${data.xpToNextLevel} XP lagi',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    else
                      Text(
                        'Level Maksimal! 👑',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: data.progressToNextLevel,
                    minHeight: 10,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Grid untuk menampilkan badge
class BadgeGrid extends StatelessWidget {
  final List<Badge> badges;
  final bool showLocked;
  final Function(Badge)? onBadgeTap;

  const BadgeGrid({
    super.key,
    required this.badges,
    this.showLocked = true,
    this.onBadgeTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.85,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: badges.length,
      itemBuilder: (context, index) {
        final badge = badges[index];
        return BadgeItem(badge: badge, onTap: () => onBadgeTap?.call(badge));
      },
    );
  }
}

/// Single badge item
class BadgeItem extends StatelessWidget {
  final Badge badge;
  final VoidCallback? onTap;

  const BadgeItem({super.key, required this.badge, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: badge.isUnlocked
                  ? badge.color.withOpacity(0.15)
                  : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: badge.isUnlocked
                    ? badge.color.withOpacity(0.5)
                    : Colors.grey.shade300,
                width: 2,
              ),
            ),
            child: Center(
              child: badge.isUnlocked
                  ? Text(badge.emoji, style: const TextStyle(fontSize: 28))
                  : Icon(Icons.lock, color: Colors.grey.shade400, size: 24),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            badge.name,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: badge.isUnlocked
                  ? Colors.grey.shade800
                  : Colors.grey.shade400,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Dialog untuk menampilkan detail badge
class BadgeDetailDialog extends StatelessWidget {
  final Badge badge;

  const BadgeDetailDialog({super.key, required this.badge});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Badge Icon
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: badge.isUnlocked
                    ? badge.color.withOpacity(0.15)
                    : Colors.grey.shade200,
                shape: BoxShape.circle,
                border: Border.all(
                  color: badge.isUnlocked ? badge.color : Colors.grey.shade300,
                  width: 3,
                ),
              ),
              child: Center(
                child: badge.isUnlocked
                    ? Text(badge.emoji, style: const TextStyle(fontSize: 48))
                    : Icon(
                        Icons.lock_outline,
                        color: Colors.grey.shade400,
                        size: 48,
                      ),
              ),
            ).animate().scale(duration: 300.ms, curve: Curves.elasticOut),
            const SizedBox(height: 20),

            // Badge Name
            Text(
              badge.name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: badge.isUnlocked
                    ? Colors.grey.shade800
                    : Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Category
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: badge.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(badge.category.icon, size: 14, color: badge.color),
                  const SizedBox(width: 6),
                  Text(
                    badge.category.name,
                    style: TextStyle(
                      fontSize: 12,
                      color: badge.color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Description
            Text(
              badge.description,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // XP Reward
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 18),
                const SizedBox(width: 4),
                Text(
                  '+${badge.xpReward} XP',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
              ],
            ),

            // Unlock date if unlocked
            if (badge.isUnlocked && badge.unlockedAt != null) ...[
              const SizedBox(height: 12),
              Text(
                'Diraih pada ${_formatDate(badge.unlockedAt!)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            const SizedBox(height: 24),

            // Close button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: badge.isUnlocked ? badge.color : Colors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Tutup',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Ags',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

/// Popup notifikasi ketika dapat badge baru
class BadgeUnlockedPopup extends StatelessWidget {
  final Badge badge;

  const BadgeUnlockedPopup({super.key, required this.badge});

  static void show(BuildContext context, Badge badge) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => BadgeUnlockedPopup(badge: badge),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Celebration
            const Text(
              '🎉',
              style: TextStyle(fontSize: 48),
            ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
            const SizedBox(height: 16),

            const Text(
              'Badge Baru!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryGreen,
              ),
            ),
            const SizedBox(height: 20),

            // Badge
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: badge.color.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(color: badge.color, width: 3),
              ),
              child: Center(
                child: Text(badge.emoji, style: const TextStyle(fontSize: 40)),
              ),
            ).animate().scale(
              delay: 200.ms,
              duration: 400.ms,
              curve: Curves.elasticOut,
            ),
            const SizedBox(height: 16),

            Text(
              badge.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            Text(
              badge.description,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // XP Reward
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    '+${badge.xpReward} XP',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 400.ms),
            const SizedBox(height: 24),

            // Close button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: badge.color,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Keren! 🎊',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Popup notifikasi ketika level up
class LevelUpPopup extends StatelessWidget {
  final FarmerLevel newLevel;

  const LevelUpPopup({super.key, required this.newLevel});

  static void show(BuildContext context, FarmerLevel newLevel) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => LevelUpPopup(newLevel: newLevel),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [newLevel.color, newLevel.color.withOpacity(0.8)],
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Celebration
            const Text(
              '⬆️',
              style: TextStyle(fontSize: 48),
            ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
            const SizedBox(height: 16),

            const Text(
              'LEVEL UP!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            // New Level Badge
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Text(newLevel.emoji, style: const TextStyle(fontSize: 56)),
            ).animate().scale(
              delay: 200.ms,
              duration: 400.ms,
              curve: Curves.elasticOut,
            ),
            const SizedBox(height: 20),

            Text(
              newLevel.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            Text(
              'Selamat! Kamu terus berkembang!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.9),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Continue button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Lanjutkan! 🚀',
                  style: TextStyle(
                    color: newLevel.color,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Stats row untuk menampilkan statistik gamification
class GamificationStatsRow extends StatelessWidget {
  final GamificationData data;

  const GamificationStatsRow({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildStat(
          icon: Icons.document_scanner,
          value: '${data.totalScans}',
          label: 'Scan',
          color: Colors.blue,
        ),
        _buildDivider(),
        _buildStat(
          icon: Icons.local_fire_department,
          value: '${data.scanStreak}',
          label: 'Streak',
          color: Colors.orange,
        ),
        _buildDivider(),
        _buildStat(
          icon: Icons.emoji_events,
          value: '${data.unlockedBadgeIds.length}',
          label: 'Badge',
          color: Colors.amber,
        ),
        _buildDivider(),
        _buildStat(
          icon: Icons.star,
          value: '${data.totalXP}',
          label: 'XP',
          color: Colors.purple,
        ),
      ],
    );
  }

  Widget _buildStat({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 40, color: Colors.grey.shade300);
  }
}
