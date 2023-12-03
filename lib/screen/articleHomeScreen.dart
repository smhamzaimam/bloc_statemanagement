import 'package:bloc_statemanagement/screen/article_listing_screen.dart';
import 'package:bloc_statemanagement/screen/article_screen.dart';
import 'package:flutter/material.dart';

class ArticleHomeScreen extends StatefulWidget {
  const ArticleHomeScreen({super.key});

  @override
  State<ArticleHomeScreen> createState() => _ArticleHomeScreenState();
}

class _ArticleHomeScreenState extends State<ArticleHomeScreen> {
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const ArticleListingScreen();
                    }));
                  },
                  child: const Text('Article Listing (With pagination)')),
            ),
            
            
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const ArticleListingScreen(showEmptyState: true,);
                    }));
                  },
                  child: const Text('Article Listing (No Article Found)')),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const ArticleListingScreen(showErrorState: true,);
                    }));
                  },
                  child: const Text('Article Listing (Error State)')),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const ArticleScreen(articleId: 3);
                    }));
                  },
                  child: const Text('Article Screen (No Data Found)')),
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
                  child: const Text('Article Screen (Error State)')),
            ),
          ],
        ),
      ),
    );
  }
}
