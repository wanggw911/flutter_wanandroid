
import 'package:flutter_wanandroid/database/database_hander.dart';
import 'package:flutter_wanandroid/model/home_banner.dart';

class HomeBannerDB {
  static final String tableHomeBanner = 'HomeBanner';
  static final String id = 'id';
  static final String title = 'title';
  static final String desc = 'desc';
  static final String imagePath = 'imagePath';
  static final String url = 'url';
  
  static createTableSql() {
    return '''
      CREATE TABLE $tableHomeBanner (
      $id INTEGER PRIMARY KEY, 
      $title TEXT, 
      $desc TEXT, 
      $imagePath TEXT, 
      $url TEXT
      )''';
  }

  //操作一：增
  static Future insertWith(List<HomeBanner> list) async {
    print('Banner List 准备插入数据的条数：${list.length}');
    var database = await DatabaseHander.shared.db;    
    await database.transaction((txn) async {
      list.forEach((banner) async {
        var insertSql = '''
        insert or replace into $tableHomeBanner($id, $title, $desc, $imagePath, $url)
        values(?, ?, ?, ?, ?)
        ''';
        await txn.rawInsert(insertSql, [banner.id, banner.title, banner.desc, banner.imagePath, banner.url]);
      });
    });

    //数据库关闭的时机需要考虑好在什么时候关闭
    //await DatabaseHander.shared.closeDatabase();
  }

  static Future<List<HomeBanner>> selectAll() async {
    List<HomeBanner> list = [];

    var database = await DatabaseHander.shared.db;
    List<Map> datalist = await database.rawQuery('SELECT * FROM $tableHomeBanner');
    datalist.forEach((item) {
      list.add(HomeBanner.fromJson(item));
    });

    //T数据库关闭的时机需要考虑好在什么时候关闭
    //await DatabaseHander.shared.closeDatabase();

    return list;
  } 
}