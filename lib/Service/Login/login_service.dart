import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mesapp/Model/Api/api_result_model.dart';
import 'package:mesapp/Model/Auth/auth_model.dart';
import 'package:mesapp/Model/Login/login_model.dart';
import 'package:mesapp/Preference/login_preference.dart';
import 'package:mesapp/Preference/userinfo_preference.dart';
import 'package:mesapp/Service/Http/api_service.dart';
import 'package:mesapp/Preference/token_preference.dart';
import 'package:mesapp/Config/app_config.dart';

class LoginService with ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  Future<ApiResult<LoginData>> login(String username, String password) async {
    // 模拟登录请求
    // 这里可以使用 Dio 或其他网络库发送请求
    ApiResult<LoginData> result = ApiResult<LoginData>();
    LoginPara para = LoginPara(
      account: username,
      passWord: password,
    );
    try {
      var response = await DioHelper.post(
          AppConfig.baseUrl, // 基础 URL
          '/Login/Login', // 请求路径
          data: para);
      if (response.statusCode == 200) {
        final res = response.data;
        result.msgCode = res['msgCode'];
        result.msg = res['msg'];
        result.time = res['time'];
        if (res['msgCode'] == '0') {
          UserInfo user = UserInfo.fromJson(res['data']['user']);
          LoginData loginData = LoginData(token: res['data']['token'], user: user);
          result.data = loginData;
          _isLoggedIn = true;
          notifyListeners();

          final tokenPreference = TokenPreference();
          await tokenPreference.saveToken(res['data']['token']);

          final userInfoPreference = UserInfoPreference();
          await userInfoPreference.saveUserName(user.accName);
          await userInfoPreference.saveJobNumber(user.accId);

          final LoginPreference preference = LoginPreference();
          await preference.saveAccount(username);
          await preference.savePassword(password);

          return result;
        }
        return result;
      }
      return result;
    } catch (e) {
      result.msgCode = '2';
      result.msg = e.toString();
      result.time = DateTime.now().toString();
      return result;
    }
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }

  Future<ApiResult<String>> changePassword(PasswordChangeData form) async {
    ApiResult<String> result = ApiResult<String>();
    try {
      final response = await DioHelper.post(AppConfig.baseUrl, '/Login/ChangePassword', data: form);
      if (response.statusCode == 200) {
        final res = response.data;
        result.msgCode = res['msgCode'];
        result.msg = res['msg'];
        result.time = res['time'];
        if (res['msgCode'] == '0') {
          result.data = res['data'];
        }
        return result;
      }
      return result;
    } catch (e) {
      result.msgCode = '2';
      result.msg = e.toString();
      result.time = DateTime.now().toString();
      return result;
    }
  }

  Future<ApiResult<String>> addAccount(PasswordChangeData form) async {
    ApiResult<String> result = ApiResult<String>();
    try {
      final response = await DioHelper.post(AppConfig.baseUrl, '/Login/AddAccount', data: form);
      if (response.statusCode == 200) {
        final res = response.data;
        result.msg = res['msg'];
        result.msgCode = res['msgCode'];
        result.time = res['time'];
        if (res['msgCode'] == '0') {
          result.data = res['data'];
        }
        return result;
      }
      return result;
    } catch (e) {
      result.msgCode = '2';
      result.msg = e.toString();
      result.time = DateTime.now().toString();
      return result;
    }
  }

  Future<ApiResult<String>> getUserInfo(GetUserInfo form) async {
    ApiResult<String> result = ApiResult<String>();
    try {
      final response = await DioHelper.post(AppConfig.baseUrl, '/Employee/QueryEmployeeData', data: form);
      if (response.statusCode == 200) {
        final res = response.data;

        final userInfoPreference = UserInfoPreference();
        await userInfoPreference.saveUserName(res['data']["records"][0]["userName"]);
        await userInfoPreference.saveJobNumber(res['data']["records"][0]["userId"]);

        result.msg = res['msg'];
        result.msgCode = res['msgCode'];
        result.time = res['time'];
        if (res['msgCode'] == '0') {
          result.data = jsonEncode(res['data']);
        }
        return result;
      }
      return result;
    } catch (e) {
      result.msgCode = '2';
      result.msg = e.toString();
      result.time = DateTime.now().toString();
      return result;
    }
  }

  Future<ApiResult<List<AuthData>>> getAuthInfo(AuthDataPara para) async {
    ApiResult<List<AuthData>> result = ApiResult<List<AuthData>>();
    try {
      final response = await DioHelper.post(AppConfig.baseUrl, '/Login/GetAuthData', data: para);
      if (response.statusCode == 200) {
        final res = response.data;
        result.msg = res['msg'];
        result.msgCode = res['msgCode'];
        result.time = res['time'];
        if (res['msgCode'] == '0') {
          List<AuthData> list = [];
          for (var item in res['data']) {

            list.add(AuthData.fromJson(item));
          }
          result.data = list;
        }
        return result;
      }
      return result;
    } catch (e) {
      result.msgCode = '2';
      result.msg = e.toString();
      result.time = DateTime.now().toString();
      return result;
    }
  }
}
