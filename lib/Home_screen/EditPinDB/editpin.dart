import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('pin.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
      CREATE TABLE pin (
        id $idType,
        pin $textType
      )
    ''');
  }

  Future<int> insertPin(String pin) async {
    final db = await instance.database;
    final id = await db.insert('pin', {'pin': pin});
    return id;
  }

  Future<String?> getPin() async {
    final db = await instance.database;
    final result = await db.query('pin', limit: 1);
    if (result.isNotEmpty) {
      return result.first['pin'] as String?;
    }
    return null;
  }

  Future<int> updatePin(String newPin) async {
    final db = await instance.database;
    final count = await db.update(
      'pin',
      {'pin': newPin},
      where: 'id = ?',
      whereArgs: [1],
    );
    return count;
  }
}
