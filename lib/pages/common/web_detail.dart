
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/model/home_article.dart';

class WebDetailPage extends StatefulWidget {
  final dynamic model;
  WebDetailPage({Key key, this.model}) : super(key: key);

  _WebDetailPageState createState() => _WebDetailPageState();
}

class _WebDetailPageState extends State<WebDetailPage> {
  String title;
  String urlString;

  @override
  void initState() {
    super.initState();

    title = "详情";
    if (widget.model is Article) {
      var article = widget.model as Article;
      title = article.title;
      urlString = article.link;
      print("Web详情：\n文章名字：$title \n文章地址：$urlString");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$title'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.favorite_border, color: Colors.white,),
            tooltip: 'Air it',
            onPressed: (){
              showDialog(context: context, builder: (context){
                return AlertDialog(content: Text('点击了收藏按钮'),);
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            tooltip: 'Air it',
            onPressed: (){
              showDialog(context: context, builder: (context){
                return AlertDialog(content: Text('点击了更多按钮'),);
              });
            },
          ),
        ],
      ),
      body: Container(
        child: Center(child: Text('$urlString'),),
      ),
    );
  }
}