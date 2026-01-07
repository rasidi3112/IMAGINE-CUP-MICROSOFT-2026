/// AgriVision NTB - Local Storage Service
/// Service untuk offline mode dan penyimpanan lokal

import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import '../models/scan_result.dart';
import '../models/treatment_schedule.dart';
import '../models/user.dart';

class LocalStorageService {
  static Database? _database;
  static const String _dbName = 'agrivision_ntb.db';
  static const int _dbVersion = 2;

  /// Initialize database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final dbPath = path.join(documentsDirectory.path, _dbName);

    return await openDatabase(
      dbPath,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        phone TEXT NOT NULL,
        email TEXT,
        village TEXT,
        district TEXT,
        regency TEXT,
        latitude REAL,
        longitude REAL,
        profile_image TEXT,
        farm_types TEXT,
        farm_area REAL,
        registered_at TEXT,
        total_scans INTEGER DEFAULT 0,
        diseases_detected INTEGER DEFAULT 0
      )
    ''');

    // Scan results table (for offline storage)
    await db.execute('''
      CREATE TABLE scan_results (
        id TEXT PRIMARY KEY,
        image_path TEXT NOT NULL,
        cloud_image_url TEXT,
        scan_date TEXT NOT NULL,
        latitude REAL,
        longitude REAL,
        location_name TEXT,
        plant_type TEXT,
        disease_data TEXT,
        confidence_score REAL,
        severity_level INTEGER,
        severity_percentage REAL,
        is_synced INTEGER DEFAULT 0,
        ai_response TEXT,
        treatments TEXT
      )
    ''');

    // Treatment schedules table
    await db.execute('''
      CREATE TABLE treatment_schedules (
        id TEXT PRIMARY KEY,
        scan_result_id TEXT,
        treatment_name TEXT NOT NULL,
        treatment_type TEXT,
        description TEXT,
        dosage TEXT,
        scheduled_date TEXT NOT NULL,
        completed_date TEXT,
        is_completed INTEGER DEFAULT 0,
        notification_enabled INTEGER DEFAULT 1,
        notes TEXT,
        reminder_days_before INTEGER DEFAULT 1,
        FOREIGN KEY (scan_result_id) REFERENCES scan_results (id)
      )
    ''');

    // Pending uploads table (for offline mode)
    await db.execute('''
      CREATE TABLE pending_uploads (
        id TEXT PRIMARY KEY,
        scan_result_id TEXT,
        image_path TEXT NOT NULL,
        created_at TEXT NOT NULL,
        retry_count INTEGER DEFAULT 0,
        last_error TEXT,
        FOREIGN KEY (scan_result_id) REFERENCES scan_results (id)
      )
    ''');

    // Farms table (for user's farm management)
    await db.execute('''
      CREATE TABLE farms (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        name TEXT NOT NULL,
        plant_type TEXT NOT NULL,
        area REAL NOT NULL,
        latitude REAL,
        longitude REAL,
        village TEXT,
        district TEXT,
        regency TEXT,
        planting_date TEXT,
        current_growth_stage TEXT,
        status TEXT DEFAULT 'active',
        notes TEXT,
        created_at TEXT,
        updated_at TEXT
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Migration from version 1 to 2: Add farms table
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS farms (
          id TEXT PRIMARY KEY,
          user_id TEXT NOT NULL,
          name TEXT NOT NULL,
          plant_type TEXT NOT NULL,
          area REAL NOT NULL,
          latitude REAL,
          longitude REAL,
          village TEXT,
          district TEXT,
          regency TEXT,
          planting_date TEXT,
          current_growth_stage TEXT,
          status TEXT DEFAULT 'active',
          notes TEXT,
          created_at TEXT,
          updated_at TEXT
        )
      ''');
    }
  }

  // ============ USER METHODS ============

  Future<void> saveUser(User user) async {
    final db = await database;
    await db.insert('users', {
      ...user.toJson(),
      'farm_types': json.encode(user.farmTypes),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<User?> getUser() async {
    final db = await database;
    final results = await db.query('users', limit: 1);
    if (results.isEmpty) return null;

    final userData = results.first;
    return User.fromJson({
      ...userData,
      'farm_types': json.decode(userData['farm_types'] as String? ?? '[]'),
    });
  }

  // ============ SCAN RESULT METHODS ============

  Future<void> saveScanResult(ScanResult result) async {
    final db = await database;
    await db.insert('scan_results', {
      'id': result.id,
      'image_path': result.imagePath,
      'cloud_image_url': result.cloudImageUrl,
      'scan_date': result.scanDate.toIso8601String(),
      'latitude': result.latitude,
      'longitude': result.longitude,
      'location_name': result.locationName,
      'plant_type': result.plantType,
      'disease_data': result.detectedDisease != null
          ? json.encode(result.detectedDisease!.toJson())
          : null,
      'confidence_score': result.confidenceScore,
      'severity_level': result.severityLevel.index,
      'severity_percentage': result.severityPercentage,
      'is_synced': result.isSynced ? 1 : 0,
      'ai_response': result.aiConsultationResponse,
      'treatments': result.recommendedTreatments != null
          ? json.encode(
              result.recommendedTreatments!.map((t) => t.toJson()).toList(),
            )
          : null,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<ScanResult>> getAllScanResults() async {
    final db = await database;
    final results = await db.query('scan_results', orderBy: 'scan_date DESC');

    return results.map((row) => _rowToScanResult(row)).toList();
  }

  Future<List<ScanResult>> getUnsyncedScanResults() async {
    final db = await database;
    final results = await db.query(
      'scan_results',
      where: 'is_synced = ?',
      whereArgs: [0],
    );

    return results.map((row) => _rowToScanResult(row)).toList();
  }

  Future<void> markScanResultSynced(String id) async {
    final db = await database;
    await db.update(
      'scan_results',
      {'is_synced': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  ScanResult _rowToScanResult(Map<String, dynamic> row) {
    return ScanResult.fromJson({
      'id': row['id'],
      'image_path': row['image_path'],
      'cloud_image_url': row['cloud_image_url'],
      'scan_date': row['scan_date'],
      'latitude': row['latitude'],
      'longitude': row['longitude'],
      'location_name': row['location_name'],
      'plant_type': row['plant_type'],
      'disease': row['disease_data'] != null
          ? json.decode(row['disease_data'])
          : null,
      'confidence_score': row['confidence_score'],
      'severity_level': row['severity_level'],
      'severity_percentage': row['severity_percentage'],
      'is_synced': row['is_synced'] == 1,
      'ai_response': row['ai_response'],
      'treatments': row['treatments'] != null
          ? json.decode(row['treatments'])
          : null,
    });
  }

  // ============ TREATMENT SCHEDULE METHODS ============

  Future<void> saveTreatmentSchedule(TreatmentSchedule schedule) async {
    final db = await database;
    await db.insert(
      'treatment_schedules',
      schedule.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TreatmentSchedule>> getAllSchedules() async {
    final db = await database;
    final results = await db.query(
      'treatment_schedules',
      orderBy: 'scheduled_date ASC',
    );

    return results.map((row) => TreatmentSchedule.fromJson(row)).toList();
  }

  Future<List<TreatmentSchedule>> getUpcomingSchedules() async {
    final db = await database;
    final now = DateTime.now().toIso8601String();
    final results = await db.query(
      'treatment_schedules',
      where: 'scheduled_date >= ? AND is_completed = ?',
      whereArgs: [now, 0],
      orderBy: 'scheduled_date ASC',
    );

    return results.map((row) => TreatmentSchedule.fromJson(row)).toList();
  }

  Future<void> markScheduleCompleted(String id) async {
    final db = await database;
    await db.update(
      'treatment_schedules',
      {'is_completed': 1, 'completed_date': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ============ IMAGE STORAGE METHODS ============

  Future<String> saveImageLocally(File imageFile) async {
    final directory = await getApplicationDocumentsDirectory();
    final imagesDir = Directory(path.join(directory.path, 'leaf_images'));

    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }

    final fileName = 'leaf_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final savedPath = path.join(imagesDir.path, fileName);

    await imageFile.copy(savedPath);
    return savedPath;
  }

  Future<void> deleteLocalImage(String imagePath) async {
    final file = File(imagePath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  // ============ PENDING UPLOADS (OFFLINE MODE) ============

  Future<void> addPendingUpload(String scanResultId, String imagePath) async {
    final db = await database;
    await db.insert('pending_uploads', {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'scan_result_id': scanResultId,
      'image_path': imagePath,
      'created_at': DateTime.now().toIso8601String(),
      'retry_count': 0,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getPendingUploads() async {
    final db = await database;
    return await db.query('pending_uploads', orderBy: 'created_at ASC');
  }

  Future<void> removePendingUpload(String id) async {
    final db = await database;
    await db.delete('pending_uploads', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> incrementRetryCount(String id, String error) async {
    final db = await database;
    await db.rawUpdate(
      '''
      UPDATE pending_uploads 
      SET retry_count = retry_count + 1, last_error = ?
      WHERE id = ?
    ''',
      [error, id],
    );
  }

  // ============ STATISTICS ============

  Future<Map<String, dynamic>> getStatistics() async {
    final db = await database;

    final totalScans =
        Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM scan_results'),
        ) ??
        0;

    final diseasesDetected =
        Sqflite.firstIntValue(
          await db.rawQuery(
            'SELECT COUNT(*) FROM scan_results WHERE disease_data IS NOT NULL',
          ),
        ) ??
        0;

    final pendingSync =
        Sqflite.firstIntValue(
          await db.rawQuery(
            'SELECT COUNT(*) FROM scan_results WHERE is_synced = 0',
          ),
        ) ??
        0;

    final upcomingTreatments =
        Sqflite.firstIntValue(
          await db.rawQuery(
            'SELECT COUNT(*) FROM treatment_schedules WHERE is_completed = 0',
          ),
        ) ??
        0;

    return {
      'total_scans': totalScans,
      'diseases_detected': diseasesDetected,
      'pending_sync': pendingSync,
      'upcoming_treatments': upcomingTreatments,
    };
  }

  // ============ FARM METHODS ============

  Future<void> saveFarm(Map<String, dynamic> farm) async {
    final db = await database;
    farm['created_at'] ??= DateTime.now().toIso8601String();
    farm['updated_at'] = DateTime.now().toIso8601String();
    await db.insert(
      'farms',
      farm,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getFarms({String? userId}) async {
    final db = await database;
    if (userId != null) {
      return await db.query(
        'farms',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'created_at DESC',
      );
    }
    return await db.query('farms', orderBy: 'created_at DESC');
  }

  Future<Map<String, dynamic>?> getFarmById(String id) async {
    final db = await database;
    final results = await db.query(
      'farms',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<void> updateFarm(String id, Map<String, dynamic> updates) async {
    final db = await database;
    updates['updated_at'] = DateTime.now().toIso8601String();
    await db.update('farms', updates, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteFarm(String id) async {
    final db = await database;
    await db.delete('farms', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> getFarmCount({String? userId}) async {
    final db = await database;
    if (userId != null) {
      return Sqflite.firstIntValue(
            await db.rawQuery('SELECT COUNT(*) FROM farms WHERE user_id = ?', [
              userId,
            ]),
          ) ??
          0;
    }
    return Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM farms'),
        ) ??
        0;
  }

  // ============ NOTIFICATION SETTINGS ============

  Future<void> saveNotificationSetting(bool enabled) async {
    final db = await database;
    // Create settings table if not exists
    await db.execute('''
      CREATE TABLE IF NOT EXISTS app_settings (
        key TEXT PRIMARY KEY,
        value TEXT
      )
    ''');

    await db.insert('app_settings', {
      'key': 'notifications_enabled',
      'value': enabled ? '1' : '0',
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<bool> getNotificationSetting() async {
    final db = await database;
    // Create settings table if not exists
    await db.execute('''
      CREATE TABLE IF NOT EXISTS app_settings (
        key TEXT PRIMARY KEY,
        value TEXT
      )
    ''');

    final results = await db.query(
      'app_settings',
      where: 'key = ?',
      whereArgs: ['notifications_enabled'],
      limit: 1,
    );

    if (results.isEmpty) return true; // Default: enabled
    return results.first['value'] == '1';
  }

  // ============ CLEAR ALL DATA (LOGOUT) ============

  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('users');
    await db.delete('scan_results');
    await db.delete('treatment_schedules');
    await db.delete('pending_uploads');
    await db.delete('farms');
  }
}
