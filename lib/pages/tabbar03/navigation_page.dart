import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/model/navigation_tree.dart';
import 'package:flutter_wanandroid/network/network.dart';
import 'package:flutter_wanandroid/tools/tools.dart';

class NavigationPage extends StatefulWidget {
  NavigationPage({Key key}) : super(key: key);

  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> with AutomaticKeepAliveClientMixin {

  List<NavigationSuperNode> _leftList = [];
  List<NavigationSubNode> _rightList = [];

  int _currentLeftIndex = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('导航')),
      body: Container(
        child: Row(
          children: <Widget>[
            _leftListView(),
            _rightListView(),
          ],
        ),
      ), 
    );
  }

  Widget _leftListView() {
    return Container(
      width: setWidth(240),
      child: ListView.builder(
        itemCount: _leftList.length,
        itemBuilder: (context, index) {
          return _leftCell(index);
        },
      ),
    );
  }

  Widget _leftCell(int index) {
    bool isSelect = index == _currentLeftIndex;
    NavigationSuperNode superNode = _leftList[index];
    return InkWell(
      onTap: () {
        setState(() {
          _currentLeftIndex = index;
          _rightList.clear();
          _rightList.addAll(superNode.articles);
        });
      },
      child: Container(
        height: setHeight(100),
        decoration: BoxDecoration(
          color: isSelect?Colors.white:Colors.grey[200],
        ),
        child: Center(
          child: Text(
            '${superNode.name}',
            style: TextStyle(
              color: isSelect?Colors.green:Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _rightListView() {
    NavigationSuperNode superNode = _leftList[_currentLeftIndex];
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, //控制Column子元素排列的方式
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10.0),
            //decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.red)), //use for debug frame
            height: setHeight(100),
            child: Text('${superNode.name}', style: TextStyle(fontSize: setFontSize(36)),),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            //decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.red)), //use for debug frame
            width: setWidth(510), //750 - 240
            height: setHeight(990), //1334 - 100 - 64x
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 10, //主轴上子控件的间距
                runSpacing: 10, //交叉轴上子控件之间的间距
                children: _rightItems(),
              )
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _rightItems() {
    return List.generate(_rightList.length, (index){
      NavigationSubNode subNode = _rightList[index];
      return InkWell(
        child: Container(
          padding: EdgeInsets.only(top:10, bottom: 10, left: 20, right: 20),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Text('${subNode.title}'),
        ),
      );
    });
  }

  Future _refreshData() async {
    await _loadNodeData();
  }
 
  Future _loadNodeData() async {
    _leftList.clear();
    _rightList.clear();
    var list = await Network.getNavigationAllNodes();
    setState(() {
      _leftList.addAll(list);
      if (list.length > 0) {
        NavigationSuperNode superNode = list[0];
        _rightList.addAll(superNode.articles);
      }
    });
  }
}