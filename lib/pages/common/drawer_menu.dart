
import 'package:flutter/material.dart';

class MenuBuilder {
  static Widget menuDrawer(BuildContext context) {
    return Container(
      //decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.red)), //use for debug frame
      child: ListView(
        padding: EdgeInsets.only(),
        children: <Widget>[
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
            onTap: (){},
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
          ),
        ],
      ),
    );
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