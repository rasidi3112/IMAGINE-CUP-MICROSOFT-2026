import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/disease.dart';
import '../models/scan_result.dart';

class CustomVisionService {
  static String get _baseUrl => AppConfig.customVisionEndpoint;
  static String get _predictionKey => AppConfig.customVisionPredictionKey;
  static String get _projectId => AppConfig.customVisionProjectId;
  static String get _publishedName => AppConfig.customVisionPublishedName;

  /// Analyze leaf image for disease detection
  Future<PredictionResult?> analyzeImage(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      return await analyzeImageBytes(bytes);
    } catch (e) {
      print('Error analyzing image: $e');
      return null;
    }
  }

  /// Analyze leaf image bytes for disease detection
  Future<PredictionResult?> analyzeImageBytes(Uint8List imageBytes) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/customvision/v3.0/Prediction/$_projectId/classify/iterations/$_publishedName/image',
      );

      final response = await http.post(
        url,
        headers: {
          'Prediction-Key': _predictionKey,
          'Content-Type': 'application/octet-stream',
        },
        body: imageBytes,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return PredictionResult.fromJson(data);
      } else {
        print('Custom Vision API Error: ${response.statusCode}');
        print('Response: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error calling Custom Vision API: $e');
      return null;
    }
  }

  /// Convert prediction result to ScanResult
  ScanResult? predictionToScanResult({
    required PredictionResult prediction,
    required String imagePath,
    required double latitude,
    required double longitude,
    required String plantType,
  }) {
    if (prediction.predictions.isEmpty) return null;

    final topPrediction = prediction.predictions.first;
    final disease = _mapTagToDisease(topPrediction.tagName);
    final severity = _calculateSeverity(topPrediction.probability);

    return ScanResult(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      imagePath: imagePath,
      scanDate: DateTime.now(),
      latitude: latitude,
      longitude: longitude,
      plantType: plantType,
      detectedDisease: disease,
      confidenceScore: topPrediction.probability * 100,
      severityLevel: severity,
      severityPercentage: _probabilityToSeverityPercentage(
        topPrediction.probability,
      ),
    );
  }

  /// Map prediction tag to Disease object
  Disease? _mapTagToDisease(String tagName) {
    final tagLower = tagName.toLowerCase();

    // Map common Custom Vision tags to Disease objects
    for (var disease in Disease.commonDiseases) {
      if (disease.name.toLowerCase().contains(tagLower) ||
          disease.nameIndonesia.toLowerCase().contains(tagLower) ||
          disease.id.contains(tagLower)) {
        return disease;
      }
    }

    // If healthy leaf detected
    if (tagLower == 'healthy' || tagLower == 'sehat') {
      return null;
    }

    // Return a generic disease if no match found
    return Disease(
      id: tagLower.replaceAll(' ', '_'),
      name: tagName,
      nameIndonesia: tagName,
      description: 'Penyakit terdeteksi pada daun tanaman.',
      symptoms: 'Lihat detail lebih lanjut dengan konsultasi AI.',
      causes: 'Perlu analisis lebih lanjut.',
      affectedPlants: [],
    );
  }

  /// Calculate severity level from probability
  SeverityLevel _calculateSeverity(double probability) {
    if (probability < 0.3) return SeverityLevel.healthy;
    if (probability < 0.5) return SeverityLevel.low;
    if (probability < 0.7) return SeverityLevel.medium;
    if (probability < 0.85) return SeverityLevel.high;
    return SeverityLevel.critical;
  }

  /// Convert probability to severity percentage
  double _probabilityToSeverityPercentage(double probability) {
    // Transform probability to a more useful severity scale
    return (probability * 100).clamp(0, 100);
  }
}

/// Prediction result from Azure Custom Vision
class PredictionResult {
  final String id;
  final String project;
  final String iteration;
  final DateTime created;
  final List<Prediction> predictions;

  PredictionResult({
    required this.id,
    required this.project,
    required this.iteration,
    required this.created,
    required this.predictions,
  });

  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    final predictions =
        (json['predictions'] as List?)
            ?.map((p) => Prediction.fromJson(p))
            .toList() ??
        [];

    // Sort by probability descending
    predictions.sort((a, b) => b.probability.compareTo(a.probability));

    return PredictionResult(
      id: json['id'] ?? '',
      project: json['project'] ?? '',
      iteration: json['iteration'] ?? '',
      created: DateTime.tryParse(json['created'] ?? '') ?? DateTime.now(),
      predictions: predictions,
    );
  }

  Prediction? get topPrediction =>
      predictions.isNotEmpty ? predictions.first : null;

  bool get isHealthy {
    if (predictions.isEmpty) return true;
    final top = predictions.first;
    return top.tagName.toLowerCase() == 'healthy' ||
        top.tagName.toLowerCase() == 'sehat' ||
        top.probability < 0.3;
  }
}

class Prediction {
  final String tagId;
  final String tagName;
  final double probability;

  Prediction({
    required this.tagId,
    required this.tagName,
    required this.probability,
  });

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      tagId: json['tagId'] ?? '',
      tagName: json['tagName'] ?? '',
      probability: (json['probability'] ?? 0).toDouble(),
    );
  }

  double get percentageConfidence => probability * 100;
}
