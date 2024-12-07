import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_news_app/models/article.dart';

class NewsController with ChangeNotifier {
  List<Article> _articles = [];
  List<Article> get articles => _articles;

  String _selectedCategory = 'general';
  String get selectedCategory => _selectedCategory;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final String _apiKey = const String.fromEnvironment('API_KEY');
  final String _baseUrl = 'https://newsapi.org/v2';

  Future<void> fetchNews({String category = 'general'}) async {
    _isLoading = true;
    notifyListeners();

    final response = await http.get(
      Uri.parse('$_baseUrl/top-headlines?country=us&category=$category&apiKey=$_apiKey'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _articles = (data['articles'] as List)
          .map((article) => Article.fromJson(article))
          .toList();
      _selectedCategory = category;
    } else {
      throw Exception('Failed to load news');
    }

    _isLoading = false;
    notifyListeners();
  }

  void sortNewsByDate({bool ascending = true}) {
    _articles.sort((a, b) => ascending
        ? a.publishedAt.compareTo(b.publishedAt)
        : b.publishedAt.compareTo(a.publishedAt));
    notifyListeners();
  }

  Future<List<Article>> searchNews(String query) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/everything?q=$query&apiKey=$_apiKey'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['articles'] as List)
          .map((article) => Article.fromJson(article))
          .toList();
    } else {
      throw Exception('Failed to search news');
    }
  }
}