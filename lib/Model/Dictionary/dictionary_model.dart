import 'package:mesapp/Route/app_routes.dart';

final Map<int, String> materialReceivingEnum = {
  7463: "输入的二维码无效",
  7464: "此单不在线检加工中",
  7909: "返修单未报工",
  7910: "返修单已完成，不可再次到站",
  503: "查询程序异常",
  201: "新增成功",
  7457: "上工序未出站",
  0: "上工序未出站"
};

// 定义功能路由映射
final Map<String, String> authEnum = {
  'qt': AppRoutes.materialReceivingLine,
  'twts': AppRoutes.materialReceiving,
  'mtld': AppRoutes.loadingCar,
};
