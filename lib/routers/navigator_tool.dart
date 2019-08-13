
import 'package:flutter/material.dart';

class NavigatorTool {
  //页面跳转：
  static go(BuildContext context, Widget page) {
    Navigator.of(context).push(
    MaterialPageRoute(builder: (BuildContext context) {
        return page;
      })
    );
  }
}