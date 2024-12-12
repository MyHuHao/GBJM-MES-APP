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
flutter build apk --flavor dev --dart-define=FLAVOR=dev --release
flutter build apk --flavor dev --dart-define=FLAVOR=dev --release --build-name=1.0.0 --build-number=0

## 发布正式apk
flutter build apk --flavor staging --dart-define=FLAVOR=staging --release
flutter build apk --flavor staging --dart-define=FLAVOR=staging --release --build-name=1.0.0 --build-number=0


## 更新app图标
flutter pub run flutter_launcher_icons:main

keytool -genkey -v -keystore android/app/my-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias my-release-key

keytool -genkey -v -keystore android/app/key/release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias release-key

## 一般页面
```dart
import 'package:flutter/material.dart';
import 'package:mesapp/Service/Route/navigation_service.dart';

class TextPage extends StatefulWidget {
  const TextPage({super.key});

  @override
  TextPageState createState() => TextPageState();
}

class TextPageState extends State<TextPage> {
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
        title: const Text('测试'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _returnPage,
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              _buildTextFormField(),
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
              hintText: '请输入流程卡号',
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

  void _returnPage() {
    NavigationService().goBack();
  }
}

```


