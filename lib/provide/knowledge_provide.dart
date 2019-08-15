
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/database/knowledge_db.dart';
import 'package:flutter_wanandroid/model/home_article.dart';
import 'package:flutter_wanandroid/model/knowledge_tree.dart';
import 'package:flutter_wanandroid/network/network.dart';

class KnowledgeProvide with ChangeNotifier {
  List<KnowledgeTreeNode> nodeList = [];
  Map<int, KnowledgeArticles> nodeArticleMap = Map<int, KnowledgeArticles>();
  
  Future getNodeData() async {
    nodeList.clear();
    nodeList = await KnowledgeTreeNodeDB.selectAll();
    if (nodeList.isEmpty) {
      var list = await Network.getKnowledgeAllNodes();
      nodeList.addAll(list);

      //save to database
      KnowledgeTreeNodeDB.insertWith(list, false);
    }
    
    nodeList.forEach((item){
      item.children.forEach((subItem){
        nodeArticleMap[subItem.id] = KnowledgeArticles();
      });
    });

    notifyListeners();
  }

  Future getNodeArticleData(int cid, bool isRefresh) async {
    KnowledgeArticles articles = nodeArticleMap[cid];
    if (isRefresh) {
      articles.pageIndex = 0;
      articles.articleList.clear();
    }
    else {
      articles.pageIndex++;
    }

    var list = await Network.getKnowledgeArticleList(articles.pageIndex, cid);
    articles.articleList.addAll(list);

    notifyListeners();
  }
}

class KnowledgeArticles {
  int pageIndex = 0;
  List<Article> articleList = [];
}