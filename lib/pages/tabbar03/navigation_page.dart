import 'package:flutter/material.dart';

class NavigationPage extends StatefulWidget {
  NavigationPage({Key key}) : super(key: key);

  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
       child: Center(child: Text('导航页面'),),
    );
  }
}