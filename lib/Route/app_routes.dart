import 'package:flutter/material.dart';
import 'package:mesapp/Views/Layout/container.dart';
import 'package:mesapp/Views/Login/login_main.dart';
import 'package:mesapp/Views/MaterialReceiving/material_receiving_main.dart';
import 'package:mesapp/Views/MaterialReceivingLine/material_receiving_line_main.dart';
import 'package:mesapp/Widgets/scan_widget.dart';


class AppRoutes {
  static const String login = '/login'; // 登录
  static const String container = '/container'; // 容器
  static const String qrCodeScanner = '/qrCodeScanner'; // 扫码
  static const String materialReceivingLine = '/materialReceivingLine'; // 转料到站-线检
  static const String materialReceiving = '/materialReceiving'; // 转料到站



  static Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginPage(),
    container: (context) => const ContainerPage(),
    qrCodeScanner: (context) => const QRCodeScannerPage(),
    materialReceivingLine: (context) => const MaterialReceivingLinePage(),
    materialReceiving: (context) => const MaterialReceivingPage(),
  };
}
