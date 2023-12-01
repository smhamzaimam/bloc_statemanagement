import 'package:bloc_statemanagement/screen/article_screen.dart';
import 'package:flutter/material.dart';

class ArticleListingScreen extends StatefulWidget {
  const ArticleListingScreen({super.key});

  @override
  State<ArticleListingScreen> createState() => _ArticleListingScreenState();
}

class _ArticleListingScreenState extends State<ArticleListingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bloc State Management',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...List.generate(2, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ArticleScreen(articleId: index);
                      }));
                    },
                    child: Text('Article ${index + 1} Data found state')),
              );
            }),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const ArticleScreen(articleId: 3);
                    }));
                  },
                  child: const Text('Article not found state')),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const ArticleScreen(articleId: 4);
                    }));
                  },
                  child: const Text('Article error state')),
            )
          ],
        ),
      ),
    );
  }
}
