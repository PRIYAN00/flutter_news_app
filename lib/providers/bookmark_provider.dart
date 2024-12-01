import 'package:flutter/foundation.dart';
import 'package:flutter_news_app/models/article.dart';
import 'package:flutter_news_app/models/bookmark.dart';
import 'package:flutter_news_app/db/database_helper.dart';
import 'package:uuid/uuid.dart';

class BookmarkProvider extends ChangeNotifier {
  List<Bookmark> _bookmarks = [];
  List<Bookmark> get bookmarks => _bookmarks;

  BookmarkProvider() {
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    _bookmarks = await DatabaseHelper.instance.getAllBookmarks();
    notifyListeners();
  }

  Future<void> addBookmark(Article article) async {
    final bookmark = Bookmark(
      id: const Uuid().v4(),
      article: article,
      createdAt: DateTime.now(),
    );
    await DatabaseHelper.instance.insertBookmark(bookmark);
    _bookmarks.add(bookmark);
    notifyListeners();
  }

  Future<void> removeBookmark(String id) async {
    await DatabaseHelper.instance.deleteBookmark(id);
    _bookmarks.removeWhere((bookmark) => bookmark.id == id);
    notifyListeners();
  }

  Future<bool> isBookmarked(Article article) async {
    return await DatabaseHelper.instance.isBookmarked(article.url);
  }

  Future<Bookmark?> getBookmark(Article article) async {
    return await DatabaseHelper.instance.getBookmark(article.url);
  }
}

