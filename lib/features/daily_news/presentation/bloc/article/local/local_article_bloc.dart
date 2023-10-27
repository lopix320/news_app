import 'dart:async';

import 'package:news_app/features/daily_news/presentation/bloc/article/local/local_article_event.dart';
import 'package:news_app/features/daily_news/presentation/bloc/article/local/local_article_state.dart';

import '../../../../domain/usecases/get_saved_article.dart';
import '../../../../domain/usecases/remove_article.dart';
import '../../../../domain/usecases/save_article.dart';

class LocalArticleBloc {
  final GetSavedArticleUseCase _getSavedArticleUseCase;
  final SaveArticleUseCase _saveArticleUseCase;
  final RemoveArticleUseCase _removeArticleUseCase;

  LocalArticleBloc(this._getSavedArticleUseCase, this._saveArticleUseCase,
      this._removeArticleUseCase) {
    _inputArticleController.stream.listen(eventHandler);
  }

  final StreamController<LocalArticlesEvent> _inputArticleController =
      StreamController<LocalArticlesEvent>();
  final StreamController<LocalArticlesState> _outputArticleController =
      StreamController<LocalArticlesState>();

  Sink<LocalArticlesEvent> get inputArticle => _inputArticleController.sink;
  Stream<LocalArticlesState> get stream => _outputArticleController.stream;

  eventHandler(LocalArticlesEvent event) async {
    _outputArticleController.add(LocalArticlesLoading());
    if (event is GetSavedArticles) {
      onGetSavedArticles(event);
    }
    if (event is RemoveArticle) {
      onRemoveArticle(event);
    }
    if (event is SaveArticle) {
      onSaveArticle(event);
    }
  }

  void onGetSavedArticles(GetSavedArticles event) async {
    final articles = await _getSavedArticleUseCase();
    _outputArticleController.add(LocalArticlesDone(articles));
  }

  void onRemoveArticle(RemoveArticle event) async {
    await _removeArticleUseCase(params: event.article);
    final articles = await _getSavedArticleUseCase();
    _outputArticleController.add(LocalArticlesDone(articles));
  }

  void onSaveArticle(SaveArticle event) async {
    await _saveArticleUseCase(params: event.article);
    final articles = await _getSavedArticleUseCase();
    _outputArticleController.add(LocalArticlesDone(articles));
  }
}
