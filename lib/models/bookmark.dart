import 'package:flutter_news_app/models/article.dart';

class Bookmark {
  final String id;
  final Article article;
  final DateTime createdAt;

  Bookmark({
    required this.id,
    required this.article,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': article.title,
      'description': article.description,
      'url': article.url,
      'urlToImage': article.urlToImage,
      'publishedAt': article.publishedAt.toIso8601String(),
      'content': article.content,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Bookmark.fromMap(Map<String, dynamic> map) {
    return Bookmark(
      id: map['id'],
      article: Article(
        title: map['title'],
        description: map['description'],
        url: map['url'],
        urlToImage: map['urlToImage'],
        publishedAt: DateTime.parse(map['publishedAt']),
        content: map['content'],
      ),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
