import 'package:flutter_wanandroid/database/project_article_db.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart'; //join method need import
import 'package:flutter_wanandroid/database/home_article_db.dart';
import 'package:flutter_wanandroid/database/home_banner_db.dart';
import 'package:flutter_wanandroid/database/knowledge_db.dart';
import 'package:flutter_wanandroid/database/navigation_db.dart';

/* 
sqflite [使用文档列表](https://github.com/tekartik/sqflite/tree/master/sqflite/doc)

数据库使用说明：
   1、文章数据表，使用首页文章一样的数据结构就好了，
   2、顺便测试数据库升级的功能，升级数据库的版本 [数据库升级的官方例子](https://github.com/tekartik/sqflite/blob/master/sqflite/doc/migration_example.md)
   3、文章表字段需要加入封面标题的字段需要加入数据表中要加入进去，注意给添加的字段设置默认值
   4、文章表字段需要增加增加文章类型标识字段，首页文章、知识体系文章、项目文章，使用枚举字段来进行分类，查找的时候，增加查找条件
   5、文章表，获取数据需要设置只获取10条数据
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
      version: 2,
      onCreate: (Database db, int version) async {
        print("数据表版本2.0，onCreate");
        var batch = db.batch();
        _createVersion2Tables(batch);
        await batch.commit();
      }, onUpgrade: (db, oldVersion, newVersion) async {
        var batch = db.batch();
        if (oldVersion == 1) {
          print("数据库版本1.0 -> 2.0，onUpgrade");
          _updateTablesV1ToV2(batch);
        }
        await batch.commit();
      }
    );
    return database;
  }

  Future closeDatabase() async {
    var database = await db;
    await database.close();
  }

  // 数据表2.0
  void _createVersion2Tables(Batch batch) {
    batch.execute(HomeBannerDB.createTableSql());
    batch.execute(KnowledgeTreeNodeDB.createTableSql());
    batch.execute(NavigationNodeDB.createSuperNodeTableSql());
    batch.execute(NavigationNodeDB.createSubNodeTableSql());
    //升级1：文章表增加了三个字段
    batch.execute(HomeArticleDB.createTableSqlV2());
    //升级2：增加了项目节点表
    batch.execute(ProjectModuleDB.createNodeTableSql());
  }

  // 数据表1.0 升级 2.0
  void _updateTablesV1ToV2(Batch batch) {
    /* 
      [sqflite 数据库更新](https://github.com/tekartik/sqflite/blob/master/sqflite/doc/migration_example.md)
     */ 
    //升级1：给文章表增加4个字段
    var tabelName = HomeArticleDB.tableHomeArticle;
    batch.execute('ALTER TABLE $tabelName ADD desc TEXT DEFAULT ""');
    batch.execute('ALTER TABLE $tabelName ADD envelopePic TEXT DEFAULT ""');
    batch.execute('ALTER TABLE $tabelName ADD chapterId INTEGER DEFAULT 0');
    batch.execute('ALTER TABLE $tabelName ADD articleType INTEGER DEFAULT 0');
    //升级2：增加项目节点表
    batch.execute(ProjectModuleDB.createNodeTableSql());
  }
}