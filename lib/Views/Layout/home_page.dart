import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mesapp/Model/Auth/auth_model.dart';
import 'package:mesapp/Model/Dictionary/dictionary_model.dart';
import 'package:mesapp/Model/Home/home_model.dart';
import 'package:mesapp/Preference/auth_preference.dart';
import 'package:mesapp/Service/Route/navigation_service.dart';
import 'package:collection/collection.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  // 定义一个变量来存储天气数据
  WeatherData weatherData = WeatherData();
  List<Map<String, dynamic>> featuresList = [];

  @override
  void initState() {
    super.initState();
    _initializeFeaturesList();
  }

  @override
  void dispose() {
    super.dispose();
    weatherData = WeatherData();
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
          physics: const ClampingScrollPhysics(), // 防止嵌套滑动冲突
          children: <Widget>[
            _buildHintCard(),
            const SizedBox(height: 10),
            // _buildFeatureCard(),
            // const SizedBox(height: 10),
            _buildListCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildHintCard() {
    final date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '感谢您的工作！',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              '今天是$date',
              style: const TextStyle(fontSize: 12),
            ),
            // ，天气${weatherData.weather}，气温${weatherData.temperature}摄氏度。
          ],
        ),
      ),
    );
  }

  Widget _buildListCard() {
    final List<Map<String, dynamic>> dataList = featuresList;

    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '快捷功能列表',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                final item = dataList[index];
                return InkWell(
                  onTap: () {
                    NavigationService().navigateTo(item['route']);
                  },
                  child: Container(
                    height: 45,
                    alignment: Alignment.centerLeft,
                    child: Text(item['name'], style: const TextStyle(fontSize: 14)),
                  ),
                );
              },
            ),
          ],
        ),
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
        'name': firstItem.functionName,
        'value': entry.key,
        'route': authEnum[entry.key],
      };
    }).toList();

    // 刷新 UI
    setState(() {});
  }
}
