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
  String ruN_CARD; // ignore: non_constant_identifier_names
  String operation;
  int qty;
  String tickeT_SN; // ignore: non_constant_identifier_names
  String mT_SN; // ignore: non_constant_identifier_names
  int fW_COUNT; // ignore: non_constant_identifier_names
  String createD_DD; // ignore: non_constant_identifier_names
  String createD_U_ID; // ignore: non_constant_identifier_names

  // 构造函数
  TableData({
    this.plant = "",
    this.ruN_CARD = "", // ignore: non_constant_identifier_names
    this.operation = "", // ignore: non_constant_identifier_names
    this.qty = 0,
    this.tickeT_SN = "", // ignore: non_constant_identifier_names
    this.mT_SN = "", // ignore: non_constant_identifier_names
    this.fW_COUNT = 0, // ignore: non_constant_identifier_names
    this.createD_DD = "", // ignore: non_constant_identifier_names
    this.createD_U_ID = "", // ignore: non_constant_identifier_names
  });

  // 添加 toJson 方法
  Map<String, dynamic> toJson() {
    return {
      'plant': plant,
      'ruN_CARD': ruN_CARD,
      'operation': operation,
      'qty': qty,
      'tickeT_SN': tickeT_SN,
      'mT_SN': mT_SN,
      'fW_COUNT': fW_COUNT,
      'createD_DD': createD_DD,
      'createD_U_ID': createD_U_ID,
    };
  }

  // 添加 fromJson 方法
  factory TableData.fromJson(Map<String, dynamic> json) {
    return TableData(
      plant: json['plant'],
      ruN_CARD: json['ruN_CARD'],
      operation: json['operation'],
      qty: json['qty'],
      tickeT_SN: json['tickeT_SN'],
      mT_SN: json['mT_SN'],
      fW_COUNT: json['fW_COUNT'],
      createD_DD: json['createD_DD'],
      createD_U_ID: json['createD_U_ID'],
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
