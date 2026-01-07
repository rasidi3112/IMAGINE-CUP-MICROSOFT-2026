// Custom Localizations Delegates for NTB local languages
// Provides Material, Cupertino, and Widgets localizations for Sasak, Samawa, and Mbojo
// These local languages fallback to English for Flutter internal components

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

/// Initialize date formatting for local languages
/// Must be called before using any local language
Future<void> initializeNTBLocalLanguages() async {
  // Local languages will use Indonesian date formatting
  await initializeDateFormatting('id', null);
  await initializeDateFormatting('en', null);
}

/// Custom Material Localizations that falls back to English defaults for local languages
class NTBMaterialLocalizations extends DefaultMaterialLocalizations {
  const NTBMaterialLocalizations();

  static const LocalizationsDelegate<MaterialLocalizations> delegate =
      _NTBMaterialLocalizationsDelegate();

  static const List<String> supportedLanguages = ['sas', 'smw', 'mbj'];
}

class _NTBMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const _NTBMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return NTBMaterialLocalizations.supportedLanguages.contains(
      locale.languageCode,
    );
  }

  @override
  Future<MaterialLocalizations> load(Locale locale) {
    return SynchronousFuture<MaterialLocalizations>(
      const NTBMaterialLocalizations(),
    );
  }

  @override
  bool shouldReload(_NTBMaterialLocalizationsDelegate old) => false;
}

/// Custom Cupertino Localizations for local languages
class NTBCupertinoLocalizations extends DefaultCupertinoLocalizations {
  const NTBCupertinoLocalizations();

  static const LocalizationsDelegate<CupertinoLocalizations> delegate =
      _NTBCupertinoLocalizationsDelegate();
}

class _NTBCupertinoLocalizationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const _NTBCupertinoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return NTBMaterialLocalizations.supportedLanguages.contains(
      locale.languageCode,
    );
  }

  @override
  Future<CupertinoLocalizations> load(Locale locale) {
    return SynchronousFuture<CupertinoLocalizations>(
      const NTBCupertinoLocalizations(),
    );
  }

  @override
  bool shouldReload(_NTBCupertinoLocalizationsDelegate old) => false;
}

/// Custom Widgets Localizations for local languages
class NTBWidgetsLocalizations extends DefaultWidgetsLocalizations {
  const NTBWidgetsLocalizations();

  static const LocalizationsDelegate<WidgetsLocalizations> delegate =
      _NTBWidgetsLocalizationsDelegate();
}

class _NTBWidgetsLocalizationsDelegate
    extends LocalizationsDelegate<WidgetsLocalizations> {
  const _NTBWidgetsLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return NTBMaterialLocalizations.supportedLanguages.contains(
      locale.languageCode,
    );
  }

  @override
  Future<WidgetsLocalizations> load(Locale locale) {
    return SynchronousFuture<WidgetsLocalizations>(
      const NTBWidgetsLocalizations(),
    );
  }

  @override
  bool shouldReload(_NTBWidgetsLocalizationsDelegate old) => false;
}
