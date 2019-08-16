
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

  Future getProjectNodeData() async {
    projectNodeList.clear();
    var list = await ProjectModuleDB.selectAll();
    if (list.isEmpty) {
      list = await Network.getProjectTypes();
      if (list.isNotEmpty) {
        projectNodeList.addAll(list);
        getArticleData(true);

        ProjectModuleDB.insertWith(list);
      }
    }
    else {
      projectNodeList.addAll(list);
      getArticleData(true);
    }

    notifyListeners();
  }

  Future getArticleData(bool isRefresh) async {
    //TODO: 应该初始化的时候获取本地数据，这里这样获取不大好，跟网络数据那边耦合了，晚点修改
    int cid = projectNodeList[projectNodeIndex].id;
    var list = await HomeArticleDB.selectWith(ArticleType.Project, chapterIdValue: cid);
    if (list.isEmpty) {
      if (isRefresh) {
        articlePageIndex = 1;
        articleList.clear();
      }
      else {
        articlePageIndex++;
      }
      list = await Network.getProjectArticleList(articlePageIndex, cid);
      articleList.addAll(list);
      notifyListeners();

      HomeArticleDB.insertWith(list, ArticleType.Project);
    }
    else {
      articleList.clear();
      articleList.addAll(list);
      notifyListeners();
    }
  }

  void selectProjectNodeWith(int index) {
    projectNodeIndex = index;
    getArticleData(true);
  }
}