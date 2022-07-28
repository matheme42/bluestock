import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceController {

  static const String _languageKeys = "language_keys";

  static const String _sitesKeys = "site_keys";

  static const String _processKeys = "process_keys";

  static const String _cguKeys = "cgu_keys";

  static const String _articleKeys = "article_keys";

  static const String _articleDateKeys = "article_date_keys";

  static Future<Locale> getLanguage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? languageString = preferences.getString(_languageKeys);
    Locale? language;
    if (languageString != null) {
      language= Locale(languageString.substring(0, 2), languageString.substring(3, 5));
    }
    return (language ?? const Locale('fr', 'FR'));
  }

  static Future<void> setLanguage(Locale locale) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(_languageKeys, locale.toString());
  }

  static Future<bool> getCgu() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool? validated = preferences.getBool(_cguKeys);
    return (validated ?? false);
  }

  static Future<void> setCgu() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(_cguKeys, true);
  }

  static Future<List<String>> getSite() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String>? sites = preferences.getStringList(_sitesKeys);
    return (sites ?? []);
  }

  static Future<void> setSite(List<String> data) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setStringList(_sitesKeys, data);
  }

  static Future<List<String>> getProcess() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String>? process = preferences.getStringList(_processKeys);
    return (process ?? []);
  }

  static Future<void> setProcess(List<String> data) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setStringList(_processKeys, data);
  }

  static Future<List<String>> getArticles() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String>? articles = preferences.getStringList(_articleKeys);
    return (articles ?? []);
  }

  static Future<void> setArticles(List<String> data) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setStringList(_articleKeys, data);
  }

  static Future<DateTime?> getArticlesDate() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? date = preferences.getString(_articleDateKeys);
    if (date == null) return (null);
    return (DateTime.parse(date));
  }

  static Future<void> setArticlesDate(DateTime date) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(_articleDateKeys, date.toIso8601String());
  }
}
