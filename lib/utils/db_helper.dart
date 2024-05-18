import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' show Platform;

class DBHelper {
  static const String _databaseName = 'decks.db1';
  static const int _databaseVersion = 1;

  DBHelper._();

  static final DBHelper _singleton = DBHelper._();

  factory DBHelper() => _singleton;

  Database? _database;

  get db async {
    _database ??= await _initDatabase();
    
    return _database;
  }

  Future<Database> _initDatabase() async {

    var dbDir = await getApplicationDocumentsDirectory();

    var dbPath = path.join(dbDir.path, _databaseName);

    // await deleteDatabase(dbPath);

    var db = await openDatabase(
      dbPath, 
      version: _databaseVersion, 

      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE user_data(
            id INTEGER PRIMARY KEY,
            email varchar(255),
            username TEXT,
            password TEXT,
            loggedIn BOOL
          )
        ''');
      }
    );

    return db;
  }

  Future<List<Map<String, dynamic>>> query(String table, {String? where}) async {
    final db = await this.db;
    return where == null ? db.query(table)
                         : db.query(table, where: where);
  }

  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await this.db;
    int id = await db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

    Future<int> insertData(String table, Map<String, dynamic> data) async {
    final db = await this.db;
    int userId = await db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return userId;
  }

  Future<void> update(String table, Map<String, dynamic> data, int id) async {
    final db = await this.db;
    await db.update(
      table,
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateData(String table, Map<String, dynamic> data, int userId) async {
    final db = await this.db;
    await db.update(
      table,
      data,
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  Future<int?> count(int userId) async {
    final db = await this.db;
     final count = Sqflite.firstIntValue(
      await db.rawQuery(
        'SELECT COUNT(*) FROM card_info WHERE id = ?', 
        [userId]
      )
    );
    return count;
  }
}