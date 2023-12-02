import 'package:bloc_statemanagement/bloc_states.dart';
import 'package:bloc_statemanagement/cubits.dart';
import 'package:bloc_statemanagement/cubits/articleCubit.dart';
import 'package:bloc_statemanagement/cubits/articleListingCubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArticleListingScreen extends StatefulWidget {
  const ArticleListingScreen({super.key});

  @override
  State<ArticleListingScreen> createState() => _ArticleListingScreenState();
}

class _ArticleListingScreenState extends State<ArticleListingScreen> {
  late GetPaginatedDataCubit<Article> _articlesListCubit;
  late DataBaseServices _db;
  late ScrollController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _db = DataBaseServices();
    _articlesListCubit = GetPaginatedDataCubit.initialize(
        initialState: InitialState(null),
        dataFetchFunction: _db.getArticles,
        errorMessage: 'Something went wrong.',
        dataNotFoundMessage: 'Articles not found.');
    _articlesListCubit.getData();
    _controller = ScrollController();
    _controller.addListener(() {
      if (_controller.position.maxScrollExtent == _controller.position.pixels) {
        _articlesListCubit.getData();
      }
    });
    _articlesListCubit.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Article Listing Screen'),
      ),
      body: BlocProvider<GetPaginatedDataCubit<Article>>(
        create: (context) {
          return _articlesListCubit;
        },
        child: RefreshIndicator(
          onRefresh: () async {
            _articlesListCubit.getData(refreshPagination: true);
          },
          child: BlocConsumer<GetPaginatedDataCubit<Article>, BlocState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state is UpdatePageState) {
                  return ListView.separated(
                      controller: _controller,
                      padding:const  EdgeInsets.all(10),
                      itemCount: _articlesListCubit.getDataLength() +
                          (state.hasMoreData ? 1 : 0),
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 10,
                        );
                      },
                      itemBuilder: (context, index) {
                        if (index < _articlesListCubit.getDataLength()) {
                          final article = _articlesListCubit.getListItem(index);
                          return ListTile(
                            leading: Text(article.id),
                            title: Text(article.title),
                            subtitle: Text(article.content),
                            tileColor: Colors.deepPurple[100],
                          ); 
                        }else{
                          return const Center(child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ),);
                        }
                      });
                } else if (state is DataNotFoundState) {
                  return Center(
                    child: Text(state.message),
                  );
                } else if (state is ErrorState) {
                  return Center(
                    child: Text(state.message),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ),
      ),
    );
  }
}
