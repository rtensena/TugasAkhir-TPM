import 'dart:typed_data';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute(
            'CREATE TABLE users(id INTEGER PRIMARY KEY, username TEXT, password TEXT, image BLOB)');
      },
    );
  }

  Future<void> insertUser(
      String username, String password, Uint8List? image) async {
    final db = await database;
    await db.insert(
        'users', {'username': username, 'password': password, 'image': image});
  }

  Future<Map<String, dynamic>?> getUser(
      String username, String password) async {
    final db = await database;
    final result = await db.query('users',
        where: 'username = ? AND password = ?',
        whereArgs: [username, password]);
    return result.isNotEmpty ? result.first : null;
  }
}
