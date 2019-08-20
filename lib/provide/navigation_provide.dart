
import 'package:flutter/widgets.dart';
import 'package:flutter_wanandroid/database/navigation_db.dart';
import 'package:flutter_wanandroid/model/navigation_tree.dart';
import 'package:flutter_wanandroid/network/network.dart';

class NavigationProvide with ChangeNotifier {
  List<NavigationSuperNode> leftList = [];
  int selectedLeftIndex = 0;
  
  Future getLocationNavigationNodeData() async {
    var list = await NavigationNodeDB.selectAll();
    if (list.isNotEmpty) {
      leftList.clear();
      leftList.addAll(list);
      notifyListeners();
    }
    else {
      await requestNavigationNodeData();
    }
  }

  Future requestNavigationNodeData() async {
    leftList.clear();
    var list = await Network.getNavigationAllNodes();
    leftList.addAll(list);
  
    notifyListeners();

    NavigationNodeDB.insertWith(list);
  }

  void selectLeftIndex(int index) {
    selectedLeftIndex = index;
    notifyListeners();
  }
}