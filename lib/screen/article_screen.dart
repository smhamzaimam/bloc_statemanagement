import 'package:bloc_statemanagement/cubits/articleCubit.dart';
import 'package:bloc_statemanagement/bloc_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArticleScreen extends StatefulWidget {
  final int articleId;
  const ArticleScreen({super.key, required this.articleId});

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  late ArticleCubit articleCubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    articleCubit = ArticleCubit(initState: InitialState(widget.articleId));
    articleCubit.getArticle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Article ${widget.articleId+1}'),
      ),
      body: BlocProvider(
          create: (context) => articleCubit,
          child: BlocConsumer<ArticleCubit, BlocState>(
            builder: (context, state) {
              return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (state is LoadingState)
                  const  Center(child:  CircularProgressIndicator(color: Colors.deepPurple,)),
                  if (state is DataFoundState<Article?>) ...[
                     Text(state.data!.id),
                     Text(state.data!.title),
                     Text(state.data!.content),
                  ],
                  if (state is DataNotFoundState) Text(state.message),
                  if (state is ErrorState) Text(state.message),
                ],
              ));
            },
            listener: (context, state) {},
          )),
    );
  }
}
