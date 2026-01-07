/// AgriVision NTB - Application Configuration
/// Konfigurasi Azure dan API endpoints
/// API Keys dibaca dari file .env untuk keamanan

import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  // Azure Custom Vision Configuration
  static String get customVisionEndpoint =>
      dotenv.env['CUSTOM_VISION_ENDPOINT'] ?? '';
  static String get customVisionPredictionKey =>
      dotenv.env['CUSTOM_VISION_PREDICTION_KEY'] ?? '';
  static String get customVisionProjectId =>
      dotenv.env['CUSTOM_VISION_PROJECT_ID'] ?? '';
  static String get customVisionPublishedName =>
      dotenv.env['CUSTOM_VISION_PUBLISHED_NAME'] ?? '';

  // Azure OpenAI Configuration
  static String get azureOpenAIEndpoint =>
      dotenv.env['AZURE_OPENAI_ENDPOINT'] ?? '';
  static String get azureOpenAIKey => dotenv.env['AZURE_OPENAI_KEY'] ?? '';
  static String get azureOpenAIDeploymentName =>
      dotenv.env['AZURE_OPENAI_DEPLOYMENT_NAME'] ?? 'gpt-4o';
  static const String azureOpenAIApiVersion = '2024-02-15-preview';

  // Azure Blob Storage Configuration
  static String get blobStorageConnectionString =>
      dotenv.env['BLOB_STORAGE_CONNECTION_STRING'] ?? '';
  static const String blobContainerName = 'leaf-images';

  // Azure SQL Database Configuration
  static String get azureSQLEndpoint => dotenv.env['AZURE_SQL_ENDPOINT'] ?? '';

  // Azure Functions API Base URL
  static String get azureFunctionsBaseUrl =>
      dotenv.env['AZURE_FUNCTIONS_BASE_URL'] ?? '';

  // Azure Maps Configuration
  static String get azureMapsKey => dotenv.env['AZURE_MAPS_KEY'] ?? '';

  // App Settings
  static const String appName = 'AgriVision NTB';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Petani Cerdas, Pertanian Sehat';

  // NTB Region Bounds (Nusa Tenggara Barat)
  static const double ntbMinLat = -9.0;
  static const double ntbMaxLat = -8.0;
  static const double ntbMinLng = 115.5;
  static const double ntbMaxLng = 119.5;

  // Default Location (Mataram, NTB)
  static const double defaultLat = -8.5833;
  static const double defaultLng = 116.1167;

  /// Check if API keys are configured
  static bool get isConfigured =>
      customVisionEndpoint.isNotEmpty &&
      customVisionPredictionKey.isNotEmpty &&
      azureOpenAIEndpoint.isNotEmpty &&
      azureOpenAIKey.isNotEmpty;
}
