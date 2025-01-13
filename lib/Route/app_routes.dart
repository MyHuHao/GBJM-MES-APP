import 'package:flutter/material.dart';
import 'package:mesapp/Views/Layout/container.dart';
import 'package:mesapp/Views/Login/login_main.dart';
import 'package:mesapp/Views/MaterialReceiving/material_receiving_main.dart';
import 'package:mesapp/Views/MaterialReceivingAssembly/material_receiving_assembly_main.dart';
import 'package:mesapp/Views/MaterialReceivingDrum/material_receiving_drum.dart';
import 'package:mesapp/Views/MaterialReceivingKiyomitsu/material_receiving_kiyomitsu.dart';
import 'package:mesapp/Views/MaterialReceivingLine/material_receiving_line_main.dart';
import 'package:mesapp/Views/MaterialReceivingRough/material_receiving_rough.dart';
import 'package:mesapp/Views/MaterialReceivingShockEngines/material_receiving_welding_main.dart';
import 'package:mesapp/Views/MaterialReceivingStamp/material_receiving_stamp.dart';
import 'package:mesapp/Views/MaterialReceivingWelding/material_receiving_welding_main.dart';
import 'package:mesapp/Widgets/scan_widget.dart';


class AppRoutes {
  static const String login = '/login'; // 登录
  static const String container = '/container'; // 容器
  static const String qrCodeScanner = '/qrCodeScanner'; // 扫码
  static const String materialReceivingLine = '/materialReceivingLine'; // 转料到站-线检
  static const String materialReceiving = '/materialReceiving'; // 转料到站-水抛
  static const String materialReceivingAssembly = '/materialReceivingAssembly'; // 转料到站-组装
  static const String materialReceivingWelding = '/materialReceivingWelding'; // 转料到站-焊接
  static const String materialReceivingShockEngines = '/materialReceivingShockEngines'; // 转料到站-震机 喷砂

  static const String materialReceivingDrum = '/materialReceivingDrum'; // 转料到站-滚筒
  static const String materialReceivingKiyomitsu = '/materialReceivingKiyomitsu'; // 转料到站-清光
  static const String materialReceivingRough = '/materialReceivingRough'; // 转料到站-开粗
  static const String materialReceivingStamp = '/materialReceivingStamp'; // 转料到站-平面抛光 镭射 打钢印



  static Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginPage(),
    container: (context) => const ContainerPage(),
    qrCodeScanner: (context) => const QRCodeScannerPage(),
    materialReceivingLine: (context) => const MaterialReceivingLinePage(),
    materialReceiving: (context) => const MaterialReceivingPage(),
    materialReceivingAssembly: (context) => const MaterialReceivingAssemblyPage(),
    materialReceivingWelding: (context) => const MaterialReceivingWeldingPage(),
    materialReceivingShockEngines: (context) => const MaterialReceivingShockEnginesPage(),
    materialReceivingDrum: (context) => const MaterialReceivingDrumPage(),
    materialReceivingKiyomitsu: (context) => const MaterialReceivingKiyomitsuPage(),
    materialReceivingRough: (context) => const MaterialReceivingRoughPage(),
    materialReceivingStamp: (context) => const MaterialReceivingStampPage(),
  };
}
