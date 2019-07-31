import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:flutter_wanandroid/model/article.dart';
import 'package:flutter_wanandroid/model/home_banner.dart';

class Network {
  static Future<List<HomeBanner>> getBannerList() async {
    var requestUrl = "https://www.wanandroid.com/banner/json";
    var client = http.Client();
    http.Response response = await client.get(requestUrl);
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