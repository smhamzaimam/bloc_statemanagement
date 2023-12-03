import 'package:bloc_statemanagement/article_model.dart';
import 'package:bloc_statemanagement/dbServices.dart';
import '../generic_states.dart';
import '../generic_cubits.dart';

class ArticleCubit extends GetDataCubit {
  InitialState initState;
  final DataBaseServices _db = DataBaseServices();
  ArticleCubit({required this.initState}) : super(initState);

  Future<Article?> _getArticle() async {
    //Here you can also add any business logic you want 
    return await _db.getArticle(initState.data as int);
  }

  getArticle() {
    super.emitDataState<Article?>(
      fetchData: _getArticle,
      errorMessage: 'Something went wrong!',
      dataNotFoundMessage: 'Article not found',
    );
  }
}
