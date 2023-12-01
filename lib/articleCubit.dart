import 'bloc_states.dart';
import 'cubits.dart';

class Article {
  final String id;
  final String title;
  final String content;

  Article({
    required this.id,
    required this.title,
    required this.content,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
        id: json['id'], title: json['title'], content: json['content']);
  }
}

List<Article?> articles = [
  Article(id: 'ID: 1', title: 'Article Title 1', content: 'Article Content 1'),
  Article(id: 'ID: 2', title: 'Article Title 2', content: 'Article Content 2'),
 
];

class ArticleCubit extends GetDataCubit {
  InitialState initState;
  ArticleCubit({required this.initState}) : super(initState);

  Future<Article?> _getArticle() async {
    //Here i mimic api call
    return await Future.delayed(
        const Duration(
          milliseconds: 2000,
        ), () async {
      //Just to create different state Data not found and error states
      if ((initState.data as int) == 3) {
        return null;
      } else {
        //Using array of article
        return articles[initState.data as int];
      }
    });
  }

  getArticle() {
    super.emitDataState<Article?>(
      fetchData: _getArticle,
      errorMessage: 'Something went wrong!',
      dataNotFoundMessage: 'Article not found',
    );
  }
}
