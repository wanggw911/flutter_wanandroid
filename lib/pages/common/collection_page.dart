
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_wanandroid/model/home_article.dart';
import 'package:flutter_wanandroid/pages/common/common_list_cell.dart';
import 'package:flutter_wanandroid/provide/user_provide.dart';
import 'package:provide/provide.dart';

class CollectionPage extends StatefulWidget {
  CollectionPage({Key key}) : super(key: key);

  _CollectionPageState createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {

  GlobalKey<EasyRefreshState> _easyRefreshKey =  GlobalKey<EasyRefreshState>();

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
    return Scaffold(
       appBar: AppBar(title: Text('我的收藏'),),
       body: _contentListView(),
    );
  }

  Widget _contentListView() {
    return Provide<UserProvide>(builder: (context, child, value) {
      List<Article> collectionList = Provide.value<UserProvide>(context).collectionList;
      return EasyRefresh(
          key: _easyRefreshKey,
          behavior: ScrollOverBehavior(),
          child: ListView.builder(
            itemCount: collectionList.length,
            itemBuilder: (context, index) {
              return _articleCell(collectionList[index]);
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

  Widget _articleCell(Article article) {
    return CommonListCell.articleCell(context, article);
  }

  Future _refreshData() async {
    await Provide.value<UserProvide>(context).getCollectionArticleData(true);
  }

  Future _loadMoreData() async {
    await Provide.value<UserProvide>(context).getCollectionArticleData(false);
  }
}