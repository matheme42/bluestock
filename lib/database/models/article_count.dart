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

  /// type de codebar utilisé
  String codeBarType = "";

  /// commentaire associé
  String commentaire = "";

  DateTime? peremption;

  @override
  Map<String, dynamic> asMap() {
    Map<String, dynamic> message = {};
    message['number'] = number;
    message['codebartype'] = codeBarType;
    message['commentaire'] = commentaire;
    message['peremption'] = peremption != null ? peremption!.toIso8601String() : "";
    message.addAll(super.asMap());
    return message;
  }
}
