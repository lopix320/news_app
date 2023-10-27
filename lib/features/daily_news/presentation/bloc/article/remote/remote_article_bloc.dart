// import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

import 'package:news_app/core/resources/data_state.dart';
import 'package:news_app/features/daily_news/domain/usecases/get_article.dart';
import 'package:news_app/features/daily_news/presentation/bloc/article/remote/remote_article_event.dart';
import 'package:news_app/features/daily_news/presentation/bloc/article/remote/remote_article_state.dart';

class RemoteArticlesBloc {
  final GetArticleUseCase _getArticleUseCase;
  RemoteArticlesBloc(this._getArticleUseCase) {
    _inputArticleController.stream.listen(onGetArticles);
  }

  final StreamController<RemoteArticlesEvent> _inputArticleController =
      StreamController<RemoteArticlesEvent>();
  final StreamController<RemoteArticleState> _outputArticleController =
      StreamController<RemoteArticleState>();

  Sink<RemoteArticlesEvent> get inputArticle => _inputArticleController.sink;
  Stream<RemoteArticleState> get stream => _outputArticleController.stream;

  onGetArticles(RemoteArticlesEvent event) async {
    _outputArticleController.add(RemoteArticlesLoading());
    if (event is GetArticles) {
      final dataState = await _getArticleUseCase();

      if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
        _outputArticleController.add(RemoteArticlesDone(dataState.data!));
      }

      if (dataState is DataFailed) {
        print(dataState.error!.message);
        _outputArticleController.add(RemoteArticlesError(dataState.error!));
      }
    }
  }
}
