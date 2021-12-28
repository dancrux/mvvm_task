import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppSqliteDb {
  static Database? sqliteDb;
  static String dbName = 'database1.db';
  static Future init() async {
    String databasePath = await getDatabasesPath();
    String usersDbPath = join(databasePath, dbName);
    sqliteDb = await openDatabase(usersDbPath, version: 1,
        onCreate: (Database db, int version) async {
      db.execute('''CREATE TABLE IF NOT EXISTS user(email TEXT)''');
    });
  }
}
