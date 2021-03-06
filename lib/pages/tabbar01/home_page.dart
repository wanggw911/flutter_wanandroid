import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_wanandroid/model/home_article.dart';
import 'package:flutter_wanandroid/model/home_banner.dart';
import 'package:flutter_wanandroid/pages/common/common_appbar.dart';
import 'package:flutter_wanandroid/pages/common/common_list_cell.dart';
import 'package:flutter_wanandroid/pages/common/drawer_menu.dart';
import 'package:flutter_wanandroid/provide/home_provide.dart';
import 'package:flutter_wanandroid/routers/routers.dart';
import 'package:flutter_wanandroid/routers/routers_tool.dart';
import 'package:flutter_wanandroid/tools/uikit_help.dart';
import 'package:provide/provide.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {

  GlobalKey<EasyRefreshState> _easyRefreshKey =  GlobalKey<EasyRefreshState>();

  //bool _showLoading = false; //上下拉刷和Loading配合使用的例子

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    //页面加载完毕请求数据
    WidgetsBinding.instance.addPostFrameCallback((_){ 
      _getLocationData();
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
          headerStatusChanged: (state) {
            if (state == HeaderStatus.START) {
              _needShowLoading(true);
            }
            if (state == HeaderStatus.END) {
               _needShowLoading(false);
            }
          },
          footerStatusChanged: (state) {
            if (state == FooterStatus.START) {
              _needShowLoading(true);
            }
            if (state == FooterStatus.END) {
               _needShowLoading(false);
            }
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
              String modelType = 'HomeBanner';
              String json = RouterTools.object2string(banner);
              Application.push(context, Routers.webDetailsPage+'?json=$json&model_type=$modelType');
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

  Future _getLocationData() async {
    //初始加载数据库数据，如果没有加载到则进行网络请求
    await Provide.value<HomeProvide>(context).getLocationBannerData();
    await Provide.value<HomeProvide>(context).getLocationArticleData();
  }

  Future _refreshData() async {
    await Provide.value<HomeProvide>(context).requestBannerData();
    await Provide.value<HomeProvide>(context).requestArticleData(true);
  }

  Future _loadMoreData() async {
    await Provide.value<HomeProvide>(context).requestArticleData(false);
  }

  void _needShowLoading(bool needShow) {
    setState(() {
      //_showLoading = needShow;
    });
  }
}