import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceController {
  static const String _sitesKeys = "site_keys";

  static const String _processKeys = "process_keys";

  static const String _cguKeys = "cgu_keys";

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
}
