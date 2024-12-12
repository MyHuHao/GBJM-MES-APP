import 'package:shared_preferences/shared_preferences.dart';

class UserInfoPreference {
  static const String _userName = '默认用户名';
  static const String _jobNumber = '默认工号';

  Future<void> saveUserName(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userName, username);
  }

  Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userName) ?? '';
  }

  Future<void> clearUserName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userName);
  }

  Future<void> saveJobNumber(String jobNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_jobNumber, jobNumber);
  }

  Future<String> getJobNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_jobNumber) ?? '';
  }

  Future<void> clearJobNumber() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_jobNumber);
  }
}
