import 'dart:convert';
import 'package:mesapp/Model/Auth/auth_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPreference {
  static const String authDataKey = "authDataKey";

  // 保存 AuthData 列表到 SharedPreferences
  Future<void> saveAuthList(List<AuthData> authData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // 将列表转换为 JSON 字符串
    String jsonData = jsonEncode(authData.map((auth) => auth.toJson()).toList());
    // 保存 JSON 字符串到 SharedPreferences
    await prefs.setString(authDataKey, jsonData);
  }

  // 从 SharedPreferences 中获取 AuthData 列表
  Future<List<AuthData>> getAuthList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // 读取 JSON 字符串
    String? jsonData = prefs.getString(authDataKey);
    if (jsonData == null || jsonData.isEmpty) {
      // 如果没有数据，则返回空列表
      return [];
    }
    // 将 JSON 字符串转换为 List<AuthData>
    List<dynamic> jsonList = jsonDecode(jsonData);
    return jsonList.map((json) => AuthData.fromJson(json)).toList();
  }
}
