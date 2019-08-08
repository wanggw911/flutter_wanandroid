
import 'package:flutter/foundation.dart';
import 'package:flutter_wanandroid/model/home_article.dart';
import 'package:flutter_wanandroid/model/user.dart';
import 'package:flutter_wanandroid/network/network.dart';
import 'package:flutter_wanandroid/tools/save_to_location.dart';

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

    _saveAccountToLocation(username, password);
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

    _saveAccountToLocation(username, password);
  }

  //获取收藏的文章数据
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

  Future collectionArticle(int id) async {
    bool isSuccess = await Network.collectionArticle(id);
    if (isSuccess) {
      // TODO: 怎么去刷新数据是一个问题
      if (!UserProvide.currentUser.collectIds.contains(id)) {
        UserProvide.currentUser.collectIds.add(id);
      }
    }

    notifyListeners();
  }

  Future cancelCollectionArticle(int id) async {
    bool isSuccess = await Network.cancelCollectionArticle(id);
    if (isSuccess) {
      // TODO: 怎么去刷新数据是一个问题
      if (UserProvide.currentUser.collectIds.contains(id)) {
        UserProvide.currentUser.collectIds.remove(id);
      }
    }

    notifyListeners();
  }

  void _saveAccountToLocation(String username, String password) {
    DataHander.saveStringWith("username", username);
    DataHander.saveStringWith("password", password);
  }
}