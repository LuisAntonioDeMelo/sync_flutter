import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  DbHelper.internal();
  static final DbHelper instance = new DbHelper.internal();
  factory DbHelper() => instance;

  static final contatoTable = 'contatoTable';
  static final _version = 1;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return db;
  }

  Future<Database> initDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = join(directory.path, 'syncdatabase.db');
    print(dbPath);
    var openDb = await openDatabase(dbPath, version: _version,
        onCreate: (Database db, int version) async {
      await db.execute(""" 
          CREATE TABLE $contatoTable (
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          user_id INTEGER NOT NULL, 
          name TEXT, 
          email TEXT, 
          gender TEXT, 
          created_at TEXT
          )""");
    }, onUpgrade: (Database db, int oldversion, int newversion) async {
      if (oldversion < newversion) {
        print("Version Upgrade");
      }
    });
    print('db init');
    return openDb;
  }
}
