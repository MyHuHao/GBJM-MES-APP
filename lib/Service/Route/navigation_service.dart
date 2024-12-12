import 'package:flutter/material.dart';

/*
  在全局使用 NavigationService
  任何地方都可以使用 NavigationService，无需 BuildContext：

  示例 1：普通跳转
  NavigationService().navigateTo('/profile');
  示例 2：替换当前页面
  NavigationService().navigateAndReplace('/login');
  示例 3：清空栈并跳转
  NavigationService().navigateAndClearStack('/home');
  示例 4：返回上一页
  NavigationService().goBack();
  示例 5：判断是否可以返回
  if (NavigationService().canGoBack()) {
    NavigationService().goBack();
  }
 */

class NavigationService {
  // 私有化构造函数，防止外部直接实例化
  NavigationService._internal();

  // 静态变量存储唯一实例
  static final NavigationService _instance = NavigationService._internal();

  // 提供公共访问点
  factory NavigationService() => _instance;

  // GlobalKey，用于管理 Navigator 的状态
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // 获取当前的 navigator 状态
  NavigatorState? get navigator => navigatorKey.currentState;

  // 跳转到指定页面
  Future<dynamic>? navigateTo(String routeName, {Object? arguments}) {
    return navigatorKey.currentState?.pushNamed(routeName, arguments: arguments);
  }

  // 替换当前页面（无返回）
  Future<dynamic>? navigateAndReplace(String routeName, {Object? arguments}) {
    return navigatorKey.currentState?.pushReplacementNamed(routeName, arguments: arguments);
  }

  // 清空栈并跳转到指定页面
  Future<dynamic>? navigateAndClearStack(String routeName, {Object? arguments}) {
    return navigatorKey.currentState?.pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  // 返回上一页
  void goBack<T extends Object?>([T? result]) {
    if (navigatorKey.currentState?.canPop() ?? false) {
      navigatorKey.currentState?.pop(result);
    }
  }

  // 检查是否可以返回
  bool canGoBack() {
    return navigatorKey.currentState?.canPop() ?? false;
  }
}
