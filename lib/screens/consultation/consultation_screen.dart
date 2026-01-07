// AgriVision NTB - AI Consultation Screen
// Layar konsultasi dengan AI Agronomist

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../services/voice_output_service.dart';
import '../../config/app_theme.dart';
import '../../providers/app_provider.dart';
import '../../services/azure_openai_service.dart';
import '../../widgets/common_widgets.dart';
import '../../models/treatment_schedule.dart';

class ConsultationScreen extends StatefulWidget {
  const ConsultationScreen({super.key});

  @override
  State<ConsultationScreen> createState() => _ConsultationScreenState();
}

class _ConsultationScreenState extends State<ConsultationScreen> {
  final TextEditingController _questionController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AzureOpenAIService _aiService = AzureOpenAIService();

  // Voice Chat
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  bool _speechAvailable = false;

  List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String _selectedLanguage = 'id';

  @override
  void initState() {
    super.initState();
    _initializeConsultation();
  }

  @override
  void dispose() {
    _questionController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeConsultation() {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final scanResult = provider.currentScanResult;

    // Add welcome message
    _messages.add(
      ChatMessage(
        content:
            '''
Selamat datang di Konsultasi AI AgriVision! 🌱

Saya adalah asisten pertanian AI yang akan membantu Anda menangani masalah tanaman.

${scanResult != null && scanResult.detectedDisease != null ? 'Saya melihat tanaman ${scanResult.plantType} Anda terdeteksi terkena **${scanResult.detectedDisease!.nameIndonesia}** dengan tingkat keparahan ${scanResult.severityPercentage.toStringAsFixed(0)}%.\n\nApa yang ingin Anda ketahui tentang penyakit ini?' : 'Silakan tanyakan apa saja tentang perawatan tanaman, penanganan penyakit, atau pemupukan.'}

**Contoh pertanyaan:**
• "Bagaimana cara mengobati penyakit ini?"
• "Pestisida apa yang cocok?"
• "Berapa dosis yang tepat?"
• "Kapan waktu terbaik menyemprot?"
''',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );

    // If there's a scan result with disease, auto-consult
    if (scanResult != null && scanResult.detectedDisease != null) {
      _autoConsult(scanResult);
    }

    _initSpeech();
  }

  void _initSpeech() async {
    try {
      _speechAvailable = await _speech.initialize(
        onStatus: (status) {
          debugPrint('Speech status: $status');
          if (status == 'notListening' || status == 'done') {
            setState(() => _isListening = false);
          }
        },
        onError: (errorNotification) {
          debugPrint('Speech error: $errorNotification');
          setState(() => _isListening = false);
        },
      );
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Error initializing speech: $e');
    }
  }

  void _listen() async {
    if (!_speechAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fitur suara tidak tersedia di perangkat ini'),
        ),
      );
      return;
    }

    if (_isListening) {
      _speech.stop();
      setState(() => _isListening = false);
    } else {
      setState(() => _isListening = true);

      // Determine locale based on app language
      // For local languages (sas, mbj, smw), we fallback to Indonesian (id-ID)
      // because standard STT engines don't support them yet.
      String localeId = 'id-ID';
      if (_selectedLanguage == 'en') {
        localeId = 'en-US';
      }

      // If user selected a local language, we can try to prompt them
      // or just use Indonesian which is widely understood

      _speech.listen(
        onResult: (result) {
          setState(() {
            _questionController.text = result.recognizedWords;
            // If final result, send it automatically if desired,
            // or let user press send. For now, let's keep it in the text field.
            if (result.finalResult) {
              _isListening = false;
            }
          });
        },
        localeId: localeId,
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 5),
        listenOptions: stt.SpeechListenOptions(
          partialResults: true,
          cancelOnError: true,
          listenMode: stt.ListenMode.dictation,
        ),
      );
    }
  }

  Future<void> _autoConsult(dynamic scanResult) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _aiService.getConsultation(
        scanResult: scanResult,
        language: _selectedLanguage,
      );

      if (response != null) {
        if (!mounted) return;
        setState(() {
          _messages.add(
            ChatMessage(
              content: response.responseText,
              isUser: false,
              timestamp: DateTime.now(),
            ),
          );
        });

        // Update scan result with AI response
        if (mounted) {
          Provider.of<AppProvider>(
            context,
            listen: false,
          ).updateScanResultWithAIResponse(
            scanResult.id,
            response.responseText,
          );
        }

        _scrollToBottom();
      }
    } catch (e) {
      _addErrorMessage();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _sendMessage() async {
    final question = _questionController.text.trim();
    if (question.isEmpty || _isLoading) return;

    // Add user message
    setState(() {
      _messages.add(
        ChatMessage(content: question, isUser: true, timestamp: DateTime.now()),
      );
      _isLoading = true;
    });

    _questionController.clear();
    _scrollToBottom();

    try {
      final provider = Provider.of<AppProvider>(context, listen: false);
      final scanResult = provider.currentScanResult;

      String? response;

      // Always try API first, regardless of connectivity check
      // (connectivity_plus sometimes reports wrong on iOS Simulator)

      if (scanResult != null && scanResult.detectedDisease != null) {
        // Follow-up question based on context
        final context = _messages
            .where((m) => !m.isUser)
            .map((m) => m.content)
            .join('\n');

        response = await _aiService.askFollowUp(
          context: context,
          question: question,
          language: _selectedLanguage,
        );
      } else {
        // Try general consultation via API
        // Create a dummy scan result for general questions
        response = await _aiService.askFollowUp(
          context: 'Saya adalah asisten pertanian AI untuk petani NTB.',
          question: question,
          language: _selectedLanguage,
        );
      }

      // If API call succeeded
      if (response != null) {
        setState(() {
          _messages.add(
            ChatMessage(
              content: response!,
              isUser: false,
              timestamp: DateTime.now(),
            ),
          );
        });
      } else {
        // API failed, use offline response
        setState(() {
          _messages.add(
            ChatMessage(
              content: _getOfflineResponse(question),
              isUser: false,
              timestamp: DateTime.now(),
            ),
          );
        });
      }

      _scrollToBottom();
    } catch (e) {
      _addErrorMessage();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _getOfflineResponse(String question) {
    return '''
⚠️ **Mode Offline**

Saat ini Anda tidak terhubung ke internet, sehingga saya tidak dapat memberikan saran yang spesifik.

**Saran Umum:**
1. Pisahkan tanaman yang terinfeksi dari tanaman sehat
2. Jangan menyiram daun, siram bagian pangkal saja
3. Pastikan sirkulasi udara baik di sekitar tanaman
4. Kunjungi toko pertanian terdekat untuk konsultasi langsung

Saat Anda online, saya akan dapat memberikan saran yang lebih akurat berdasarkan kondisi tanaman Anda.
''';
  }

  void _addErrorMessage() {
    setState(() {
      _messages.add(
        ChatMessage(
          content: '''
❌ **Maaf, terjadi kesalahan**

Tidak dapat menghubungi server AI saat ini. Silakan coba lagi dalam beberapa saat.

**Tips:**
- Periksa koneksi internet Anda
- Coba kirim ulang pertanyaan
- Jika masalah berlanjut, hubungi support
''',
          isUser: false,
          timestamp: DateTime.now(),
          isError: true,
        ),
      );
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _createTreatmentSchedule() {
    final provider = Provider.of<AppProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _TreatmentScheduleSheet(
        onScheduleCreated: (schedule) {
          provider.addTreatmentSchedule(schedule);
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('common.success_schedule'.tr()),
              backgroundColor: AppTheme.successGreen,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('consultation.title'.tr()),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
        actions: [
          // Language selector
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            onSelected: (value) {
              setState(() {
                _selectedLanguage = value;
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'id',
                child: Text('🇮🇩 ${'language.indonesian'.tr()}'),
              ),
              PopupMenuItem(
                value: 'sasak',
                child: Text('🏝️ ${'language.sasak'.tr()}'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Connectivity banner
          Consumer<AppProvider>(
            builder: (context, provider, child) {
              if (!provider.isOnline) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  color: AppTheme.warningOrange,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.wifi_off, color: Colors.white, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'consultation.offline_mode'.tr(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),

          // Chat messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isLoading) {
                  return _buildTypingIndicator();
                }
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),

          // Quick actions
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildQuickAction(
                    '💊 ${'consultation.medicine_recommendation'.tr()}',
                    () => _sendQuickQuestion(
                      'consultation.quick_ask_medicine'.tr(),
                    ),
                  ),
                  _buildQuickAction(
                    'consultation.spray_schedule'.tr(),
                    () => _sendQuickQuestion(
                      'consultation.quick_ask_schedule'.tr(),
                    ),
                  ),
                  _buildQuickAction(
                    'consultation.organic_alternative'.tr(),
                    () => _sendQuickQuestion(
                      'consultation.quick_ask_organic'.tr(),
                    ),
                  ),
                  _buildQuickAction(
                    'consultation.create_schedule'.tr(),
                    _createTreatmentSchedule,
                  ),
                ],
              ),
            ),
          ),

          // Input area
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(12),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: _isListening
                        ? Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.red.withAlpha(20),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: Colors.red.withAlpha(50),
                              ),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.red.shade700,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Mendengarkan...',
                                  style: TextStyle(
                                    color: Colors.red.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ).animate().fadeIn(duration: 300.ms)
                        : TextField(
                            controller: _questionController,
                            decoration: InputDecoration(
                              hintText: 'consultation.placeholder'.tr(),
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                            ),
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) => _sendMessage(),
                          ),
                  ),
                  const SizedBox(width: 8),

                  // Voice Button
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    child: _speechAvailable
                        ? GestureDetector(
                            onTap: _listen,
                            onLongPress: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Voice Input Active ($_selectedLanguage)',
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: _isListening
                                    ? Colors.red
                                    : AppTheme.secondaryGreen,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        (_isListening
                                                ? Colors.red
                                                : AppTheme.secondaryGreen)
                                            .withAlpha(100),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(
                                _isListening ? Icons.stop : Icons.mic,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),

                  const SizedBox(width: 8),

                  // Send Button
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: _sendMessage,
                      icon: const Icon(Icons.send, color: Colors.white),
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

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: message.isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.smart_toy, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: message.isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: message.isUser
                        ? AppTheme.primaryGreen
                        : message.isError
                        ? AppTheme.dangerRed.withAlpha(20)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: Radius.circular(message.isUser ? 20 : 4),
                      bottomRight: Radius.circular(message.isUser ? 4 : 20),
                    ),
                    border: message.isError
                        ? Border.all(color: AppTheme.dangerRed.withAlpha(50))
                        : null,
                  ),
                  child: Text(
                    message.content,
                    style: TextStyle(
                      color: message.isUser ? Colors.white : Colors.black87,
                      height: 1.5,
                    ),
                  ),
                ),
                if (!message.isUser)
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 4),
                    child: GestureDetector(
                      onTap: () {
                        VoiceOutputService()
                            .setLanguage(_selectedLanguage)
                            .then((_) {
                              VoiceOutputService().speak(
                                message.content,
                                ignoreEnabledState: true,
                              );
                            });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.volume_up_rounded,
                              size: 16,
                              color: AppTheme.primaryGreen,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'voice.speak_button'.tr(),
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.primaryGreen,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 12),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.person, color: Colors.grey, size: 20),
            ),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1);
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.smart_toy, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(4),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDot(0),
                const SizedBox(width: 4),
                _buildDot(1),
                const SizedBox(width: 4),
                _buildDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: AppTheme.primaryGreen.withAlpha(150),
            shape: BoxShape.circle,
          ),
        )
        .animate(onPlay: (controller) => controller.repeat())
        .fadeIn(
          delay: Duration(milliseconds: index * 200),
          duration: 400.ms,
        )
        .then()
        .fadeOut(delay: 400.ms, duration: 400.ms);
  }

  Widget _buildQuickAction(String text, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.primaryGreen.withAlpha(20),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.primaryGreen.withAlpha(50)),
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: AppTheme.primaryGreen,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  void _sendQuickQuestion(String question) {
    _questionController.text = question;
    _sendMessage();
  }
}

class ChatMessage {
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final bool isError;

  ChatMessage({
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.isError = false,
  });
}

class _TreatmentScheduleSheet extends StatefulWidget {
  final Function(TreatmentSchedule) onScheduleCreated;

  const _TreatmentScheduleSheet({required this.onScheduleCreated});

  @override
  State<_TreatmentScheduleSheet> createState() =>
      _TreatmentScheduleSheetState();
}

class _TreatmentScheduleSheetState extends State<_TreatmentScheduleSheet> {
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedType = 'pestisida';
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));

  final List<Map<String, String>> _treatmentTypes = [
    {'value': 'pestisida', 'label': 'Pestisida'},
    {'value': 'fungisida', 'label': '🍄 Fungisida'},
    {'value': 'pupuk', 'label': 'Pupuk'},
    {'value': 'organik', 'label': 'Organik'},
    {'value': 'penyiraman', 'label': '💧 Penyiraman'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'consultation.create_schedule'.tr(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // Treatment name
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'calendar.treatment_name'.tr(),
                hintText: 'calendar.hint_name'.tr(),
              ),
            ),
            const SizedBox(height: 16),

            // Treatment type
            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: InputDecoration(
                labelText: 'calendar.treatment_type'.tr(),
              ),
              items: _treatmentTypes
                  .map(
                    (type) => DropdownMenuItem(
                      value: type['value'],
                      child: Text(type['label']!),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedType = value!;
                });
              },
            ),
            const SizedBox(height: 16),

            // Dosage
            TextField(
              controller: _dosageController,
              decoration: InputDecoration(
                labelText: 'pesticide_section.dosage'.tr(),
                hintText: 'calendar.hint_dosage'.tr(),
              ),
            ),
            const SizedBox(height: 16),

            // Date picker
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('common.date'.tr()),
              subtitle: Text(
                '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryGreen,
                ),
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) {
                  setState(() {
                    _selectedDate = date;
                  });
                }
              },
            ),
            const SizedBox(height: 16),

            // Description
            TextField(
              controller: _descriptionController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: 'calendar.notes'.tr(),
                hintText: 'calendar.notes_hint'.tr(),
              ),
            ),
            const SizedBox(height: 24),

            // Create button
            GradientButton(
              text: 'consultation.create_schedule'.tr(),
              onPressed: () {
                if (_nameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${'calendar.treatment_name'.tr()} ${'common.required'.tr()}',
                      ),
                    ),
                  );
                  return;
                }

                final schedule = TreatmentSchedule(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  scanResultId: '',
                  treatmentName: _nameController.text,
                  treatmentType: _selectedType,
                  description: _descriptionController.text,
                  dosage: _dosageController.text,
                  scheduledDate: _selectedDate,
                );

                widget.onScheduleCreated(schedule);
              },
            ),
          ],
        ),
      ),
    );
  }
}
