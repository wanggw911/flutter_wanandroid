import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/pages/index_page.dart';
import 'package:flutter_wanandroid/provide/home_provide.dart';
import 'package:flutter_wanandroid/provide/knowledge_provide.dart';
import 'package:flutter_wanandroid/provide/navigation_provide.dart';
import 'package:flutter_wanandroid/provide/projects_provide.dart';
import 'package:flutter_wanandroid/provide/setting_provide.dart';
import 'package:flutter_wanandroid/provide/user_provide.dart';
import 'package:flutter_wanandroid/routers/routers.dart';
import 'package:flutter_wanandroid/tools/net_connectivity.dart';
import 'package:flutter_wanandroid/tools/save_to_location.dart';
import 'package:provide/provide.dart';

void main() async {
  DataHander.setup();

  NetConnectivity netConnectivity = NetConnectivity();
  netConnectivity.startListen();
  netConnectivity.getOriginConnectivityResult();
  NetConnectivity.shared = netConnectivity;

  SettingProvide settingProvide = SettingProvide();
  await settingProvide.readLocationSetting();

  return runApp(ProviderNode(
    providers: setupAppProviders(settingProvide),
    child: MyApp(),
  ));
}

Providers setupAppProviders(SettingProvide settingProvide) {
  //【项目初始化】之：Provide
  final providers = Providers()
      ..provide(Provider<HomeProvide>.value(HomeProvide()))
      ..provide(Provider<KnowledgeProvide>.value(KnowledgeProvide()))
      ..provide(Provider<NavigationProvide>.value(NavigationProvide()))
      ..provide(Provider<ProjectProvide>.value(ProjectProvide()))
      ..provide(Provider<UserProvide>.value(UserProvide()))
      ..provide(Provider<SettingProvide>.value(settingProvide));
      
    return providers;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final router = Router();
    Routers.configureRouters(router);
    Application.router = router;

    return Provide<SettingProvide>(builder: (context, child, value) {
      ThemeData themeData = Provide.value<SettingProvide>(context).themeData;
      return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: themeData,
        home: IndexPage(),
      );
    });
  }
}