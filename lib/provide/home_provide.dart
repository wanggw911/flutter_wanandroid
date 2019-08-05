
import 'package:flutter/widgets.dart';
import '../model/home_article.dart';
import '../model/home_banner.dart';
import '../network/network.dart';

class HomeProvide with ChangeNotifier {
  List<HomeBanner> bannerList = [];
  int _articlePageIndex = 0;
  List<Article> articleList = [];

  Future getHomePageData() async {
    await getBannerData();
    await getArticleData(true);
  }

  //请求获取广告数据
  Future getBannerData() async {
    bannerList.clear();
    var list = await Network.getHomeBannerList();
    bannerList.addAll(list);

    notifyListeners();
  }

  //请求获取文章数据
  Future getArticleData(bool isRefresh) async {
    if (isRefresh) {
      articleList.clear();
      _articlePageIndex = 0;
    }
    else {
      _articlePageIndex++;
    }

    //_articlePageIndex
    var list = await Network.getHomeArticleList(_articlePageIndex);
    articleList.addAll(list);

    notifyListeners();
  }
}