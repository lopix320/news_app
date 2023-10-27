import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'package:news_app/features/daily_news/presentation/bloc/article/remote/remote_article_event.dart';
import 'package:news_app/features/daily_news/presentation/bloc/article/remote/remote_article_state.dart';
import 'package:news_app/injection_container.dart';

import '../../../domain/entities/article.dart';
import '../../widgets/article_tile.dart';

class DailyNews extends StatefulWidget {
  const DailyNews({Key? key}) : super(key: key);

  @override
  State<DailyNews> createState() => _DailyNewsState();
}

class _DailyNewsState extends State<DailyNews> {
  late final RemoteArticlesBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = RemoteArticlesBloc(sl());
    bloc.inputArticle.add(GetArticles());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    bloc.inputArticle.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(context),
      body: StreamBuilder(
        stream: bloc.stream,
        builder: (_, snapshot) {
          if (snapshot.data is RemoteArticlesLoading) {
            return const Center(child: CupertinoActivityIndicator());
          }
          if (snapshot.data is RemoteArticlesError) {
            return const Center(child: Icon(Icons.refresh));
          }
          if (snapshot.data is RemoteArticlesDone) {
            return ListView.builder(
              itemBuilder: (context, index) {
                return ArticleWidget(
                  article: snapshot.data!.articles![index],
                  onArticlePressed: (article) =>
                      _onArticlePressed(context, article),
                );
              },
              itemCount: snapshot.data!.articles!.length,
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  _buildAppbar(BuildContext context) {
    return AppBar(
      title: const Text(
        'Daily News',
        style: TextStyle(color: Colors.black),
      ),
      actions: [
        GestureDetector(
          onTap: () => _onShowSavedArticlesViewTapped(context),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Icon(Icons.bookmark, color: Colors.black),
          ),
        ),
      ],
    );
  }

  void _onArticlePressed(BuildContext context, ArticleEntity article) {
    Navigator.pushNamed(context, '/ArticleDetails', arguments: article);
  }

  void _onShowSavedArticlesViewTapped(BuildContext context) {
    Navigator.pushNamed(context, '/SavedArticles');
  }
}
