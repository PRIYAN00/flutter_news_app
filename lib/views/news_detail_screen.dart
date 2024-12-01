import 'package:flutter/material.dart';
import 'package:flutter_news_app/models/article.dart';
import 'package:flutter_news_app/providers/bookmark_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class NewsDetailScreen extends StatelessWidget {
  final Article article;

  const NewsDetailScreen({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Consumer<BookmarkProvider>(
            builder: (context, bookmarkProvider, child) {
              return FutureBuilder<bool>(
                future: bookmarkProvider.isBookmarked(article),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  final isBookmarked = snapshot.data ?? false;
                  return IconButton(
                    icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border),
                    onPressed: () async {
                      if (isBookmarked) {
                        final bookmark = await bookmarkProvider.getBookmark(article);
                        if (bookmark != null) {
                          await bookmarkProvider.removeBookmark(bookmark.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Bookmark removed')),
                          );
                        }
                      } else {
                        await bookmarkProvider.addBookmark(article);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Bookmark added')),
                        );
                      }
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.urlToImage.isNotEmpty)
              Image.network(
                article.urlToImage,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  color: Theme.of(context).colorScheme.secondary,
                  child: Icon(Icons.error, size: 50, color: Theme.of(context).colorScheme.onSecondary),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Published on ${DateFormat('MMM dd, yyyy').format(article.publishedAt)}',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(article.description),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

