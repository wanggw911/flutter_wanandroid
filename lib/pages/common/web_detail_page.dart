
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
import 'package:flutter_wanandroid/tools/uikit_help.dart';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:provide/provide.dart';

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
    
    print("WebDetailPage：Web详情: 文章名字: $title、文章地址: $urlString");
  }

  @override
  Widget build(BuildContext context) {
    return Provide<UserProvide>(builder: (context, child, value) {
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
              print('选择的菜单是$value');
            },
            itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
              PopupMenuItem<String>(
                //height: setHeight(40),
                value: '选项一的值',
                child: new Text('分享')
              ),
              PopupMenuItem<String>(
                //height: setHeight(40),
                value: '选项二的值',
                child: new Text('Safari打开')
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

  void _collectionOrNotAction() {
    User _currentUser = UserProvide.currentUser;
    if (_currentUser == null) {
      // TODO: 跳转有问题，无论是push，还是present，跳转后的登录界面不能展示内容
      NavigatorTool.push(context, LoginRegisterPage(pageType: PageType.login));
      //NavigatorTool.present(context, LoginRegisterPage(pageType: PageType.login));
      return;
    }

    int articleId = (widget.model as Article).id;
    print("_collectionOrNotAction === ${_currentUser.collectIds} == $articleId");
    bool isCollection = _currentUser.collectIds.contains(articleId);
    if (isCollection) {
      Provide.value<UserProvide>(context).cancelCollectionArticle(articleId);
    }
    else {
      Provide.value<UserProvide>(context).collectionArticle(articleId);
    }
  }
}