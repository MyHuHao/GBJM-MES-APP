import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mesapp/Model/Api/api_result_model.dart';
import 'package:mesapp/Model/Auth/auth_model.dart';
import 'package:mesapp/Model/Login/login_model.dart';
import 'package:mesapp/Preference/login_preference.dart';
import 'package:mesapp/Preference/userinfo_preference.dart';
import 'package:mesapp/Service/Http/api_service.dart';
import 'package:mesapp/Config/app_config.dart';

class LoginService with ChangeNotifier {
  Future<ApiResult<UserInfo>> login(LoginPara para) async {
    ApiResult<UserInfo> result = ApiResult<UserInfo>();
    try {
      final response = await DioHelper.post(
          AppConfig.baseUrl, // 基础 URL
          '/Login/Login', // 请求路径
          data: para);
      if (response.statusCode == 200) {
        final res = response.data;
        result.msgCode = res['msgCode'];
        result.msg = res['msg'];
        result.time = res['time'];
        if (res['msgCode'] == '0') {
          UserInfo user = UserInfo.fromJson(res['data']);
          result.data = user;
          // 缓存 用户名 工号
          final userInfoPreference = UserInfoPreference();
          await userInfoPreference.saveUserName(user.accName);
          await userInfoPreference.saveJobNumber(user.accId);
          // 缓存 账户密码
          final LoginPreference preference = LoginPreference();
          await preference.saveAccount(para.account);
          await preference.savePassword(para.passWord);
        }
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
      final response = await DioHelper.post(AppConfig.baseUrl, '/Login/GetAuthInfo', data: para);
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
