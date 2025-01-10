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
            username TEXT UNIQUE,
            password TEXT,
            firstLogin INTEGER DEFAULT 1
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
  Future<bool> isFirstLogin() async {
    final db = await DatabaseHelper.instance.database;
    final res = await db.query('users', limit: 1);
    if (res.isNotEmpty) {
      return res.first['firstLogin'] == 1;
    }
    return true; // If no user exists, it's a first login
  }

  Future<void> setFirstLoginCompleted() async {
    final db = await DatabaseHelper.instance.database;
    await db.update('users', {'firstLogin': 0});
  }

  // User Management
  Future<int> registerUser(String username, String password) async {
    try {
      final db = await database;
      final res = await db.insert(
        'users',
        {'username': username, 'password': password},
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
      return res;
    } catch (e) {
      throw Exception('Error registering user: $e');
    }
  }

  Future<Map<String, dynamic>?> loginUser(String username, String password) async {
    final db = await database;
    final res = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return res.isNotEmpty ? res.first : null;
  }

  Future<bool> userExists(String username) async {
    final db = await database;
    final res = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    return res.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> fetchAllUsers() async {
    final db = await database;
    return await db.query('users');
  }

  // Pin Management
  Future<String?> getPin() async {
    final db = await database;
    final res = await db.query('pin', limit: 1);
    return res.isNotEmpty ? res.first['pin'] as String : null;
  }

  Future<int> savePin(String pin) async {
    final db = await database;
    final existingPin = await getPin();
    if (existingPin != null) {
      return await db.update('pin', {'pin': pin});
    } else {
      return await db.insert('pin', {'pin': pin});
    }
  }

  Future<int> deletePin() async {
    final db = await database;
    return await db.delete('pin');
  }

  // Clear all data (Optional utility for debugging)
  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('users');
    await db.delete('pin');
  }
}
