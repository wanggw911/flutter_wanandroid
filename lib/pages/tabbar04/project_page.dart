import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/model/project_tree.dart';
import 'package:flutter_wanandroid/network/network.dart';
import 'package:flutter_wanandroid/tools/tools.dart';

class ProjectsPage extends StatefulWidget {
  ProjectsPage({Key key}) : super(key: key);

  _ProjectsPageState createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  List<ProjectNode> _projectNodes = [];
  int _currentSelectIndex = 0;
  
  @override
  void initState() {
    super.initState();

    _loadProjectNodeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('项目')),
      body: Container(
        child: Column(
          children: <Widget>[
            _topNavigation(),
            _listContent(),
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
    bool isSelect = (index == _currentSelectIndex) ? true : false;
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
          _currentSelectIndex = index;
        });
      },
      child: Row(
        children: cellItems,
      ),
    );
  }

  Widget _listContent() {
    return Container(
      child: Text('列表内容'),
    );
  }

  Future _loadProjectNodeData() async {
    _projectNodes.clear();
    var list = await Network.getProjectTypes();
    setState(() {
      _projectNodes.addAll(list);
    });
  }
}