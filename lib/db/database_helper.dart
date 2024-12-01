import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_news_app/models/bookmark.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('bookmarks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE bookmarks(
        id TEXT PRIMARY KEY,
        title TEXT,
        description TEXT,
        url TEXT,
        urlToImage TEXT,
        publishedAt TEXT,
        content TEXT,
        createdAt TEXT
      )
    ''');
  }

  Future<String> insertBookmark(Bookmark bookmark) async {
    final db = await instance.database;
    await db.insert('bookmarks', bookmark.toMap());
    return bookmark.id;
  }

  Future<List<Bookmark>> getAllBookmarks() async {
    final db = await instance.database;
    final result = await db.query('bookmarks');
    return result.map((json) => Bookmark.fromMap(json)).toList();
  }

  Future<int> deleteBookmark(String id) async {
    final db = await instance.database;
    return await db.delete('bookmarks', where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> isBookmarked(String url) async {
    final db = await instance.database;
    final result = await db.query(
      'bookmarks',
      where: 'url = ?',
      whereArgs: [url],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Future<Bookmark?> getBookmark(String url) async {
    final db = await instance.database;
    final result = await db.query(
      'bookmarks',
      where: 'url = ?',
      whereArgs: [url],
      limit: 1,
    );
    if (result.isNotEmpty) {
      return Bookmark.fromMap(result.first);
    }
    return null;
  }
}
