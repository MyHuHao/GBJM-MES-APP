class TableDataPara {
  String plant;
  String runCard;
  int page;
  int pageSize;

  // 构造函数
  TableDataPara({this.plant = "DG", this.runCard = "", this.page = 1, this.pageSize = 15});

  // 添加 toJson 方法
  Map<String, dynamic> toJson() {
    return {
      'plant': plant,
      'runCard': runCard,
      'page': page,
      'pageSize': pageSize,
    };
  }
}

class TableData {
  String plant;
  String runCard;
  String ticketSn;
  String operation;
  int qty;
  String createdDd;
  String createdUId;
  String mtSn;
  int fwCount;

  // 构造函数
  TableData({
    this.plant = "",
    this.runCard = "",
    this.ticketSn = "",
    this.operation = "",
    this.qty = 0,
    this.createdDd = "",
    this.createdUId = "",
    this.mtSn = "",
    this.fwCount = 0,
  });

  // 添加 toJson 方法
  Map<String, dynamic> toJson() {
    return {
      'plant': plant,
      'runCard': runCard,
      'ticketSn': ticketSn,
      'operation': operation,
      'qty': qty,
      'createdDd': createdDd,
      'createdUId': createdUId,
      'mtSn': mtSn,
      'fwCount': fwCount,
    };
  }

  // 添加 fromJson 方法
  factory TableData.fromJson(Map<String, dynamic> json) {
    return TableData(
      plant: json['plant'],
      runCard: json['runCard'],
      ticketSn: json['ticketSn'],
      operation: json['operation'],
      qty: json['qty'],
      createdDd: json['createdDd'],
      createdUId: json['createdUId'],
      mtSn: json['mtSn'],
      fwCount: json['fwCount'],
    );
  }
}

class MaterialReceivingLineAddResult {
  int code;
  String errorMsg;

  // 构造函数
  MaterialReceivingLineAddResult({this.code = 0, this.errorMsg = ""});

  // 添加 fromJson 方法
  factory MaterialReceivingLineAddResult.fromJson(Map<String, dynamic> json) {
    return MaterialReceivingLineAddResult(
      code: json['code'],
      errorMsg: json['errorMsg'] ?? "",
    );
  }

  // 添加 toJson 方法
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'errorMsg': errorMsg,
    };
  }
}
