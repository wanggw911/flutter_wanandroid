
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/provide/setting_provide.dart';
import 'package:provide/provide.dart';

final ThemeData kiOSNormalTheme = ThemeData(
  brightness: Brightness.light, //亮色主题
  primaryColor: Colors.blue, //主题颜色为蓝色
  //accentColor: Colors.white, //Widget 前景色为白色
  //iconTheme: IconThemeData(color: Colors.blue),
  //textTheme: TextTheme(body1: TextStyle(color: Colors.black)) //文本注意色为黑色
);

final ThemeData kiOSDarkTheme = ThemeData(
  brightness: Brightness.dark, //亮色主题
  primaryColor: Colors.black, //主题颜色为蓝色
  //accentColor: Colors.black, //Widget 前景色为白色
  //iconTheme: IconThemeData(color: Colors.blue),
  //textTheme: TextTheme(body1: TextStyle(color: Colors.white)) //文本注意色为黑色
);

class NavigationPageTheme {
  static Color leftCellNormalBGColor(BuildContext context) {
    bool nighttime = Provide.value<SettingProvide>(context).nighttime;
    return nighttime ? Colors.black12 : Colors.grey[200];
  }

  static Color leftCellSelectBGColor(BuildContext context) {
    bool nighttime = Provide.value<SettingProvide>(context).nighttime;
    return nighttime ? Colors.black26 : Colors.white;
  }

  static Color leftCellNormalTitleColor(BuildContext context) {
    bool nighttime = Provide.value<SettingProvide>(context).nighttime;
    return nighttime ? Colors.white : Colors.black;
  }

  static Color leftCellSelectTitleColor(BuildContext context) {
    bool nighttime = Provide.value<SettingProvide>(context).nighttime;
    return nighttime ? Colors.green : Colors.green;
  }

  static Color rightItemBGColor(BuildContext context) {
    bool nighttime = Provide.value<SettingProvide>(context).nighttime;
    return nighttime ? Colors.black12 : Colors.grey[200];
  }

  static Color rightItemTitleColor(BuildContext context) {
    bool nighttime = Provide.value<SettingProvide>(context).nighttime;
    return nighttime ? Colors.white : Colors.black;
  }
}

class LoginPageTheme {
  static Color navigationColor(BuildContext context) {
    return Theme.of(context).scaffoldBackgroundColor;
    //bool nighttime = Provide.value<SettingProvide>(context).nighttime;
    //return nighttime ? 
    //Colors.black12 : 
  }

  static Color inputTextColor(BuildContext context) {
    bool nighttime = Provide.value<SettingProvide>(context).nighttime;
    return nighttime ? Colors.white : Colors.black;
  }
}