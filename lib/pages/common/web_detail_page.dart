
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/model/home_article.dart';
import 'package:flutter_wanandroid/model/home_banner.dart';
import 'package:flutter_wanandroid/model/navigation_tree.dart';
import 'package:flutter_wanandroid/model/project_article.dart';
import 'package:flutter_wanandroid/model/user.dart';
import 'package:flutter_wanandroid/pages/common/login_register_page.dart';
import 'package:flutter_wanandroid/provide/user_provide.dart';
import 'package:flutter_wanandroid/routers/navigator_tool.dart';
import 'package:flutter_wanandroid/routers/routers_tool.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:provide/provide.dart';


class WebDetailPage extends StatefulWidget {
  final dynamic model;
  final String modelJson;
  final String modelType;
  WebDetailPage({Key key, this.model, this.modelJson, this.modelType}) : super(key: key);

  _WebDetailPageState createState() => _WebDetailPageState();
}

class _WebDetailPageState extends State<WebDetailPage> {
  String title;
  String urlString;
  Function _actionFunction;

  _analysisParams() {
    var map = RouterTools.string2map(widget.modelJson);
    if (widget.modelType == 'Article') {
      Article article = Article.fromJson(map);
      title = article.title;
      urlString = article.link;
    }
    else if (widget.modelType == 'ProjectArticle') {
      ProjectArticle article = ProjectArticle.fromJson(map);
      title = article.title;
      urlString = article.link;
    }
    print("WebDetailPage，Web详情：[$title]($urlString)");
  }

  @override
  void initState() {
    super.initState();

    _analysisParams();

    //title = "详情";
    // if (widget.model is HomeBanner) {
    //   var banner = widget.model as HomeBanner;
    //   title = banner.title;
    //   urlString = banner.url;
    // }
    // else if (widget.model is Article) {
    //   var article = widget.model as Article;
    //   title = article.title;
    //   urlString = article.link;
    // }
    // else if (widget.model is NavigationSubNode) {
    //   var subNode = widget.model as NavigationSubNode;
    //   title = subNode.title;
    //   urlString = subNode.link;
    // }
    // else if (widget.model is ProjectArticle) {
    //   var project = widget.model as ProjectArticle;
    //   title = project.title;
    //   urlString = project.link;
    // }
    
    
  }

  @override
  Widget build(BuildContext context) {
    return Provide<UserProvide>(builder: (context, child, value) {
      User user = Provide.value<UserProvide>(context).user;
      if (user != null && _actionFunction != null) {
        _actionFunction();
        _actionFunction = null;
      }
      return Scaffold(
        appBar: AppBar(
          title: Text('$title'),  
          actions: _rightNaviButtons(),
        ),
        body: WebView(
          initialUrl: urlString,
          javascriptMode: JavascriptMode.unrestricted,
        ),
      );
    });
  }

  List<Widget> _rightNaviButtons() {
    List<Widget> list = [];
    if (widget.model is Article) {
      IconData iconData = _collectionIconData(widget.model as Article);
      list.add(IconButton(
        icon: Icon(iconData, color: Colors.white,),
        tooltip: 'Air it',
        onPressed: (){
          _collectionOrNotAction();
        },
      ),);
    }
    list.add(
      PopupMenuButton<String>(
            icon: Icon(Icons.more_vert),
            onSelected: (String value) {
              _navigaitonButtonAction(value);
            },
            itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
              PopupMenuItem<String>(
                value: 'share',
                child: Text('分享')
              ),
              PopupMenuItem<String>(
                value: 'safari',
                child: Text(Platform.isIOS?'Safari打开':'浏览器打开')
              ),
            ]
          ),
    );
    return list;
  }

  IconData _collectionIconData(Article article) {
    User _currentUser = UserProvide.currentUser;
    if (_currentUser == null) {
      return Icons.favorite_border;
    }
    else {
      bool isCollection = _currentUser.collectIds.contains(article.id);
      IconData iconData = isCollection?Icons.favorite:Icons.favorite_border;
      return iconData;
    }
  } 

  void _navigaitonButtonAction(String value) async {
    print('选择的菜单是$value');
    if (value == 'share') {
      //弹出系统的分享，有问题，不能分享网页到微信，比较坑爹哈
    }
    else if (value == 'safari') {
      if (Platform.isIOS) {
        //forceSafariVC: false: 跳转safari打开网页
        //forceSafariVC: true: 内建浏览器打开网页
        await launch(urlString, forceSafariVC: false);
      } else {
        await launch(urlString);
      }
    }
  }

  void _collectionOrNotAction() {
    User _currentUser = UserProvide.currentUser;
    if (_currentUser == null) {
      _actionFunction = _collectionOrNotAction;
      NavigatorTool.present(context, LoginRegisterPage(pageType: PageType.login));
      return;
    }

    int articleId = (widget.model as Article).id;
    print("_collectionOrNotAction === ${_currentUser.collectIds} == $articleId");
    bool isCollection = _currentUser.collectIds.contains(articleId);
    if (isCollection && _actionFunction != null) {
      print("文章已经收藏了。。。。");
      return;
    }

    if (isCollection) {
      Provide.value<UserProvide>(context).cancelCollectionArticle(articleId);
    }
    else {
      Provide.value<UserProvide>(context).collectionArticle(articleId);
    }
  }
}