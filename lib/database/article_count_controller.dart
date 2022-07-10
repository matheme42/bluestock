import 'package:bluestock/database/database_controller.dart';
import 'package:bluestock/database/models/article.dart';
import 'package:bluestock/database/models/article_count.dart';
import 'package:bluestock/database/models/zone.dart';
import 'package:sqflite/sqflite.dart';

class ArticleCountController {
  static final ArticleCountController _articleController =
      ArticleCountController._internal();
  static final DatabaseController _controller = DatabaseController();

  factory ArticleCountController() {
    return _articleController;
  }

  ArticleCountController._internal();

  Future<ArticleCount> insert(
      ArticleCount articleCount, Article article, Zone zone) async {
    Database db = await _controller.database;
    articleCount.id = await db.insert(
        _controller.articleCountTable,
        articleCount.asMap()
          ..addAll({'article_id': article.id, 'zone_id': zone.id}));
    return articleCount;
  }

  Future<int> update(ArticleCount articleCount) async {
    Database db = await _controller.database;
    return await db.update(_controller.articleCountTable, articleCount.asMap(),
        where: 'id = ?', whereArgs: [articleCount.id]);
  }

  Future<int> delete(ArticleCount articleCount) async {
    Database db = await _controller.database;
    return await db.delete(_controller.articleCountTable,
        where: 'id = ?', whereArgs: [articleCount.id]);
  }

  Future<List<ArticleCount>> getArticleCountZone(
      {required Zone zone, required List<Article> articles}) async {
    Database db = await _controller.database;
    List<Map<String, dynamic>> articleCountListQuery = [];
    List<ArticleCount> articleCounts = [];

    articleCountListQuery = await db.query(_controller.articleCountTable,
        where: 'zone_id = ?', whereArgs: [zone.id]);

    for (var articleCount in articleCountListQuery) {
      Article article =
          articles.firstWhere((elm) => elm.id == articleCount['article_id']);
      articleCounts.add(ArticleCount()
        ..zone = zone
        ..number = articleCount['number']
        ..article = article
        ..commentaire = articleCount['commentaire']
      );
    }
    return (articleCounts);
  }
}
