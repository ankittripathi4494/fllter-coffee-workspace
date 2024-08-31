import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert' show jsonDecode;
import 'app_localizations_delegate.dart';

class AppLocalizations {
  late final Locale? locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      AppLocalizationsDelegate();

  late Map<dynamic, dynamic> _localizedStrings;

  Future<bool> load() async {
    String jsonString = await rootBundle
        .loadString('assets/jsons/${locale?.languageCode}.json');
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    _localizedStrings = flattenTranslations(jsonMap);
    return true;
  }

  Map<dynamic, dynamic> flattenTranslations(Map<dynamic, dynamic> json,
      [String prefix = '']) {
    final Map<dynamic, dynamic> translations = {};
    json.forEach((dynamic key, dynamic value) {
      if (value is Map) {
        translations.addAll(flattenTranslations(value, '$prefix$key.'));
      } else {
        translations['$prefix$key'] = value.toString();
      }
    });
    return translations;
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }
  // String translate(String key) => _localizedStrings[key]!;

  bool get isEnLocale => locale?.languageCode == 'en';
}
