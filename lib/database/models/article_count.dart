import 'package:bluestock/database/models/article.dart';
import 'package:bluestock/database/models/model.dart';
import 'package:bluestock/database/models/zone.dart';

class ArticleCount extends Model {
  /// article associé
  late Article article;

  /// zone associé
  late Zone zone;

  /// quantité retenue
  late int number;

  /// commentaire associé
  String commentaire = "";

  @override
  Map<String, dynamic> asMap() {
    Map<String, dynamic> message = {};
    message['number'] = number;
    message['commentaire'] = commentaire;
    message.addAll(super.asMap());
    return message;
  }
}
