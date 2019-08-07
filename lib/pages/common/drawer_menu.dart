
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/model/user.dart';
import 'package:flutter_wanandroid/pages/common/login_register_page.dart';
import 'package:flutter_wanandroid/provide/user_provide.dart';
import 'package:provide/provide.dart';

class MenuBuilder {
  static Widget menuDrawer(BuildContext context) {
    return Provide<UserProvide>(builder: (context, child, value) {
      User user = Provide.value<UserProvide>(context).user;
      List<Widget> list = _widgetList(context, user);
      return Container(
        //decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.red)), //use for debug frame
        child: ListView(
          padding: EdgeInsets.only(),
          children: list,
        ),
      );
    });
  }

  static List<Widget> _widgetList(BuildContext context, User user) {
    List<Widget> _list = [
      _header(),
      ListTile(
        leading: Icon(Icons.android),
        title: Text('玩Android'),
        onTap: () {
          //侧滑菜单返回，主动调用返回事件
          Navigator.pop(context);
        },
      ),
      ListTile(
        leading: Icon(Icons.favorite),
        title: Text('收藏'),
        onTap: (){
          Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) {
              
              return LoginRegisterPage(pageType: PageType.login,);
            })
          );
        },
      ),
      ListTile(
        leading: Icon(Icons.settings),
        title: Text('设置'),
        onTap: (){},
      ),
      ListTile(
        leading: Icon(Icons.camera),
        title: Text('关于我们'),
        onTap: (){},
      ),];

    if (user != null) {
      _list.add(
        ListTile(
          leading: Icon(Icons.camera),
          title: Text('退出登录'),
          onTap: (){
            Provide.value<UserProvide>(context).loginOut();
          },
      ),);
    }

    return _list;
  }

  static Widget _header() {
    return UserAccountsDrawerHeader(
      accountName: Text('UseName'),
      accountEmail: Text('user@gmail.com'),
      currentAccountPicture: CircleAvatar(
        backgroundImage: NetworkImage('https://avatars1.githubusercontent.com/u/20632280?s=460&v=4'),
      ),
      onDetailsPressed: (){},
    );
  }
}