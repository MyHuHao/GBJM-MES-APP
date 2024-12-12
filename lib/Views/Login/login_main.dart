import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mesapp/Config/app_config.dart';
import 'package:mesapp/Model/Auth/auth_model.dart';
import 'package:mesapp/Model/Dictionary/dictionary_model.dart';
import 'package:mesapp/Preference/auth_preference.dart';
import 'package:mesapp/Preference/login_preference.dart';
import 'package:mesapp/Route/app_routes.dart';
import 'package:mesapp/Service/Login/login_service.dart';
import 'package:mesapp/Service/Route/navigation_service.dart';
import 'package:mesapp/Widgets/adaptive_dialog.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  // key
  final _formKey = GlobalKey<FormState>();
  final _usernameKey = GlobalKey<FormFieldState>();
  final _passwordKey = GlobalKey<FormFieldState>();
  // 表单的值
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  // 获取焦点
  final _passwordFocusNode = FocusNode();
  // 密码可见性
  bool _obscurePassword = true;
  // 退出标志
  int _exitFlag = 0;

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
    _initPackageInfo();
    final LoginPreference preference = LoginPreference();
    preference.getAccount().then((String value) {
      if (value.isNotEmpty) {
        _usernameController.text = value;
      }
    });
    preference.getPassword().then((String value) {
      if (value.isNotEmpty) {
        _passwordController.text = value;
      }
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final topPadding = screenHeight * 0.1;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) {
          return;
        }
        _handleBackPress().then((bool value) {
          // 在这里处理返回的布尔值
          if (value) {
            SystemNavigator.pop();
          }
        });
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Padding(
            padding: EdgeInsets.only(top: topPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildTopTitle(),
                const SizedBox(height: 20.0),
                _buildAccInputFields(),
                const SizedBox(height: 10.0),
                _buildPassWordInputFields(),
                const SizedBox(height: 10.0),
                _buildLoginAndRegisterButtons(),
                const Spacer(),
                _buildBottomInfo(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopTitle() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 16.0),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'GBJM',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(10, 32, 99, 1),
            ),
          ),
          Text(
            '智能制造执行系统',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(10, 32, 99, 1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccInputFields() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextFormField(
        key: _usernameKey,
        controller: _usernameController,
        decoration: InputDecoration(
          labelText: "用户名",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '用户名不能为空';
          }
          if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
            return '用户名只能包含字母、数字和下划线';
          }
          return null;
        },
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(_passwordFocusNode);
        },
        onChanged: (_) {
          // 手动触发校验
          _usernameKey.currentState?.validate();
        },
      ),
    );
  }

  Widget _buildPassWordInputFields() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextFormField(
        key: _passwordKey,
        focusNode: _passwordFocusNode,
        controller: _passwordController,
        decoration: InputDecoration(
          labelText: "密码",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '密码不能为空';
          }
          if (value.length < 2) {
            return '密码长度不能少于6位';
          }
          return null;
        },
        obscureText: _obscurePassword,
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (_) => _handleLogin(),
        onChanged: (_) {
          // 密码输入时触发校验
          _passwordKey.currentState?.validate();
        },
      ),
    );
  }

  Widget _buildLoginAndRegisterButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 48.0,
            child: ElevatedButton(
              onPressed: _handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text('登录'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomInfo() {
    String flavor = const String.fromEnvironment('FLAVOR');
    String text;
    if (flavor == 'dev') {
      text = '© 2024 东莞金上晋(科技)有限公司 - 测试区';
    } else if (flavor == 'staging') {
      text = '© 2024 东莞金上晋(科技)有限公司 - 正式区';
    } else {
      text = '© 2024 东莞金上晋(科技)有限公司';
    }
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: () async {
          String baseUrl = AppConfig.baseUrl;
          String appConfig = AppConfig.appConfig;
          String mesUrl = AppConfig.mesUrl;

          String version = packageInfo.version;
          await DialogUtil.showOkConfirmDialog('提示', '后端地址：$baseUrl \n配置文件：$appConfig \nMES地址：$mesUrl \n版本：$version');
        },
        child: Text(
          text,
          style: const TextStyle(fontSize: 12.0, color: Color.fromRGBO(10, 32, 99, 1)),
        ),
      ),
    );
  }

  void _clearForm() {
    _passwordController.clear();
    setState(() {
      _obscurePassword = true;
    });
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        EasyLoading.show(status: '登录中...');
        final result = await context.read<LoginService>().login(
              _usernameController.text,
              _passwordController.text,
            );
        EasyLoading.dismiss();
        if (result.msgCode != '0') {
          EasyLoading.showToast('登录失败：${result.msg}');
          _clearForm();
        } else {
          if (mounted) {
            AuthDataPara authData = AuthDataPara(
              accId: _usernameController.text,
              plant: "DG",
              list: authEnum.keys.toList(),
            );
            final authResult = await context.read<LoginService>().getAuthInfo(authData);
            if (authResult.msgCode != '0') {
              EasyLoading.showToast('获取权限失败：${authResult.msg}');
              _clearForm();
            } else {
              final AuthPreference authPreference = AuthPreference();
              await authPreference.saveAuthList(authResult.data ?? []);
              NavigationService().navigateAndReplace(AppRoutes.container);
            }
          }
        }
      } catch (e) {
        EasyLoading.showError('登录异常，请稍后重试');
        _clearForm();
      }
    }
  }

  Future<bool> _handleBackPress() async {
    if (_exitFlag == 1) {
      return true;
    }
    _exitFlag = 1;
    Fluttertoast.showToast(msg: '再按一次退出应用');
    Future.delayed(const Duration(seconds: 2), () => _exitFlag = 0);
    return false;
  }
}
