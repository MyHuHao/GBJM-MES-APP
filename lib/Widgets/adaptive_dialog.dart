import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:mesapp/Service/Route/navigation_service.dart';

class DialogUtil {
  static BuildContext? _getContext() {
    return NavigationService().navigatorKey.currentContext;
  }

  /// 显示确定取消对话框
  static Future<bool> showOkCancelConfirmDialog(
    String title,
    String content, {
    String okLabel = '确定',
    String cancelLabel = '取消',
    bool barrierDismissible = false,
  }) async {
    final context = _getContext();
    if (context == null) {
      debugPrint('Context is null');
      return false;
    }
    final result = await showOkCancelAlertDialog(
      context: context,
      title: title,
      message: content,
      okLabel: okLabel,
      cancelLabel: cancelLabel,
      barrierDismissible: barrierDismissible,
    );
    return result == OkCancelResult.ok;
  }

  /// 显示单按钮确认对话框
  static Future<bool> showOkConfirmDialog(
    String title,
    String content, {
    String okLabel = '确定',
    bool barrierDismissible = false,
  }) async {
    final context = _getContext();
    if (context == null) {
      debugPrint('Context is null');
      return false;
    }
    final result = await showOkAlertDialog(
        context: context, title: title, message: content, okLabel: okLabel, barrierDismissible: barrierDismissible, canPop: false);
    return result == OkCancelResult.ok;
  }

  /// 显示文本输入对话框
  static Future<String?> showInputDialog(
    String title,
    String hint, {
    String? okLabel = '确定',
    String? cancelLabel = '取消',
    bool barrierDismissible = false,
  }) async {
    final context = _getContext();
    if (context == null) {
      debugPrint('Context is null');
      return null;
    }
    final result = await showTextInputDialog(
      context: context,
      title: title,
      textFields: [
        DialogTextField(hintText: hint),
      ],
      okLabel: okLabel,
      cancelLabel: cancelLabel,
      barrierDismissible: barrierDismissible,
    );
    return result?.first;
  }

// 可以根据需要添加更多的封装方法，例如自定义多选对话框等
}
