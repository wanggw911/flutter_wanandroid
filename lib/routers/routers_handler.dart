import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/pages/common/web_detail_page.dart';

// 跳转 Router 跳转传参数，只能传 String 字符串数组的参数
// 不能传 model 好像不大好用，model 参数只能转成String，然后再来解析
Handler webDetailsHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String json = params['json'].first;
    String modelType = params['model_type'].first;
    //print('参数：json = $json');
    print('参数：modelType = $modelType');
    return WebDetailPage(modelJson: json, modelType: modelType);
  }
);