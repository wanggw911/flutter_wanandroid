
import 'package:flutter/widgets.dart';
import 'package:flutter_wanandroid/model/project_article.dart';
import 'package:flutter_wanandroid/model/project_tree.dart';
import 'package:flutter_wanandroid/network/network.dart';

class ProjectProvide with ChangeNotifier {
  int projectNodeIndex = 0;
  List<ProjectNode> projectNodeList = [];
  int articlePageIndex = 1;
  List<ProjectArticle> articleList = [];

  Future getProjectNodeData() async {
    projectNodeList.clear();
    var list = await Network.getProjectTypes();
    
    if (list.isNotEmpty) {
      projectNodeList.addAll(list);
      
      getArticleData(true);
    }

    notifyListeners();
  }

  Future getArticleData(bool isRefresh) async {
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
  }

  void selectProjectNodeWith(int index) {
    projectNodeIndex = index;
    getArticleData(true);
  }
}