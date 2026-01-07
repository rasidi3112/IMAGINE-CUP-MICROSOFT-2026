import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

/// Get locale code that is safe for DateFormat (intl package)
/// Falls back to 'id' for local languages that are not supported by intl
String getSafeDateLocale(BuildContext context) {
  final langCode = context.locale.languageCode;
  // intl package only supports standard locales
  // Local NTB languages (sas, smw, mbj) are not supported
  // Fall back to Indonesian for date formatting
  const supportedDateLocales = ['id', 'en'];
  if (supportedDateLocales.contains(langCode)) {
    return langCode;
  }
  return 'id'; // Default to Indonesian for local languages
}

/// Get locale code that is safe for DateFormat from string
String getSafeDateLocaleFromCode(String langCode) {
  const supportedDateLocales = ['id', 'en'];
  if (supportedDateLocales.contains(langCode)) {
    return langCode;
  }
  return 'id';
}
