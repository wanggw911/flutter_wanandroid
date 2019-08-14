
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_wanandroid/pages/common/404_page.dart';
import 'package:flutter_wanandroid/routers/routers_handler.dart';

class Application {
  static Router router;

  static push(BuildContext context, String path) {
    if (Platform.isIOS) {
      Application.router.navigateTo(context, path, transition: TransitionType.cupertino);  
    }
    else {
      Application.router.navigateTo(context, path);  
    }
  }
}

class Routers {
  static String root = '/';
  static String web_detailsPage = '/web_detail';
  
  static void configureRouters(Router router) {
    router.notFoundHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> params) {
        print('ERROR ===> ROUTER $context $params');
        return NotFountPage(params: params);
      }
    );

    router.define(web_detailsPage, handler: webDetailsHandler);
  }

}