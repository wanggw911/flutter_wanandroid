import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/model/navigation_tree.dart';
import 'package:flutter_wanandroid/pages/common/common_appbar.dart';
import 'package:flutter_wanandroid/pages/common/drawer_menu.dart';
import 'package:flutter_wanandroid/provide/navigation_provide.dart';
import 'package:flutter_wanandroid/routers/routers.dart';
import 'package:flutter_wanandroid/routers/routers_tool.dart';
import 'package:flutter_wanandroid/tools/theme_manage.dart';
import 'package:flutter_wanandroid/tools/uikit_help.dart';
import 'package:provide/provide.dart';

class NavigationPage extends StatefulWidget {
  NavigationPage({Key key}) : super(key: key);

  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> with AutomaticKeepAliveClientMixin {
  
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
    return Scaffold(
      appBar: AppBarBuilder.commonAppBar('导航'),
      drawer: Drawer(
        child: MenuBuilder.menuDrawer(context)
      ),
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
      child: _leftContentListView(),
    );
  }

  Widget _leftContentListView() {
    return Provide<NavigationProvide>(builder: (context, child, value) {
        List<NavigationSuperNode> leftList = Provide.value<NavigationProvide>(context).leftList;
        int currentLeftIndex = Provide.value<NavigationProvide>(context).selectedLeftIndex;
        return ListView.builder(
          itemCount: leftList.length,
          itemBuilder: (context, index) {
            bool isSelect = index == currentLeftIndex;
            NavigationSuperNode leftNode = leftList[index];
            return _leftCell(leftNode, isSelect, index);
          },
        );
    });
  }

  Widget _leftCell(NavigationSuperNode leftNode, bool isSelect, int index) {
    return InkWell(
      onTap: () {
        Provide.value<NavigationProvide>(context).selectLeftIndex(index);
      },
      child: Container(
        height: setHeight(100),
        decoration: BoxDecoration(
          color: isSelect? 
            NavigationPageTheme.leftCellSelectBGColor(context) :
            NavigationPageTheme.leftCellNormalBGColor(context),
        ),
        child: Center(
          child: Text(
            '${leftNode.name}',
            style: TextStyle(
              color: isSelect? 
                NavigationPageTheme.leftCellSelectTitleColor(context) :
                NavigationPageTheme.leftCellNormalTitleColor(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _rightListView() {
    return Provide<NavigationProvide>(builder: (context, child, value) {
        List<NavigationSuperNode> leftList = Provide.value<NavigationProvide>(context).leftList;
        if (leftList.isEmpty) {
          //print('❌：列表为空，所以直接返回 Container');
          return Container(
            child: Text(''),
          );
        }

        //print('✅：列表不为空，所以返回组合 Container');
        int leftIndex = Provide.value<NavigationProvide>(context).selectedLeftIndex;
        NavigationSuperNode superNode = leftList[leftIndex];
        List<NavigationSubNode> rightList = superNode.articles;
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
              Expanded(
                child: Container(
                  //decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.red)), //use for debug frame
                  padding: EdgeInsets.all(10.0),
                  width: setWidth(510), 
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 10, //主轴上子控件的间距
                      runSpacing: 10, //交叉轴上子控件之间的间距
                      children: _rightItems(rightList),
                    )
                  ),
                ),
              )
            ],
          ),
        );
    });    
  }

  List<Widget> _rightItems(List<NavigationSubNode> rightList) {
    return List.generate(rightList.length, (index){
        NavigationSubNode subNode = rightList[index];
        return InkWell(
          onTap: (){
            String modelType = 'NavigationSubNode';
            String json = RouterTools.object2string(subNode);
            Application.push(context, Routers.webDetailsPage+'?json=$json&model_type=$modelType');
          },
          child: Container(
            padding: EdgeInsets.only(top:10, bottom: 10, left: 20, right: 20),
            decoration: BoxDecoration(
              color: NavigationPageTheme.rightItemBGColor(context),
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Text(
              '${subNode.title}',
              style: TextStyle(color: NavigationPageTheme.rightItemTitleColor(context)),),
          ),
        );
      });
  }

  Future _refreshData() async {
    await Provide.value<NavigationProvide>(context).getNavigationNodeData();
  }
}