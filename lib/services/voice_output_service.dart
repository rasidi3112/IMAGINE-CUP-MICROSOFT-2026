// AgriVision NTB - Voice Output Service
// Text-to-Speech untuk petani lansia
// Fitur aksesibilitas untuk membacakan hasil scan dan rekomendasi AI

import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service untuk voice output (Text-to-Speech)
/// Membantu petani lansia yang kesulitan membaca
class VoiceOutputService {
  static final VoiceOutputService _instance = VoiceOutputService._internal();
  factory VoiceOutputService() => _instance;
  VoiceOutputService._internal();

  FlutterTts? _flutterTts;
  bool _isInitialized = false;
  bool _isEnabled = false;
  bool _isSpeaking = false;
  double _speechRate = 0.4; // Slower for elderly (0.0 - 1.0)
  double _pitch = 1.0;
  double _volume = 1.0;
  String _currentLanguage = 'id-ID';

  // Getters
  bool get isEnabled => _isEnabled;
  bool get isSpeaking => _isSpeaking;
  double get speechRate => _speechRate;
  String get currentLanguage => _currentLanguage;

  /// Initialize TTS service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _flutterTts = FlutterTts();

      // Load saved settings
      await _loadSettings();

      // Configure TTS
      await _flutterTts!.setLanguage(_currentLanguage);
      await _flutterTts!.setSpeechRate(_speechRate);
      await _flutterTts!.setPitch(_pitch);
      await _flutterTts!.setVolume(_volume);

      // Set up handlers
      _flutterTts!.setStartHandler(() {
        _isSpeaking = true;
        debugPrint('VoiceOutput: Started speaking');
      });

      _flutterTts!.setCompletionHandler(() {
        _isSpeaking = false;
        debugPrint('VoiceOutput: Finished speaking');
      });

      _flutterTts!.setCancelHandler(() {
        _isSpeaking = false;
        debugPrint('VoiceOutput: Cancelled');
      });

      _flutterTts!.setErrorHandler((message) {
        _isSpeaking = false;
        debugPrint('VoiceOutput Error: $message');
      });

      // iOS specific
      await _flutterTts!.setIosAudioCategory(
        IosTextToSpeechAudioCategory.playback,
        [
          IosTextToSpeechAudioCategoryOptions.allowBluetooth,
          IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
          IosTextToSpeechAudioCategoryOptions.mixWithOthers,
          IosTextToSpeechAudioCategoryOptions.defaultToSpeaker,
        ],
        IosTextToSpeechAudioMode.voicePrompt,
      );

      _isInitialized = true;
      debugPrint('VoiceOutput: Initialized successfully');
    } catch (e) {
      debugPrint('VoiceOutput: Failed to initialize - $e');
    }
  }

  /// Load saved settings
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    // Default to true if not set, so users can hear it out of the box?
    // Or keep false but manual button works. Let's keep false but make manual button work.
    _isEnabled = prefs.getBool('voice_output_enabled') ?? true;
    _speechRate = prefs.getDouble('voice_speech_rate') ?? 0.4;
    _currentLanguage = prefs.getString('voice_language') ?? 'id-ID';
  }

  /// Save settings
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('voice_output_enabled', _isEnabled);
    await prefs.setDouble('voice_speech_rate', _speechRate);
    await prefs.setString('voice_language', _currentLanguage);
  }

  /// Enable/disable voice output
  Future<void> setEnabled(bool enabled) async {
    _isEnabled = enabled;
    await _saveSettings();

    if (!enabled) {
      await stop();
    }

    debugPrint('VoiceOutput: ${enabled ? 'Enabled' : 'Disabled'}');
  }

  /// Set speech rate (0.0 - 1.0)
  /// Untuk lansia, gunakan 0.3 - 0.5 (lebih lambat)
  Future<void> setSpeechRate(double rate) async {
    _speechRate = rate.clamp(0.1, 1.0);
    await _flutterTts?.setSpeechRate(_speechRate);
    await _saveSettings();
    debugPrint('VoiceOutput: Speech rate set to $_speechRate');
  }

  /// Set language
  Future<void> setLanguage(String languageCode) async {
    // Map app language codes to TTS language codes
    final ttsLanguage = _mapLanguageCode(languageCode);
    _currentLanguage = ttsLanguage;
    await _flutterTts?.setLanguage(ttsLanguage);
    await _saveSettings();
    debugPrint('VoiceOutput: Language set to $ttsLanguage');
  }

  /// Map app language codes to TTS language codes
  String _mapLanguageCode(String appCode) {
    switch (appCode) {
      case 'id':
        return 'id-ID';
      case 'en':
        return 'en-US';
      case 'sas': // Sasak - fallback to Indonesian
      case 'mbj': // Mbojo - fallback to Indonesian
      case 'smw': // Samawa - fallback to Indonesian
        return 'id-ID';
      default:
        return 'id-ID';
    }
  }

  /// Speak text
  /// [ignoreEnabledState] if true, will speak even if _isEnabled is false (for manual triggers)
  Future<void> speak(String text, {bool ignoreEnabledState = false}) async {
    // If not initialized, try to initialize
    if (!_isInitialized) {
      await initialize();
    }

    if ((!_isEnabled && !ignoreEnabledState) || text.isEmpty) return;

    try {
      // Stop any current speech
      if (_isSpeaking) {
        await stop();
      }

      // Clean text for TTS (remove markdown, emojis, etc.)
      final cleanText = _cleanTextForTTS(text);

      if (cleanText.isNotEmpty) {
        await _flutterTts!.speak(cleanText);
        debugPrint(
          'VoiceOutput: Speaking "${cleanText.substring(0, cleanText.length.clamp(0, 50))}..."',
        );
      }
    } catch (e) {
      debugPrint('VoiceOutput: Error speaking - $e');
    }
  }

  /// Clean text for TTS (remove markdown, emojis, special characters)
  String _cleanTextForTTS(String text) {
    String cleaned = text;

    // Remove emojis
    cleaned = cleaned.replaceAll(
      RegExp(r'[\u{1F600}-\u{1F64F}]', unicode: true),
      '',
    );
    cleaned = cleaned.replaceAll(
      RegExp(r'[\u{1F300}-\u{1F5FF}]', unicode: true),
      '',
    );
    cleaned = cleaned.replaceAll(
      RegExp(r'[\u{1F680}-\u{1F6FF}]', unicode: true),
      '',
    );
    cleaned = cleaned.replaceAll(
      RegExp(r'[\u{1F1E0}-\u{1F1FF}]', unicode: true),
      '',
    );
    cleaned = cleaned.replaceAll(
      RegExp(r'[\u{2600}-\u{26FF}]', unicode: true),
      '',
    );
    cleaned = cleaned.replaceAll(
      RegExp(r'[\u{2700}-\u{27BF}]', unicode: true),
      '',
    );

    // Remove markdown formatting
    cleaned = cleaned.replaceAll(RegExp(r'\*\*(.+?)\*\*'), r'\1'); // Bold
    cleaned = cleaned.replaceAll(RegExp(r'\*(.+?)\*'), r'\1'); // Italic
    cleaned = cleaned.replaceAll(RegExp(r'#{1,6}\s'), ''); // Headers
    cleaned = cleaned.replaceAll(RegExp(r'\[(.+?)\]\(.+?\)'), r'\1'); // Links
    cleaned = cleaned.replaceAll('•', ','); // Bullet points

    // Remove excess whitespace
    cleaned = cleaned.replaceAll(RegExp(r'\n{3,}'), '\n\n');
    cleaned = cleaned.replaceAll(RegExp(r' {2,}'), ' ');

    return cleaned.trim();
  }

  /// Speak scan result
  Future<void> speakScanResult({
    required String plantType,
    required String diseaseName,
    required double severity,
    required bool isHealthy,
  }) async {
    if (!_isEnabled) return;

    String message;
    if (isHealthy) {
      message =
          'Hasil scan menunjukkan tanaman $plantType dalam kondisi sehat. '
          'Lanjutkan perawatan seperti biasa.';
    } else {
      message =
          'Hasil scan menunjukkan tanaman $plantType terdeteksi penyakit $diseaseName '
          'dengan tingkat keparahan ${severity.toStringAsFixed(0)} persen. '
          'Silakan lihat rekomendasi pengobatan di bawah.';
    }

    await speak(message);
  }

  /// Speak AI recommendation
  Future<void> speakAIRecommendation(String recommendation) async {
    if (!_isEnabled) return;

    await speak('Berikut adalah rekomendasi AI: $recommendation');
  }

  /// Speak treatment reminder
  Future<void> speakTreatmentReminder({
    required String treatmentName,
    required String time,
  }) async {
    if (!_isEnabled) return;

    await speak('Pengingat perawatan: $treatmentName dijadwalkan pada $time');
  }

  /// Speak weather warning
  Future<void> speakWeatherWarning(String warning) async {
    if (!_isEnabled) return;

    await speak('Peringatan cuaca: $warning');
  }

  /// Speak disease info summary
  Future<void> speakDiseaseInfo({
    required String diseaseName,
    required String symptoms,
    required String treatment,
  }) async {
    if (!_isEnabled) return;

    final message =
        'Informasi penyakit $diseaseName. '
        'Gejala: $symptoms. '
        'Pengobatan yang disarankan: $treatment';

    await speak(message);
  }

  /// Speak confirmation
  Future<void> speakConfirmation(String message) async {
    if (!_isEnabled) return;
    await speak(message);
  }

  /// Speak error
  Future<void> speakError(String error) async {
    if (!_isEnabled) return;
    await speak('Terjadi kesalahan: $error');
  }

  /// Pause speaking
  Future<void> pause() async {
    try {
      await _flutterTts?.pause();
      debugPrint('VoiceOutput: Paused');
    } catch (e) {
      debugPrint('VoiceOutput: Error pausing - $e');
    }
  }

  /// Stop speaking
  Future<void> stop() async {
    try {
      await _flutterTts?.stop();
      _isSpeaking = false;
      debugPrint('VoiceOutput: Stopped');
    } catch (e) {
      debugPrint('VoiceOutput: Error stopping - $e');
    }
  }

  /// Get available languages
  Future<List<dynamic>?> getAvailableLanguages() async {
    try {
      return await _flutterTts?.getLanguages;
    } catch (e) {
      debugPrint('VoiceOutput: Error getting languages - $e');
      return null;
    }
  }

  /// Check if TTS is available
  Future<bool> isLanguageAvailable(String language) async {
    try {
      final result = await _flutterTts?.isLanguageAvailable(language);
      return result == 1;
    } catch (e) {
      return false;
    }
  }

  /// Dispose TTS
  Future<void> dispose() async {
    await stop();
    _isInitialized = false;
  }
}

/// Extension untuk kemudahan akses dari widget
extension VoiceOutputExtension on String {
  /// Bicara teks ini menggunakan VoiceOutputService
  Future<void> speakAloud() async {
    await VoiceOutputService().speak(this);
  }
}
