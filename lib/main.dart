import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mesapp/Config/app_config.dart';
import 'package:mesapp/Route/app_routes.dart';
import 'package:mesapp/Service/Home/home_service.dart';
import 'package:mesapp/Service/Login/login_service.dart';
import 'package:mesapp/Service/MaterialReceiving/materialreceiving_service.dart';
import 'package:mesapp/Service/MaterialReceivingLine/material_receiving_line_service.dart';
import 'package:mesapp/Service/Route/navigation_service.dart';
import 'package:mesapp/Service/Version/version_service.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.loadConfig();
  _setSystemUIOverlayStyle();
  _configureEasyLoading();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginService>(create: (_) => LoginService()),
        ChangeNotifierProvider<MaterialReceivingService>(create: (_) => MaterialReceivingService()),
        ChangeNotifierProvider<MaterialReceivingLineService>(create: (_) => MaterialReceivingLineService()),
        ChangeNotifierProvider<HomeService>(create: (_) => HomeService()),
        ChangeNotifierProvider<VersionService>(create: (_) => VersionService())
      ],
      child: const MyApp(),
    ),
  );
}

void _setSystemUIOverlayStyle() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.white, // 状态栏背景色
    statusBarIconBrightness: Brightness.dark, // 图标颜色
    statusBarBrightness: Brightness.light, // iOS 状态栏图标颜色
  ));
}

void _configureEasyLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 1000)
    ..indicatorWidget = null // 隐藏指示器
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 20.0
    ..radius = 8.0
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..backgroundColor = Colors.black12
    ..userInteractions = false
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GBJM App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.dark, // 暗色模式
      ),
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system, // 根据系统设置自动选择主题
      initialRoute: AppRoutes.login, // 初始页面为登录页面
      routes: AppRoutes.routes, // 配置路由
      navigatorKey: NavigationService().navigatorKey,
      builder: (context, child) {
        _configureErrorWidget();
        return SafeArea(child: FlutterEasyLoading(child: child!));
      },
    );
  }

  void _configureErrorWidget() {
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('发生错误：${details.exception}'),
          ),
        ),
      );
    };
  }
}