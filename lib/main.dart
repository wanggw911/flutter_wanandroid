import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/pages/index_page.dart';
import 'package:flutter_wanandroid/provide/home_provide.dart';
import 'package:flutter_wanandroid/provide/knowledge_provide.dart';
import 'package:flutter_wanandroid/provide/navigation_provide.dart';
import 'package:flutter_wanandroid/provide/projects_provide.dart';
import 'package:flutter_wanandroid/provide/setting_provide.dart';
import 'package:flutter_wanandroid/provide/user_provide.dart';
import 'package:provide/provide.dart';

void main() {
  return runApp(ProviderNode(
    providers: appProviders(),
    child: MyApp(),
  ));
}

Providers appProviders() {
  //【项目初始化】之：Provide
  final providers = Providers()
      ..provide(Provider<HomeProvide>.value(HomeProvide()))
      ..provide(Provider<KnowledgeProvide>.value(KnowledgeProvide()))
      ..provide(Provider<NavigationProvide>.value(NavigationProvide()))
      ..provide(Provider<ProjectProvide>.value(ProjectProvide()))
      ..provide(Provider<UserProvide>.value(UserProvide()))
      ..provide(Provider<SettingProvide>.value(SettingProvide()));
      
    return providers;
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: IndexPage(),
    );
  }
}