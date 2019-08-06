import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_wanandroid/model/home_article.dart';
import 'package:flutter_wanandroid/model/home_banner.dart';
import 'package:flutter_wanandroid/pages/common/web_detail.dart';
import 'package:flutter_wanandroid/provide/home_provide.dart';
import 'package:flutter_wanandroid/tools/tools.dart';
import 'package:provide/provide.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {

  GlobalKey<EasyRefreshState> _easyRefreshKey =  GlobalKey<EasyRefreshState>();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    //页面加载完毕请求数据
    WidgetsBinding.instance.addPostFrameCallback((_){ 
      _refreshData();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    //【项目初始化】之：flutter_screenutil 
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    
    return Scaffold(
      appBar: AppBar(title: Text('首页')),
      body: Container(
        child: _contentListView(),
      ),
    );
  }

  Widget _contentListView() {
    return Provide<HomeProvide>(builder: (context, child, value) {
      List<HomeBanner> _bannerList = Provide.value<HomeProvide>(context).bannerList;
      List<Article> _articleList = Provide.value<HomeProvide>(context).articleList;
      return EasyRefresh(
          key: _easyRefreshKey,
          behavior: ScrollOverBehavior(),
          child: ListView.builder(
            itemCount: _articleList.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _bannerCell(_bannerList);
              }
              else {
                if (_articleList.length > 0) {
                  return _articleCell(_articleList[index-1]);
                }
                else {
                  return Container();
                }
              }
            },
          ),
          onRefresh: () async {
            await _refreshData();
          },
          loadMore: () async {
            await _loadMoreData();
          },
        );
    });
  }

  //首页广告视图
  Widget _bannerCell(List bannerList) {
    if (bannerList.length == 0) {
      return Container(
        width: setWidth(750),
        height: setHeight(350),
      );
    }
    return Container(
      width: setWidth(750),
      height: setHeight(350),
      child: Swiper(
        autoplay: true,
        pagination: SwiperPagination(),
        itemCount: bannerList.length,
        itemBuilder: (context, index) {
          HomeBanner banner = bannerList[index];
          return InkWell(
            onTap: (){
              //页面跳转：WebDetailPage 
              Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) {
                  return WebDetailPage(model: banner);
                })
              );
            },
            child: Image.network(
              banner.imagePath,
              fit: BoxFit.fill,
            ),
          );
        },
      ),
    );
  }

  Widget _articleCell(Article article) {
    return Container(
      padding: EdgeInsets.only(left: 10.0, top: 5.0, right: 10.0),
      child: InkWell(
        onTap: () {
          //页面跳转：WebDetailPage 
          Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) {
              return WebDetailPage(model: article);
            })
          );
        },
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
    await Provide.value<HomeProvide>(context).getHomePageData();
  }

  Future _loadMoreData() async {
    await Provide.value<HomeProvide>(context).getArticleData(false);
  }
}