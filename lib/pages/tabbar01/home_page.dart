import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_wanandroid/model/home_article.dart';
import 'package:flutter_wanandroid/model/home_banner.dart';
import 'package:flutter_wanandroid/pages/common/common_appbar.dart';
import 'package:flutter_wanandroid/pages/common/common_list_cell.dart';
import 'package:flutter_wanandroid/pages/common/drawer_menu.dart';
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
      appBar: AppBarBuilder.commonAppBar('首页'),
      drawer: Drawer(
        child: MenuBuilder.menuDrawer(context)
      ),
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
    return CommonListCell.articleCell(context, article);
  }

  Future _refreshData() async {
    await Provide.value<HomeProvide>(context).getHomePageData();
  }

  Future _loadMoreData() async {
    await Provide.value<HomeProvide>(context).getArticleData(false);
  }
}