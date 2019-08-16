import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/model/home_article.dart';
import 'package:flutter_wanandroid/model/home_banner.dart';
import 'package:flutter_wanandroid/model/knowledge_tree.dart';
import 'package:flutter_wanandroid/model/navigation_tree.dart';
import 'package:flutter_wanandroid/pages/common/collection_page.dart';
import 'package:flutter_wanandroid/pages/common/login_register_page.dart';
import 'package:flutter_wanandroid/pages/common/setting_page.dart';
import 'package:flutter_wanandroid/pages/common/web_detail_page.dart';
import 'package:flutter_wanandroid/pages/tabbar02/knowledge_second_page.dart';
import 'package:flutter_wanandroid/routers/routers_tool.dart';

// 跳转 Router 跳转传参数，只能传 String 字符串数组的参数
// 不能传 model 好像不大好用，model 参数只能转成String，然后再来解析
Handler webDetailsHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String json = params['json'].first;
    var map = RouterTools.string2map(json);
    dynamic model;
    String modelType = params['model_type'].first;
    if (modelType == 'Article') {
      model = Article.fromJson(map);
    }
    else if (modelType == 'HomeBanner') {
      model = HomeBanner.fromJson(map);
    }
    else if (modelType == 'NavigationSubNode') {
      model = NavigationSubNode.fromJson(map);
    }
    return WebDetailPage(model: model);
  }
);

Handler settingHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return SettingPage();
  }
);

Handler loginRegisterHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String isLogin = params['isLogin'].first;
    PageType pageType = isLogin == "1" ? PageType.login : PageType.register;
    return LoginRegisterPage(pageType: pageType);
  }
);

Handler collectionHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return CollectionPage();
  }
);

Handler knowledgeSecondHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String json = params['nodeJson'].first;
    var map = RouterTools.string2map(json);
    KnowledgeTreeNode node = KnowledgeTreeNode.fromJson(map);
    return KnowledgeSecondPage(node: node);
  }
);


