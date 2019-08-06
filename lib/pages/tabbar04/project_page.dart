import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_wanandroid/model/project_article.dart';
import 'package:flutter_wanandroid/model/project_tree.dart';
import 'package:flutter_wanandroid/pages/common/common_appbar.dart';
import 'package:flutter_wanandroid/pages/common/drawer_menu.dart';
import 'package:flutter_wanandroid/pages/common/web_detail.dart';
import 'package:flutter_wanandroid/provide/projects_provide.dart';
import 'package:flutter_wanandroid/tools/tools.dart';
import 'package:provide/provide.dart';

class ProjectsPage extends StatefulWidget {
  ProjectsPage({Key key}) : super(key: key);

  _ProjectsPageState createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> with AutomaticKeepAliveClientMixin {

  GlobalKey<EasyRefreshState> _easyRefreshKey =  GlobalKey<EasyRefreshState>();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    //页面加载完毕请求数据
    WidgetsBinding.instance.addPostFrameCallback((_){ 
      _loadProjectNodeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBuilder.commonAppBar('项目'),
      drawer: Drawer(
        child: MenuBuilder.menuDrawer()
      ),
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
      child: _topNavigationListView(),
    );
  }

  Widget _topNavigationListView() {
    return Provide<ProjectProvide>(builder: (context, child, value) {
      List<ProjectNode> projectNodeList = Provide.value<ProjectProvide>(context).projectNodeList;
      int selectIndex = Provide.value<ProjectProvide>(context).projectNodeIndex;
      return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: projectNodeList.length,
        itemBuilder: (context, index) {
          return _topNavigationCell(projectNodeList, index, selectIndex);
        },
      );
    });
  }

  Widget _topNavigationCell(List<ProjectNode> projectNodeList, int index, int selectIndex) {
    bool isSelect = (index == selectIndex) ? true : false;
    bool isLast = (index == (projectNodeList.length - 1)) ? true : false;
    ProjectNode node = projectNodeList[index];

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
        Provide.value<ProjectProvide>(context).selectProjectNodeWith(index);
      },
      child: Row(
        children: cellItems,
      ),
    );
  }

  Widget _pageContent() {
    return Provide<ProjectProvide>(builder: (context, child, value) {
      List<ProjectNode> projectNodeList = Provide.value<ProjectProvide>(context).projectNodeList;
      if (projectNodeList.isEmpty) {
        return Expanded(child: Container(child: Center(child: Text('加载中...'),),),);
      }

      List<ProjectArticle> articleList = Provide.value<ProjectProvide>(context).articleList;
      return Expanded(
      child: Container(
        //decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.red)), //use for debug frame
        decoration: BoxDecoration(color: Colors.grey[200],),
        padding: EdgeInsets.only(left: 10, right: 10),
        child: EasyRefresh(
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
        ),
      ),
    );
    });
  }

  Widget _articleCell(ProjectArticle article) {
    return Card(
      child: InkWell(
        onTap: (){
          //页面跳转：WebDetailPage 
            Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) {
                return WebDetailPage(model: article);
              })
            );
        },
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
      )
    );
  }


  Future _loadProjectNodeData() async {
    await Provide.value<ProjectProvide>(context).getProjectNodeData();
  }

  Future _refreshData() async {
    await Provide.value<ProjectProvide>(context).getArticleData(true);
  }

  Future _loadMoreData() async {
    await Provide.value<ProjectProvide>(context).getArticleData(false);
  }
}