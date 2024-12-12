import 'package:flutter/material.dart';
import 'package:mesapp/Service/Route/navigation_service.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRCodeScannerPage extends StatefulWidget {
  const QRCodeScannerPage({super.key});

  @override
  QRCodeScannerState createState() => QRCodeScannerState();
}

class QRCodeScannerState extends State<QRCodeScannerPage> {
  final MobileScannerController _cameraController = MobileScannerController();
  bool _isFlashOn = false; // 是否开启闪光灯
  bool _isScanning = false; // 添加标志位，防止重复扫码

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  void _toggleFlash() {
    setState(() {
      _isFlashOn = !_isFlashOn;
      _cameraController.toggleTorch(); // 切换闪光灯
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        // 禁用普通的返回行为
        canPop: false,
        // 自定义返回键行为
        onPopInvokedWithResult: (bool didPop, Object? result) {
          if (didPop) {
            return;
          }
          _returnPage();
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => _returnPage(),
            ),
          ),
          body: Stack(
            children: [
              // 扫码视图
              MobileScanner(
                controller: _cameraController,
                onDetect: (capture) {
                  if (_isScanning) return; // 如果已经扫码成功，则不再执行
                  final List<Barcode> barcodes = capture.barcodes;
                  for (final barcode in barcodes) {
                    if (barcode.rawValue != null) {
                      _isScanning = true; // 设置为正在扫码
                      _returnPage(barcode.rawValue!); // 返回并带回扫码数据
                      break;
                    }
                  }
                },
              ),
              // 半透明扫码框
              Center(
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white.withOpacity(0.6), width: 2),
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
              // 底部工具栏
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    IconButton(
                      icon: Icon(
                        _isFlashOn ? Icons.flash_on : Icons.flash_off,
                        color: Colors.white,
                        size: 32,
                      ),
                      onPressed: _toggleFlash,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '请将二维码置于扫描框内',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  void _returnPage([String? result]) {
    // 返回上一页并携带扫码数据
    NavigationService().goBack(result); // 返回并携带扫码结果
  }
}
