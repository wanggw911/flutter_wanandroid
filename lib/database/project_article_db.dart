
import 'package:flutter_wanandroid/database/database_hander.dart';
import 'package:flutter_wanandroid/model/project_tree.dart';

class ProjectModuleDB {
  static final String tableProjectTreeNode = 'ProjectTreeNode';
  static final String id = 'id';
  static final String name = 'name';
  
  //static final String tableHomeArticle = 'HomeArticle';
  
  static createNodeTableSql() {
    return '''
      CREATE TABLE $tableProjectTreeNode (
      $id INTEGER PRIMARY KEY, 
      $name TEXT
      )''';
  }

  //操作一：增 
  static Future insertWith(List<ProjectNode> list) async {
    print('NavigationSuperNode List 准备插入数据的条数：${list.length}');

    var database = await DatabaseHander.shared.db;
    await database.transaction((txn) async {

      for (ProjectNode treeNode in list) {
        var insertSql = '''
        insert or replace into $tableProjectTreeNode($id, $name) 
        values(?, ?)
        ''';
        await txn.rawInsert(insertSql, [treeNode.id, treeNode.name]);
      }
    });

    //数据库关闭的时机需要考虑好在什么时候关闭
    //await DatabaseHander.shared.closeDatabase();
  }

  static Future<List<ProjectNode>> selectAll() async {
    List<ProjectNode> list = [];
    var database = await DatabaseHander.shared.db;

    //Step1：查询父节点的数据
    List<Map> datalist = await database.rawQuery('SELECT * FROM $tableProjectTreeNode');
    for (Map item in datalist) {
      list.add(ProjectNode.fromJson(item));
    }

    //数据库关闭的时机需要考虑好在什么时候关闭
    //await DatabaseHander.shared.closeDatabase();
    
    return list;
  } 
}