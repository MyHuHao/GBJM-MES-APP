class ApiResult<T> {
  T? data;
  String? msgCode;
  String? msg;
  String? time;

  ApiResult({this.data, this.msgCode, this.msg, this.time});

  Map<String, dynamic> toJson() {
    return {
      'data': data ?? "",
      'msgCode': msgCode,
      'msg': msg,
      'time': time,
    };
  }

  // 添加 fromJson 方法
  factory ApiResult.fromJson(Map<String, dynamic> json) {
    return ApiResult(
      data: json['data'],
      msgCode: json['msgCode'],
      msg: json['msg'],
      time: json['time'],
    );
  }
}

class ListResult<T> {
  List<T>? records;
  int page;
  int pageSize;
  int total;

  // 添加构造函数
  ListResult({this.records, this.page = 0, this.pageSize = 0, this.total = 0});

  // 添加 toJson 方法
  Map<String, dynamic> toJson() {
    return {
      'records': records ?? [],
      'page': page,
      'pageSize': pageSize,
      'total': total,
    };
  }

  // 添加 fromJson 方法
  factory ListResult.fromJson(Map<String, dynamic> json) {
    return ListResult(
      records: json['records'],
      page: json['page'],
      pageSize: json['pageSize'],
      total: json['total'],
    );
  }

}
