import 'package:flutter/material.dart';
import 'package:mesapp/Config/app_config.dart';
import 'package:mesapp/Model/Login/login_model.dart';
import 'package:mesapp/Service/Version/version_service.dart';
import 'package:mesapp/Tool/global_timer.dart';
import 'package:mesapp/Views/Layout/home_page.dart';
import 'package:mesapp/Views/Layout/features_page.dart';
import 'package:mesapp/Views/Layout/profile_page.dart';
import 'package:mesapp/Widgets/adaptive_dialog.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ContainerPage extends StatefulWidget {
  const ContainerPage({super.key});

  @override
  ContainerPageState createState() => ContainerPageState();
}

class ContainerPageState extends State<ContainerPage> {
  int _selectedIndex = 0;

  PackageInfo packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  static const List<Widget> _pages = <Widget>[
    HomePage(),
    FeaturesPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initPackageInfo();
    GlobalTimer().startTimer(() async {
      VersionInfo result = await context.read<VersionService>().getVersionUpdate(AppConfig.appConfig);
      if (result.push.isNotEmpty && result.version != packageInfo.version) {
        _updateApp(result.name);
      }
    });
  }

  @override
  void dispose() {
    _selectedIndex = 0;
    super.dispose();
  }

  // 获取版本信息
  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      packageInfo = info;
    });
  }

  Future<void> _updateApp(String name) async {
    GlobalTimer().stopTimer();
    String appUrl = AppConfig.baseUrl;
    String appName = "";
    String version = name.split('_')[1].split('-')[0];
    if (AppConfig.appConfig == 'Testing') {
      appName = "test$version";
    } else if (AppConfig.appConfig == 'Production') {
      appName = "prod$version";
    }
    String downloadUrl = "$appUrl/AppUpdate/DownloadApp/$appName";
    bool result = await DialogUtil.showOkConfirmDialog('提示', "当前有新系统版本需要更新 \n 当前版本: $name \n 当前下载服务器 $appUrl \n 下载URL $downloadUrl \n 请点击确认更新");
    if (result == true) {
      // 跳转到浏览器下载
      final Uri url = Uri.parse(downloadUrl).replace(
        pathSegments: ['AppUpdate', 'DownloadApp', appName],
      );
      if (!await launchUrl(
        url,
        mode: LaunchMode.externalApplication, // 使用外部浏览器打开
      )) {
        throw Exception('无法打开浏览器: $url');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, Object? result) {
          if (didPop) {
            return;
          }
        },
        child: Scaffold(
          body: _pages[_selectedIndex],
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
              BottomNavigationBarItem(icon: Icon(Icons.build), label: '功能'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: '我的'),
            ],
            currentIndex: _selectedIndex,
            iconSize: 20,
            selectedItemColor: Colors.blue,
            // 选中时的颜色
            unselectedItemColor: Colors.black,
            // 未选中时的颜色
            onTap: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ));
  }
}
