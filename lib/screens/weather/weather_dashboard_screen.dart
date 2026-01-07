// AgriVision NTB - Weather Dashboard Screen
// Dashboard cuaca dan rekomendasi pertanian

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import '../../config/app_theme.dart';
import '../../models/weather.dart';
import '../../data/ntb_regions.dart';

class WeatherDashboardScreen extends StatefulWidget {
  const WeatherDashboardScreen({super.key});

  @override
  State<WeatherDashboardScreen> createState() => _WeatherDashboardScreenState();
}

class _WeatherDashboardScreenState extends State<WeatherDashboardScreen> {
  bool _isLoading = true;

  // Data Kabupaten dan Kecamatan NTB dengan koordinat
  final Map<String, List<Map<String, dynamic>>> _ntbLocations = {
    'Kota Mataram': [
      {'name': 'Ampenan', 'lat': -8.5833, 'lon': 116.0833},
      {'name': 'Cakranegara', 'lat': -8.5903, 'lon': 116.1328},
      {'name': 'Mataram', 'lat': -8.5833, 'lon': 116.1167},
      {'name': 'Sekarbela', 'lat': -8.6022, 'lon': 116.0872},
      {'name': 'Selaparang', 'lat': -8.5750, 'lon': 116.1083},
      {'name': 'Sandubaya', 'lat': -8.5944, 'lon': 116.1500},
    ],
    'Lombok Barat': [
      {'name': 'Gerung', 'lat': -8.6567, 'lon': 116.1103},
      {'name': 'Kediri', 'lat': -8.6833, 'lon': 116.1333},
      {'name': 'Kuripan', 'lat': -8.6500, 'lon': 116.0667},
      {'name': 'Labuapi', 'lat': -8.6167, 'lon': 116.0833},
      {'name': 'Lembar', 'lat': -8.7333, 'lon': 116.0667},
      {'name': 'Lingsar', 'lat': -8.5667, 'lon': 116.1833},
      {'name': 'Narmada', 'lat': -8.5667, 'lon': 116.2167},
      {'name': 'Sekotong', 'lat': -8.7500, 'lon': 115.9833},
      {'name': 'Batu Layar', 'lat': -8.5333, 'lon': 116.0667},
      {'name': 'Gunungsari', 'lat': -8.5333, 'lon': 116.1167},
    ],
    'Lombok Tengah': [
      {'name': 'Praya', 'lat': -8.7167, 'lon': 116.2833},
      {'name': 'Praya Barat', 'lat': -8.8000, 'lon': 116.1833},
      {'name': 'Praya Barat Daya', 'lat': -8.8333, 'lon': 116.1333},
      {'name': 'Praya Tengah', 'lat': -8.7500, 'lon': 116.3000},
      {'name': 'Praya Timur', 'lat': -8.7333, 'lon': 116.3667},
      {'name': 'Pujut', 'lat': -8.8500, 'lon': 116.2833},
      {'name': 'Janapria', 'lat': -8.7000, 'lon': 116.3333},
      {'name': 'Kopang', 'lat': -8.6667, 'lon': 116.3000},
      {'name': 'Batukliang', 'lat': -8.6333, 'lon': 116.2833},
      {'name': 'Batukliang Utara', 'lat': -8.6000, 'lon': 116.3167},
      {'name': 'Jonggat', 'lat': -8.6667, 'lon': 116.2500},
      {'name': 'Pringgarata', 'lat': -8.6333, 'lon': 116.3333},
    ],
    'Lombok Timur': [
      {'name': 'Selong', 'lat': -8.6500, 'lon': 116.5333},
      {'name': 'Masbagik', 'lat': -8.6333, 'lon': 116.4500},
      {'name': 'Aikmel', 'lat': -8.5667, 'lon': 116.4333},
      {'name': 'Pringgabaya', 'lat': -8.5500, 'lon': 116.5500},
      {'name': 'Sukamulia', 'lat': -8.6167, 'lon': 116.5000},
      {'name': 'Labuhan Haji', 'lat': -8.5000, 'lon': 116.5833},
      {'name': 'Sakra', 'lat': -8.7000, 'lon': 116.4667},
      {'name': 'Terara', 'lat': -8.6667, 'lon': 116.4167},
      {'name': 'Montong Gading', 'lat': -8.6000, 'lon': 116.3833},
      {'name': 'Sikur', 'lat': -8.5667, 'lon': 116.5000},
      {'name': 'Sembalun', 'lat': -8.4000, 'lon': 116.5333},
    ],
    'Lombok Utara': [
      {'name': 'Tanjung', 'lat': -8.3500, 'lon': 116.1500},
      {'name': 'Pemenang', 'lat': -8.4000, 'lon': 116.0833},
      {'name': 'Gangga', 'lat': -8.3167, 'lon': 116.1833},
      {'name': 'Kayangan', 'lat': -8.2833, 'lon': 116.2333},
      {'name': 'Bayan', 'lat': -8.2667, 'lon': 116.3667},
    ],
    'Sumbawa Barat': [
      {'name': 'Taliwang', 'lat': -8.7431, 'lon': 116.8525},
      {'name': 'Seteluk', 'lat': -8.7000, 'lon': 116.8000},
      {'name': 'Brang Rea', 'lat': -8.7833, 'lon': 116.9167},
      {'name': 'Brang Ene', 'lat': -8.6667, 'lon': 116.8833},
      {'name': 'Jereweh', 'lat': -8.7167, 'lon': 116.7500},
      {'name': 'Maluk', 'lat': -8.7833, 'lon': 116.7000},
      {'name': 'Sekongkang', 'lat': -8.8167, 'lon': 116.6667},
    ],
    'Sumbawa': [
      {'name': 'Sumbawa', 'lat': -8.5000, 'lon': 117.4333},
      {'name': 'Labuhan Badas', 'lat': -8.5333, 'lon': 117.3667},
      {'name': 'Unter Iwes', 'lat': -8.4500, 'lon': 117.4000},
      {'name': 'Moyohulu', 'lat': -8.4000, 'lon': 117.3333},
      {'name': 'Moyohilir', 'lat': -8.4167, 'lon': 117.5000},
      {'name': 'Empang', 'lat': -8.6500, 'lon': 117.7167},
      {'name': 'Alas', 'lat': -8.5500, 'lon': 117.0000},
      {'name': 'Utan', 'lat': -8.4333, 'lon': 117.1667},
      {'name': 'Buer', 'lat': -8.5000, 'lon': 117.1333},
    ],
    'Dompu': [
      {'name': 'Dompu', 'lat': -8.5333, 'lon': 118.4667},
      {'name': 'Woja', 'lat': -8.5000, 'lon': 118.5167},
      {'name': 'Kilo', 'lat': -8.6000, 'lon': 118.5500},
      {'name': 'Kempo', 'lat': -8.6833, 'lon': 118.4333},
      {'name': 'Hu\'u', 'lat': -8.5667, 'lon': 118.5833},
      {'name': 'Pajo', 'lat': -8.4500, 'lon': 118.5000},
      {'name': 'Pekat', 'lat': -8.4000, 'lon': 118.3833},
      {'name': 'Manggelewa', 'lat': -8.4667, 'lon': 118.3500},
    ],
    'Kota Bima': [
      {'name': 'Raba', 'lat': -8.4667, 'lon': 118.7500},
      {'name': 'Rasanae Barat', 'lat': -8.4667, 'lon': 118.7167},
      {'name': 'Rasanae Timur', 'lat': -8.4500, 'lon': 118.7333},
      {'name': 'Asakota', 'lat': -8.4333, 'lon': 118.6833},
      {'name': 'Mpunda', 'lat': -8.4833, 'lon': 118.7333},
    ],
    'Kabupaten Bima': [
      {'name': 'Woha', 'lat': -8.5283, 'lon': 118.7239},
      {'name': 'Belo', 'lat': -8.5167, 'lon': 118.7833},
      {'name': 'Palibelo', 'lat': -8.5333, 'lon': 118.6500},
      {'name': 'Wawo', 'lat': -8.5667, 'lon': 118.8167},
      {'name': 'Sape', 'lat': -8.5833, 'lon': 119.0000},
      {'name': 'Lambu', 'lat': -8.4667, 'lon': 118.9500},
      {'name': 'Wera', 'lat': -8.3833, 'lon': 118.9167},
      {'name': 'Langgudu', 'lat': -8.5500, 'lon': 118.5333},
      {'name': 'Tambora', 'lat': -8.2833, 'lon': 118.0000},
      {'name': 'Sanggar', 'lat': -8.3500, 'lon': 118.1000},
    ],
  };

  String _selectedKabupaten = 'Kota Mataram';
  int _selectedKecamatanIndex = 0;

  Weather _currentWeather = Weather(
    date: DateTime.now(),
    temperature: 0,
    humidity: 0,
    rainfall: 0,
    windSpeed: 0,
    condition: 'partly_cloudy',
    description: 'Memuat data...',
    uvIndex: 0,
    cloudCover: 0,
    locationName: 'Lombok Tengah',
  );

  List<Weather> _forecast = [];

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    try {
      // Get kecamatan name for BMKG API
      final kecamatanList = _ntbLocations[_selectedKabupaten]!;
      final kecamatanName =
          kecamatanList[_selectedKecamatanIndex]['name'] as String;

      // Get adm4 code from NTBRegions (for BMKG API)
      final adm4Code = NTBRegions.getAdm4Code(
        _selectedKabupaten,
        kecamatanName,
      );

      if (adm4Code == null) {
        throw Exception('Kode wilayah tidak ditemukan');
      }

      // Fetch from BMKG API
      final bmkgUrl = Uri.parse(
        'https://api.bmkg.go.id/publik/prakiraan-cuaca?adm4=$adm4Code',
      );

      final bmkgResponse = await http
          .get(bmkgUrl)
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () => throw Exception('Koneksi timeout'),
          );

      if (bmkgResponse.statusCode == 200) {
        final data = json.decode(bmkgResponse.body);
        if (data['data'] != null && data['data'].isNotEmpty) {
          if (mounted) _parseBmkgData(data);
        } else {
          throw Exception('Data cuaca tidak tersedia');
        }
      } else {
        throw Exception('Gagal mengambil data: ${bmkgResponse.statusCode}');
      }
    } catch (e) {
      debugPrint('BMKG Error: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat data cuaca: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _parseBmkgData(Map<String, dynamic> data) {
    try {
      final lokasi = data['lokasi'];
      final cuacaList = data['data'][0]['cuaca'][0] as List;

      // Find current/closest forecast
      final now = DateTime.now();
      Map<String, dynamic>? currentForecast;

      for (var forecast in cuacaList) {
        final forecastTime = DateTime.parse(forecast['local_datetime']);
        if (forecastTime.isAfter(now.subtract(const Duration(hours: 3)))) {
          currentForecast = forecast;
          break;
        }
      }

      currentForecast ??= cuacaList.first;

      setState(() {
        _currentWeather = Weather(
          date: DateTime.now(),
          temperature: (currentForecast!['t'] as num).toDouble(),
          humidity: (currentForecast['hu'] as num).toDouble(),
          rainfall: (currentForecast['tp'] as num?)?.toDouble() ?? 0,
          windSpeed: (currentForecast['ws'] as num).toDouble(),
          condition: _mapBmkgCondition(currentForecast['weather_desc'] ?? ''),
          description: currentForecast['weather_desc'] ?? '',
          uvIndex: 5, // BMKG tidak provide UV index langsung
          cloudCover: (currentForecast['tcc'] as num?)?.toDouble() ?? 0,
          locationName: '${lokasi['kecamatan']}, ${lokasi['kotkab']}',
        );

        // Parse forecast data
        _forecast = [];
        final allCuaca = data['data'][0]['cuaca'] as List;
        for (int i = 0; i < allCuaca.length && i < 7; i++) {
          final dayList = allCuaca[i] as List;
          if (dayList.isNotEmpty) {
            // Get mid-day forecast
            final midDayForecast = dayList.length > 2
                ? dayList[2]
                : dayList.first;
            _forecast.add(
              Weather(
                date: DateTime.now().add(Duration(days: i)),
                temperature: (midDayForecast['t'] as num).toDouble(),
                humidity: (midDayForecast['hu'] as num).toDouble(),
                rainfall: (midDayForecast['tp'] as num?)?.toDouble() ?? 0,
                windSpeed: (midDayForecast['ws'] as num).toDouble(),
                condition: _mapBmkgCondition(
                  midDayForecast['weather_desc'] ?? '',
                ),
                description: midDayForecast['weather_desc'] ?? '',
                uvIndex: 5,
                cloudCover: (midDayForecast['tcc'] as num?)?.toDouble() ?? 0,
                locationName: '${lokasi['kecamatan']}, ${lokasi['kotkab']}',
              ),
            );
          }
        }

        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Parse BMKG Error: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _mapBmkgCondition(String weatherDesc) {
    final desc = weatherDesc.toLowerCase();
    if (desc.contains('cerah')) return 'sunny';
    if (desc.contains('berawan sebagian')) return 'partly_cloudy';
    if (desc.contains('berawan')) return 'cloudy';
    if (desc.contains('hujan ringan') || desc.contains('gerimis'))
      return 'light_rain';
    if (desc.contains('hujan sedang')) return 'rain';
    if (desc.contains('hujan lebat') || desc.contains('hujan petir'))
      return 'heavy_rain';
    if (desc.contains('kabut') || desc.contains('asap')) return 'cloudy';
    return 'partly_cloudy';
  }

  void _showLocationPicker() {
    String tempKabupaten = _selectedKabupaten;
    int tempKecamatan = _selectedKecamatanIndex;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          final kecamatanList = _ntbLocations[tempKabupaten]!;

          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                // Handle bar
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Title
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: AppTheme.primaryGreen,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'weather_dash.select_location'.tr(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                // Kabupaten Selection
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kabupaten/Kota',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: tempKabupaten,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        items: _ntbLocations.keys.map((kabupaten) {
                          return DropdownMenuItem(
                            value: kabupaten,
                            child: Text(kabupaten),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setModalState(() {
                            tempKabupaten = value!;
                            tempKecamatan = 0;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                // Kecamatan Selection
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kecamatan',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
                // Kecamatan List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: kecamatanList.length,
                    itemBuilder: (context, index) {
                      final kec = kecamatanList[index];
                      final isSelected = index == tempKecamatan;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.primaryGreen.withOpacity(0.1)
                              : Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.primaryGreen
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: ListTile(
                          title: Text(
                            kec['name'],
                            style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected
                                  ? AppTheme.primaryGreen
                                  : Colors.black87,
                            ),
                          ),
                          trailing: isSelected
                              ? const Icon(
                                  Icons.check_circle,
                                  color: AppTheme.primaryGreen,
                                )
                              : null,
                          onTap: () {
                            setModalState(() {
                              tempKecamatan = index;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                // Confirm Button
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          _selectedKabupaten = tempKabupaten;
                          _selectedKecamatanIndex = tempKecamatan;
                          _isLoading = true;
                        });
                        _fetchWeatherData();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text('common.confirm'.tr()),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Note: Open-Meteo functions removed - now using BMKG API only

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF0F4F8),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final recommendation = _currentWeather.farmingRecommendation;
    final diseaseRisks = _currentWeather.diseaseRisks;
    final seasonInfo = NTBSeasonalData.getCurrentSeason();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: CustomScrollView(
        slivers: [
          // Weather Header
          SliverAppBar(
            expandedHeight: 400,
            floating: false,
            pinned: true,
            backgroundColor: _getWeatherColor(),
            elevation: 0,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                color: Colors.white,
                onPressed: () => Navigator.pop(context),
                tooltip: 'Kembali',
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      _getWeatherColor(),
                      _getWeatherColor().withOpacity(0.8),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.white.withOpacity(0.9),
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            GestureDetector(
                              onTap: _showLocationPicker,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _selectedKabupaten,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Kec. ${_ntbLocations[_selectedKabupaten]![_selectedKecamatanIndex]['name']}',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.8),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    _getSeasonIcon(seasonInfo.season),
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    seasonInfo.seasonName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              _getWeatherIcon(_currentWeather.condition),
                              size: 80,
                              color: Colors.white,
                            ).animate().scale(delay: 300.ms),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${_currentWeather.temperature.toInt()}°',
                                  style: const TextStyle(
                                    fontSize: 64,
                                    fontWeight: FontWeight.w200,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  _currentWeather.conditionText,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Weather Stats
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildWeatherStat(
                                Icons.water_drop_outlined,
                                '${_currentWeather.humidity.toInt()}%',
                                'weather_dash.humidity'.tr(),
                              ),
                              _buildWeatherStat(
                                Icons.air,
                                '${_currentWeather.windSpeed} km/h',
                                'weather_dash.wind'.tr(),
                              ),
                              _buildWeatherStat(
                                Icons.umbrella_outlined,
                                '${_currentWeather.rainfall} mm',
                                'weather_dash.rainfall'.tr(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Farming Recommendation
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        recommendation.statusEmoji,
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'weather_dash.today_recommendation'.tr(),
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    recommendation.message,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Activity Icons
                  Row(
                    children: [
                      _buildActivityIndicator(
                        '💨',
                        'weather_dash.spray'.tr(),
                        recommendation.canSpray,
                      ),
                      _buildActivityIndicator(
                        '🌾',
                        'weather_dash.harvest'.tr(),
                        recommendation.canHarvest,
                      ),
                      _buildActivityIndicator(
                        '🌱',
                        'weather_dash.plant'.tr(),
                        recommendation.canPlant,
                      ),
                      _buildActivityIndicator(
                        '💚',
                        'weather_dash.fertilize'.tr(),
                        recommendation.canFertilize,
                      ),
                    ],
                  ),
                  if (recommendation.warnings.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.amber[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.amber[800],
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              recommendation.warnings.first,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.amber[900],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ).animate().fadeIn().slideY(begin: 0.1, end: 0),
          ),

          // Disease Risk Alert
          if (diseaseRisks.isNotEmpty)
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.warning_amber,
                          color: Colors.red[700],
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'weather_dash.disease_risk_warning'.tr(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red[800],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...diseaseRisks
                        .take(2)
                        .map(
                          (risk) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.circle,
                                  size: 14,
                                  color: _getRiskColor(risk.riskLevel),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        risk.diseaseName,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.red[800],
                                        ),
                                      ),
                                      Text(
                                        risk.reason,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.red[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                  ],
                ),
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),
            ),

          // 7-Day Forecast
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month,
                        color: Colors.grey[700],
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'weather_dash.forecast_3_days'.tr(),
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 130,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _forecast.length,
                      itemBuilder: (context, index) {
                        return _ForecastCard(
                          weather: _forecast[index],
                          isToday: index == 0,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Seasonal Info
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryGreen.withOpacity(0.1),
                    AppTheme.primaryGreen.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppTheme.primaryGreen.withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _getSeasonIcon(seasonInfo.seasonName),
                        size: 28,
                        color: AppTheme.primaryGreen,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              seasonInfo.seasonName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${'weather.avg_rainfall'.tr()}: ${seasonInfo.avgRain}mm',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.tips_and_updates,
                          color: Colors.amber[700],
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            seasonInfo.plantingRecommendation,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Tips
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('💡', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      Text(
                        'weather.tips_today'.tr(),
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  ...recommendation.recommendations
                      .take(3)
                      .toList()
                      .asMap()
                      .entries
                      .map((entry) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryGreen.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    '${entry.key + 1}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryGreen,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  entry.value,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(delay: (100 * entry.key).ms);
                      }),
                ],
              ),
            ),
          ),

          // BMKG Attribution - Wajib ditampilkan sesuai kebijakan sumber data
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[100]!),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.verified,
                      color: Colors.blue[700],
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sumber Data Cuaca',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'BMKG (Badan Meteorologi, Klimatologi, dan Geofisika)',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getWeatherColor() {
    switch (_currentWeather.condition) {
      case 'sunny':
        return const Color(0xFFFFA726);
      case 'partly_cloudy':
        return const Color(0xFF42A5F5);
      case 'cloudy':
        return const Color(0xFF78909C);
      case 'light_rain':
      case 'rain':
        return const Color(0xFF5C6BC0);
      case 'heavy_rain':
      case 'thunderstorm':
        return const Color(0xFF455A64);
      default:
        return const Color(0xFF42A5F5);
    }
  }

  IconData _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'sunny':
      case 'cerah':
        return Icons.wb_sunny_rounded;
      case 'partly_cloudy':
      case 'berawan_sebagian':
        return Icons.wb_cloudy_rounded;
      case 'cloudy':
      case 'berawan':
        return Icons.cloud_rounded;
      case 'light_rain':
      case 'hujan_ringan':
      case 'rain':
      case 'hujan':
        return Icons.water_drop_rounded;
      case 'heavy_rain':
      case 'hujan_lebat':
      case 'thunderstorm':
      case 'badai':
        return Icons.thunderstorm_rounded;
      default:
        return Icons.wb_sunny_rounded;
    }
  }

  IconData _getSeasonIcon(String season) {
    if (season == 'hujan') return Icons.water_drop;
    if (season == 'kemarau') return Icons.wb_sunny;
    return Icons.cloud;
  }

  Color _getRiskColor(String level) {
    if (level == 'tinggi') return Colors.red;
    if (level == 'sedang') return Colors.orange;
    return Colors.green;
  }

  Widget _buildWeatherStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 18, color: Colors.white),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildActivityIndicator(String emoji, String label, bool canDo) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: canDo ? Colors.green[50] : Colors.red[50],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 4),
                Icon(
                  canDo ? Icons.check_circle : Icons.cancel,
                  color: canDo ? Colors.green[600] : Colors.red[400],
                  size: 14,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: canDo ? Colors.green[800] : Colors.red[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ForecastCard extends StatelessWidget {
  final Weather weather;
  final bool isToday;

  const _ForecastCard({required this.weather, this.isToday = false});

  @override
  Widget build(BuildContext context) {
    final dayNames = [
      'days.sunday'.tr(),
      'days.monday'.tr(),
      'days.tuesday'.tr(),
      'days.wednesday'.tr(),
      'days.thursday'.tr(),
      'days.friday'.tr(),
      'days.saturday'.tr(),
    ];
    final dayName = isToday
        ? 'time.today'.tr()
        : dayNames[weather.date.weekday % 7];

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) => Container(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
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
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Text(
                  '$dayName, ${weather.date.day}/${weather.date.month}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Icon(
                  WeatherUIHelper.getWeatherIcon(weather.condition),
                  size: 64,
                  color: AppTheme.primaryGreen,
                ),
                const SizedBox(height: 16),
                Text(
                  '${weather.temperature.toInt()}°C',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w200,
                  ),
                ),
                Text(
                  weather.condition.replaceAll('_', ' ').toUpperCase(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildDetailItem(
                      Icons.water_drop_outlined,
                      '${weather.rainfall.toStringAsFixed(1)} mm',
                      'weather_dash.rainfall'.tr(),
                      Colors.blue,
                    ),
                    _buildDetailItem(
                      Icons.wb_sunny_outlined,
                      '${weather.uvIndex}',
                      'weather.uv_index'.tr(),
                      Colors.orange,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: isToday ? AppTheme.primaryGreen : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              dayName,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isToday ? Colors.white : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 6),
            Icon(
              WeatherUIHelper.getWeatherIcon(weather.condition),
              size: 32,
              color: isToday ? Colors.white : Colors.amber[700],
            ),
            const SizedBox(height: 6),
            Text(
              '${weather.temperature.toInt()}°',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isToday ? Colors.white : Colors.black87,
              ),
            ),
            if (weather.rainfall > 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.water_drop,
                    size: 10,
                    color: isToday ? Colors.white70 : Colors.blue[300],
                  ),
                  Text(
                    '${weather.rainfall.toInt()}mm',
                    style: TextStyle(
                      fontSize: 9,
                      color: isToday ? Colors.white70 : Colors.blue[400],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }
}

class WeatherUIHelper {
  static IconData getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'sunny':
      case 'cerah':
        return Icons.wb_sunny_rounded;
      case 'partly_cloudy':
      case 'berawan_sebagian':
        return Icons.wb_cloudy_rounded;
      case 'cloudy':
      case 'berawan':
        return Icons.cloud_rounded;
      case 'light_rain':
      case 'hujan_ringan':
      case 'rain':
      case 'hujan':
        return Icons.water_drop_rounded;
      case 'heavy_rain':
      case 'hujan_lebat':
      case 'thunderstorm':
      case 'badai':
        return Icons.thunderstorm_rounded;
      default:
        return Icons.wb_sunny_rounded;
    }
  }
}
