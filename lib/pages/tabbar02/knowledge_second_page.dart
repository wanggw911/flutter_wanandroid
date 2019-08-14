
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_wanandroid/model/home_article.dart';
import 'package:flutter_wanandroid/model/knowledge_tree.dart';
import 'package:flutter_wanandroid/pages/common/common_list_cell.dart';
import 'package:flutter_wanandroid/provide/knowledge_provide.dart';
import 'package:provide/provide.dart';

class KnowledgeSecondPage extends StatefulWidget {
  final KnowledgeTreeNode node;
  
  KnowledgeSecondPage({Key key, this.node}) : super(key: key);

  _KnowledgeSecondPageState createState() => _KnowledgeSecondPageState();
}

class _KnowledgeSecondPageState extends State<KnowledgeSecondPage> with SingleTickerProviderStateMixin {
  String _title;
  List<Tab> _tabs;
  List<KnowledgeTabbarPage> _pages;
  TabController _controller;

  @override
  void initState() {
    super.initState();

    KnowledgeTreeNode node = widget.node;
    _title = node.name;
    _controller = TabController(length: node.children.length, vsync: this);

    _tabs = List.generate(node.children.length, (index){ 
      KnowledgeTreeNode subNode = node.children[index];
      return Tab(text: subNode.name);
    });

    _pages = List.generate(node.children.length, (index){ 
      KnowledgeTreeNode subNode = node.children[index];
      return KnowledgeTabbarPage(subNode: subNode);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         title: Text('$_title'),
         bottom: TabBar(
           controller: _controller,
           tabs: _tabs,
           isScrollable: true,
         ),
       ),
       body: TabBarView(
         controller: _controller,
         children: _pages,
       ),
    );
  }
}

class KnowledgeTabbarPage extends StatefulWidget {
  final KnowledgeTreeNode subNode;
  KnowledgeTabbarPage({Key key, this.subNode}) : super(key: key);

  _KnowledgeTabbarPageState createState() => _KnowledgeTabbarPageState();
}

class _KnowledgeTabbarPageState extends State<KnowledgeTabbarPage> {
  GlobalKey<EasyRefreshState> _easyRefreshKey =  GlobalKey<EasyRefreshState>();
  int _cid;

  @override
  void initState() {
    super.initState();

    _cid = widget.subNode.id;
    
    //页面加载完毕请求数据
    WidgetsBinding.instance.addPostFrameCallback((_){ 
      _refreshData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _contentListView(),
    );
  }

  Widget _contentListView() {
    return Provide<KnowledgeProvide>(builder: (context, child, value) {
      Map<int, KnowledgeArticles> nodeArticleMap = Provide.value<KnowledgeProvide>(context).nodeArticleMap;
      List<Article> articleList = nodeArticleMap[_cid].articleList;
      return EasyRefresh(
          key: _easyRefreshKey,
          behavior: ScrollOverBehavior(),
          child: ListView.builder(
            itemCount: articleList.length,
            itemBuilder: (context, index) {
              return _articleCell(articleList[index]);
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
    await Provide.value<KnowledgeProvide>(context).getNodeArticleData(_cid, true);
  }

  Future _loadMoreData() async {
    await Provide.value<KnowledgeProvide>(context).getNodeArticleData(_cid, false);
  }
}