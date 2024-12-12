class AuthDataPara {
  String accId;
  String plant;
  List<String> list;

  // 构造函数
  AuthDataPara({
    required this.accId,
    required this.plant,
    required this.list,
  });

// 添加 toJson 方法
  Map<String, dynamic> toJson() {
    return {
      'accId': accId,
      'plant': plant,
      'list': list,
    };
  }

  // 添加 fromJson 方法
  factory AuthDataPara.fromJson(Map<String, dynamic> json) {
    return AuthDataPara(
      accId: json['accId'] ?? "",
      plant: json['plant'] ?? "",
      list: List<String>.from(json['list'] ?? []),
    );
  }
}

class AuthData {
  String plant;
  String role;
  String functionId;
  String functionName;
  int createAuth;
  int deleteAuth;
  int updateAuth;
  int queryAuth;
  int approvalAuth;
  int disapprovalAuth;
  int cancelAuth;
  int ngCodeMoveAuth;

  // 构造函数
  AuthData({
    this.plant = "",
    this.role = "",
    this.functionId = "",
    this.functionName = "",
    this.createAuth = 0,
    this.deleteAuth = 0,
    this.updateAuth = 0,
    this.queryAuth = 0,
    this.approvalAuth = 0,
    this.disapprovalAuth = 0,
    this.cancelAuth = 0,
    this.ngCodeMoveAuth = 0,
  });

  // 添加 toJson 方法
  Map<String, dynamic> toJson() {
    return {
      'plant': plant,
      'role': role,
      'functionId': functionId,
      'functionName': functionName,
      'createAuth': createAuth,
      'deleteAuth': deleteAuth,
      'updateAuth': updateAuth,
      'queryAuth': queryAuth,
      'approvalAuth': approvalAuth,
      'disapprovalAuth': disapprovalAuth,
      'cancelAuth': cancelAuth,
      'ngCodeMoveAuth': ngCodeMoveAuth,
    };
  }

  // 添加 fromJson 方法
  factory AuthData.fromJson(Map<String, dynamic> json) {
    return AuthData(
      plant: json['plant'] ?? "",
      role: json['role'] ?? "",
      functionId: json['functionId'] ?? "",
      functionName: json['functionName'] ?? "",
      createAuth: json['createAuth'] ?? 0,
      deleteAuth: json['deleteAuth'] ?? 0,
      updateAuth: json['updateAuth'] ?? 0,
      queryAuth: json['queryAuth'] ?? 0,
      approvalAuth: json['approvalAuth'] ?? 0,
      disapprovalAuth: json['disapprovalAuth'] ?? 0,
      cancelAuth: json['cancelAuth'] ?? 0,
      ngCodeMoveAuth: json['ngCodeMoveAuth'] ?? 0,
    );
  }
}
