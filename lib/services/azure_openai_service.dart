import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/scan_result.dart';

class AzureOpenAIService {
  static String get _endpoint => AppConfig.azureOpenAIEndpoint;
  static String get _apiKey => AppConfig.azureOpenAIKey;
  static String get _deploymentName => AppConfig.azureOpenAIDeploymentName;
  static const String _apiVersion = AppConfig.azureOpenAIApiVersion;

  /// Check if using Azure endpoint or direct OpenAI
  static bool get _isAzure =>
      _endpoint.contains('azure.com') ||
      _endpoint.contains('cognitiveservices');

  /// Get the correct API URL based on endpoint type
  Uri _getApiUrl() {
    if (_isAzure) {
      return Uri.parse(
        '$_endpoint/openai/deployments/$_deploymentName/chat/completions?api-version=$_apiVersion',
      );
    } else {
      // Direct OpenAI API
      return Uri.parse('https://api.openai.com/v1/chat/completions');
    }
  }

  /// Get headers based on endpoint type
  Map<String, String> _getHeaders() {
    if (_isAzure) {
      return {'Content-Type': 'application/json', 'api-key': _apiKey};
    } else {
      // Direct OpenAI API uses Authorization header
      return {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      };
    }
  }

  /// Get model name for request body (needed for direct OpenAI)
  String get _modelName => _isAzure ? _deploymentName : 'gpt-4o-mini';

  /// Get AI consultation for plant disease treatment
  Future<ConsultationResponse?> getConsultation({
    required ScanResult scanResult,
    String? additionalQuestion,
    String language = 'id', // id for Indonesian, sasak for Sasak dialect
  }) async {
    try {
      final prompt = _buildPrompt(scanResult, additionalQuestion, language);

      final requestBody = {
        'messages': [
          {'role': 'system', 'content': _getSystemPrompt(language)},
          {'role': 'user', 'content': prompt},
        ],
        'temperature': 0.7,
        'max_tokens': 1500,
        'top_p': 0.95,
      };

      // Add model for direct OpenAI
      if (!_isAzure) {
        requestBody['model'] = _modelName;
      }

      final response = await http.post(
        _getApiUrl(),
        headers: _getHeaders(),
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ConsultationResponse.fromJson(data, scanResult.id);
      } else {
        print('OpenAI API Error: ${response.statusCode}');
        print('Response: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error calling OpenAI API: $e');
      return null;
    }
  }

  /// Ask follow-up question
  Future<String?> askFollowUp({
    required String context,
    required String question,
    String language = 'id',
  }) async {
    try {
      final requestBody = {
        'messages': [
          {'role': 'system', 'content': _getSystemPrompt(language)},
          {'role': 'assistant', 'content': context},
          {'role': 'user', 'content': question},
        ],
        'temperature': 0.7,
        'max_tokens': 800,
      };

      // Add model for direct OpenAI
      if (!_isAzure) {
        requestBody['model'] = _modelName;
      }

      final response = await http.post(
        _getApiUrl(),
        headers: _getHeaders(),
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['choices']?[0]?['message']?['content'];
      }
      return null;
    } catch (e) {
      print('Error asking follow-up: $e');
      return null;
    }
  }

  String _getSystemPrompt(String language) {
    if (language == 'sasak') {
      return '''
Kamu adalah ahli pertanian yang ramah dan berpengalaman di Nusa Tenggara Barat.
Jawab dalam campuran Bahasa Indonesia dan dialek Sasak Lombok yang sederhana.
Gunakan kata-kata seperti: 
- "Bapak/Ibu" untuk sapaan
- "Tie" (iya), "Ndek" (tidak)
- "Mbe" (apa), "Piran" (kapan)
Fokus pada solusi praktis yang bisa dilakukan petani lokal dengan bahan yang tersedia.
Berikan saran pestisida yang mudah didapat di toko pertanian lokal NTB.
''';
    }

    return '''
Kamu adalah ahli agronomi berpengalaman yang membantu petani di Nusa Tenggara Barat (NTB), Indonesia.
Tugasmu adalah memberikan saran pengobatan tanaman yang praktis, mudah dipahami, dan sesuai dengan kondisi lokal.

PENTING:
1. Gunakan Bahasa Indonesia yang sederhana dan ramah petani
2. Berikan saran pestisida/fungisida yang tersedia di toko pertanian lokal
3. Sertakan dosis yang tepat dan cara aplikasi
4. Berikan alternatif organik jika memungkinkan
5. Sebutkan waktu terbaik untuk aplikasi obat
6. Ingatkan tentang masa tunggu sebelum panen
7. Berikan tips pencegahan untuk masa depan

Format jawaban:
1. **Diagnosis**: Penjelasan singkat tentang penyakit
2. **Tingkat Keparahan**: Penjelasan kondisi tanaman
3. **Tindakan Segera**: Langkah pertama yang harus dilakukan
4. **Rekomendasi Obat**: Nama obat, dosis, dan cara pakai
5. **Jadwal Pengobatan**: Kapan dan berapa kali aplikasi
6. **Pencegahan**: Tips untuk mencegah serangan berulang
''';
  }

  String _buildPrompt(
    ScanResult scanResult,
    String? additionalQuestion,
    String language,
  ) {
    final diseaseName =
        scanResult.detectedDisease?.nameIndonesia ??
        scanResult.detectedDisease?.name ??
        'Penyakit tidak diketahui';

    String prompt =
        '''
Saya petani di NTB dan tanaman ${scanResult.plantType} saya terdeteksi terkena ${diseaseName}.

Detail:
- Tingkat kepercayaan deteksi: ${scanResult.confidenceScore.toStringAsFixed(1)}%
- Tingkat keparahan: ${scanResult.severityText} (${scanResult.severityPercentage.toStringAsFixed(0)}%)
- Lokasi: ${scanResult.locationName ?? 'NTB'}

Tolong berikan:
1. Penjelasan tentang penyakit ini
2. Rekomendasi obat yang bisa saya beli di toko pertanian
3. Dosis dan cara pemakaian yang tepat
4. Jadwal penyemprotan yang disarankan
5. Tips pencegahan ke depannya
''';

    if (additionalQuestion != null && additionalQuestion.isNotEmpty) {
      prompt += '\n\nPertanyaan tambahan: $additionalQuestion';
    }

    return prompt;
  }
}

class ConsultationResponse {
  final String scanResultId;
  final String responseText;
  final List<TreatmentRecommendation> recommendations;
  final DateTime timestamp;

  ConsultationResponse({
    required this.scanResultId,
    required this.responseText,
    required this.recommendations,
    required this.timestamp,
  });

  factory ConsultationResponse.fromJson(
    Map<String, dynamic> json,
    String scanResultId,
  ) {
    final content = json['choices']?[0]?['message']?['content'] ?? '';

    return ConsultationResponse(
      scanResultId: scanResultId,
      responseText: content,
      recommendations: _parseRecommendations(content),
      timestamp: DateTime.now(),
    );
  }

  static List<TreatmentRecommendation> _parseRecommendations(String content) {
    // Parse recommendations from AI response
    List<TreatmentRecommendation> recommendations = [];

    // Look for pesticide/treatment mentions
    final pesticides = [
      'Dithane',
      'Antracol',
      'Score',
      'Amistar',
      'Regent',
      'Confidor',
      'Decis',
      'Furadan',
      'Gramoxone',
      'Matador',
    ];

    for (var pesticide in pesticides) {
      if (content.toLowerCase().contains(pesticide.toLowerCase())) {
        recommendations.add(
          TreatmentRecommendation(
            name: pesticide,
            type: 'pesticide',
            mentionedInResponse: true,
          ),
        );
      }
    }

    return recommendations;
  }
}

class TreatmentRecommendation {
  final String name;
  final String type;
  final String? dosage;
  final String? applicationMethod;
  final bool mentionedInResponse;

  TreatmentRecommendation({
    required this.name,
    required this.type,
    this.dosage,
    this.applicationMethod,
    this.mentionedInResponse = false,
  });
}
