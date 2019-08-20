import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_wanandroid/model/knowledge_tree.dart';
import 'package:flutter_wanandroid/pages/common/common_appbar.dart';
import 'package:flutter_wanandroid/pages/common/drawer_menu.dart';
import 'package:flutter_wanandroid/provide/knowledge_provide.dart';
import 'package:flutter_wanandroid/routers/routers.dart';
import 'package:flutter_wanandroid/routers/routers_tool.dart';
import 'package:flutter_wanandroid/tools/uikit_help.dart';
import 'package:provide/provide.dart';

class KnowledgePage extends StatefulWidget {
  KnowledgePage({Key key}) : super(key: key);

  _KnowledgePageState createState() => _KnowledgePageState();
}

class _KnowledgePageState extends State<KnowledgePage> with AutomaticKeepAliveClientMixin {

  GlobalKey<EasyRefreshState> _easyRefreshKey =  GlobalKey<EasyRefreshState>();

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
    return Scaffold(
      appBar: AppBarBuilder.commonAppBar('知识体系'),
      drawer: Drawer(
        child: MenuBuilder.menuDrawer(context)
      ),
      body: Container(
        child: _contentListView(),
      ), 
    );
  }

  Widget _contentListView() {
    return Provide<KnowledgeProvide>(builder: (context, child, value) {
      List<KnowledgeTreeNode> _nodeList = Provide.value<KnowledgeProvide>(context).nodeList;
      return EasyRefresh(
          key: _easyRefreshKey,
          behavior: ScrollOverBehavior(),
          child: ListView.builder(
            itemCount: _nodeList.length,
            itemBuilder: (context, index) {
              return _nodeCell(_nodeList[index]);
            },
          ),
          onRefresh: () async {
            await _refreshData();
          },
        );
    });
  }

  Widget _nodeCell(KnowledgeTreeNode node) {
    return Container(
      padding: EdgeInsets.only(top: 5.0, left: 10.0, bottom: 0, right: 10.0),
      child: InkWell(
        onTap: (){
          String json = RouterTools.object2string(node);
          Application.push(context, Routers.knowledgeSecondPage+'?nodeJson=$json');
        },
        child: Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              //cell文字信息
              Container(
                width: setWidth(610), //750 - 80 - 40 - 20
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "${node.name}",
                        style: TextStyle(fontSize: setFontSize(32)),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 5.0, left: 10.0, bottom: 10.0, right: 10.0),
                      child: Text("${node.subNodeNames}"),
                    )
                  ],
                ),
              ),
              //cell箭头
              Container(
                width: setWidth(80),
                child: Icon(CupertinoIcons.right_chevron),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _getLocationData() async {
    await Provide.value<KnowledgeProvide>(context).getLocationNodeData();
  }

  Future _refreshData() async {
    await Provide.value<KnowledgeProvide>(context).requestNodeData();
  }
}