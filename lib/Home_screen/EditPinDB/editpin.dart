import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'pin_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE pin(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            pin TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertPin(String pin) async {
    final db = await database;
    await db.insert(
      'pin',
      {'pin': pin},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  Future<String?> getPin() async {
    final db = await database;
    List<Map> result = await db.query('pin');
    if (result.isNotEmpty) {
      return result.first['pin'] as String?;
    }
    return null; // No pin saved in database
  }

  Future<void> updatePin(String newPin) async {
    final db = await database;
    await db.update(
      'pin',
      {'pin': newPin},
      where: 'id = ?',
      whereArgs: [1], // Assuming you have one row in the table
    );
  }
}