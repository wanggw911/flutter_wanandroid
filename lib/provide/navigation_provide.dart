
import 'package:flutter/widgets.dart';
import 'package:flutter_wanandroid/model/navigation_tree.dart';
import 'package:flutter_wanandroid/network/network.dart';

class NavigationProvide with ChangeNotifier {
  List<NavigationSuperNode> leftList = [];
  int selectedLeftIndex = 0;
  
  Future getNavigationNodeData() async {
    leftList.clear();
    var list = await Network.getNavigationAllNodes();
    if (list.length > 0) {
        leftList.addAll(list);
    }

    notifyListeners();
  }

  void selectLeftIndex(int index) {
    selectedLeftIndex = index;

    notifyListeners();
  }
}