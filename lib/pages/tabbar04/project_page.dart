import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_wanandroid/model/project_article.dart';
import 'package:flutter_wanandroid/model/project_tree.dart';
import 'package:flutter_wanandroid/network/network.dart';
import 'package:flutter_wanandroid/tools/tools.dart';

class ProjectsPage extends StatefulWidget {
  ProjectsPage({Key key}) : super(key: key);

  _ProjectsPageState createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> with AutomaticKeepAliveClientMixin {
  List<ProjectNode> _projectNodes = [];
  int _selectIndex = 0;

  List<Widget> _pages = [];
  PageController _pageController;

  int _articlePage = 1; 
  List<ProjectArticle> _articleList = [];
  GlobalKey<EasyRefreshState> _easyRefreshKey =  GlobalKey<EasyRefreshState>();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: _selectIndex, keepPage: true);
    _loadProjectNodeData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(title: Text('项目')),
      body: Container(
        child: Column(
          children: <Widget>[
            _topNavigation(),
            _pageContent(),
          ],
        ),
      ), 
    );
  }

  Widget _topNavigation() {
    return Container(
      width: setWidth(750),
      height: setHeight(90),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey[300])),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _projectNodes.length,
        itemBuilder: (context, index) {
          return _topNavigationCell(index);
        },
      ),
    );
  }

  Widget _topNavigationCell(int index) {
    bool isSelect = (index == _selectIndex) ? true : false;
    bool isLast = (index == (_projectNodes.length - 1)) ? true : false;
    ProjectNode node = _projectNodes[index];

    List<Widget> cellItems = [];
    cellItems.add(Container(
            //decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.red)), //use for debug frame
            padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5, bottom: 5),
            child: Container(
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
              decoration: BoxDecoration(
                color: isSelect?Colors.orangeAccent:Colors.white,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Text(
                '${node.name}',
                style: TextStyle(
                  color: isSelect?Colors.white:Colors.black,
                  fontSize: setFontSize(30)
                ),
              ),
            ),
          ));
    if (!isLast) {
      cellItems.add(Container(
            width: setWidth(1.0),
            height: setHeight(60),
            decoration: BoxDecoration(
              color: Colors.orange
            ),
            //child: ,
          ));
    }

    return InkWell(
      onTap: () {
        setState(() {
          _selectIndex = index;
          _articleList.clear();
        });
        ProjectNode node = _projectNodes[index];
        _loadArticleData(node.id);
      },
      child: Row(
        children: cellItems,
      ),
    );
  }

  // Widget _listContent() {
    // if (_projectNodes.isEmpty) {
    //   return Expanded(
    //     child: Container(
    //       //decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.red)), //use for debug frame
    //       child: Center(
    //         child: Text('加载中...'),
    //       ),
    //     ),
    //   );
    // }
    // return Expanded(
    //   child: Container(
    //     decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.red)), //use for debug frame
    //     child: PageView(
    //       children: _pages,
    //       controller: _pageController,
    //       physics: NeverScrollableScrollPhysics(),//禁止左右滑动
    //     ),
    //   ),
    // );
  // }

  //这个是会服用多次，所以可能会存在一些问题
  Widget _pageContent() {
    if (_projectNodes.isEmpty) {
      return Expanded(child: Container(child: Center(child: Text('加载中...'),),),);
    }

    ProjectNode node = _projectNodes[_selectIndex];
    return Expanded(
      child: Container(
        //decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.red)), //use for debug frame
        decoration: BoxDecoration(color: Colors.grey[200],),
        padding: EdgeInsets.only(left: 10, right: 10),
        child: EasyRefresh(
          key: _easyRefreshKey,
          behavior: ScrollOverBehavior(),
            child: ListView.builder(
              itemCount: _articleList.length,
              itemBuilder: (context, index) {
                return _articleCell(_articleList[index]);
              },
            ),
            onRefresh: () async {
              await _refreshData(node.id);
            },
            loadMore: () async {
              await _loadMoreData(node.id);
            },
        ),
      ),
    );
  }

  Widget _articleCell(ProjectArticle article) {
    return Card(
      child: Container(
        //decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.red)), //use for debug frame
        height: setHeight(300),
        child: Row(
          children: <Widget>[
            Container(
              //decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.red)), //use for debug frame
              width: setWidth(200),
              padding: EdgeInsets.all(10),
              child: Image.network('${article.envelopePic}', fit: BoxFit.fill,),
            ),
            Expanded(
              child: Container(
                //decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.red)), //use for debug frame
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      //decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.red)), //use for debug frame
                      child: Row(
                        children: <Widget>[
                          Container(
                            child: Icon(Icons.android, color: Colors.blue,),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                '${article.title}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: setFontSize(30)),
                              ),
                            ),
                          )
                        ],
                      )
                    ),
                    Expanded(
                      child: Container(
                        //decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.red)), //use for debug frame
                        padding: EdgeInsets.only(top:10, bottom: 10),
                        child: Text(
                          '${article.desc}',
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Container(
                      //decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.red)), //use for debug frame
                      child: Text(
                        '${article.niceDate} ${article.author}',
                        style: TextStyle(color: Colors.grey[400]),
                      ),  
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _loadProjectNodeData() async {
    _pages.clear();
    _projectNodes.clear();
    var list = await Network.getProjectTypes();
    
    if (list.isNotEmpty) {
      ProjectNode node = list[0];
      _loadArticleData(node.id);
    }

    setState(() {
      _projectNodes.addAll(list);
    });
  }

   Future _refreshData(int cid) async {
    _articlePage = 1;
    _articleList.clear();
    await _loadArticleData(cid);
  }

  Future _loadMoreData(int cid) async {
    _articlePage += 1;
    await _loadArticleData(cid);
  }

   Future _loadArticleData(int cid) async {
    var list = await Network.getProjectArticleList(_articlePage, cid);
    //print("列表数据有：${list.length}");
    setState(() {
      _articleList.addAll(list);
    });
  }
}