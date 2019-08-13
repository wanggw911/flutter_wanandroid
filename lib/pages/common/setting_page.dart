
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/provide/setting_provide.dart';
import 'package:flutter_wanandroid/tools/uikit_help.dart';
import 'package:provide/provide.dart';

typedef CheckBoxCallBack = void Function(bool);

class SettingPage extends StatefulWidget {
  SettingPage({Key key}) : super(key: key);

  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_){ 
      Provide.value<SettingProvide>(context).readLocationSetting();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('设置'),),
      body: _settingContent(),
      // body: _testContent(),
    );
  }

  Widget _settingContent() {
    return Container(
      width: setWidth(750),
      height: setHeight(1334),
      //能不设置颜色就不设置颜色
      //decoration: BoxDecoration(color: Colors.grey[200]),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _header('通用设置'),
            _commonSettingContent(),
            _header('其他设置'),
            _otherSettingContent(),
          ],
        ),
      ),
    );
  }

  Widget _header(String title) {
    return Container(
      height: setHeight(80),
      padding: EdgeInsets.only(left: 15),
      alignment: Alignment.centerLeft,
      child: Text(title),
    );
  }

  Widget _commonSettingContent() {
    return Provide<SettingProvide>(builder: (context, child, value) {
      bool autoCache = Provide.value<SettingProvide>(context).autoCache;
      bool noPictures = Provide.value<SettingProvide>(context).noPictures;
      bool nighttime = Provide.value<SettingProvide>(context).nighttime; 
      return Container(
        //height: setHeight(300), //设置了高度，里面的内容高度就不准确了😂
        padding: EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
          // TODO: 设置圆角的好像没有生效，应该使用 card clipBehavior
          //borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),
        child: Card(
          child: Column(
            children: <Widget>[
              _commonCell(Icon(Icons.file_download), '自动缓存', autoCache, true, (isCheck){
                Provide.value<SettingProvide>(context).settingWith(SettingType.autoCache);
              }),
              _commonCell(Icon(Icons.image), '无图模式', noPictures, true, (isCheck){
                Provide.value<SettingProvide>(context).settingWith(SettingType.noPictures);
              }),
              _commonCell(Icon(Icons.widgets), '夜间模式', nighttime, false, (isCheck){
                Provide.value<SettingProvide>(context).settingWith(SettingType.nighttime);
              }),
            ],
          )
        ),
      );
    });
  }

  Widget _commonCell(Icon icon, String title, bool isCheck, bool addBottomLine, CheckBoxCallBack callBack) {
    BoxDecoration boxDecoration = addBottomLine ? BoxDecoration(
        //color: Colors.white,
        border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey[200])),
      ) : BoxDecoration();
    return Container(
      height: setHeight(100),
      decoration: boxDecoration,
      child: Center(
        child: ListTile(
          leading: icon,
          title: Text(title),
          trailing: Checkbox(
            value: isCheck, 
            onChanged: (value) {
              callBack(value);
            },  
          ),
        ),
      ),
    );
  }

  Widget _otherSettingContent() {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10)
      ),
      child: Card(
        child: Column(
          children: <Widget>[
            Container(
              height: setHeight(100),
              decoration: BoxDecoration(
                //color: Colors.white,
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