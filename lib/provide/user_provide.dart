
import 'package:flutter/foundation.dart';
import 'package:flutter_wanandroid/model/home_article.dart';
import 'package:flutter_wanandroid/model/user.dart';
import 'package:flutter_wanandroid/network/network.dart';

class UserProvide with ChangeNotifier {
  static User currentUser;
  User user;
  int _pageIndex = 0;
  List<Article> collectionList = [];
  
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

  //请求获取文章数据
  Future getCollectionArticleData(bool isRefresh) async {
    if (isRefresh) {
      collectionList.clear();
      _pageIndex = 0;
    }
    else {
      _pageIndex++;
    }

    var list = await Network.getCollectionArticleList(_pageIndex);
    collectionList.addAll(list);

    notifyListeners();
  }
}