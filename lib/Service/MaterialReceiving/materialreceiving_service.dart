import 'package:flutter/material.dart';
import 'package:mesapp/Config/app_config.dart';
import 'package:mesapp/Model/Api/api_result_model.dart';
import 'package:mesapp/Model/MaterialReceiving/material_receiving_model.dart';
import 'package:mesapp/Service/Http/api_service.dart';

class MaterialReceivingService with ChangeNotifier {
  Future<ApiResult<ListResult<TableData>>> getTableData(TableDataPara para) async {
    ApiResult<ListResult<TableData>> result = ApiResult<ListResult<TableData>>();
    try {
      final response = await DioHelper.post(AppConfig.baseUrl, '/MaterialReceiving/GetOperationTransferLogData', data: para, requiresToken: false);
      if (response.statusCode == 200) {
        final res = response.data;
        result.msgCode = res['msgCode'];
        result.msg = res['msg'];
        result.time = res['time'];
        if (res['msgCode'] == '0') {
          ListResult<TableData> listResult = ListResult<TableData>();
          listResult.total = res['data']['total'];
          listResult.page = res['data']['page'];
          listResult.pageSize = res['data']['pageSize'];

          List<TableData> tableData = [];
          List<dynamic> records = res['data']['records'];
          for (var record in records) {
            tableData.add(TableData.fromJson(record));
          }
          listResult.records = tableData;
          result.data = listResult;
        }
        return result;
      }
      return result;
    } catch (e) {
      result.msgCode = '2';
      result.msg = e.toString();
      result.time = DateTime.now().toString();
      return result;
    }
  }

  Future<MaterialReceivingAddResult> addMaterialReceiving(Map<String, dynamic> para) async {
    MaterialReceivingAddResult result = MaterialReceivingAddResult();
    try {
      final response = await DioHelper.post(AppConfig.mesUrl, '/TransferWaterThrowingSandblasting/Save', data: para, requiresToken: false);
      final res = response.data;
      return MaterialReceivingAddResult.fromJson(res);
    } catch (e) {
      return result;
    }
  }

  Future<List<TransferMaterial>> getTransferMaterialList() async {
    List<TransferMaterial> result = [];
    try {
      final response = await DioHelper.get(AppConfig.baseUrl, '/MaterialReceiving/GetTransferMaterialList', requiresToken: false);
      final res = response.data;
      // 添加数据解析逻辑
      if (res is Map<String, dynamic> && res['msgCode'] == '0') {
        final data = res['data'] as List<dynamic>?;
        if (data != null) {
          result = data.map((item) {
            return TransferMaterial.fromJson({
              'name': item['name'],
              'array': (item['array'] as List<dynamic>).map((e) => e.toString()).toList()
            });
          }).toList();
        }
      }
      return result;
    } catch (e) {
      return result;
    }
  }
}
