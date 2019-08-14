
import 'package:flutter/material.dart';

class NotFountPage extends StatelessWidget {
  final Map<String, List<String>> params;
  const NotFountPage({Key key, this.params}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('404')),
      body: Center(
        child: Text('界面未找到\n，$params')
      ),
    );
  }
}