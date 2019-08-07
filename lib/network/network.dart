import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_wanandroid/model/home_article.dart';
import 'package:flutter_wanandroid/model/knowledge_tree.dart';
import 'package:flutter_wanandroid/model/navigation_tree.dart';
import 'package:flutter_wanandroid/model/project_article.dart';
import 'package:flutter_wanandroid/model/project_tree.dart';
import 'package:flutter_wanandroid/model/user.dart';
import 'package:flutter_wanandroid/provide/user_provide.dart';
import 'package:flutter_wanandroid/model/home_banner.dart';

class Network {
  //接口1：获取首页 banner 列表数据
  static Future<List<HomeBanner>> getHomeBannerList() async {
    var requestUrl = "https://www.wanandroid.com/banner/json";
    var client = http.Client();
    http.Response response = await client.get(requestUrl, headers: _headers());
    debugLog(response);
    if (response.statusCode == 200) {
      var jsonString = json.decode(response.body);
      HomeBannerRespond bannerData = HomeBannerRespond.fromJson(jsonString);
      return bannerData.data;
    }
    else {
      return null;
    }
  }

  //接口2：获取首页文章列表数据
  static Future<List<Article>> getHomeArticleList(int pageIndex) async {
    var requestUrl = "https://www.wanandroid.com/article/list/$pageIndex/json";
    var client = http.Client();
    http.Response response = await client.get(requestUrl);
    debugLog(response);
    if (response.statusCode == 200) {
      var jsonString = json.decode(response.body);
      ArticleRespond articleData = ArticleRespond.fromJson(jsonString);
      return articleData.data.datas;
    }
    else {
      return null;
    }
  }

  //接口3：获取知识体系的所有节点数据 
  static Future<List<KnowledgeTreeNode>> getKnowledgeAllNodes() async {
    var requestUrl = "https://www.wanandroid.com/tree/json";
    var client = http.Client();
    http.Response response = await client.get(requestUrl);
    debugLog(response);
    if (response.statusCode == 200) {
      var jsonString = json.decode(response.body);
      KnowledgeTreeNodeRespond articleData = KnowledgeTreeNodeRespond.fromJson(jsonString);
      return articleData.data;
    }
    else {
      return null;
    }
  }

  //接口3.1：获取首页文章列表数据
  static Future<List<Article>> getKnowledgeArticleList(int pageIndex, int cid) async {
    var requestUrl = "https://www.wanandroid.com/article/list/$pageIndex/json?cid=$cid";
    var client = http.Client();
    http.Response response = await client.get(requestUrl);
    debugLog(response);
    if (response.statusCode == 200) {
      var jsonString = json.decode(response.body);
      ArticleRespond articleData = ArticleRespond.fromJson(jsonString);
      return articleData.data.datas;
    }
    else {
      return null;
    }
  }

  //接口4：获取导航模块的节点数据
  static Future<List<NavigationSuperNode>> getNavigationAllNodes() async {
    var requestUrl = "https://www.wanandroid.com/navi/json";
    var client = http.Client();
    http.Response response = await client.get(requestUrl);
    debugLog(response);
    if (response.statusCode == 200) {
      var jsonString = json.decode(response.body);
      NavigationTreeNodeRespond respondData = NavigationTreeNodeRespond.fromJson(jsonString);
      return respondData.data;
    }
    else {
      return null;
    }
  }
 
  //接口5：获取项目分类的列表
  static Future<List<ProjectNode>> getProjectTypes() async {
    var requestUrl = "https://www.wanandroid.com/project/tree/json";
    var client = http.Client();
    http.Response response = await client.get(requestUrl);
    debugLog(response);
    if (response.statusCode == 200) {
      var jsonString = json.decode(response.body);
      ProjectTreeNodeRespond respondData = ProjectTreeNodeRespond.fromJson(jsonString);
      return respondData.data;
    }
    else {
      return null;
    }
  }

  //接口6：获取项目分类的文章列表  
  static Future<List<ProjectArticle>> getProjectArticleList(int index, int nodeid) async {
    //页码：拼接在链接中，从1开始。cid 分类的id，上面项目分类接口
    var requestUrl = "https://www.wanandroid.com/project/list/$index/json?cid=$nodeid";
    var client = http.Client();
    http.Response response = await client.get(requestUrl);
    debugLog(response);
    if (response.statusCode == 200) {
      var jsonString = json.decode(response.body);
      ProjectArticleRespond respondData = ProjectArticleRespond.fromJson(jsonString);
      return respondData.data.datas;
    }
    else {
      return null;
    }
  }

  //接口7：登录 
  static Future<User> loginAction(String username, String password) async {
    var requestUrl = "https://www.wanandroid.com/user/login";
    var params = Map<String, String>();
    params["username"] = username;
    params["password"] = password;

    var client = http.Client();
    http.Response response = await client.post(requestUrl, body: params);
    debugLog(response);
    if (response.statusCode == 200) {
      var jsonString = json.decode(response.body);
      UserLoginRespond respondData = UserLoginRespond.fromJson(jsonString);
      return respondData.data;
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
    
    var client = http.Client();
    http.Response response = await client.post(requestUrl, body: params);
    debugLog(response);
    if (response.statusCode == 200) {
      var jsonString = json.decode(response.body);
      UserLoginRespond respondData = UserLoginRespond.fromJson(jsonString);
      return respondData.data;
    }
    else {
      return null;
    }
  }

  //接口9：退出登录
  static Future<bool> loginOutAction() async {
    var requestUrl = "https://www.wanandroid.com/user/logout/json";
    var client = http.Client();
    http.Response response = await client.get(requestUrl);
    debugLog(response);
    if (response.statusCode == 200) {
      return true;
    }
    else {
      return false;
    }
  }

  //请求header
  static Map<String, String> _headers() {
    Map<String, String> header = Map<String, String>();
    var user = UserProvide.currentUser;
    if (user != null) {
      var cookie = "loginUserName=${user.username}, loginUserPassword=${user.password}";
      header["Cookie"] = cookie;
    }
    print('header = $header');
    return header;
  }

  //debug print
  static debugLog(http.Response response) {
    var url = response.request.url;
    if (response.statusCode == 200) {
      print("✅请求成功，url=$url");
    }
    else {
      print("❌请求失败，url=$url");
    }
  }
}