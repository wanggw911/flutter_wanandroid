
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/tools/tools.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key key}) : super(key: key);

  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(title: Text('设置'),),
       body: _settingContent(),
    );
  }

  Widget _settingContent() {
    return Container(
      width: setWidth(750),
      height: setHeight(1334),
      decoration: BoxDecoration(color: Colors.grey[200]),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _header('通用设置'),
            _commonSettingContent(),
            _header('其他设置'),
            _otherSettingContent()
          ],
        ),
      ),
    );
  }

  Widget _header(String title) {
    return Container(
      height: setHeight(80),
      padding: EdgeInsets.only(left: 13),
      alignment: Alignment.centerLeft,
      child: Text(title),
    );
  }

  Widget _commonSettingContent() {
    return Container(
      height: setHeight(300),
      padding: EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        // TODO: 设置圆角的好像没有生效，应该使用 card clipBehavior
        borderRadius: BorderRadius.circular(10)
      ),
      child: Card(
        child: ListView(
          children: <Widget>[
            Container(
              height: setHeight(100),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey[200])),
              ),
              child: Center(
                child: ListTile(
                  leading: Icon(Icons.file_download),
                  title: Text('自动缓存'),
                  trailing: Checkbox(
                    value: true, 
                    onChanged: (value) {

                    },  
                  ),
                ),
              ),
            ),
            //Divider(),
            Container(
              height: setHeight(100),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey[200])),
              ),
              child: Center(
                child: ListTile(
                  leading: Icon(Icons.image),
                  title: Text('无图模式'),
                  trailing: Checkbox(
                    value: false, 
                    onChanged: (value) {
                      
                    },  
                  ),
                ),
              ),
            ),
            //Divider(),
            Container(
              height: setHeight(100),
              child: ListTile(
                leading: Icon(Icons.mood),
                title: Text('夜间模式'),
                trailing: Checkbox(
                  value: false, 
                  onChanged: (value) {
                    
                  },  
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _otherSettingContent() {
    return Container(
      height: setHeight(200),
      padding: EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        // TODO: 设置圆角的好像没有生效，应该使用 card clipBehavior
        borderRadius: BorderRadius.circular(10)
      ),
      child: Card(
        child: ListView(
          children: <Widget>[
            Container(
              height: setHeight(100),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey[200])),
              ),
              child: Center(
                child: ListTile(
                  leading: Icon(Icons.file_download),
                  title: Text('意见反馈'),
                ),
              ),
            ),
            //Divider(),
            Container(
              height: setHeight(100),
              child: Center(
                child: ListTile(
                  leading: Icon(Icons.warning),
                  title: Text('清除缓存'),
                  trailing: Text('2M'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
}