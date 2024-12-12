import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mesapp/Config/app_config.dart';
import 'package:mesapp/Model/Login/login_model.dart';
import 'package:mesapp/Service/Http/api_service.dart';

class VersionService with ChangeNotifier {
  Future<VersionInfo> getVersionUpdate(String id) async {
    VersionInfo versionInfo = VersionInfo();
    try {
      final response = await DioHelper.get(AppConfig.baseUrl, '/Login/GetVersionUpdate/$id', requiresToken: false);
      final res = response.data;
      versionInfo = VersionInfo.fromJson(res['data']);
      return versionInfo;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return versionInfo;
    }
  }
}
