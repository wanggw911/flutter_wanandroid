
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/model/knowledge_tree.dart';
import 'package:flutter_wanandroid/network/network.dart';

class KnowledgeProvide with ChangeNotifier {
  List<KnowledgeTreeNode> nodeList = [];
  
  Future getNodeData() async {
    nodeList.clear();
    var list = await Network.getKnowledgeAllNodes();
    nodeList.addAll(list);

    notifyListeners();
  }
}