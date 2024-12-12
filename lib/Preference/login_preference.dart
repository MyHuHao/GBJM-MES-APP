/*
 * 存储 Login 的服务类
 * LoginPreference.accountKey(String account)：保存 account。
 * LoginPreference.getAccount()：获取 account。
 * LoginPreference.clearAccount()：清除 account。
 */

import 'package:shared_preferences/shared_preferences.dart';

class LoginPreference {
  static const String _accountKey = '默认账户';
  static const String _passwordKey = '默认密码';

  // 保存账号
  Future<void> saveAccount(String account) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accountKey, account);
  }

  // 获取账号
  Future<String> getAccount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accountKey) ?? "";
  }

  // 删除账号
  Future<void> clearAccount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accountKey);
  }

  // 保存密码
  Future<void> savePassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_passwordKey, password);
  }

  // 获取密码
  Future<String> getPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_passwordKey) ?? "";
  }

  // 删除密码
  Future<void> clearPassword() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_passwordKey);
  }
}
