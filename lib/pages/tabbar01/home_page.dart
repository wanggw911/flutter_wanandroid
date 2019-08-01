import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_wanandroid/model/home_article.dart';
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
  GlobalKey<EasyRefreshState> _easyRefreshKey =  GlobalKey<EasyRefreshState>();

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
      child: EasyRefresh(
        key: _easyRefreshKey,
        behavior: ScrollOverBehavior(),
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
        onRefresh: () async {
          await _refreshData();
        },
        loadMore: () async {
          await _loadMoreData();
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
      child: InkWell(
        child: Card(
          child: Column(
            children: <Widget>[
              // Cell顶部栏
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(5.0),
                          child: Icon(Icons.account_circle, size: 30, color: Colors.blue),
                        ),
                        Text('${article.author}'),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Text(
                      '${article.superChapterName}/${article.chapterName}',
                      style: TextStyle(color: Colors.blue),
                    ),
                  )
                ],
              ),
              // Cell标题栏
              Container(
                padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                width: setWidth(710), // 750 - 20 - 20
                child: Text(
                  '${article.title}', 
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: setFontSize(34)),
                ),
              ),
              // Cell底部栏 
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(5.0),
                    child: Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(5.0),
                          child: Icon(Icons.favorite, size: 25, color: Colors.grey[400]),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 5.0),
                          child: Icon(Icons.watch_later, size: 25, color: Colors.grey[400]),
                        ),
                        Text('${article.niceDate}'),
                      ],
                    ),
                  ),
                  _cellTags(article),
                ],
              ),
            ],
          ),
      ),
      ),
    );
  }

  Widget _cellTags(Article article) {
    List<Widget> tagWidgets = [];
    if (article.projectLink.length > 0) {
      //添加项目标签Widget
      tagWidgets.add(Container(
                      padding: EdgeInsets.only(left: 2.0, right: 2.0),
                      child: Text('项目', style: TextStyle(color: Colors.red)),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1.0, color: Colors.red)
                      ),
                    ));
    }
    if (article.fresh) {  
      //添加新旧Widget
      tagWidgets.add(Container(
                      padding: EdgeInsets.only(left: 2.0, right: 2.0),
                      child: Text('新', style: TextStyle(color: Colors.green)),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1.0, color: Colors.green)
                      ),
                    ),);
    }

    return Container(
      padding: EdgeInsets.only(right: 10.0),
      child: Row(
        children: tagWidgets,
      )
    );
  }

  Future _refreshData() async {
    await _loadBannerData();

    _articlePage = 0;
    await _loadArticleData();
  }

  Future _loadMoreData() async {
    _articlePage += 1;
    await _loadArticleData();
  }

  Future _loadBannerData() async {
    var list = await Network.getBannerList();
    setState(() {
      _bannerList.addAll(list);
    });
  }

  Future _loadArticleData() async {
    var list = await Network.getHomeArticleList(_articlePage);
    setState(() {
      _articleList.addAll(list);
    });
  }
}