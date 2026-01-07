/// AgriVision NTB - Sync Service
/// Service untuk sinkronisasi data offline ke Azure

import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/app_config.dart';
import '../models/scan_result.dart';
import 'local_storage_service.dart';
import 'custom_vision_service.dart';

class SyncService {
  final LocalStorageService _localStorage = LocalStorageService();
  final CustomVisionService _customVision = CustomVisionService();

  bool _isSyncing = false;

  /// Check if device is online
  Future<bool> isOnline() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    // connectivity_plus returns List<ConnectivityResult> in newer versions
    if (connectivityResult is List) {
      return !(connectivityResult as List).contains(ConnectivityResult.none);
    }
    return connectivityResult != ConnectivityResult.none;
  }

  /// Listen for connectivity changes
  Stream<bool> get connectivityStream {
    return Connectivity().onConnectivityChanged.map((result) {
      if (result is List) {
        return !(result as List).contains(ConnectivityResult.none);
      }
      return result != ConnectivityResult.none;
    });
  }

  /// Sync all pending data when online
  Future<SyncResult> syncPendingData() async {
    if (_isSyncing) {
      return SyncResult(
        success: false,
        message: 'Sinkronisasi sedang berjalan',
        syncedCount: 0,
        failedCount: 0,
      );
    }

    if (!await isOnline()) {
      return SyncResult(
        success: false,
        message: 'Tidak ada koneksi internet',
        syncedCount: 0,
        failedCount: 0,
      );
    }

    _isSyncing = true;
    int syncedCount = 0;
    int failedCount = 0;

    try {
      // Get all unsynced scan results
      final unsyncedResults = await _localStorage.getUnsyncedScanResults();

      for (var result in unsyncedResults) {
        try {
          // Upload image to Azure Blob Storage
          final cloudUrl = await _uploadImageToBlob(result.imagePath);

          if (cloudUrl != null) {
            // Update result with cloud URL
            final updatedResult = result.copyWith(
              cloudImageUrl: cloudUrl,
              isSynced: true,
            );

            // Send data to Azure Function API
            final apiSuccess = await _sendToApi(updatedResult);

            if (apiSuccess) {
              await _localStorage.saveScanResult(updatedResult);
              await _localStorage.markScanResultSynced(result.id);
              syncedCount++;
            } else {
              failedCount++;
            }
          } else {
            failedCount++;
          }
        } catch (e) {
          // Error syncing result
          failedCount++;
        }
      }

      // Process pending uploads
      final pendingUploads = await _localStorage.getPendingUploads();
      for (var upload in pendingUploads) {
        try {
          final cloudUrl = await _uploadImageToBlob(upload['image_path']);
          if (cloudUrl != null) {
            await _localStorage.removePendingUpload(upload['id']);
            syncedCount++;
          }
        } catch (e) {
          await _localStorage.incrementRetryCount(upload['id'], e.toString());
          failedCount++;
        }
      }

      return SyncResult(
        success: failedCount == 0,
        message: failedCount == 0
            ? 'Sinkronisasi berhasil'
            : 'Beberapa data gagal disinkronkan',
        syncedCount: syncedCount,
        failedCount: failedCount,
      );
    } finally {
      _isSyncing = false;
    }
  }

  /// Upload image to Azure Blob Storage
  Future<String?> _uploadImageToBlob(String imagePath) async {
    try {
      final file = File(imagePath);
      if (!await file.exists()) {
        return null;
      }

      final bytes = await file.readAsBytes();
      final fileName = 'leaf_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // In production, use Azure Blob Storage SDK or SAS token
      final url = Uri.parse(
        '${AppConfig.azureFunctionsBaseUrl}/api/upload-image',
      );

      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/octet-stream',
              'x-filename': fileName,
            },
            body: bytes,
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['url'];
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  /// Send scan result to Azure Function API
  Future<bool> _sendToApi(ScanResult result) async {
    try {
      final url = Uri.parse(
        '${AppConfig.azureFunctionsBaseUrl}/api/scan-results',
      );

      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: json.encode(result.toJson()),
          )
          .timeout(const Duration(seconds: 30));

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  /// Process offline scan when back online
  Future<ScanResult?> processOfflineScan(
    String imagePath,
    double lat,
    double lng,
    String plantType,
  ) async {
    try {
      final imageFile = File(imagePath);

      // Analyze with Custom Vision
      final prediction = await _customVision.analyzeImage(imageFile);

      if (prediction != null) {
        return _customVision.predictionToScanResult(
          prediction: prediction,
          imagePath: imagePath,
          latitude: lat,
          longitude: lng,
          plantType: plantType,
        );
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}

class SyncResult {
  final bool success;
  final String message;
  final int syncedCount;
  final int failedCount;

  SyncResult({
    required this.success,
    required this.message,
    required this.syncedCount,
    required this.failedCount,
  });
}
