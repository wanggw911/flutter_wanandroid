import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/pages/index_page.dart';
import 'package:flutter_wanandroid/provide/home_provide.dart';
import 'package:provide/provide.dart';

void main() {
  //【项目初始化】之：Provide
  final providers = Providers()
      ..provide(Provider<HomeProvide>.value(HomeProvide()));

  return runApp(ProviderNode(
    providers: providers,
    child: MyApp(),
  ));

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