import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:easy_localization/easy_localization.dart';

/// Service untuk mengelola konten multibahasa (penyakit, tanaman, pestisida)
class ContentService {
  static final ContentService _instance = ContentService._internal();
  factory ContentService() => _instance;
  ContentService._internal();

  // Cache untuk konten yang sudah dimuat
  final Map<String, Map<String, dynamic>> _diseaseContentCache = {};
  final Map<String, Map<String, dynamic>> _plantContentCache = {};
  final Map<String, Map<String, dynamic>> _pesticideContentCache = {};

  /// Mendapatkan kode bahasa saat ini
  String getCurrentLanguageCode(BuildContext context) {
    return context.locale.languageCode;
  }

  /// Memuat konten pestisida berdasarkan bahasa
  Future<Map<String, dynamic>> loadPesticideContent(String langCode) async {
    // Cek cache
    if (_pesticideContentCache.containsKey(langCode)) {
      return _pesticideContentCache[langCode]!;
    }

    try {
      // Coba muat file bahasa spesifik
      final String jsonString = await rootBundle.loadString(
        'assets/content/pesticides_$langCode.json',
      );
      final Map<String, dynamic> content = json.decode(jsonString);
      _pesticideContentCache[langCode] = content;
      return content;
    } catch (e) {
      // Fallback ke Bahasa Indonesia jika file tidak ditemukan
      try {
        if (langCode != 'id' && !_pesticideContentCache.containsKey('id')) {
          final String jsonString = await rootBundle.loadString(
            'assets/content/pesticides_id.json',
          );
          final Map<String, dynamic> content = json.decode(jsonString);
          _pesticideContentCache['id'] = content;
        }
        return _pesticideContentCache['id'] ?? {};
      } catch (e2) {
        return {};
      }
    }
  }

  /// Mendapatkan konten pestisida berdasarkan ID dan bahasa
  Future<Map<String, dynamic>?> getPesticideContent(
    String pesticideId,
    String langCode,
  ) async {
    final content = await loadPesticideContent(langCode);
    return content[pesticideId] as Map<String, dynamic>?;
  }

  /// Memuat konten tanaman berdasarkan bahasa
  Future<Map<String, dynamic>> loadPlantContent(String langCode) async {
    // Cek cache
    if (_plantContentCache.containsKey(langCode)) {
      return _plantContentCache[langCode]!;
    }

    try {
      // Coba muat file bahasa spesifik
      final String jsonString = await rootBundle.loadString(
        'assets/content/plants_$langCode.json',
      );
      final Map<String, dynamic> content = json.decode(jsonString);
      _plantContentCache[langCode] = content;
      return content;
    } catch (e) {
      // Fallback ke Bahasa Indonesia jika file tidak ditemukan
      try {
        if (langCode != 'id' && !_plantContentCache.containsKey('id')) {
          final String jsonString = await rootBundle.loadString(
            'assets/content/plants_id.json',
          );
          final Map<String, dynamic> content = json.decode(jsonString);
          _plantContentCache['id'] = content;
        }
        return _plantContentCache['id'] ?? {};
      } catch (e2) {
        return {};
      }
    }
  }

  /// Mendapatkan konten tanaman berdasarkan ID dan bahasa
  Future<Map<String, dynamic>?> getPlantContent(
    String plantId,
    String langCode,
  ) async {
    final content = await loadPlantContent(langCode);
    return content[plantId] as Map<String, dynamic>?;
  }

  /// Memuat konten penyakit berdasarkan bahasa
  Future<Map<String, dynamic>> loadDiseaseContent(String langCode) async {
    // Cek cache
    if (_diseaseContentCache.containsKey(langCode)) {
      return _diseaseContentCache[langCode]!;
    }

    try {
      // Coba muat file bahasa spesifik
      final String jsonString = await rootBundle.loadString(
        'assets/content/diseases_$langCode.json',
      );
      final Map<String, dynamic> content = json.decode(jsonString);
      _diseaseContentCache[langCode] = content;
      return content;
    } catch (e) {
      // Fallback ke Bahasa Indonesia jika file tidak ditemukan
      try {
        if (langCode != 'id' && !_diseaseContentCache.containsKey('id')) {
          final String jsonString = await rootBundle.loadString(
            'assets/content/diseases_id.json',
          );
          final Map<String, dynamic> content = json.decode(jsonString);
          _diseaseContentCache['id'] = content;
        }
        return _diseaseContentCache['id'] ?? {};
      } catch (e2) {
        return {};
      }
    }
  }

  /// Mendapatkan konten penyakit berdasarkan ID dan bahasa
  Future<Map<String, dynamic>?> getDiseaseContent(
    String diseaseId,
    String langCode,
  ) async {
    final content = await loadDiseaseContent(langCode);
    return content[diseaseId] as Map<String, dynamic>?;
  }

  /// Mendapatkan nama penyakit dalam bahasa saat ini
  Future<String> getDiseaseName(
    String diseaseId,
    String defaultName,
    String langCode,
  ) async {
    final content = await getDiseaseContent(diseaseId, langCode);
    return content?['name'] ?? defaultName;
  }

  /// Mendapatkan deskripsi penyakit dalam bahasa saat ini
  Future<String> getDiseaseDescription(
    String diseaseId,
    String defaultDescription,
    String langCode,
  ) async {
    final content = await getDiseaseContent(diseaseId, langCode);
    return content?['description'] ?? defaultDescription;
  }

  /// Mendapatkan gejala penyakit dalam bahasa saat ini
  Future<String> getDiseaseSymptoms(
    String diseaseId,
    String defaultSymptoms,
    String langCode,
  ) async {
    final content = await getDiseaseContent(diseaseId, langCode);
    return content?['symptoms'] ?? defaultSymptoms;
  }

  /// Mendapatkan penyebab penyakit dalam bahasa saat ini
  Future<String> getDiseaseCauses(
    String diseaseId,
    String defaultCauses,
    String langCode,
  ) async {
    final content = await getDiseaseContent(diseaseId, langCode);
    return content?['causes'] ?? defaultCauses;
  }

  /// Hapus cache (untuk refresh)
  void clearCache() {
    _diseaseContentCache.clear();
    _plantContentCache.clear();
    _pesticideContentCache.clear();
  }
}

/// Extension untuk Disease model untuk mendukung multilingual
extension DiseaseLocalization on dynamic {
  /// Mendapatkan nama penyakit dalam bahasa saat ini
  Future<String> getLocalizedName(BuildContext context) async {
    final langCode = context.locale.languageCode;
    // Jika bahasa Indonesia, gunakan nameIndonesia langsung
    if (langCode == 'id') {
      return this.nameIndonesia;
    }
    // Untuk bahasa lain, ambil dari content service
    return await ContentService().getDiseaseName(
      this.id,
      this.nameIndonesia,
      langCode,
    );
  }

  /// Mendapatkan deskripsi penyakit dalam bahasa saat ini
  Future<String> getLocalizedDescription(BuildContext context) async {
    final langCode = context.locale.languageCode;
    if (langCode == 'id') {
      return this.description;
    }
    return await ContentService().getDiseaseDescription(
      this.id,
      this.description,
      langCode,
    );
  }

  /// Mendapatkan gejala penyakit dalam bahasa saat ini
  Future<String> getLocalizedSymptoms(BuildContext context) async {
    final langCode = context.locale.languageCode;
    if (langCode == 'id') {
      return this.symptoms;
    }
    return await ContentService().getDiseaseSymptoms(
      this.id,
      this.symptoms,
      langCode,
    );
  }

  /// Mendapatkan penyebab penyakit dalam bahasa saat ini
  Future<String> getLocalizedCauses(BuildContext context) async {
    final langCode = context.locale.languageCode;
    if (langCode == 'id') {
      return this.causes;
    }
    return await ContentService().getDiseaseCauses(
      this.id,
      this.causes,
      langCode,
    );
  }
}
