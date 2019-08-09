
import 'package:flutter/material.dart';

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