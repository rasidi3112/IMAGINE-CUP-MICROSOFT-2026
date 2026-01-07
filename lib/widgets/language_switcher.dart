// Language Switcher Widget for AgriVision NTB
// Supports English, Indonesian, Sasak, Samawa, and Mbojo languages

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../config/app_theme.dart';

/// Language data model
class LanguageOption {
  final String code;
  final String name;
  final String nativeName;
  final String region;

  const LanguageOption({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.region,
  });
}

/// Available languages in the app - 5 bahasa NTB
class AppLanguages {
  static const List<LanguageOption> supported = [
    LanguageOption(
      code: 'id',
      name: 'Indonesian',
      nativeName: 'Indonesia',
      region: 'Nasional',
    ),
    LanguageOption(
      code: 'en',
      name: 'English',
      nativeName: 'English',
      region: 'International',
    ),
    LanguageOption(
      code: 'sas',
      name: 'Sasak',
      nativeName: 'Sasak',
      region: 'Lombok',
    ),
    LanguageOption(
      code: 'smw',
      name: 'Samawa',
      nativeName: 'Samawa',
      region: 'Sumbawa',
    ),
    LanguageOption(
      code: 'mbj',
      name: 'Mbojo',
      nativeName: 'Mbojo',
      region: 'Bima',
    ),
  ];

  static LanguageOption getByCode(String code) {
    return supported.firstWhere(
      (lang) => lang.code == code,
      orElse: () => supported[0], // Default to Indonesian
    );
  }

  static Locale getLocale(String code) {
    return Locale(code);
  }
}

/// Modern Language Switcher Button for AppBar
class LanguageSwitcherButton extends StatelessWidget {
  final bool showLabel;
  final Color? iconColor;

  const LanguageSwitcherButton({
    super.key,
    this.showLabel = false,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale;
    final currentLang = AppLanguages.getByCode(currentLocale.languageCode);

    return PopupMenuButton<String>(
      onSelected: (String langCode) {
        context.setLocale(Locale(langCode));
      },
      offset: const Offset(0, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      itemBuilder: (BuildContext context) {
        return AppLanguages.supported.map((lang) {
          final isSelected = currentLocale.languageCode == lang.code;
          return PopupMenuItem<String>(
            value: lang.code,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  // Language icon with first letter
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primaryGreen
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        lang.code.toUpperCase().substring(0, 2),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Colors.white
                              : Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Language name
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lang.nativeName,
                          style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? AppTheme.primaryGreen
                                : Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          lang.region,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Check icon for selected
                  if (isSelected)
                    const Icon(
                      Icons.check_circle,
                      color: AppTheme.primaryGreen,
                      size: 20,
                    ),
                ],
              ),
            ),
          );
        }).toList();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(30),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.language_rounded,
              size: 20,
              color: iconColor ?? Colors.white,
            ),
            if (showLabel) ...[
              const SizedBox(width: 6),
              Text(
                currentLang.code.toUpperCase(),
                style: TextStyle(
                  color: iconColor ?? Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Language Selector Dialog - Modern Bottom Sheet
class LanguageSelectorDialog extends StatelessWidget {
  const LanguageSelectorDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const LanguageSelectorDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen.withAlpha(30),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.language_rounded,
                    color: AppTheme.primaryGreen,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'language.title'.tr(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '5 Bahasa Tersedia',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Language options
          ...AppLanguages.supported.map((lang) {
            final isSelected = currentLocale.languageCode == lang.code;
            return ListTile(
              onTap: () {
                context.setLocale(Locale(lang.code));
                Navigator.pop(context);
              },
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: isSelected ? AppTheme.primaryGradient : null,
                  color: isSelected ? null : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    lang.code.toUpperCase().substring(0, 2),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.grey.shade700,
                    ),
                  ),
                ),
              ),
              title: Text(
                lang.nativeName,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? AppTheme.primaryGreen : Colors.black87,
                ),
              ),
              subtitle: Text(
                '${lang.name} - ${lang.region}',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
              trailing: isSelected
                  ? Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppTheme.primaryGreen,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      ),
                    )
                  : Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Colors.grey.shade400,
                    ),
            );
          }),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

/// Extension for easy translation access
extension TranslationExtension on String {
  String get translated => this.tr();
}
