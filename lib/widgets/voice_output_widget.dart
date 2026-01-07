// AgriVision NTB - Voice Output Widget
// Widget tombol suara untuk membacakan teks
// Fitur aksesibilitas untuk petani lansia

import 'package:flutter/material.dart';
import '../services/voice_output_service.dart';
import '../config/app_theme.dart';

/// Widget tombol untuk membacakan teks dengan suara
/// Sangat berguna untuk petani lansia
class VoiceButton extends StatefulWidget {
  final String textToSpeak;
  final String? label;
  final double size;
  final Color? color;
  final bool showLabel;
  final VoidCallback? onSpeakStart;
  final VoidCallback? onSpeakEnd;

  const VoiceButton({
    super.key,
    required this.textToSpeak,
    this.label,
    this.size = 48,
    this.color,
    this.showLabel = true,
    this.onSpeakStart,
    this.onSpeakEnd,
  });

  @override
  State<VoiceButton> createState() => _VoiceButtonState();
}

class _VoiceButtonState extends State<VoiceButton>
    with SingleTickerProviderStateMixin {
  final VoiceOutputService _voiceService = VoiceOutputService();
  bool _isSpeaking = false;
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _toggleSpeak() async {
    if (_isSpeaking) {
      await _voiceService.stop();
      setState(() => _isSpeaking = false);
      _animationController.stop();
      _animationController.reset();
      widget.onSpeakEnd?.call();
    } else {
      setState(() => _isSpeaking = true);
      _animationController.repeat(reverse: true);
      widget.onSpeakStart?.call();

      await _voiceService.speak(widget.textToSpeak);

      // Wait for completion
      await Future.delayed(const Duration(milliseconds: 500));
      while (_voiceService.isSpeaking) {
        await Future.delayed(const Duration(milliseconds: 100));
      }

      if (mounted) {
        setState(() => _isSpeaking = false);
        _animationController.stop();
        _animationController.reset();
        widget.onSpeakEnd?.call();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_voiceService.isEnabled) {
      return const SizedBox.shrink();
    }

    final color = widget.color ?? AppTheme.primaryGreen;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _isSpeaking ? _pulseAnimation.value : 1.0,
              child: child,
            );
          },
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _toggleSpeak,
              borderRadius: BorderRadius.circular(widget.size / 2),
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isSpeaking ? color : color.withAlpha(30),
                  border: Border.all(color: color, width: 2),
                  boxShadow: _isSpeaking
                      ? [
                          BoxShadow(
                            color: color.withAlpha(100),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  _isSpeaking ? Icons.stop : Icons.volume_up,
                  color: _isSpeaking ? Colors.white : color,
                  size: widget.size * 0.5,
                ),
              ),
            ),
          ),
        ),
        if (widget.showLabel && widget.label != null) ...[
          const SizedBox(height: 4),
          Text(
            _isSpeaking ? 'Berhenti' : widget.label!,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}

/// Compact voice button for inline use
class VoiceButtonCompact extends StatefulWidget {
  final String textToSpeak;
  final double size;
  final Color? color;

  const VoiceButtonCompact({
    super.key,
    required this.textToSpeak,
    this.size = 32,
    this.color,
  });

  @override
  State<VoiceButtonCompact> createState() => _VoiceButtonCompactState();
}

class _VoiceButtonCompactState extends State<VoiceButtonCompact> {
  final VoiceOutputService _voiceService = VoiceOutputService();
  bool _isSpeaking = false;

  Future<void> _toggleSpeak() async {
    if (_isSpeaking) {
      await _voiceService.stop();
      setState(() => _isSpeaking = false);
    } else {
      setState(() => _isSpeaking = true);
      await _voiceService.speak(widget.textToSpeak);

      // Wait for completion
      while (_voiceService.isSpeaking) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      if (mounted) {
        setState(() => _isSpeaking = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_voiceService.isEnabled) {
      return const SizedBox.shrink();
    }

    final color = widget.color ?? AppTheme.primaryGreen;

    return IconButton(
      onPressed: _toggleSpeak,
      icon: Icon(
        _isSpeaking ? Icons.stop_circle : Icons.volume_up_rounded,
        color: _isSpeaking ? AppTheme.dangerRed : color,
        size: widget.size,
      ),
      tooltip: _isSpeaking ? 'Berhenti bicara' : 'Bacakan',
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(
        minWidth: widget.size,
        minHeight: widget.size,
      ),
    );
  }
}

/// Voice settings panel for profile/settings screen
class VoiceSettingsPanel extends StatefulWidget {
  const VoiceSettingsPanel({super.key});

  @override
  State<VoiceSettingsPanel> createState() => _VoiceSettingsPanelState();
}

class _VoiceSettingsPanelState extends State<VoiceSettingsPanel> {
  final VoiceOutputService _voiceService = VoiceOutputService();
  bool _isEnabled = false;
  double _speechRate = 0.4;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    setState(() {
      _isEnabled = _voiceService.isEnabled;
      _speechRate = _voiceService.speechRate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.record_voice_over,
                  color: AppTheme.primaryGreen,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Suara untuk Lansia',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Bacakan hasil scan & rekomendasi',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Switch.adaptive(
                value: _isEnabled,
                onChanged: (value) async {
                  await _voiceService.setEnabled(value);
                  setState(() => _isEnabled = value);

                  if (value) {
                    _voiceService.speak(
                      'Fitur suara aktif. Saya akan membacakan hasil scan dan rekomendasi untuk Anda.',
                    );
                  }
                },
                activeColor: AppTheme.primaryGreen,
              ),
            ],
          ),
          if (_isEnabled) ...[
            const SizedBox(height: 20),
            const Text(
              'Kecepatan Bicara',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.slow_motion_video,
                  size: 20,
                  color: Colors.grey,
                ),
                Expanded(
                  child: Slider(
                    value: _speechRate,
                    min: 0.2,
                    max: 0.8,
                    divisions: 6,
                    label: _getSpeechRateLabel(_speechRate),
                    onChanged: (value) async {
                      await _voiceService.setSpeechRate(value);
                      setState(() => _speechRate = value);
                    },
                    onChangeEnd: (value) {
                      _voiceService.speak(
                        'Kecepatan bicara ${_getSpeechRateLabel(value)}',
                      );
                    },
                    activeColor: AppTheme.primaryGreen,
                  ),
                ),
                const Icon(Icons.speed, size: 20, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                _getSpeechRateLabel(_speechRate),
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  _voiceService.speak(
                    'Ini adalah contoh suara untuk membacakan hasil scan tanaman. '
                    'Kecepatan bicara bisa diatur sesuai kebutuhan Anda.',
                  );
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('Tes Suara'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryGreen,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getSpeechRateLabel(double rate) {
    if (rate <= 0.3) return 'Sangat Lambat';
    if (rate <= 0.4) return 'Lambat';
    if (rate <= 0.5) return 'Normal';
    if (rate <= 0.6) return 'Cepat';
    return 'Sangat Cepat';
  }
}

/// Floating voice button for scan results
class FloatingVoiceButton extends StatelessWidget {
  final String textToSpeak;
  final String? heroTag;

  const FloatingVoiceButton({
    super.key,
    required this.textToSpeak,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final voiceService = VoiceOutputService();

    if (!voiceService.isEnabled) {
      return const SizedBox.shrink();
    }

    return FloatingActionButton.small(
      heroTag: heroTag ?? 'voice_fab_${textToSpeak.hashCode}',
      onPressed: () {
        voiceService.speak(textToSpeak);
      },
      backgroundColor: AppTheme.primaryGreen,
      child: const Icon(Icons.volume_up, color: Colors.white),
    );
  }
}
