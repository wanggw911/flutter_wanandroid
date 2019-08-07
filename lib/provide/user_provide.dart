
import 'package:flutter/foundation.dart';
import 'package:flutter_wanandroid/model/user.dart';
import 'package:flutter_wanandroid/network/network.dart';

class UserProvide with ChangeNotifier {
  static User currentUser;
  User user;

  Future login(String username, String password) async {
    user = await Network.loginAction(username, password);
    UserProvide.currentUser = user;
    UserProvide.currentUser.password = password;
    print('登录成功....');
    notifyListeners();
  }

  Future loginOut() async {
    var isSuccess = await Network.loginOutAction();
    if (isSuccess) {
      user = null;
      UserProvide.currentUser = null;
      notifyListeners();
    }
  }

  Future register(String username, String password) async {
    user = await Network.registerAction(username, password);
    UserProvide.currentUser = user;
    print('注册成功....');
    notifyListeners();
  }
}