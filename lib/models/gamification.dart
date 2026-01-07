/// AgriVision NTB - Gamification Model
/// Model untuk sistem badge, level, dan achievement petani

import 'package:flutter/material.dart';

/// Level petani berdasarkan total XP
enum FarmerLevel {
  pemula, // 0-99 XP
  petaniMuda, // 100-299 XP
  petaniCakap, // 300-599 XP
  petaniAhli, // 600-999 XP
  petaniMaster, // 1000+ XP
}

/// Ekstensi untuk FarmerLevel
extension FarmerLevelExtension on FarmerLevel {
  String get name {
    switch (this) {
      case FarmerLevel.pemula:
        return 'Petani Pemula';
      case FarmerLevel.petaniMuda:
        return 'Petani Muda';
      case FarmerLevel.petaniCakap:
        return 'Petani Cakap';
      case FarmerLevel.petaniAhli:
        return 'Petani Ahli';
      case FarmerLevel.petaniMaster:
        return 'Petani Master';
    }
  }

  String get nameEnglish {
    switch (this) {
      case FarmerLevel.pemula:
        return 'Beginner Farmer';
      case FarmerLevel.petaniMuda:
        return 'Young Farmer';
      case FarmerLevel.petaniCakap:
        return 'Skilled Farmer';
      case FarmerLevel.petaniAhli:
        return 'Expert Farmer';
      case FarmerLevel.petaniMaster:
        return 'Master Farmer';
    }
  }

  String get emoji {
    switch (this) {
      case FarmerLevel.pemula:
        return '🌱';
      case FarmerLevel.petaniMuda:
        return '🌿';
      case FarmerLevel.petaniCakap:
        return '🌾';
      case FarmerLevel.petaniAhli:
        return '🏆';
      case FarmerLevel.petaniMaster:
        return '👑';
    }
  }

  Color get color {
    switch (this) {
      case FarmerLevel.pemula:
        return const Color(0xFF8BC34A); // Light Green
      case FarmerLevel.petaniMuda:
        return const Color(0xFF4CAF50); // Green
      case FarmerLevel.petaniCakap:
        return const Color(0xFF2196F3); // Blue
      case FarmerLevel.petaniAhli:
        return const Color(0xFF9C27B0); // Purple
      case FarmerLevel.petaniMaster:
        return const Color(0xFFFF9800); // Orange/Gold
    }
  }

  int get minXP {
    switch (this) {
      case FarmerLevel.pemula:
        return 0;
      case FarmerLevel.petaniMuda:
        return 100;
      case FarmerLevel.petaniCakap:
        return 300;
      case FarmerLevel.petaniAhli:
        return 600;
      case FarmerLevel.petaniMaster:
        return 1000;
    }
  }

  int get maxXP {
    switch (this) {
      case FarmerLevel.pemula:
        return 99;
      case FarmerLevel.petaniMuda:
        return 299;
      case FarmerLevel.petaniCakap:
        return 599;
      case FarmerLevel.petaniAhli:
        return 999;
      case FarmerLevel.petaniMaster:
        return 9999; // Unlimited
    }
  }
}

/// Badge / Achievement yang bisa didapatkan
class Badge {
  final String id;
  final String name;
  final String nameEnglish;
  final String description;
  final String descriptionEnglish;
  final String emoji;
  final Color color;
  final BadgeCategory category;
  final int xpReward;
  final DateTime? unlockedAt;
  final bool isUnlocked;

  const Badge({
    required this.id,
    required this.name,
    required this.nameEnglish,
    required this.description,
    required this.descriptionEnglish,
    required this.emoji,
    required this.color,
    required this.category,
    required this.xpReward,
    this.unlockedAt,
    this.isUnlocked = false,
  });

  Badge copyWith({DateTime? unlockedAt, bool? isUnlocked}) {
    return Badge(
      id: id,
      name: name,
      nameEnglish: nameEnglish,
      description: description,
      descriptionEnglish: descriptionEnglish,
      emoji: emoji,
      color: color,
      category: category,
      xpReward: xpReward,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'unlocked_at': unlockedAt?.toIso8601String(),
      'is_unlocked': isUnlocked,
    };
  }
}

/// Kategori Badge
enum BadgeCategory {
  scanning, // Terkait scan penyakit
  learning, // Terkait belajar/encyclopedia
  schedule, // Terkait jadwal perawatan
  community, // Terkait berbagi/komunitas
  milestone, // Pencapaian umum
}

extension BadgeCategoryExtension on BadgeCategory {
  String get name {
    switch (this) {
      case BadgeCategory.scanning:
        return 'Deteksi Penyakit';
      case BadgeCategory.learning:
        return 'Pembelajaran';
      case BadgeCategory.schedule:
        return 'Perawatan';
      case BadgeCategory.community:
        return 'Komunitas';
      case BadgeCategory.milestone:
        return 'Pencapaian';
    }
  }

  IconData get icon {
    switch (this) {
      case BadgeCategory.scanning:
        return Icons.document_scanner;
      case BadgeCategory.learning:
        return Icons.school;
      case BadgeCategory.schedule:
        return Icons.calendar_month;
      case BadgeCategory.community:
        return Icons.people;
      case BadgeCategory.milestone:
        return Icons.emoji_events;
    }
  }
}

/// Data gamifikasi user
class GamificationData {
  final int totalXP;
  final FarmerLevel level;
  final List<String> unlockedBadgeIds;
  final Map<String, DateTime> badgeUnlockDates;
  final int scanStreak; // Berturut-turut scan setiap hari
  final int totalScans;
  final int totalSchedulesCompleted;
  final int totalDiseasesLearned;
  final int totalReportsShared;
  final DateTime? lastScanDate;
  final DateTime? lastActiveDate;

  const GamificationData({
    this.totalXP = 0,
    this.level = FarmerLevel.pemula,
    this.unlockedBadgeIds = const [],
    this.badgeUnlockDates = const {},
    this.scanStreak = 0,
    this.totalScans = 0,
    this.totalSchedulesCompleted = 0,
    this.totalDiseasesLearned = 0,
    this.totalReportsShared = 0,
    this.lastScanDate,
    this.lastActiveDate,
  });

  factory GamificationData.fromJson(Map<String, dynamic> json) {
    final xp = json['total_xp'] ?? 0;
    return GamificationData(
      totalXP: xp,
      level: _getLevelFromXP(xp),
      unlockedBadgeIds: List<String>.from(json['unlocked_badge_ids'] ?? []),
      badgeUnlockDates:
          (json['badge_unlock_dates'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, DateTime.parse(value)),
          ) ??
          {},
      scanStreak: json['scan_streak'] ?? 0,
      totalScans: json['total_scans'] ?? 0,
      totalSchedulesCompleted: json['total_schedules_completed'] ?? 0,
      totalDiseasesLearned: json['total_diseases_learned'] ?? 0,
      totalReportsShared: json['total_reports_shared'] ?? 0,
      lastScanDate: json['last_scan_date'] != null
          ? DateTime.parse(json['last_scan_date'])
          : null,
      lastActiveDate: json['last_active_date'] != null
          ? DateTime.parse(json['last_active_date'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_xp': totalXP,
      'unlocked_badge_ids': unlockedBadgeIds,
      'badge_unlock_dates': badgeUnlockDates.map(
        (key, value) => MapEntry(key, value.toIso8601String()),
      ),
      'scan_streak': scanStreak,
      'total_scans': totalScans,
      'total_schedules_completed': totalSchedulesCompleted,
      'total_diseases_learned': totalDiseasesLearned,
      'total_reports_shared': totalReportsShared,
      'last_scan_date': lastScanDate?.toIso8601String(),
      'last_active_date': lastActiveDate?.toIso8601String(),
    };
  }

  GamificationData copyWith({
    int? totalXP,
    FarmerLevel? level,
    List<String>? unlockedBadgeIds,
    Map<String, DateTime>? badgeUnlockDates,
    int? scanStreak,
    int? totalScans,
    int? totalSchedulesCompleted,
    int? totalDiseasesLearned,
    int? totalReportsShared,
    DateTime? lastScanDate,
    DateTime? lastActiveDate,
  }) {
    final newXP = totalXP ?? this.totalXP;
    return GamificationData(
      totalXP: newXP,
      level: _getLevelFromXP(newXP),
      unlockedBadgeIds: unlockedBadgeIds ?? this.unlockedBadgeIds,
      badgeUnlockDates: badgeUnlockDates ?? this.badgeUnlockDates,
      scanStreak: scanStreak ?? this.scanStreak,
      totalScans: totalScans ?? this.totalScans,
      totalSchedulesCompleted:
          totalSchedulesCompleted ?? this.totalSchedulesCompleted,
      totalDiseasesLearned: totalDiseasesLearned ?? this.totalDiseasesLearned,
      totalReportsShared: totalReportsShared ?? this.totalReportsShared,
      lastScanDate: lastScanDate ?? this.lastScanDate,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
    );
  }

  /// Hitung progress ke level selanjutnya (0.0 - 1.0)
  double get progressToNextLevel {
    if (level == FarmerLevel.petaniMaster) return 1.0;
    final currentMin = level.minXP;
    final currentMax = level.maxXP;
    return (totalXP - currentMin) / (currentMax - currentMin + 1);
  }

  /// XP yang dibutuhkan untuk level selanjutnya
  int get xpToNextLevel {
    if (level == FarmerLevel.petaniMaster) return 0;
    return level.maxXP - totalXP + 1;
  }

  static FarmerLevel _getLevelFromXP(int xp) {
    if (xp >= 1000) return FarmerLevel.petaniMaster;
    if (xp >= 600) return FarmerLevel.petaniAhli;
    if (xp >= 300) return FarmerLevel.petaniCakap;
    if (xp >= 100) return FarmerLevel.petaniMuda;
    return FarmerLevel.pemula;
  }
}

/// Semua badge yang tersedia di aplikasi
class AvailableBadges {
  static const List<Badge> all = [
    // === SCANNING BADGES ===
    Badge(
      id: 'first_scan',
      name: 'Detektif Pemula',
      nameEnglish: 'Beginner Detective',
      description: 'Lakukan scan pertama Anda',
      descriptionEnglish: 'Complete your first scan',
      emoji: '🔍',
      color: Color(0xFF4CAF50),
      category: BadgeCategory.scanning,
      xpReward: 10,
    ),
    Badge(
      id: 'scan_10',
      name: 'Pemindai Aktif',
      nameEnglish: 'Active Scanner',
      description: 'Lakukan 10 kali scan',
      descriptionEnglish: 'Complete 10 scans',
      emoji: '📸',
      color: Color(0xFF2196F3),
      category: BadgeCategory.scanning,
      xpReward: 25,
    ),
    Badge(
      id: 'scan_50',
      name: 'Mata Elang',
      nameEnglish: 'Eagle Eye',
      description: 'Lakukan 50 kali scan',
      descriptionEnglish: 'Complete 50 scans',
      emoji: '🦅',
      color: Color(0xFF9C27B0),
      category: BadgeCategory.scanning,
      xpReward: 50,
    ),
    Badge(
      id: 'scan_100',
      name: 'Detektif Penyakit',
      nameEnglish: 'Disease Detective',
      description: 'Lakukan 100 kali scan',
      descriptionEnglish: 'Complete 100 scans',
      emoji: '🏅',
      color: Color(0xFFFF9800),
      category: BadgeCategory.scanning,
      xpReward: 100,
    ),
    Badge(
      id: 'streak_7',
      name: 'Petani Konsisten',
      nameEnglish: 'Consistent Farmer',
      description: 'Scan 7 hari berturut-turut',
      descriptionEnglish: 'Scan for 7 consecutive days',
      emoji: '🔥',
      color: Color(0xFFE91E63),
      category: BadgeCategory.scanning,
      xpReward: 50,
    ),

    // === LEARNING BADGES ===
    Badge(
      id: 'first_learn',
      name: 'Pelajar Pemula',
      nameEnglish: 'Eager Learner',
      description: 'Baca detail penyakit pertama',
      descriptionEnglish: 'Read your first disease detail',
      emoji: '📚',
      color: Color(0xFF3F51B5),
      category: BadgeCategory.learning,
      xpReward: 10,
    ),
    Badge(
      id: 'learn_10',
      name: 'Siswa Rajin',
      nameEnglish: 'Diligent Student',
      description: 'Pelajari 10 jenis penyakit',
      descriptionEnglish: 'Learn about 10 diseases',
      emoji: '🎓',
      color: Color(0xFF00BCD4),
      category: BadgeCategory.learning,
      xpReward: 30,
    ),
    Badge(
      id: 'learn_30',
      name: 'Ahli Pengetahuan',
      nameEnglish: 'Knowledge Expert',
      description: 'Pelajari 30 jenis penyakit',
      descriptionEnglish: 'Learn about 30 diseases',
      emoji: '🧠',
      color: Color(0xFF673AB7),
      category: BadgeCategory.learning,
      xpReward: 75,
    ),

    // === SCHEDULE BADGES ===
    Badge(
      id: 'first_schedule',
      name: 'Perencana Pemula',
      nameEnglish: 'Beginning Planner',
      description: 'Buat jadwal perawatan pertama',
      descriptionEnglish: 'Create your first treatment schedule',
      emoji: '📅',
      color: Color(0xFF009688),
      category: BadgeCategory.schedule,
      xpReward: 15,
    ),
    Badge(
      id: 'complete_5_schedules',
      name: 'Petani Teratur',
      nameEnglish: 'Organized Farmer',
      description: 'Selesaikan 5 jadwal perawatan',
      descriptionEnglish: 'Complete 5 treatment schedules',
      emoji: '✅',
      color: Color(0xFF4CAF50),
      category: BadgeCategory.schedule,
      xpReward: 35,
    ),
    Badge(
      id: 'complete_20_schedules',
      name: 'Maestro Perawatan',
      nameEnglish: 'Care Maestro',
      description: 'Selesaikan 20 jadwal perawatan',
      descriptionEnglish: 'Complete 20 treatment schedules',
      emoji: '🌟',
      color: Color(0xFFFFEB3B),
      category: BadgeCategory.schedule,
      xpReward: 80,
    ),

    // === COMMUNITY BADGES ===
    Badge(
      id: 'first_share',
      name: 'Berbagi Itu Indah',
      nameEnglish: 'Sharing is Caring',
      description: 'Bagikan laporan scan pertama',
      descriptionEnglish: 'Share your first scan report',
      emoji: '🤝',
      color: Color(0xFFE91E63),
      category: BadgeCategory.community,
      xpReward: 15,
    ),
    Badge(
      id: 'share_10',
      name: 'Pemandu Petani',
      nameEnglish: 'Farmer Guide',
      description: 'Bagikan 10 laporan scan',
      descriptionEnglish: 'Share 10 scan reports',
      emoji: '📢',
      color: Color(0xFFFF5722),
      category: BadgeCategory.community,
      xpReward: 40,
    ),

    // === MILESTONE BADGES ===
    Badge(
      id: 'registered',
      name: 'Selamat Datang!',
      nameEnglish: 'Welcome!',
      description: 'Bergabung dengan AgriVision NTB',
      descriptionEnglish: 'Join AgriVision NTB',
      emoji: '🎉',
      color: Color(0xFF4CAF50),
      category: BadgeCategory.milestone,
      xpReward: 10,
    ),
    Badge(
      id: 'level_petani_muda',
      name: 'Naik Level!',
      nameEnglish: 'Level Up!',
      description: 'Mencapai level Petani Muda',
      descriptionEnglish: 'Reach Young Farmer level',
      emoji: '⬆️',
      color: Color(0xFF4CAF50),
      category: BadgeCategory.milestone,
      xpReward: 20,
    ),
    Badge(
      id: 'level_petani_cakap',
      name: 'Petani Berbakat',
      nameEnglish: 'Talented Farmer',
      description: 'Mencapai level Petani Cakap',
      descriptionEnglish: 'Reach Skilled Farmer level',
      emoji: '🌾',
      color: Color(0xFF2196F3),
      category: BadgeCategory.milestone,
      xpReward: 30,
    ),
    Badge(
      id: 'level_petani_ahli',
      name: 'Ahli Pertanian',
      nameEnglish: 'Agriculture Expert',
      description: 'Mencapai level Petani Ahli',
      descriptionEnglish: 'Reach Expert Farmer level',
      emoji: '🏆',
      color: Color(0xFF9C27B0),
      category: BadgeCategory.milestone,
      xpReward: 50,
    ),
    Badge(
      id: 'level_petani_master',
      name: 'Legenda Pertanian',
      nameEnglish: 'Farming Legend',
      description: 'Mencapai level Petani Master',
      descriptionEnglish: 'Reach Master Farmer level',
      emoji: '👑',
      color: Color(0xFFFF9800),
      category: BadgeCategory.milestone,
      xpReward: 100,
    ),
  ];

  static Badge? getBadgeById(String id) {
    try {
      return all.firstWhere((badge) => badge.id == id);
    } catch (_) {
      return null;
    }
  }
}
