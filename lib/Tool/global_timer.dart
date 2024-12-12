import 'dart:async';

class GlobalTimer {
  static final GlobalTimer _instance = GlobalTimer._internal();
  Timer? _timer;

  factory GlobalTimer() => _instance;

  GlobalTimer._internal();

  // 开始定时器
  void startTimer(Function callback) {
    // 如果定时器已启动，先取消
    stopTimer();
    _timer = Timer.periodic(const Duration(minutes: 10), (timer) {
      callback();
    });
  }

  // 停止定时器
  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }
}
