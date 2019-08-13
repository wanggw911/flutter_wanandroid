
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigatorTool {
  //页面跳转：
  static push(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) {
        return page;
      })
    );
  }

  static present(BuildContext context, Widget page) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) {
          return page;
        }
      )
    );
  }
}