import 'package:flutter/material.dart';
import 'package:flutter_app_update/flutter_app_update.dart';
import 'package:flutter_app_update/result_model.dart';
import 'package:mesapp/Config/app_config.dart';
import 'package:mesapp/Model/Login/login_model.dart';
import 'package:mesapp/Preference/token_preference.dart';
import 'package:mesapp/Preference/userinfo_preference.dart';
import 'package:mesapp/Route/app_routes.dart';
import 'package:mesapp/Service/Route/navigation_service.dart';
import 'package:mesapp/Service/Version/version_service.dart';
import 'package:mesapp/Tool/global_timer.dart';
import 'package:mesapp/Widgets/adaptive_dialog.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  // 创建一个新的 State 子类
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  // 定义一个变量来存储用户信息
  String _userName = '';
  String _userId = '';

  PackageInfo packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initPackageInfo();
    _fetchUserProfile(); // 页面初始化时查询个人信息
    if (!kIsWeb) {
      AzhonAppUpdate.listener((ResultModel model) {
        debugPrint('更新结果: $model');
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _userName = '';
    _userId = '';
    AzhonAppUpdate.dispose();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromRGBO(240, 243, 248, 1), Color.fromRGBO(240, 243, 248, 1)], // 从上到下的渐变颜色
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: [
                _buildProfileCard(),
                const SizedBox(height: 5),
                _buildListCard(),
                const SizedBox(height: 5),
                _buildHintCard(),
              ],
            )));
  }

  Widget _buildProfileCard() {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 20, top: 10),
              child: Text(
                _userName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, top: 10),
              child: Text(
                _userId,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // 基本信息
            Container(
              margin: const EdgeInsets.only(left: 20, top: 10),
              child: const Text(
                '工作中...',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListCard() {
    return Card(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('在线更新'),
              onTap: () async {
                _getVersion();
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('关于'),
              onTap: () async {
                await DialogUtil.showOkConfirmDialog('关于', "GBJM 智能制造系统移动版\n版本：${packageInfo.version}");
              },
            ),
          ],
        ));
  }

  Widget _buildHintCard() {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('退出登录'),
            onTap: () async {
              // 这里添加退出登录的逻辑，比如清除用户数据、返回到登录页面等
              // 以下是简单的示例，假设跳转到登录页面
              await _clearForm();
              await NavigationService().navigateAndClearStack(AppRoutes.login);
            },
          )
        ],
      ),
    );
  }

  Future<void> _fetchUserProfile() async {
    final userInfoPreference = UserInfoPreference();
    final userName = await userInfoPreference.getUserName();
    final userId = await userInfoPreference.getJobNumber();

    setState(() {
      _userName = userName;
      _userId = userId;
    });
  }

  _appUpdate(String url) {
    UpdateModel model = UpdateModel(
      url,
      "flutterUpdate.apk",
      "ic_launcher",
      '',
    );
    AzhonAppUpdate.update(model);
  }

  Future<void> _clearForm() async {
    final tokenPreference = TokenPreference();
    await tokenPreference.clearToken();
    final userInfoPreference = UserInfoPreference();
    await userInfoPreference.clearUserName();
    await userInfoPreference.clearJobNumber();
    GlobalTimer().stopTimer();
  }

  Future<void> _openUpdatePage(String name) async {
    // 这里添加打开更新页面的逻辑，比如跳转到更新页面等
    // 以下是简单的示例，假设跳转到更新页面
    String appUrl = AppConfig.baseUrl;
    String url = "$appUrl/AppUpdate/DownloadUpdateApk/$name";
    bool result = await DialogUtil.showOkCancelConfirmDialog('提示', "更新系统将自动更新 \n 当前版本: $name \n 当前下载服务器 $appUrl \n 下载URL $url \n 请点击确认更新");
    if (result == true) {
      _appUpdate(url);
    }
  }

  Future<void> _getVersion() async {
    VersionInfo result = await context.read<VersionService>().getVersionUpdate(AppConfig.appConfig);
    if (result.push.isNotEmpty && result.version != packageInfo.version) {
      _openUpdatePage(result.name);
    } else {
      await DialogUtil.showOkConfirmDialog('提示', '当前暂无版本更新');
    }
  }
}
