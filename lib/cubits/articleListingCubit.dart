import 'package:bloc_statemanagement/cubits/articleCubit.dart';

class DataBaseServices{

  Future<List<Article>> getArticles(int page)async{
    return Future.delayed(const Duration(milliseconds: 2000),(){
       List<Article> articles = [];
       if(page<5){
        int _id  = (page-1)*10;
        for(int i = 1;i <= 10;i++){
          final id = _id +i;
          articles.add(Article(id: id.toString(), title: 'Article Title $id', content: 'Article Content $id',));
        }
       }
       return articles;
    });
  }

}
