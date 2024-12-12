class PasswordChangeData {
  String? account;
  String? oldPassWord;
  String? newPassWord;

  // 添加构造函数
  PasswordChangeData({this.account, this.oldPassWord, this.newPassWord});

  // 添加 toJson 方法
  Map<String, dynamic> toJson() {
    return {
      'account': account,
      'oldPassWord': oldPassWord,
      'newPassWord': newPassWord,
    };
  }
}

class GetUserInfo {
  String empId;
  int page;
  int pageSize;

  // 添加构造函数
  GetUserInfo({this.empId = "", this.page = 1, this.pageSize = 15});

  // 添加 toJson 方法
  Map<String, dynamic> toJson() {
    return {
      'empId': empId,
      'page': page,
      'pageSize': pageSize,
    };
  }
}

class LoginPara {
  String account;
  String passWord;

  // 添加构造函数
  LoginPara({this.account = "", this.passWord = ""});

  // 添加 toJson 方法
  Map<String, dynamic> toJson() {
    return {
      'account': account,
      'passWord': passWord,
    };
  }
}

class UserInfo {
  final String accId;
  final String accName;
  final String deptId;
  final String empEntryDate;
  final String empMobilePhone;
  final String empEmail;

  // 添加构造函数
  const UserInfo({
    this.accId = "",
    this.accName = "",
    this.deptId = "",
    this.empEntryDate = "",
    this.empMobilePhone = "",
    this.empEmail = "",
  });

  // 添加 toJson 方法
  Map<String, dynamic> toJson() {
    return {
      'accId': accId,
      'accName': accName,
      'deptId': deptId,
      'empEntryDate': empEntryDate,
      'empMobilePhone': empMobilePhone,
      'empEmail': empEmail,
    };
  }

  // 添加 fromJson 方法
  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      accId: json['accId'] ?? "",
      accName: json['accName'] ?? "",
      deptId: json['deptId'] ?? "",
      empEntryDate: json['empEntryDate'] ?? "",
      empMobilePhone: json['empMobilePhone'] ?? "",
      empEmail: json['empEmail'] ?? "",
    );
  }
}

class VersionInfo {
  String id;
  String type;
  String version;
  String name;
  String push;
  String createdAccId;
  String createdDate;

  // 添加构造函数
  VersionInfo({
    this.id = "",
    this.type = "",
    this.version = "",
    this.name = "",
    this.push = "",
    this.createdAccId = "",
    this.createdDate = "",
  });

  // 添加 toJson 方法
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'version': version,
      'name': name,
      'push': push,
      'createdAccId': createdAccId,
      'createdDate': createdDate,
    };
  }

  // 添加 fromJson 方法
  factory VersionInfo.fromJson(Map<String, dynamic> json) {
    return VersionInfo(
      id: json['id'] ?? "",
      type: json['type'] ?? "",
      version: json['version'] ?? "",
      name: json['name'] ?? "",
      push: json['push'] ?? "",
      createdAccId: json['createdAccId'] ?? "",
      createdDate: json['createdDate'] ?? "",
    );
  }
}
