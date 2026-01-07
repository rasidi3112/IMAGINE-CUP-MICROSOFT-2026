// AgriVision NTB - Scan Screen
// Layar untuk scan daun tanaman

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../config/app_theme.dart';
import '../../models/scan_result.dart';
import '../../providers/app_provider.dart';
import '../../services/custom_vision_service.dart';
import '../../services/local_storage_service.dart';
import '../../services/location_service.dart';
import '../../services/gamification_service.dart';

import '../../widgets/common_widgets.dart';
import '../../widgets/gamification_widgets.dart';
import 'scan_result_screen.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> with WidgetsBindingObserver {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;
  bool _isProcessing = false;
  bool _isFlashOn = false;
  String _selectedPlant = 'Jagung';

  final CustomVisionService _customVision = CustomVisionService();
  final LocalStorageService _localStorage = LocalStorageService();
  final LocationService _locationService = LocationService();
  final GamificationService _gamificationService = GamificationService();

  final ImagePicker _imagePicker = ImagePicker();

  final List<String> _plantTypes = [
    'Jagung',
    'Padi',
    'Cabai',
    'Tomat',
    'Kedelai',
    'Kacang',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _cameraController = CameraController(
          _cameras!.first,
          ResolutionPreset.high,
          enableAudio: false,
        );

        await _cameraController!.initialize();

        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
        }
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<void> _toggleFlash() async {
    if (_cameraController == null) return;

    try {
      if (_isFlashOn) {
        await _cameraController!.setFlashMode(FlashMode.off);
      } else {
        await _cameraController!.setFlashMode(FlashMode.torch);
      }
      setState(() {
        _isFlashOn = !_isFlashOn;
      });
    } catch (e) {
      print('Error toggling flash: $e');
    }
  }

  Future<void> _captureImage() async {
    if (_cameraController == null || _isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final XFile image = await _cameraController!.takePicture();
      await _processImage(File(image.path));
    } catch (e) {
      print('Error capturing image: $e');
      _showError('scan.failed_capture'.tr());
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _isProcessing = true;
        });
        await _processImage(File(image.path));
      }
    } catch (e) {
      print('Error picking image: $e');
      _showError('scan.failed_gallery'.tr());
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _processImage(File imageFile) async {
    final provider = Provider.of<AppProvider>(context, listen: false);

    // Get current location
    double lat = -8.5833; // Default Mataram
    double lng = 116.1167;
    String? locationName;

    final position = await _locationService.getCurrentLocation();
    if (position != null) {
      lat = position.latitude;
      lng = position.longitude;
      locationName = await _locationService.getAddressFromCoordinates(lat, lng);
    }

    // Save image locally first (for offline mode)
    final savedPath = await _localStorage.saveImageLocally(imageFile);

    ScanResult? result;

    // Send to Azure Custom Vision for real AI analysis
    if (provider.isOnline) {
      // Online mode: Send to Azure Custom Vision
      final prediction = await _customVision.analyzeImage(imageFile);

      if (prediction != null) {
        result = _customVision.predictionToScanResult(
          prediction: prediction,
          imagePath: savedPath,
          latitude: lat,
          longitude: lng,
          plantType: _selectedPlant,
        );

        if (result != null) {
          result = result.copyWith(locationName: locationName);
        }
      }
    }

    // If offline or API failed, create placeholder result
    result ??= ScanResult(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      imagePath: savedPath,
      scanDate: DateTime.now(),
      latitude: lat,
      longitude: lng,
      locationName: locationName,
      plantType: _selectedPlant,
      confidenceScore: 0,
      severityLevel: SeverityLevel.healthy,
      severityPercentage: 0,
      isSynced: false,
    );

    // Save result
    await provider.addScanResult(result);

    // Record scan for gamification
    final newBadges = await _gamificationService.recordScan();

    // Navigate to result screen
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ScanResultScreen(scanResult: result!),
        ),
      );

      // Show badge popup if new badges unlocked
      if (newBadges.isNotEmpty && mounted) {
        await Future.delayed(const Duration(milliseconds: 500));
        for (final badge in newBadges) {
          if (mounted) {
            BadgeUnlockedPopup.show(context, badge);
          }
        }
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppTheme.dangerRed),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LoadingOverlay(
        isLoading: _isProcessing,
        message: 'scan.analyzing'.tr(),
        child: Stack(
          children: [
            // Camera Preview
            if (_isInitialized && _cameraController != null)
              Positioned.fill(child: CameraPreview(_cameraController!))
            else
              const Center(
                child: CircularProgressIndicator(color: AppTheme.primaryGreen),
              ),

            // Overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withAlpha(150),
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withAlpha(200),
                    ],
                    stops: const [0.0, 0.2, 0.7, 1.0],
                  ),
                ),
              ),
            ),

            // Scanning frame
            Center(
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.primaryGreen, width: 3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  children: [
                    // Corner decorations
                    Positioned(top: -2, left: -2, child: _buildCorner()),
                    Positioned(
                      top: -2,
                      right: -2,
                      child: _buildCorner(isRight: true),
                    ),
                    Positioned(
                      bottom: -2,
                      left: -2,
                      child: _buildCorner(isBottom: true),
                    ),
                    Positioned(
                      bottom: -2,
                      right: -2,
                      child: _buildCorner(isRight: true, isBottom: true),
                    ),
                  ],
                ),
              ),
            ),

            // Top bar
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back button
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(100),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // Title
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(100),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'scan.title'.tr(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Flash toggle
                    IconButton(
                      onPressed: _toggleFlash,
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _isFlashOn
                              ? AppTheme.primaryGreen
                              : Colors.black.withAlpha(100),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _isFlashOn ? Icons.flash_on : Icons.flash_off,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Instructions
            Positioned(
              top: MediaQuery.of(context).size.height * 0.15,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(150),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'scan.tip_1'.tr(),
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            ),

            // Bottom controls
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withAlpha(200)],
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    children: [
                      // Plant type selector
                      SizedBox(
                        height: 40,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _plantTypes.length,
                          itemBuilder: (context, index) {
                            final plant = _plantTypes[index];
                            final isSelected = plant == _selectedPlant;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedPlant = plant;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 12),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppTheme.primaryGreen
                                      : Colors.white.withAlpha(30),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppTheme.primaryGreen
                                        : Colors.white.withAlpha(100),
                                  ),
                                ),
                                child: Text(
                                  plant,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.white.withAlpha(200),
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Capture buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Gallery button
                          IconButton(
                            onPressed: _pickFromGallery,
                            icon: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(30),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withAlpha(100),
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.photo_library,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ),
                          // Capture button
                          GestureDetector(
                            onTap: _captureImage,
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: AppTheme.primaryGradient,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primaryGreen.withAlpha(100),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.camera,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),
                          // Tips button
                          IconButton(
                            onPressed: _showTips,
                            icon: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(30),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withAlpha(100),
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.help_outline,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCorner({bool isRight = false, bool isBottom = false}) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        border: Border(
          top: isBottom
              ? BorderSide.none
              : const BorderSide(color: AppTheme.secondaryGreen, width: 4),
          bottom: isBottom
              ? const BorderSide(color: AppTheme.secondaryGreen, width: 4)
              : BorderSide.none,
          left: isRight
              ? BorderSide.none
              : const BorderSide(color: AppTheme.secondaryGreen, width: 4),
          right: isRight
              ? const BorderSide(color: AppTheme.secondaryGreen, width: 4)
              : BorderSide.none,
        ),
      ),
    );
  }

  void _showTips() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'scan.tips'.tr(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildTipItem('☀️', 'scan.tip_2'.tr(), 'scan.tip_1'.tr()),
            _buildTipItem('🎯', 'scan.tip_3'.tr(), 'scan.take_photo'.tr()),
            _buildTipItem('📏', 'scan.tip_4'.tr(), 'scan.tip_1'.tr()),
            _buildTipItem('🖼️', 'scan.tip_5'.tr(), 'scan.result'.tr()),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(String emoji, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
