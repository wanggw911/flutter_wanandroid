import 'package:flutter_wanandroid/database/database_hander.dart';
import 'package:flutter_wanandroid/model/home_article.dart';

class HomeArticleDB {
  static final String tableHomeArticle = 'HomeArticle';
  static final String id = 'id';
  static final String title = 'title';
  static final String author = 'author';
  static final String chapterName = 'chapterName';
  static final String superChapterName = 'superChapterName';
  static final String niceDate = 'niceDate';
  static final String fresh = 'fresh';
  static final String link = 'link';
  static final String projectLink = 'projectLink';

  static createTableSql() {
    return '''
      CREATE TABLE $tableHomeArticle (
      $id INTEGER PRIMARY KEY, 
      $title TEXT, 
      $author TEXT, 
      $chapterName TEXT, 
      $superChapterName TEXT, 
      $niceDate TEXT, 
      $fresh INTEGER, 
      $link TEXT,
      $projectLink TEXT
      )''';
  }

  //操作一：增
  static Future insertWith(List<Article> list) async {
    print('Article List 准备插入数据的条数：${list.length}');

    var database = await DatabaseHander.shared.db;
    
    var count = 0;
    await database.transaction((txn) async {
      list.forEach((article) async {
        var insertSql = '''
            INSERT INTO $tableHomeArticle($id, $title, $author, $chapterName, $superChapterName, $niceDate, $fresh, $link, $projectLink) 
            VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)
            ''';
        await txn.rawInsert(insertSql, [article.id, article.title, article.author, article.chapterName, article.superChapterName, article.niceDate, article.fresh?1:0, article.link, article.projectLink]);
        count++;
        print('Article List 成功插入数据的条数：$count');
      });
    });

    //TODO: 数据库关闭的时机需要考虑好在什么时候关闭
    //await DatabaseHander.shared.closeDatabase();
  }

  static Future<List<Article>> selectAll() async {
    List<Article> list = [];

    var database = await DatabaseHander.shared.db;
    List<Map> datalist = await database.rawQuery('SELECT * FROM $tableHomeArticle');
    datalist.forEach((item) {
      list.add(Article.fromJson(item));
    });
    //await DatabaseHander.shared.closeDatabase();

    return list;
  }  
}