import 'package:bluestock/context/context.dart';
import 'package:bluestock/controllers/controllers.dart';
import 'package:bluestock/models/models.dart';
import 'package:sqflite/sqflite.dart';

class ArticleController {
  static final ArticleController _articleController =
      ArticleController._internal();
  static final DatabaseController _controller = DatabaseController();

  factory ArticleController() {
    return _articleController;
  }

  ArticleController._internal();

  Future<ArticleStrings> insert(
      ArticleStrings articleStrings, Site site) async {
    Database db = await _controller.database;
    articleStrings.id = await db.insert(_controller.articleStringTable,
        articleStrings.asMap()..addAll({'site_id': site.id}));
    return articleStrings;
  }

  Future<int> update(ArticleStrings articleStrings) async {
    Database db = await _controller.database;
    return await db.update(
        _controller.articleStringTable, articleStrings.asMap(),
        where: 'id = ?', whereArgs: [articleStrings.id]);
  }

  Future<List<Article>> getArticleSite({required int siteId}) async {
    Database db = await _controller.database;
    List<Map<String, dynamic>> articleStringsListQuery = [];
    List<Article> articles = [];

    articleStringsListQuery = await db.query(_controller.articleStringTable,
        where: 'site_id = ?', whereArgs: [siteId]);

    for (var articleString in articleStringsListQuery) {
      var a = articleString['string']
          .toString()
          .split(BluestockContext.csvDelimitor);
      var article = Article()
        ..fromList(a)
        ..id = articleString['id'];
      articles.add(article);
    }
    return (articles);
  }
}
