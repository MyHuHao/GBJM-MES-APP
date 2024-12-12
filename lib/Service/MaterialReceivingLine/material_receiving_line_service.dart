import 'package:flutter/material.dart';
import 'package:mesapp/Config/app_config.dart';
import 'package:mesapp/Model/Api/api_result_model.dart';
import 'package:mesapp/Model/MaterialReceivingLine/material_receiving_line_model.dart';
import 'package:mesapp/Service/Http/api_service.dart';

class MaterialReceivingLineService with ChangeNotifier {
  Future<ApiResult<ListResult<TableData>>> getTableData(TableDataPara para) async {
    ApiResult<ListResult<TableData>> result = ApiResult<ListResult<TableData>>();
    try {
      final response = await DioHelper.post(AppConfig.baseUrl, '/Sandblasting/GetQCTransferLogData', data: para, requiresToken: false);
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

  Future<MaterialReceivingLineAddResult> addMaterialReceivingLine(Map<String, dynamic> form) async {
    MaterialReceivingLineAddResult result = MaterialReceivingLineAddResult();
    try {
      final response = await DioHelper.post(AppConfig.mesUrl, '/QcTransfer/QcTransferToStation', data: form, requiresToken: false);
      final res = response.data;
      return MaterialReceivingLineAddResult.fromJson(res);
    } catch (e) {
      return result;
    }
  }
}
