/*
 * 存储 Token 的服务类
 * TokenPreference.saveToken(String token)：保存 Token。
 * TokenPreference.getToken()：获取 Token。
 * TokenPreference.clearToken()：清除 Token。
 */

import 'package:shared_preferences/shared_preferences.dart';

class TokenPreference {
  static const String _tokenKey = 'token';

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}
