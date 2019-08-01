import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_wanandroid/model/knowledge_tree.dart';
import 'package:flutter_wanandroid/network/network.dart';
import 'package:flutter_wanandroid/tools/tools.dart';

class KnowledgePage extends StatefulWidget {
  KnowledgePage({Key key}) : super(key: key);

  _KnowledgePageState createState() => _KnowledgePageState();
}

class _KnowledgePageState extends State<KnowledgePage> with AutomaticKeepAliveClientMixin {
  List<KnowledgeTreeNode> _nodeList = [];
  GlobalKey<EasyRefreshState> _easyRefreshKey =  GlobalKey<EasyRefreshState>();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _loadNodeData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(title: Text('知识体系')),
      body: Container(
        child: EasyRefresh(
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
        )
      ), 
    );
  }

  Widget _nodeCell(KnowledgeTreeNode node) {
    return Container(
      padding: EdgeInsets.only(top: 5.0, left: 10.0, bottom: 5.0, right: 10.0),
      child: InkWell(
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

  Future _refreshData() async {
    await _loadNodeData();
  }

  Future _loadNodeData() async {
    _nodeList.clear();
    var list = await Network.getKnowledgeAllNodes();
    setState(() {
      _nodeList.addAll(list);
    });
  }
}