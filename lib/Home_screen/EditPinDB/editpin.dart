import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app.db');
    return _database!;
  }

  Future<Database> _initDB(String path) async {
    final dbPath = await getDatabasesPath();
    final fullPath = join(dbPath, path);
    return await openDatabase(
      fullPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT,
            password TEXT
          );
        ''');
        await db.execute('''
          CREATE TABLE pin(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            pin TEXT
          );
        ''');
      },
    );
  }

  Future<int> registerUser(String username, String password) async {
    final db = await database;
    final res = await db.insert('users', {'username': username, 'password': password});
    return res;
  }

  Future<Map<String, dynamic>?> loginUser(String username, String password) async {
    final db = await database;
    final res = await db.query('users', where: 'username = ? AND password = ?', whereArgs: [username, password]);
    if (res.isNotEmpty) {
      return res.first;
    }
    return null;
  }

  Future<String?> getPin() async {
    final db = await instance.database;
    final res = await db.query('pin', limit: 1);
    if (res.isNotEmpty) {
      return res.first['pin'] as String;
    }
    return null;
  }

  Future<int> savePin(String pin) async {
    final db = await instance.database;
    await db.delete('pin'); // Clear previous PIN
    final res = await db.insert('pin', {'pin': pin});
    return res;
  }
  // Future<int> deleteAllUsers() async {
  //   final db = await database;
  //   return await db.delete('users'); // Deletes all user rows
  // }
  Future<int> deletePin() async {
    final db = await database;
    return await db.delete('pin'); // Deletes all rows in the pin table
  }


}
