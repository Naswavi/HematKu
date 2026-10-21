import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// PERSISTENCE #2 - Shared Preferences: pengaturan sederhana (key-value).
class Prefs {
  static late SharedPreferences _p;
  static final dark = ValueNotifier<bool>(false);
  static Future<void> load() async {
    _p = await SharedPreferences.getInstance();
    dark.value = _p.getBool('dark') ?? false;
  }
  static int get budget => _p.getInt('budget') ?? 1000000;
  static Future<void> setBudget(int v) => _p.setInt('budget', v);
  static bool get loggedIn => _p.getBool('loggedIn') ?? false;
  static Future<void> setLoggedIn(bool v) => _p.setBool('loggedIn', v);
  static String get email => _p.getString('email') ?? '';
  static Future<void> setEmail(String v) => _p.setString('email', v);
  static Future<void> setDark(bool v) async {
    dark.value = v;
    await _p.setBool('dark', v);
  }
}
