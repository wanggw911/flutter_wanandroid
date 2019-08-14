
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
  static String webDetailsPage = '/web_detail';
  static String settingPage = '/setting';
  static String loginRegisterPage = '/loginRegister';
  static String collectionPage = '/collection';
  static String knowledgeSecondPage = '/knowledgeSecond';
  
  static void configureRouters(Router router) {
    router.notFoundHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> params) {
        print('ERROR ===> ROUTER $context $params');
        return NotFountPage(params: params);
      }
    );

    router.define(webDetailsPage, handler: webDetailsHandler);
    router.define(settingPage, handler: settingHandler);
    router.define(loginRegisterPage, handler: loginRegisterHandler);
    router.define(collectionPage, handler: collectionHandler);
    router.define(knowledgeSecondPage, handler: knowledgeSecondHandler);
  }

}