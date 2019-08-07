
class UserLoginRespond {
  User data;
  int errorCode;
  String errorMsg;

  UserLoginRespond({this.data, this.errorCode, this.errorMsg});

  UserLoginRespond.fromJson(Map<String, dynamic> json) {
    data = User.fromJson(json['data']);
    errorCode = json['errorCode'];
    errorMsg = json['errorMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data.toJson();
    data['errorCode'] = this.errorCode;
    data['errorMsg'] = this.errorMsg;
    return data;
  }
}

class User {
  int id;
  String nickname;
  String icon;
  String email;
  String token;
  String username;
  String password;
  bool admin;
  List<int> collectIds;
  
  User(
      {this.id,
      this.nickname,
      this.icon,
      this.email,
      this.token,
      this.username,
      this.password,
      this.admin,
      this.collectIds});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nickname = json['nickname'];
    icon = json['icon'];
    email = json['email'];
    token = json['token'];
    username = json['username'];
    password = json['password'];
    admin = json['admin'];
    if (json['datas'] != null) {
      collectIds = List<int>();
      json['datas'].forEach((v) {
        collectIds.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nickname'] = this.nickname;
    data['icon'] = this.icon;
    data['email'] = this.email;
    data['token'] = this.token;
    data['username'] = this.username;
    data['password'] = this.password;
    data['admin'] = this.admin;
    data['collectIds'] = this.collectIds;
    return data;
  }
}