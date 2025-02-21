import 'package:flutter/material.dart';
import 'package:mesapp/Model/Auth/auth_model.dart';
import 'package:mesapp/Model/MaterialReceiving/material_receiving_model.dart';
import 'package:mesapp/Preference/auth_preference.dart';
import 'package:mesapp/Service/MaterialReceiving/materialreceiving_service.dart';
import 'package:mesapp/Service/Route/navigation_service.dart';
import 'package:collection/collection.dart';
import 'package:provider/provider.dart';

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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: featuresList.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Column(
            children: [
              ListTile(
                title: Text(item['name'] as String),
                onTap: () {
                  NavigationService().navigateTo(item['route'], arguments: item);
                },
              ),
              if (index < featuresList.length - 1)
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

    // 新增物料转移数据请求
    // 新增安全检查
    if (!mounted) return;
    List<TransferMaterial> res = await context.read<MaterialReceivingService>().getTransferMaterialList();

    // 定义一个 Map，将 Function ID 映射到对应的路由
    Map<String, List<String>> menuList = {
      for (var item in res) item.name.toString(): (item.array as List<dynamic>).map((e) => e.toString()).toList()
    };

    // 使用 groupBy 方法将具有相同 Function ID 的数据分组
    var groupedData = groupBy(
      list,
      (AuthData item) => item.functionId,
    );

    // 过滤并构建 featuresList
    featuresList = [
      // 固定项
      {"name": "线检转料到站", "value": "qt", "route": "/materialReceivingLine", "array": []},
      // 动态生成项
      ...menuList.entries.map((entry) {
        // 在groupedData中查找匹配当前工序的第一个有效functionId
        final validId = entry.value.firstWhere(
              (id) => groupedData.containsKey(id),
          orElse: () => entry.value.first,
        );

        return {
          "name": "${entry.key}转料到站",
          "value": validId, // 使用实际存在的functionId
          "route": "/materialReceiving",
          "array": entry.value
        };
      })
    ];

    // 刷新 UI
    setState(() {});
  }
}
