import 'package:flutter_wanandroid/database/database_hander.dart';
import 'package:flutter_wanandroid/model/navigation_tree.dart';

class NavigationNodeDB {
  static final String tableNavigationSuperNode = 'NavigationSuperNode';
  static final String superId = 'cid';
  static final String superName = 'name';
  
  static final String tableNavigationSubNode = 'NavigationSubNode';
  static final String id = 'id';
  static final String parentId = 'parentId';
  static final String title = 'title';
  static final String link = 'link';

  static createSuperNodeTableSql() {
    return '''
      CREATE TABLE $tableNavigationSuperNode (
      $superId INTEGER PRIMARY KEY, 
      $superName TEXT
      )''';
  }

  static createSubNodeTableSql() {
    return '''
      CREATE TABLE $tableNavigationSubNode (
      $id INTEGER PRIMARY KEY, 
      $parentId INTEGER,
      $title TEXT, 
      $link TEXT
      )''';
  }
   
  //操作一：增 
  static Future insertWith(List<NavigationSuperNode> list) async {
    print('NavigationSuperNode List 准备插入数据的条数：${list.length}');

    var database = await DatabaseHander.shared.db;
    await database.transaction((txn) async {

      for (NavigationSuperNode treeNode in list) {
        var insertSql = '''
        insert or replace into $tableNavigationSuperNode($superId, $superName) 
        values(?, ?)
        ''';
        await txn.rawInsert(insertSql, [treeNode.cid, treeNode.name]);
 
        for (NavigationSubNode subNode in treeNode.articles) {
          var subInsertSql = '''
          insert or replace into $tableNavigationSubNode($id, $parentId, $title, $link) 
          values(?, ?, ?, ?)
          ''';
          await txn.rawInsert(subInsertSql, [subNode.id, treeNode.cid, subNode.title, subNode.link]);
        }
      }
    });

    //TODO: 数据库关闭的时机需要考虑好在什么时候关闭
    //await DatabaseHander.shared.closeDatabase();
  }

  static Future<List<NavigationSuperNode>> selectAll() async {
    List<NavigationSuperNode> list = [];
    var database = await DatabaseHander.shared.db;

    //Step1：查询父节点的数据
    List<Map> datalist = await database.rawQuery('SELECT * FROM $tableNavigationSuperNode');
    for (Map item in datalist) {
      NavigationSuperNode node = NavigationSuperNode.fromJson(item);
      //Step2：根据父节点的id，来查询子节点的列表
      List<NavigationSubNode> subList = [];
      List<Map> subDatalist = await database.rawQuery('SELECT * FROM $tableNavigationSubNode where $parentId=${node.cid}');
      for (Map subItem in subDatalist) {
        NavigationSubNode subNode = NavigationSubNode.fromJson(subItem);
        subList.add(subNode);
      }
      node.articles = subList;
      list.add(node);
    }

    //TODO: 数据库关闭的时机需要考虑好在什么时候关闭
    //await DatabaseHander.shared.closeDatabase();
    
    return list;
  } 
}