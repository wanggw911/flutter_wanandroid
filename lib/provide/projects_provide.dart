
import 'package:flutter/widgets.dart';
import 'package:flutter_wanandroid/database/home_article_db.dart';
import 'package:flutter_wanandroid/database/project_article_db.dart';
import 'package:flutter_wanandroid/model/home_article.dart';
import 'package:flutter_wanandroid/model/project_tree.dart';
import 'package:flutter_wanandroid/network/network.dart';

class ProjectProvide with ChangeNotifier {
  int projectNodeIndex = 0;
  List<ProjectNode> projectNodeList = [];
  int articlePageIndex = 1;
  List<Article> articleList = [];

  Future getLocationProjectNodeData() async {
    projectNodeList.clear();
    var list = await ProjectModuleDB.selectAll();
    if (list.isNotEmpty) {
      projectNodeList.addAll(list);
      notifyListeners();
    }
    else {
      await requestProjectNodeData();
    }
  }

  Future requestProjectNodeData() async {
    var list = await Network.getProjectTypes();
    projectNodeList.addAll(list);
    notifyListeners();
    ProjectModuleDB.insertWith(list);    
  }

  Future getLocationArticleData(bool isRefresh) async {
    int cid = projectNodeList[projectNodeIndex].id;
    var list = await HomeArticleDB.selectWith(ArticleType.Project, chapterIdValue: cid);
    if (list.isNotEmpty) {
      articleList.clear();
      articleList.addAll(list);
      notifyListeners();
    }
    else {
      await requestArticleData(true);
    }
  }

  Future requestArticleData(bool isRefresh) async {
    if (isRefresh) {
      articlePageIndex = 1;
      articleList.clear();
    }
    else {
      articlePageIndex++;
    }

    int cid = projectNodeList[projectNodeIndex].id;
    var list = await Network.getProjectArticleList(articlePageIndex, cid);
    articleList.addAll(list);
    notifyListeners();
    HomeArticleDB.insertWith(list, ArticleType.Project);
  }

  void selectProjectNodeWith(int index) {
    projectNodeIndex = index;
    getLocationArticleData(true);
  }
}