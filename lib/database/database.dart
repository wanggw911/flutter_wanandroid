
import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart'; //join method need import
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
    _db = await initDatabase();
    return _db;
  }
 
  Future testDatabase() async {
    // open the database
    Database database = await initDatabase();
    if (database == null) {
      print('database == null，could not load database！！！');
      return;
    }

    await insertValueToTestWith(database);
    await selectValueToTestWith(database);

    await updateValueToTestWith(database);
    await selectValueToTestWith(database); 

    await deleteValueToTestWith(database);
    await selectValueToTestWith(database);

    await closeDatabaseWith(database);
  }

  Future<Database> initDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');
    print('path = $path');
  
    Database database = await openDatabase(path, 
      version: 1,
      onCreate: (Database db, int version) async {
        print('when table is not exist, will create the table in xxx.db');
        // When creating the db, create the table
        var sql = 'CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)';
        await db.execute(sql);
    });
    return database;
  }

  Future<File> _getLocalFile(String path) async {
    return File('$path');
  }

  Future closeDatabaseWith(Database database) async {
    // Close the database
    await database.close();
  }

  //操作一：增
  Future insertValueToTestWith(Database database) async {
    // Insert some records in a transaction
    await database.transaction((txn) async {
      var insertSql1 = 'INSERT INTO Test(name, value, num) VALUES("some name", 1234, 456.789)';
      int id1 = await txn.rawInsert(insertSql1);
      print('inserted1: $id1');
      var insertSql2 = 'INSERT INTO Test(name, value, num) VALUES(?, ?, ?)';
      int id2 = await txn.rawInsert(insertSql2, ['another name', 12345678, 3.1416]);
      print('inserted2: $id2');
    });
  }

  //操作二：删
  Future deleteValueToTestWith(Database database) async {
    // Delete a record
    var sql = 'DELETE FROM Test WHERE name = ?';
    int count = await database.rawDelete(sql, ['another name']);
    assert(count == 1);
  }

  //操作三：改
  Future updateValueToTestWith(Database database) async {
    // Update some record
    var sql = 'UPDATE Test SET name = ?, VALUE = ? WHERE name = ?';
    int count = await database.rawUpdate(sql, ['updated name', '9876', 'some name']);
    print('updated: $count');
  }

  //操作四：查
  Future selectValueToTestWith(Database database) async {
    // Get the records
    List<Map> list = await database.rawQuery('SELECT * FROM Test');
    List<Map> expectedList = [
      {'name': 'updated name', 'id': 1, 'value': 9876, 'num': 456.789},
      {'name': 'another name', 'id': 2, 'value': 12345678, 'num': 3.1416}
    ];
    print(list);
    print(expectedList);
    //assert(const DeepCollectionEquality().equals(list, expectedList));
  }
}