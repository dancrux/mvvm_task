import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppSqliteDb {
  static Database? sqliteDb;
  static String sqliteDbName = 'db1.db';

  static Future init() async {
    String databasePath = await getDatabasesPath();
    String userDbPath = join(databasePath, '$sqliteDbName');

    sqliteDb = await openDatabase(userDbPath, version: 1,
        onCreate: (Database db, int version) async {
      db.execute('''CREATE TABLE IF NOT EXISTS userEmail(email Text)''');
    });
  }
}
