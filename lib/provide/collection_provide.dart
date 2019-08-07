
import 'package:flutter/widgets.dart';
import 'package:flutter_wanandroid/model/home_article.dart';
import 'package:flutter_wanandroid/network/network.dart';
import 'package:flutter_wanandroid/provide/knowledge_provide.dart';

class CollectionProvide with ChangeNotifier {
  int pageIndex = 0;
  List<Article> articleList = [];
  
  Future getNodeArticleData(int cid, bool isRefresh) async {
    if (isRefresh) {
      pageIndex = 0;
      articleList.clear();
    }
    else {
      pageIndex++;
    }

    //var list = await Network.getKnowledgeArticleList(pageIndex, cid);
    //articleList.addAll(list);

    notifyListeners();
  }
}