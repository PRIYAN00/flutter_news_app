import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_news_app/controllers/news_controller.dart';
import 'package:flutter_news_app/models/article.dart';
import 'package:flutter_news_app/views/news_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  List<Article> _searchResults = [];
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search news...',
            border: InputBorder.none,
          ),
          onSubmitted: (value) => _performSearch(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => _performSearch(context),
          ),
        ],
      ),
      body: _isSearching
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final article = _searchResults[index];
                return ListTile(
                  leading: article.urlToImage.isNotEmpty
                      ? Image.network(
                          article.urlToImage,
                          width: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.error),
                        )
                      : Icon(Icons.article),
                  title: Text(article.title),
                  subtitle: Text(article.description),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsDetailScreen(article: article),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  void _performSearch(BuildContext context) async {
    setState(() {
      _isSearching = true;
    });

    try {
      final results = await Provider.of<NewsController>(context, listen: false)
          .searchNews(_searchController.text);
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _isSearching = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to search news')),
      );
    }
  }
}