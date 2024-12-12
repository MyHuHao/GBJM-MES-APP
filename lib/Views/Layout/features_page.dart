import 'package:flutter/material.dart';
import 'package:mesapp/Model/Auth/auth_model.dart';
import 'package:mesapp/Model/Dictionary/dictionary_model.dart';
import 'package:mesapp/Preference/auth_preference.dart';
import 'package:mesapp/Service/Route/navigation_service.dart';
import 'package:collection/collection.dart';

class FeaturesPage extends StatefulWidget {
  const FeaturesPage({super.key});

  @override
  FeaturesPageState createState() => FeaturesPageState();
}

class FeaturesPageState extends State<FeaturesPage> {
  List<Map<String, dynamic>> featuresList = [];

  @override
  void initState() {
    super.initState();
    _initializeFeaturesList();
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
              children: [_buildMenu()],
            )));
  }

  Widget _buildMenu() {
    // 使用列表存储菜单项信息
    final menuItems = featuresList;

    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: menuItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Column(
            children: [
              ListTile(
                title: Text(item['title'] as String),
                onTap: () {
                  NavigationService().navigateTo(item['route'] as String);
                },
              ),
              if (index < menuItems.length - 1)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(
                    height: 1,
                    color: Colors.grey,
                  ),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Future<void> _initializeFeaturesList() async {
    // 获取权限数据
    final AuthPreference authPreference = AuthPreference();
    List<AuthData> list = await authPreference.getAuthList();

    // 使用 groupBy 方法将具有相同 Function ID 的数据分组
    var groupedData = groupBy(
      list,
      (AuthData item) => item.functionId,
    );

    // 过滤并构建 featuresList
    featuresList = groupedData.entries
        .where((entry) => authEnum.containsKey(entry.key)) // 只保留存在于 authEnum 中的 key
        .map((entry) {
      var firstItem = entry.value.first;
      return {
        'title': firstItem.functionName,
        'route': authEnum[entry.key],
      };
    }).toList();

    // 刷新 UI
    setState(() {});
  }
}
