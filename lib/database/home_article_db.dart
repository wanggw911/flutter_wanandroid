import 'package:flutter_wanandroid/database/database_hander.dart';
import 'package:flutter_wanandroid/model/home_article.dart';
import 'package:sqflite/sqflite.dart';

enum ArticleType {
  Home,
  Konwlege,
  Project
}

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
  static final String desc = 'desc';
  static final String projectLink = 'projectLink';
  static final String envelopePic = 'envelopePic';
  static final String chapterId = 'chapterId';
  static final String articleType = 'articleType'; //用来区分文章属于的模块
  
  static createTableSqlV1() {
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

  static createTableSqlV2() {
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
      $desc TEXT,
      $projectLink TEXT, 
      $envelopePic TEXT, 
      $chapterId INTEGER, 
      $articleType INTEGER
      )''';
  }

  //操作一：增
  static Future insertWith(List<Article> list, ArticleType articlesType) async {
    print('Article List 准备插入数据的条数：${list.length}');

    var database = await DatabaseHander.shared.db;
    await database.transaction((txn) async {
      list.forEach((article) async {
        var insertSql = '''
        insert or replace into $tableHomeArticle($id, $title, $author, $chapterName, $superChapterName, $niceDate, $fresh, $link, $desc, $projectLink, $envelopePic, $chapterId, $articleType) 
        values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''';
        await txn.rawInsert(insertSql, 
        [article.id, article.title, article.author, article.chapterName, article.superChapterName, article.niceDate, article.fresh?1:0, article.link, article.desc, article.projectLink, article.envelopePic, article.chapterId, articlesType.index]);
      });
    });

    //TODO: 数据库关闭的时机需要考虑好在什么时候关闭
    //await DatabaseHander.shared.closeDatabase();
  }

  static Future<List<Article>> selectWith(ArticleType articleType, {int chapterIdValue = -1}) async {
    List<Article> list = [];

    var database = await DatabaseHander.shared.db;
    var selectSql = "";
    if (chapterIdValue > 0) {
      selectSql = 'select * from $tableHomeArticle where articleType=${articleType.index} and chapterId=$chapterIdValue';
    }
    else {
      selectSql = 'select * from $tableHomeArticle where articleType=${articleType.index}';
    }
    List<Map> datalist = await database.rawQuery(selectSql);
    datalist.forEach((item) {
      list.add(Article.fromJson(item));
    });
    //await DatabaseHander.shared.closeDatabase();

    return list;
  }  
}