/*
// 需要 Token 的 GET 请求
var response = await DioHelper.get('https://api.example.com', '/protected', requiresToken: true);

// 不需要 Token 的 POST 请求
var response = await DioHelper.post('https://api.example.com', '/public', data: {"key": "value"});
 */

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mesapp/Preference/token_preference.dart';

class DioHelper {
  static Dio? _dio;

  // 获取存储的Token
  static Future<String?> _getTokenFromStorage() async {
    // 这里可以使用 SharedPreferences 或其他存储方案
    return TokenPreference().getToken(); // 替换为实际获取Token的逻辑
  }

  // 初始化 Dio 实例
  static Dio getInstance() {
    if (_dio == null) {
      _dio = Dio(BaseOptions(
        connectTimeout: const Duration(milliseconds: 5000),
        receiveTimeout: const Duration(milliseconds: 3000),
        responseType: ResponseType.json,
        contentType: 'application/json',
      ));

      // 添加拦截器
      _dio!.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) async {
          // 根据请求是否需要Token来处理
          if (options.extra['requiresToken'] == true) {
            String? token = await _getTokenFromStorage();
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // 记录响应日志
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          // 处理错误信息
          _handleError(e);
          return handler.next(e);
        },
      ));
    }
    return _dio!;
  }

  // 错误处理方法
  static void _handleError(DioException e) {
    String message = '';
    if (e.response != null) {
      switch (e.response!.statusCode) {
        case 401:
          message = '未授权，请重新登录。';
          break;
        case 500:
          message = '服务器内部错误，请稍后再试。';
          break;
        default:
          message = '错误: ${e.response!.statusCode} ${e.response!.statusMessage}';
      }
    } else if (e.type == DioExceptionType.connectionTimeout) {
      message = '连接超时，请检查网络。';
    } else if (e.type == DioExceptionType.receiveTimeout) {
      message = '响应超时，请稍后再试。';
    } else {
      message = '未知错误: ${e.message}';
    }

    Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  // GET 请求，支持是否需要 Token
  static Future<Response> get(String baseUrl, String path, {Map<String, dynamic>? queryParameters, bool requiresToken = false}) async {
    getInstance().options.baseUrl = baseUrl;
    return await getInstance().get(path, queryParameters: queryParameters, options: Options(extra: {'requiresToken': requiresToken}));
  }

  // POST 请求，支持是否需要 Token
  static Future<Response> post(String baseUrl, String path, {dynamic data, bool requiresToken = false}) async {
    getInstance().options.baseUrl = baseUrl;
    return await getInstance().post(path, data: jsonEncode(data), options: Options(extra: {'requiresToken': requiresToken}));
  }

  // PUT 请求，支持是否需要 Token
  static Future<Response> put(String baseUrl, String path, {dynamic data, bool requiresToken = false}) async {
    getInstance().options.baseUrl = baseUrl;
    return await getInstance().put(path, data: jsonEncode(data), options: Options(extra: {'requiresToken': requiresToken}));
  }

  // DELETE 请求，支持是否需要 Token
  static Future<Response> delete(String baseUrl, String path, {dynamic data, bool requiresToken = false}) async {
    getInstance().options.baseUrl = baseUrl;
    return await getInstance().delete(path, data: jsonEncode(data), options: Options(extra: {'requiresToken': requiresToken}));
  }
}
