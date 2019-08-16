
import 'package:flutter/widgets.dart';
import 'package:flutter_wanandroid/database/home_article_db.dart';
import 'package:flutter_wanandroid/database/home_banner_db.dart';
import '../model/home_article.dart';
import '../model/home_banner.dart';
import '../network/network.dart';

class HomeProvide with ChangeNotifier {
  List<HomeBanner> bannerList = [];
  int _articlePageIndex = 0;
  List<Article> articleList = [];

  Future getHomePageData() async {
    //初始获取首页广告数据
    bannerList = await getLocationBannerData();
    if (bannerList.isNotEmpty){
      notifyListeners();
    }
    else {
      await requestBannerData();
    }

    //初始获取首页文章数据
    articleList = await getLocationArticleData();
    if (articleList.isNotEmpty){
      notifyListeners();
    }
    else {
      await requestArticleData(true);
    }
  }

  Future<List<HomeBanner>> getLocationBannerData() async {
    return await HomeBannerDB.selectAll();
  }

  Future<List<Article>> getLocationArticleData() async {
    return await HomeArticleDB.selectWith(ArticleType.Home);
  }

  //请求获取广告数据
  Future requestBannerData() async {
    bannerList.clear();
    var list = await Network.getHomeBannerList();
    bannerList.addAll(list);

    notifyListeners();

    HomeBannerDB.insertWith(list);
  }

  //请求获取文章数据
  Future requestArticleData(bool isRefresh) async {
    if (isRefresh) {
      articleList.clear();
      _articlePageIndex = 0;
    }
    else {
      _articlePageIndex++;
    }

    var list = await Network.getHomeArticleList(_articlePageIndex);
    articleList.addAll(list);

    notifyListeners();

    HomeArticleDB.insertWith(list, ArticleType.Home);
  }
}