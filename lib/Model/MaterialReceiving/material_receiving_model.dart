class TableDataPara {
  String plant;
  String runCard;
  List<String> operationList;
  int page;
  int pageSize;

  // 添加构造函数
  TableDataPara({this.plant = "DG", this.runCard = "",this.operationList = const [], this.page = 1, this.pageSize = 15});

  // 添加 toJson 方法
  Map<String, dynamic> toJson() {
    return {
      'plant': plant,
      'runCard': runCard,
      'operationList': operationList,
      'page': page,
      'pageSize': pageSize,
    };
  }
}

class TableData {
  int id;
  String plant;
  String runCard;
  String ticketSn;
  String qty;
  String operation;
  String createdDd;
  String createdUId;

  // 添加构造函数
  TableData({
    this.id = 0,
    this.plant = "",
    this.runCard = "",
    this.operation = "",
    this.qty = "",
    this.ticketSn = "",
    this.createdDd = "",
    this.createdUId = "",
  });

  // 添加 toJson 方法
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plant': plant,
      'runCard': runCard,
      'operation': operation,
      'qty': qty,
      'ticketSn': ticketSn,
      'createdDd': createdDd,
      'createdUId': createdUId,
    };
  }

  // 添加 fromJson 方法
  factory TableData.fromJson(Map<String, dynamic> json) {
    return TableData(
      id: json['id'],
      plant: json['plant'],
      runCard: json['runCard'],
      operation: json['operation'],
      qty: json['qty'],
      ticketSn: json['ticketSn'],
      createdDd: json['createdDd'],
      createdUId: json['createdUId'],
    );
  }
}

class MaterialReceivingAddPara {
  String PLANT; // ignore: non_constant_identifier_names
  String INSPECTOR; // ignore: non_constant_identifier_names
  String RUN_CARD; // ignore: non_constant_identifier_names
  String QTY; // ignore: non_constant_identifier_names
  int TICKET_SN; // ignore: non_constant_identifier_names
  // 添加构造函数
  MaterialReceivingAddPara({
    this.PLANT = "DG", // ignore: non_constant_identifier_names
    this.INSPECTOR = "", // ignore: non_constant_identifier_names
    this.RUN_CARD = "", // ignore: non_constant_identifier_names
    this.QTY = "", // ignore: non_constant_identifier_names
    this.TICKET_SN = 0, // ignore: non_constant_identifier_names
  });

  // 添加 toJson 方法
  Map<String, dynamic> toJson() {
    return {
      'PLANT': PLANT,
      'INSPECTOR': INSPECTOR,
      'RUN_CARD': RUN_CARD,
      'QTY': QTY,
      'TICKET_SN': TICKET_SN,
    };
  }

  // 添加 fromJson 方法
  factory MaterialReceivingAddPara.fromJson(Map<String, dynamic> json) {
    return MaterialReceivingAddPara(
      PLANT: json['PLANT'] ?? "",
      INSPECTOR: json['INSPECTOR'] ?? "",
      RUN_CARD: json['RUN_CARD'] ?? "",
      QTY: json['QTY'] ?? "",
      TICKET_SN: json['TICKET_SN'] ?? 0,
    );
  }
}

class MaterialReceivingAddResult {
  int code;
  String errorMsg;
  String result;

  // 添加构造函数
  MaterialReceivingAddResult({
    this.code = 0,
    this.errorMsg = "",
    this.result = "",
  });

  // 添加 toJson 方法
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'errorMsg': errorMsg,
      'result': result,
    };
  }

  // 添加 fromJson 方法
  factory MaterialReceivingAddResult.fromJson(Map<String, dynamic> json) {
    return MaterialReceivingAddResult(
      code: json['code'],
      errorMsg: json['errorMsg'] ?? "",
      result: json['result'] ?? "",
    );
  }
}
