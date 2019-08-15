import 'package:flutter_wanandroid/database/database_hander.dart';
import 'package:flutter_wanandroid/model/knowledge_tree.dart';

//TODO: node数据还涉及到父节点和子节点的关系问题
class KnowledgeTreeNodeDB {
  static final String tableKnowledgeTreeNode = 'KnowledgeTreeNode';
  static final String id = 'id';
  static final String name = 'name';
  static final String parentId = 'parentId';
 
  static createTableSql() {
    return '''
      CREATE TABLE $tableKnowledgeTreeNode (
      $id INTEGER PRIMARY KEY, 
      $name TEXT, 
      $parentId INTEGER
      )''';
  }

  //操作一：增
  static Future insertWith(List<KnowledgeTreeNode> list, bool isSub) async {
    print('KnowledgeTreeNode List 准备插入数据的条数：${list.length}，${isSub?'子节点':'父节点'}');

    var count = 0;
    var database = await DatabaseHander.shared.db;
    await database.transaction((txn) async {
      list.forEach((treeNode) async {
        var insertSql = '''
            INSERT INTO $tableKnowledgeTreeNode($id, $name, $parentId) 
            VALUES(?, ?, ?)
            ''';
        await txn.rawInsert(insertSql, [treeNode.id, treeNode.name, treeNode.parentChapterId]);
        count++;
        print('KnowledgeTreeNode List 成功插入数据的条数：$count，${isSub?'子节点':'父节点'}');
        //插入子节点
        insertWith(treeNode.children, true);
      });
    });

    //TODO: 数据库关闭的时机需要考虑好在什么时候关闭
    //await DatabaseHander.shared.closeDatabase();
  }

  static Future<List<KnowledgeTreeNode>> selectAll() async {
    List<KnowledgeTreeNode> list = [];
    var database = await DatabaseHander.shared.db;

    // 多个异步操作不能使用
    // //Step1：查询父节点的数据
    // List<Map> datalist = await database.rawQuery('SELECT * FROM $tableKnowledgeTreeNode  where $parentId=0');
    // datalist.forEach((item) async {
    //   KnowledgeTreeNode node = KnowledgeTreeNode.fromJson(item);
    //   //Step2：根据父节点的id，来查询子节点的列表
    //   List<KnowledgeTreeNode> subList = [];
    //   List<Map> subDatalist = await database.rawQuery('SELECT * FROM $tableKnowledgeTreeNode where $parentId=${node.id}');
    //   subDatalist.forEach((subItem){
    //     subList.add(KnowledgeTreeNode.fromJson(subItem));
    //   });
    //   node.children = subList;
    //   print('返回列表：-----222');
    //   list.add(node);
    // });

    //Step1：查询父节点的数据
    List<Map> datalist = await database.rawQuery('SELECT * FROM $tableKnowledgeTreeNode  where $parentId=0');
    for (Map item in datalist) {
      KnowledgeTreeNode node = KnowledgeTreeNode.fromJson(item);
      //Step2：根据父节点的id，来查询子节点的列表
      List<KnowledgeTreeNode> subList = [];
      node.subNodeNames = "";
      bool isFirst = true;
      List<Map> subDatalist = await database.rawQuery('SELECT * FROM $tableKnowledgeTreeNode where $parentId=${node.id}');
      for (Map subItem in subDatalist) {
        KnowledgeTreeNode subNode = KnowledgeTreeNode.fromJson(subItem);
        subList.add(subNode);
        if (isFirst) {
          node.subNodeNames += subNode.name;
          isFirst = false;
        }
        else {
          node.subNodeNames += "、${subNode.name}";
        }
      }
      node.children = subList;
      list.add(node);
    }

    //TODO: 数据库关闭的时机需要考虑好在什么时候关闭
    //await DatabaseHander.shared.closeDatabase();
    
    return list;
  } 
}