import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class JsonPrefsFile {
  JsonPrefsFile(this.name);

  final String name;

  static SharedPreferences? _sharedPrefs;

  Future<Map<String, dynamic>> load() async {
    _sharedPrefs ??= await SharedPreferences.getInstance();
    final p = _sharedPrefs!.getString(name);
    //print('loaded: $p');
    return Map<String, dynamic>.from(jsonDecode(p ?? '{}'));
  }

  Future<void> save(Map<String, dynamic> data) async {
    //print('saving $data');
    _sharedPrefs ??= await SharedPreferences.getInstance();
    await _sharedPrefs!.setString(name, jsonEncode(data));
  }
}
