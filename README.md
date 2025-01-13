# mesapp

mesapp flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## 安装依赖
flutter pub get
## 删除
flutter clean
## 发布测试apk
flutter build apk --flavor Testing --dart-define=FLAVOR=Testing --release
flutter build apk --flavor Testing --dart-define=FLAVOR=Testing --release --build-name=1.0.0 --build-number=0

## 发布正式apk
flutter build apk --flavor Production --dart-define=FLAVOR=Production --release
flutter build apk --flavor Production --dart-define=FLAVOR=Production --release --build-name=1.0.0 --build-number=0


## 更新app图标
flutter pub run flutter_launcher_icons:main

keytool -genkey -v -keystore android/app/my-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias my-release-key

keytool -genkey -v -keystore android/app/key/release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias release-key

## 一般页面
```dart
import 'package:flutter/material.dart';
import 'package:mesapp/Service/Route/navigation_service.dart';

class LoadingCarPage extends StatefulWidget {
  const LoadingCarPage({super.key});

  @override
  LoadingCarPageState createState() => LoadingCarPageState();
}

class LoadingCarPageState extends State<LoadingCarPage> {
  final _formKey = GlobalKey<FormState>();
  final _valueController = TextEditingController();
  final _valueKey = GlobalKey<FormFieldState>();
  final _valueFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            _returnPage();
          },
        ),
        title: const Text(
          '料车装载',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        elevation: 0.5,
      ),
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              _buildTextFormField(),
              const SizedBox(height: 15),
              Expanded(
                child: _buildListCard(), // 用 Expanded 包裹列表
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField() {
    return Row(
      children: [
        // 扫码枪文本框
        Expanded(
          child: TextFormField(
            key: _valueKey,
            focusNode: _valueFocusNode,
            controller: _valueController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.blue, width: 2.0), // 聚焦时的边框
              ),
              hintText: '请输入',
              hintStyle: TextStyle(color: Colors.grey[500]),
              prefixIcon: const Icon(Icons.qr_code, color: Colors.grey), // 左侧图标
              contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '卡号不能为空';
              }
              return null;
            },
            autofocus: true, // 页面加载时自动获取焦点
            readOnly: false, // 禁止键盘弹出
            keyboardType: TextInputType.none, // 键盘类型
            onFieldSubmitted: (value) {
              // 监听到回车事件后触发的逻辑
              _valueController.clear();
              _valueFocusNode.requestFocus();
            },
          ),
        ),
        const SizedBox(width: 8.0), // 按钮与文本框间距
      ],
    );
  }

  Widget _buildListCard() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            title: Text('料车编号：$index'),
            subtitle: Text('料车状态：已装载'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                // 删除料车
              },
            ),
          ),
        );
      },
    );
  }

  void _returnPage() {
    NavigationService().goBack();
  }
}
```


