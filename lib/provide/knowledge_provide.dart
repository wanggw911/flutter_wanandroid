
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/database/home_article_db.dart';
import 'package:flutter_wanandroid/database/knowledge_db.dart';
import 'package:flutter_wanandroid/model/home_article.dart';
import 'package:flutter_wanandroid/model/knowledge_tree.dart';
import 'package:flutter_wanandroid/network/network.dart';

class KnowledgeArticles {
  int pageIndex = 0;
  List<Article> articleList = [];
}

class KnowledgeProvide with ChangeNotifier {
  List<KnowledgeTreeNode> nodeList = [];
  Map<int, KnowledgeArticles> nodeArticleMap = Map<int, KnowledgeArticles>();
  
  Future getLocationNodeData() async {
    nodeList.clear();
    var list = await KnowledgeTreeNodeDB.selectAll();
    if (list.isNotEmpty) {
        nodeList.addAll(list);

        nodeList.forEach((item){
          item.children.forEach((subItem){
            nodeArticleMap[subItem.id] = KnowledgeArticles();
          });
        });

        notifyListeners();
    }
    else {
      await requestNodeData();
    }
  }

  Future requestNodeData() async {
    nodeList.clear();
    var list = await Network.getKnowledgeAllNodes();
    nodeList.addAll(list);
    
    nodeList.forEach((item){
      item.children.forEach((subItem){
        nodeArticleMap[subItem.id] = KnowledgeArticles();
      });
    });

    notifyListeners();

    KnowledgeTreeNodeDB.insertWith(list, false);
  }

  Future getLocationNodeArticleData(int cid, bool isRefresh) async {
    KnowledgeArticles articles = nodeArticleMap[cid];
    var list = await HomeArticleDB.selectWith(ArticleType.Konwlege, chapterIdValue: cid);
    if (list.isNotEmpty) {
      articles.articleList.addAll(list);
      notifyListeners();
    }
    else {
      await requestNodeArticleData(cid, isRefresh);
    }
  }

  Future requestNodeArticleData(int cid, bool isRefresh) async {
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

      HomeArticleDB.insertWith(list, ArticleType.Konwlege);
  }
}