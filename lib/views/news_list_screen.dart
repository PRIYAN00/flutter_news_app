import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_news_app/controllers/news_controller.dart';
import 'package:flutter_news_app/views/news_detail_screen.dart';
import 'package:intl/intl.dart';

class NewsListScreen extends StatefulWidget {
  final String category;

  const NewsListScreen({Key? key, required this.category}) : super(key: key);

  @override
  _NewsListScreenState createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<NewsController>(context, listen: false)
            .fetchNews(category: widget.category));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category.capitalize()} News'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String result) {
              if (result == 'newest') {
                Provider.of<NewsController>(context, listen: false)
                    .sortNewsByDate(ascending: false);
              } else if (result == 'oldest') {
                Provider.of<NewsController>(context, listen: false)
                    .sortNewsByDate(ascending: true);
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'newest',
                child: Text('Sort by Newest'),
              ),
              const PopupMenuItem<String>(
                value: 'oldest',
                child: Text('Sort by Oldest'),
              ),
            ],
          ),
        ],
      ),
      body: Consumer<NewsController>(
        builder: (context, newsController, child) {
          if (newsController.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemCount: newsController.articles.length,
              itemBuilder: (context, index) {
                final article = newsController.articles[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewsDetailScreen(article: article),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                          child: article.urlToImage.isNotEmpty
                              ? Image.network(
                                  article.urlToImage,
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                        height: 200,
                                        color: Theme.of(context).colorScheme.secondary,
                                        child: Icon(Icons.error, size: 50, color: Theme.of(context).colorScheme.onSecondary),
                                      ),
                                )
                              : Container(
                                  height: 200,
                                  color: Theme.of(context).colorScheme.secondary,
                                  child: Icon(Icons.article, size: 50, color: Theme.of(context).colorScheme.onSecondary),
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                article.title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    DateFormat('MMM dd, yyyy').format(article.publishedAt),
                                    style: TextStyle(
                                      color: Theme.of(context).textTheme.bodySmall?.color,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Icon(Icons.arrow_forward, size: 16, color: Theme.of(context).primaryColor),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}