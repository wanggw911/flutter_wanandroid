
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/model/home_article.dart';
import 'package:flutter_wanandroid/model/home_banner.dart';
import 'package:flutter_wanandroid/model/navigation_tree.dart';
import 'package:flutter_wanandroid/model/project_article.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

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
    if (widget.model is HomeBanner) {
      var banner = widget.model as HomeBanner;
      title = banner.title;
      urlString = banner.url;
    }
    else if (widget.model is Article) {
      var article = widget.model as Article;
      title = article.title;
      urlString = article.link;
    }
    else if (widget.model is NavigationSubNode) {
      var subNode = widget.model as NavigationSubNode;
      title = subNode.title;
      urlString = subNode.link;
    }
    else if (widget.model is ProjectArticle) {
      var project = widget.model as ProjectArticle;
      title = project.title;
      urlString = project.link;
    }
    
    print("WebDetailPage：Web详情: \n\t文章名字: $title \n\t文章地址: $urlString");
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
        url: urlString,
        appBar: _navigationBar(),
        withZoom: true, // 允许网页缩放
        withLocalStorage: true, // 允许LocalStorage
        withJavascript: true, // 允许执行js代码
    );
  }

  Widget _navigationBar() {
    return AppBar(
        title: Text('$title'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.favorite_border, color: Colors.white,),
            tooltip: 'Air it',
            onPressed: (){
              print('点击了收藏按钮');
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            tooltip: 'Air it',
            onPressed: (){
              print('点击了更多按钮');
              // showDialog(context: context, builder: (context){
              //   return AlertDialog(content: Text('点击了更多按钮'),);
              // });
            },
          ),
        ],
      );
  }
}