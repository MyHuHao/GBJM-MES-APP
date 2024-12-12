import 'package:flutter/material.dart';
import 'package:mesapp/Views/Layout/container.dart';
import 'package:mesapp/Views/LoadingCar/loading_car_main.dart';
import 'package:mesapp/Views/Login/login_main.dart';
import 'package:mesapp/Views/MaterialReceiving/material_receiving_main.dart';
import 'package:mesapp/Views/MaterialReceivingLine/material_receiving_line_main.dart';
import 'package:mesapp/Widgets/scan_widget.dart';


class AppRoutes {
  static const String login = '/login';
  static const String container = '/container';
  static const String materialReceiving = '/materialReceiving';
  static const String qrCodeScanner = '/qrCodeScanner';
  static const String materialReceivingLine = '/materialReceivingLine';
  static const String loadingCar = '/loadingCar';


  static Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginPage(),
    container: (context) => const ContainerPage(),
    materialReceiving: (context) => const MaterialReceivingPage(),
    qrCodeScanner: (context) => const QRCodeScannerPage(),
    materialReceivingLine: (context) => const MaterialReceivingLinePage(),
    loadingCar: (context) => const LoadingCarPage(),
  };
}
