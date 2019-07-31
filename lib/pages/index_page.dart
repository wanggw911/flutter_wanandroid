
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_wanandroid/pages/tabbar01/home_page.dart';
import 'package:flutter_wanandroid/pages/tabbar02/knowledge_page.dart';
import 'package:flutter_wanandroid/pages/tabbar03/navigation_page.dart';
import 'package:flutter_wanandroid/pages/tabbar04/project_page.dart';

class IndexPage extends StatefulWidget {
  IndexPage({Key key}) : super(key: key);

  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  var _currentIndex = 0;

  final List<BottomNavigationBarItem> bottomTabs = [
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.home),
      title: Text("首页")
    ),
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.search),
      title: Text("知识体系")
    ),
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.flag),
      title: Text("导航")
    ),
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.folder),
      title: Text("项目")
    ),
  ];

  final List<Widget> tabBodies = [
    HomePage(),
    KnowledgePage(),
    NavigationPage(),
    ProjectsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(title: Text('首页'),),
       backgroundColor: Color.fromRGBO(245, 245, 245, 1.0),
       body: tabBodies[_currentIndex],
       bottomNavigationBar: BottomNavigationBar(
         type: BottomNavigationBarType.fixed,
         currentIndex: _currentIndex,
         items: bottomTabs,
         onTap: (index) {
           setState(() {
             _currentIndex = index;
           });
         },
       ),
    );
  }
}