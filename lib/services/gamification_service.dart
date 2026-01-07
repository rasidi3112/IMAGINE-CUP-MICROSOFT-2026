/// AgriVision NTB - Gamification Service
/// Service untuk mengelola badge, level, dan XP petani

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/gamification.dart';

class GamificationService {
  static final GamificationService _instance = GamificationService._internal();
  factory GamificationService() => _instance;
  GamificationService._internal();

  static const String _dataKey = 'gamification_data';
  GamificationData _data = const GamificationData();

  // Callbacks untuk notifikasi
  Function(Badge badge)? onBadgeUnlocked;
  Function(FarmerLevel newLevel)? onLevelUp;

  GamificationData get data => _data;

  /// Initialize service dan load data
  Future<void> initialize() async {
    await _loadData();
    // Award welcome badge jika belum pernah
    if (!_data.unlockedBadgeIds.contains('registered')) {
      await awardBadge('registered');
    }
  }

  /// Load data dari SharedPreferences
  Future<void> _loadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_dataKey);
      if (jsonStr != null) {
        final json = jsonDecode(jsonStr) as Map<String, dynamic>;
        _data = GamificationData.fromJson(json);
      }
    } catch (e) {
      print('GamificationService: Error loading data - $e');
    }
  }

  /// Simpan data ke SharedPreferences
  Future<void> _saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_dataKey, jsonEncode(_data.toJson()));
    } catch (e) {
      print('GamificationService: Error saving data - $e');
    }
  }

  /// Tambah XP dan cek level up
  Future<bool> addXP(int amount) async {
    final oldLevel = _data.level;
    final newXP = _data.totalXP + amount;

    _data = _data.copyWith(totalXP: newXP);
    await _saveData();

    // Cek level up
    if (_data.level != oldLevel) {
      onLevelUp?.call(_data.level);

      // Award level badge
      switch (_data.level) {
        case FarmerLevel.petaniMuda:
          await awardBadge('level_petani_muda');
          break;
        case FarmerLevel.petaniCakap:
          await awardBadge('level_petani_cakap');
          break;
        case FarmerLevel.petaniAhli:
          await awardBadge('level_petani_ahli');
          break;
        case FarmerLevel.petaniMaster:
          await awardBadge('level_petani_master');
          break;
        default:
          break;
      }
      return true; // Level up occurred
    }
    return false;
  }

  /// Award badge ke user
  Future<bool> awardBadge(String badgeId) async {
    if (_data.unlockedBadgeIds.contains(badgeId)) {
      return false; // Already unlocked
    }

    final badge = AvailableBadges.getBadgeById(badgeId);
    if (badge == null) return false;

    final newBadgeIds = List<String>.from(_data.unlockedBadgeIds)..add(badgeId);
    final newBadgeDates = Map<String, DateTime>.from(_data.badgeUnlockDates);
    newBadgeDates[badgeId] = DateTime.now();

    _data = _data.copyWith(
      unlockedBadgeIds: newBadgeIds,
      badgeUnlockDates: newBadgeDates,
    );

    // Add XP reward
    await addXP(badge.xpReward);

    // Notify callback
    final unlockedBadge = badge.copyWith(
      isUnlocked: true,
      unlockedAt: DateTime.now(),
    );
    onBadgeUnlocked?.call(unlockedBadge);

    return true;
  }

  /// Record scan activity dan cek badges
  Future<List<Badge>> recordScan() async {
    final newBadges = <Badge>[];
    final now = DateTime.now();

    // Update scan count
    final newScanCount = _data.totalScans + 1;

    // Update streak
    int newStreak = _data.scanStreak;
    if (_data.lastScanDate != null) {
      final daysSinceLastScan = now.difference(_data.lastScanDate!).inDays;
      if (daysSinceLastScan == 1) {
        newStreak += 1;
      } else if (daysSinceLastScan > 1) {
        newStreak = 1;
      }
    } else {
      newStreak = 1;
    }

    _data = _data.copyWith(
      totalScans: newScanCount,
      scanStreak: newStreak,
      lastScanDate: now,
      lastActiveDate: now,
    );
    await _saveData();

    // Check scan badges
    if (newScanCount == 1) {
      if (await awardBadge('first_scan')) {
        newBadges.add(AvailableBadges.getBadgeById('first_scan')!);
      }
    }
    if (newScanCount >= 10) {
      if (await awardBadge('scan_10')) {
        newBadges.add(AvailableBadges.getBadgeById('scan_10')!);
      }
    }
    if (newScanCount >= 50) {
      if (await awardBadge('scan_50')) {
        newBadges.add(AvailableBadges.getBadgeById('scan_50')!);
      }
    }
    if (newScanCount >= 100) {
      if (await awardBadge('scan_100')) {
        newBadges.add(AvailableBadges.getBadgeById('scan_100')!);
      }
    }

    // Check streak badge
    if (newStreak >= 7) {
      if (await awardBadge('streak_7')) {
        newBadges.add(AvailableBadges.getBadgeById('streak_7')!);
      }
    }

    // Add base XP for scanning
    await addXP(5);

    return newBadges;
  }

  /// Record learning activity (membaca detail penyakit)
  Future<List<Badge>> recordLearning() async {
    final newBadges = <Badge>[];

    final newLearnCount = _data.totalDiseasesLearned + 1;
    _data = _data.copyWith(
      totalDiseasesLearned: newLearnCount,
      lastActiveDate: DateTime.now(),
    );
    await _saveData();

    // Check learning badges
    if (newLearnCount == 1) {
      if (await awardBadge('first_learn')) {
        newBadges.add(AvailableBadges.getBadgeById('first_learn')!);
      }
    }
    if (newLearnCount >= 10) {
      if (await awardBadge('learn_10')) {
        newBadges.add(AvailableBadges.getBadgeById('learn_10')!);
      }
    }
    if (newLearnCount >= 30) {
      if (await awardBadge('learn_30')) {
        newBadges.add(AvailableBadges.getBadgeById('learn_30')!);
      }
    }

    // Add XP for learning
    await addXP(3);

    return newBadges;
  }

  /// Record schedule creation
  Future<List<Badge>> recordScheduleCreated() async {
    final newBadges = <Badge>[];

    _data = _data.copyWith(lastActiveDate: DateTime.now());
    await _saveData();

    if (await awardBadge('first_schedule')) {
      newBadges.add(AvailableBadges.getBadgeById('first_schedule')!);
    }

    await addXP(5);
    return newBadges;
  }

  /// Record schedule completion
  Future<List<Badge>> recordScheduleCompleted() async {
    final newBadges = <Badge>[];

    final newCompleteCount = _data.totalSchedulesCompleted + 1;
    _data = _data.copyWith(
      totalSchedulesCompleted: newCompleteCount,
      lastActiveDate: DateTime.now(),
    );
    await _saveData();

    if (newCompleteCount >= 5) {
      if (await awardBadge('complete_5_schedules')) {
        newBadges.add(AvailableBadges.getBadgeById('complete_5_schedules')!);
      }
    }
    if (newCompleteCount >= 20) {
      if (await awardBadge('complete_20_schedules')) {
        newBadges.add(AvailableBadges.getBadgeById('complete_20_schedules')!);
      }
    }

    await addXP(10);
    return newBadges;
  }

  /// Record share activity
  Future<List<Badge>> recordShare() async {
    final newBadges = <Badge>[];

    final newShareCount = _data.totalReportsShared + 1;
    _data = _data.copyWith(
      totalReportsShared: newShareCount,
      lastActiveDate: DateTime.now(),
    );
    await _saveData();

    if (newShareCount == 1) {
      if (await awardBadge('first_share')) {
        newBadges.add(AvailableBadges.getBadgeById('first_share')!);
      }
    }
    if (newShareCount >= 10) {
      if (await awardBadge('share_10')) {
        newBadges.add(AvailableBadges.getBadgeById('share_10')!);
      }
    }

    await addXP(5);
    return newBadges;
  }

  /// Get list of unlocked badges with full data
  List<Badge> getUnlockedBadges() {
    return _data.unlockedBadgeIds
        .map((id) {
          final badge = AvailableBadges.getBadgeById(id);
          if (badge == null) return null;
          return badge.copyWith(
            isUnlocked: true,
            unlockedAt: _data.badgeUnlockDates[id],
          );
        })
        .whereType<Badge>()
        .toList();
  }

  /// Get list of locked badges
  List<Badge> getLockedBadges() {
    return AvailableBadges.all
        .where((badge) => !_data.unlockedBadgeIds.contains(badge.id))
        .toList();
  }

  /// Get all badges with unlock status
  List<Badge> getAllBadges() {
    return AvailableBadges.all.map((badge) {
      if (_data.unlockedBadgeIds.contains(badge.id)) {
        return badge.copyWith(
          isUnlocked: true,
          unlockedAt: _data.badgeUnlockDates[badge.id],
        );
      }
      return badge;
    }).toList();
  }

  /// Reset all gamification data (for testing)
  Future<void> resetData() async {
    _data = const GamificationData();
    await _saveData();
  }
}
