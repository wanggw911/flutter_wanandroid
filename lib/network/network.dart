import 'dart:convert';

import 'package:flutter_wanandroid/network/engine.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_wanandroid/model/home_article.dart';
import 'package:flutter_wanandroid/model/knowledge_tree.dart';
import 'package:flutter_wanandroid/model/navigation_tree.dart';
import 'package:flutter_wanandroid/model/project_article.dart';
import 'package:flutter_wanandroid/model/project_tree.dart';
import 'package:flutter_wanandroid/model/user.dart';
import 'package:flutter_wanandroid/provide/user_provide.dart';
import 'package:flutter_wanandroid/model/home_banner.dart';


//[玩Android接口地址](https://www.wanandroid.com/blog/show/2)
class Network {
  //接口1：获取首页 banner 列表数据
  static Future<List<HomeBanner>> getHomeBannerList() async {
    var requestUrl = "https://www.wanandroid.com/banner/json";
    EngineCallBack callBack = await Engine.get(requestUrl);
    var data = callBack.data;
    if (data != null && data is List) {
      List<HomeBanner> list = List<HomeBanner>();
      data.forEach((item) {
        HomeBanner banner = HomeBanner.fromJson(item);
        list.add(banner);
      });
      return list;
    }
    else {
      return [];
    }
  }

  //接口2：获取首页文章列表数据
  static Future<List<Article>> getHomeArticleList(int pageIndex) async {
    var requestUrl = "https://www.wanandroid.com/article/list/$pageIndex/json";
    EngineCallBack callBack = await Engine.get(requestUrl);
    var data = callBack.data;
    if (data != null) {
      ArticleData articleData = ArticleData.fromJson(data);
      return articleData.datas;
    }
    else {
      return [];
    }
  }

  //接口3：获取知识体系的所有节点数据 
  static Future<List<KnowledgeTreeNode>> getKnowledgeAllNodes() async {
    var requestUrl = "https://www.wanandroid.com/tree/json";
    EngineCallBack callBack = await Engine.get(requestUrl);
    var data = callBack.data;
    if (data != null && data is List) {
      List<KnowledgeTreeNode> list = List<KnowledgeTreeNode>();
      data.forEach((item) {
        KnowledgeTreeNode banner = KnowledgeTreeNode.fromJson(item);
        list.add(banner);
      });
      return list;
    }
    else {
      return [];
    }
  }

  //接口3.1：获取知识体系文章列表数据
  static Future<List<Article>> getKnowledgeArticleList(int pageIndex, int cid) async {
    var requestUrl = "https://www.wanandroid.com/article/list/$pageIndex/json?cid=$cid";
    EngineCallBack callBack = await Engine.get(requestUrl);
    var data = callBack.data;
    if (data != null) {
      ArticleData articleData = ArticleData.fromJson(data);
      return articleData.datas;
    }
    else {
      return [];
    }
  }

  //接口4：获取导航模块的节点数据
  static Future<List<NavigationSuperNode>> getNavigationAllNodes() async {
    var requestUrl = "https://www.wanandroid.com/navi/json";
    EngineCallBack callBack = await Engine.get(requestUrl);
    var data = callBack.data;
    if (data != null && data is List) {
      List<NavigationSuperNode> list = List<NavigationSuperNode>();
      data.forEach((item) {
        NavigationSuperNode banner = NavigationSuperNode.fromJson(item);
        list.add(banner);
      });
      return list;
    }
    else {
      return [];
    }
  }
 
  //接口5：获取项目分类的列表
  static Future<List<ProjectNode>> getProjectTypes() async {
    var requestUrl = "https://www.wanandroid.com/project/tree/json";
    EngineCallBack callBack = await Engine.get(requestUrl);
    var data = callBack.data;
    if (data != null && data is List) {
      List<ProjectNode> list = List<ProjectNode>();
      data.forEach((item) {
        ProjectNode banner = ProjectNode.fromJson(item);
        list.add(banner);
      });
      return list;
    }
    else {
      return [];
    }
  }

  //接口6：获取项目分类的文章列表，页码：拼接在链接中，从1开始。cid 分类的id，上面项目分类接口
  static Future<List<ProjectArticle>> getProjectArticleList(int index, int nodeid) async {
    var requestUrl = "https://www.wanandroid.com/project/list/$index/json?cid=$nodeid";
    EngineCallBack callBack = await Engine.get(requestUrl);
    var data = callBack.data;
    if (data != null) {
      ProjectArticleData articleData = ProjectArticleData.fromJson(data);
      return articleData.datas;
    }
    else {
      return [];
    }
  }

  //接口7：登录 
  static Future<User> loginAction(String username, String password) async {
    var requestUrl = "https://www.wanandroid.com/user/login";
    var params = Map<String, String>();
    params["username"] = username;
    params["password"] = password;

    EngineCallBack callBack = await Engine.post(requestUrl, params: params);
    var data = callBack.data;
    if (data != null) {
      User user = User.fromJson(data);
      return user;
    }
    else {
      return null;
    }
  }

  //接口8：注册 
  static Future<User> registerAction(String username, String password) async {
    var requestUrl = "https://www.wanandroid.com/user/register";
    var params = Map<String, String>();
    params["username"] = username;
    params["password"] = password;
    params["repassword"] = password;
    
    EngineCallBack callBack = await Engine.post(requestUrl, params: params);
    var data = callBack.data;
    if (data != null) {
      User user = User.fromJson(data);
      return user;
    }
    else {
      return null;
    }
  }

  //接口9：退出登录
  static Future<bool> loginOutAction() async {
    var requestUrl = "https://www.wanandroid.com/user/logout/json";
    EngineCallBack callBack = await Engine.get(requestUrl);
    if (callBack.errorInfo == null) {
      return true;
    }
    else {
      return false;
    }
  }

  //接口10：收藏列表接口
  static Future<List<Article>> getCollectionArticleList(int pageIndex) async {
    var requestUrl = "https://www.wanandroid.com/lg/collect/list/$pageIndex/json";
    EngineCallBack callBack = await Engine.get(requestUrl, headers: _headers());
    var data = callBack.data;
    if (data != null) {
      ArticleData articleData = ArticleData.fromJson(data);
      return articleData.datas;
    }
    else {
      return [];
    }
  }

  //接口11：收藏接口
  static Future<bool> collectionArticle(int id) async {
    var requestUrl = "https://www.wanandroid.com/lg/collect/$id/json";
    EngineCallBack callBack = await Engine.post(requestUrl, headers: _headers());
    if (callBack.errorInfo == null) {
      return true;
    }
    else {
      return false;
    }
  }

  //接口12：取消收藏接口
  static Future<bool> cancelCollectionArticle(int id) async {
    var requestUrl = "https://www.wanandroid.com/lg/uncollect_originId/$id/json";
    EngineCallBack callBack = await Engine.post(requestUrl, headers: _headers());
    if (callBack.errorInfo == null) {
      return true;
    }
    else {
      return false;
    }
  }

  //请求header
  static Map<String, String> _headers() {
    Map<String, String> header = Map<String, String>();
    if (UserProvide.cookie.isNotEmpty) {
      header["Cookie"] = UserProvide.cookie;
    }
    print('header = $header');
    return header;
  }
}