
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/model/home_article.dart';

class WebDetailPage extends StatefulWidget {
  final dynamic model;
  WebDetailPage({Key key, this.model}) : super(key: key);

  _WebDetailPageState createState() => _WebDetailPageState();
}

class _WebDetailPageState extends State<WebDetailPage> {
  //dynamic model;
  //_WebDetailPageState(model);

  @override
  Widget build(BuildContext context) {
    
    var title = "web详情";
    if (widget.model is Article) {
      title = "文章详情";
      print("文章详情");
    }

    return Scaffold(
      appBar: AppBar(title: Text('$title'),),
      body: Container(
        child: Center(child: Text('$title'),),
      ),
    );
  }
}