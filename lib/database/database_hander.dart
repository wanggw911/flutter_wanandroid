import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart'; //join method need import
import 'package:flutter_wanandroid/database/home_article_db.dart';
import 'package:flutter_wanandroid/database/home_banner_db.dart';
import 'package:flutter_wanandroid/database/knowledge_db.dart';
import 'package:flutter_wanandroid/database/navigation_db.dart';
/* 
sqflite [使用文档列表](https://github.com/tekartik/sqflite/tree/master/sqflite/doc)
*/

class DatabaseHander {
  static final DatabaseHander shared = DatabaseHander();
  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    else {
      _db = await _initDatabase();
      return _db;
    } 
  }
 
  Future<Database> _initDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'wan_android.db');
    
    Database database = await openDatabase(path, 
      version: 1,
      onCreate: (Database db, int version) async {
        //数据库version1.0需要创建的数据表
        await db.execute(HomeBannerDB.createTableSql());
        await db.execute(HomeArticleDB.createTableSql());
        await db.execute(KnowledgeTreeNodeDB.createTableSql());
        await db.execute(NavigationNodeDB.createSuperNodeTableSql());
        await db.execute(NavigationNodeDB.createSubNodeTableSql());
    });
    return database;
  }

  Future closeDatabase() async {
    var database = await db;
    await database.close();
  }
}