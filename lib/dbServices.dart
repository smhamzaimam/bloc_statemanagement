import 'article_model.dart';

class DataBaseServices {
  final bool showEmptyState, showErrorState;
  DataBaseServices({
     this.showEmptyState = false,
     this.showErrorState = false,
  });
  Future<List<Article>> getArticles(int page) async {
    return Future.delayed(const Duration(milliseconds: 1000), () {
      List<Article> articles = [];
      if (showEmptyState) {
        return articles;
      }
      if (showErrorState) {
        throw '';
      }
      if (page < 5) {
        int id = (page - 1) * 10;
        for (int i = 1; i <= 10; i++) {
          final articleID = id + i;
          articles.add(Article(
            id: articleID,
            title: 'Article Title $articleID',
            content: 'Article Content $articleID',
          ));
        }
      }
      return articles;
    });
  }

  Future<Article?> getArticle(int articleID)async{
    return await Future.delayed(
        const Duration(
          milliseconds: 1000,
        ), () async {
          final id = articleID-1;
      //Just to create different state Data not found and error states
      if (id == 2) {
        return null;
      } else {
        //Using array of article
        return articles[id];
      }
    });
   
  }
}
