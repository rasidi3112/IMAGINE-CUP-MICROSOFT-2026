// AgriVision NTB - App Provider
// Provider utama untuk state management aplikasi

import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/scan_result.dart';
import '../models/treatment_schedule.dart';
import '../models/outbreak_data.dart';
import '../services/local_storage_service.dart';
import '../services/sync_service.dart';
import '../services/location_service.dart';
import '../services/notification_service.dart';

class AppProvider extends ChangeNotifier {
  final LocalStorageService _localStorage = LocalStorageService();
  final SyncService _syncService = SyncService();
  // ignore: unused_field - will be used for location features
  final LocationService _locationService = LocationService();
  final NotificationService _notificationService = NotificationService();

  // User state
  User? _currentUser;
  User? get currentUser => _currentUser;

  // Scan results
  List<ScanResult> _scanResults = [];
  List<ScanResult> get scanResults => _scanResults;

  // Current scan
  ScanResult? _currentScanResult;
  ScanResult? get currentScanResult => _currentScanResult;

  // Treatment schedules
  List<TreatmentSchedule> _schedules = [];
  List<TreatmentSchedule> get schedules => _schedules;
  List<TreatmentSchedule> get upcomingSchedules =>
      _schedules.where((s) => !s.isCompleted).toList();

  // Outbreak data
  List<OutbreakData> _outbreaks = [];
  List<OutbreakData> get outbreaks => _outbreaks;

  // Connectivity
  bool _isOnline = true;
  bool get isOnline => _isOnline;

  // Loading states
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  // Statistics
  Map<String, dynamic> _statistics = {};
  Map<String, dynamic> get statistics => _statistics;

  // Theme mode
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  /// Initialize the app
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Initialize notifications
      await _notificationService.initialize();
      await _notificationService.requestPermissions();

      // Load and apply notification setting
      final notificationsEnabled = await _localStorage.getNotificationSetting();
      _notificationService.setNotificationsEnabled(notificationsEnabled);

      // Load user data
      _currentUser = await _localStorage.getUser();

      // Load scan history
      _scanResults = await _localStorage.getAllScanResults();

      // Load schedules
      _schedules = await _localStorage.getUpcomingSchedules();

      // Load statistics
      _statistics = await _localStorage.getStatistics();

      // Check connectivity
      _isOnline = await _syncService.isOnline();

      // Listen for connectivity changes
      _syncService.connectivityStream.listen((isOnline) {
        _isOnline = isOnline;
        notifyListeners();

        if (isOnline) {
          syncPendingData();
        }
      });
    } catch (e) {
      debugPrint('Error initializing app: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Set current user
  Future<void> setUser(User user) async {
    _currentUser = user;
    await _localStorage.saveUser(user);
    notifyListeners();
  }

  /// Update user
  Future<void> updateUser(User user) async {
    _currentUser = user;
    await _localStorage.saveUser(user);
    notifyListeners();
  }

  /// Add scan result
  Future<void> addScanResult(ScanResult result) async {
    _scanResults.insert(0, result);
    await _localStorage.saveScanResult(result);

    // Update statistics
    _statistics = await _localStorage.getStatistics();

    // Update user stats
    if (_currentUser != null) {
      final updatedUser = _currentUser!.copyWith(
        totalScans: _currentUser!.totalScans + 1,
        diseasesDetected: result.detectedDisease != null
            ? _currentUser!.diseasesDetected + 1
            : _currentUser!.diseasesDetected,
      );
      await updateUser(updatedUser);
    }

    // If offline, add to pending uploads
    if (!_isOnline) {
      await _localStorage.addPendingUpload(result.id, result.imagePath);
    }

    notifyListeners();
  }

  /// Set current scan result (for viewing details)
  void setCurrentScanResult(ScanResult? result) {
    _currentScanResult = result;
    notifyListeners();
  }

  /// Update scan result with AI response
  Future<void> updateScanResultWithAIResponse(
    String scanId,
    String response,
  ) async {
    final index = _scanResults.indexWhere((r) => r.id == scanId);
    if (index != -1) {
      _scanResults[index] = _scanResults[index].copyWith(
        aiConsultationResponse: response,
      );
      await _localStorage.saveScanResult(_scanResults[index]);

      if (_currentScanResult?.id == scanId) {
        _currentScanResult = _scanResults[index];
      }

      notifyListeners();
    }
  }

  /// Add treatment schedule
  Future<void> addTreatmentSchedule(TreatmentSchedule schedule) async {
    _schedules.add(schedule);
    await _localStorage.saveTreatmentSchedule(schedule);

    // Schedule notification
    await _notificationService.scheduleTreatmentReminder(schedule);

    notifyListeners();
  }

  /// Mark schedule as completed
  Future<void> completeSchedule(String scheduleId) async {
    final index = _schedules.indexWhere((s) => s.id == scheduleId);
    if (index != -1) {
      _schedules[index] = _schedules[index].copyWith(
        isCompleted: true,
        completedDate: DateTime.now(),
      );
      await _localStorage.markScheduleCompleted(scheduleId);
      await _notificationService.cancelTreatmentReminder(scheduleId);
      notifyListeners();
    }
  }

  /// Sync pending data
  Future<SyncResult> syncPendingData() async {
    if (_isSyncing) {
      return SyncResult(
        success: false,
        message: 'Sinkronisasi sedang berjalan',
        syncedCount: 0,
        failedCount: 0,
      );
    }

    _isSyncing = true;
    notifyListeners();

    try {
      final result = await _syncService.syncPendingData();

      if (result.syncedCount > 0) {
        _scanResults = await _localStorage.getAllScanResults();
        _statistics = await _localStorage.getStatistics();

        await _notificationService.showNotification(
          title: 'Sinkronisasi Selesai ✅',
          body: '${result.syncedCount} data berhasil disinkronkan',
        );
      }

      return result;
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  /// Refresh all data
  Future<void> refreshData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _scanResults = await _localStorage.getAllScanResults();
      _schedules = await _localStorage.getUpcomingSchedules();
      _statistics = await _localStorage.getStatistics();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Toggle theme mode
  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    notifyListeners();
  }

  /// Set outbreak data
  void setOutbreakData(List<OutbreakData> data) {
    _outbreaks = data;
    notifyListeners();
  }

  /// Logout user
  Future<void> logout() async {
    _currentUser = null;
    _scanResults = [];
    _schedules = [];
    _statistics = {};
    await _localStorage.clearAllData();
    notifyListeners();
  }
}
