import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:smartup/models/job_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  static Future<Database> initDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, "smartup.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT UNIQUE,
            password TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE IF NOT EXISTS categories(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT UNIQUE,
            icon INTEGER
          )
        ''');

        await db.execute('''
          CREATE TABLE IF NOT EXISTS jobs(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            vendorId TEXT,
            contact TEXT,
            imageUrl TEXT,
            rate REAL,
            lat REAL,
            lng REAL,
            locationName TEXT,
            category TEXT
          )
        ''');

        // Insert default data from JSON
        await _insertDefaultCategoriesFromJson(db);
        await _insertDefaultJobsFromJson(db);
      },
    );
  }

  // ---------------- User Methods ----------------
  static Future<int> insertUser(String email, String password) async {
    final db = await database;
    return await db.insert('users', {
      'email': email,
      'password': password,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<bool> validateUser(String email, String password) async {
    final db = await database;
    final res = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return res.isNotEmpty;
  }

  static Future<Map<String, dynamic>?> getUser(
    String email,
    String password,
  ) async {
    final db = await database;
    final res = await db.query(
      'users',
      where: "email = ? AND password = ?",
      whereArgs: [email, password],
    );
    return res.isNotEmpty ? res.first : null;
  }

  // ---------------- Category Methods ----------------
  static Future<int> insertCategory(Map<String, dynamic> category) async {
    final db = await database;
    return await db.insert(
      'categories',
      category,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getCategories() async {
    final db = await database;
    return await db.query('categories');
  }

  // ---------------- Job Methods ----------------
  static Future<int> insertJob(Map<String, dynamic> job) async {
    final db = await database;
    return await db.insert(
      'jobs',
      job,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getJobs() async {
    final db = await database;
    return await db.query('jobs');
  }

  static Future<Map<String, dynamic>?> getJobById(int id) async {
    final db = await database;
    final res = await db.query('jobs', where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? res.first : null;
  }

  static Future<List<Job>> getJobsByCategory(String category) async {
    final db = await database;
    final res = await db.query(
      'jobs',
      where: 'category = ?',
      whereArgs: [category],
    );
    return res.map((e) => Job.fromMap(e)).toList();
  }

  // ---------------- Default JSON Import ----------------
  static Future<void> _insertDefaultCategoriesFromJson(Database db) async {
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM categories'),
    );
    if (count == 0) {
      String jsonString = await rootBundle.loadString('assets/categories.json');
      List<dynamic> data = json.decode(jsonString);
      final batch = db.batch();
      for (var cat in data) {
        batch.insert('categories', {
          'name': cat['name'],
          'icon': cat['icon'], // store icon as int
        });
      }
      await batch.commit(noResult: true);
    }
  }

  static Future<void> _insertDefaultJobsFromJson(Database db) async {
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM jobs'),
    );
    if (count == 0) {
      String jsonString = await rootBundle.loadString('assets/jobs.json');
      List<dynamic> data = json.decode(jsonString);
      final batch = db.batch();
      for (var job in data) {
        batch.insert('jobs', job);
      }
      await batch.commit(noResult: true);
    }
  }
}
