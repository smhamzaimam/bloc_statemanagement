import 'package:bloc_statemanagement/generic_states.dart';
import 'package:bloc_statemanagement/generic_cubits.dart';
import 'package:bloc_statemanagement/dbServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../article_model.dart';
import 'article_screen.dart';

class ArticleListingScreen extends StatefulWidget {
  final bool showEmptyState, showErrorState;
  const ArticleListingScreen(
      {super.key, this.showEmptyState = false, this.showErrorState = false});

  @override
  State<ArticleListingScreen> createState() => _ArticleListingScreenState();
}

class _ArticleListingScreenState extends State<ArticleListingScreen> {
  late GetPaginatedDataCubit<Article> _articlesListCubit;
  late DataBaseServices _db;
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _db = DataBaseServices(
      showEmptyState: widget.showEmptyState,
      showErrorState: widget.showErrorState,
    );
//Initialzing the pagination cubit and passing api call function error message and empty state message
    _articlesListCubit = GetPaginatedDataCubit.initialize(
        initialState: InitialState(null),
        dataFetchFunction: _db.getArticles,
        errorMessage: 'Something went wrong.',
        dataNotFoundMessage: 'Articles not found.');
//API call to get initial data of page 1 which starts loading on screen
    _articlesListCubit.getData();
//Initializing the controller and condition to hit API call at the end of page
    _controller = ScrollController();
    _controller.addListener(() {
      if (_controller.position.maxScrollExtent == _controller.position.pixels) {
        _articlesListCubit.getData();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _articlesListCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Article Listing Screen'),
      ),
      //Wrapping with bloc provider
      body: BlocProvider<GetPaginatedDataCubit<Article>>(
        create: (context) {
          return _articlesListCubit;
        },
        child: RefreshIndicator(
          onRefresh: () async {
            //passing refresh check true to reset the pagination cubit
            _articlesListCubit.getData(refreshPagination: true);
          },
          // consumer to update UI accoring to states emit from cubit
          child: BlocConsumer<GetPaginatedDataCubit<Article>, BlocState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state is UpdatePageState) {
                  return ListView.separated(
                      controller: _controller,
                      padding: const EdgeInsets.all(10),
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
                            leading:Text('Article ID: ${article.id}'),
                            title: Text(article.title),
                            subtitle: Text(article.content),
                            tileColor: Colors.deepPurple[100],
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return ArticleScreen(articleId: article.id,);
                              }));
                            },
                          );
                        } else {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
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
