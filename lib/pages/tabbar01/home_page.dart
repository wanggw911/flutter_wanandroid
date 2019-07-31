import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_wanandroid/model/article.dart';
import 'package:flutter_wanandroid/model/home_banner.dart';
import 'package:flutter_wanandroid/network/network.dart';
import 'package:flutter_wanandroid/tools/tools.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<HomeBanner> _bannerList = [];
  int _articlePage = 0;
  List<Article> _articleList = [];

  @override
  void initState() {
    super.initState();

    //TODO: 目前网络请求写在了视图里面，不大好，应该写在 Provide 中
    _loadBannerData();
    _loadArticleData();
  }

  @override
  Widget build(BuildContext context) {
    //初始化：flutter_screenutil 
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    return Container(
       child: ListView.builder(
         itemCount: _articleList.length + 1,
         itemBuilder: (context, index) {
           if (index == 0) {
             return _bannerCell(_bannerList);
           }
           else {
             return _articleCell(_articleList[index-1]);
           }
         },
       ),
    );
  }

  //首页广告视图
  Widget _bannerCell(List bannerList) {
    return Container(
      width: setWidth(750),
      height: setHeight(350),
      child: Swiper(
        autoplay: true,
        pagination: SwiperPagination(),
        itemCount: bannerList.length,
        itemBuilder: (context, index) {
          HomeBanner banner = bannerList[index];
          return Image.network(
            banner.imagePath,
            fit: BoxFit.fill,
          );
        },
      ),
    );
  }

  Widget _articleCell(Article article) {
    return Container(
      padding: EdgeInsets.only(left: 10.0, top: 5.0, right: 10.0),
      child: Card(
        child: Column(
          children: <Widget>[
            Text('${article.title}'),
            Text('${article.desc}')
          ],
        ),
      ),
    );
  }

  void _loadBannerData() async {
    var list = await Network.getBannerList();
    setState(() {
      _bannerList.addAll(list);
    });
  }

  void _loadArticleData() async {
    var list = await Network.getHomeArticleList(_articlePage);
    setState(() {
      _articleList.addAll(list);
    });
  }
}