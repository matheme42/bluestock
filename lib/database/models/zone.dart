import 'package:bluestock/database/models/article_count.dart';
import 'package:bluestock/database/models/model.dart';
import 'package:flutter/material.dart';

class Zone extends Model {
  late String name;

  /// nom de la zone
  late String num;

  /// numero de la zone
  List<ArticleCount> articlesCount = [];

  /// counter d'article
  ValueNotifier<bool> lock = ValueNotifier(false);

  void fromList(List<dynamic> data) {
    if (data.length < 2) return;
    name = data[0]?.toString().trim() ?? '';
    num = data[1]?.toString().trim() ?? '';
  }

  @override
  void fromMap(Map<String, dynamic> data) {
    data.containsKey("name") ? name = data["name"].toString().trim() : 0;
    data.containsKey("lock")
        ? lock.value = data["lock"] == 0 ? false : true
        : 0;
    data.containsKey("numero") ? num = data["numero"].toString().trim() : 0;
    super.fromMap(data);
  }

  @override
  Map<String, dynamic> asMap() {
    Map<String, dynamic> message = {};
    message['name'] = name.toString();
    message['numero'] = num.toString();
    message['lock'] = lock.value == false ? 0 : 1;
    message.addAll(super.asMap());
    return message;
  }

  void print() => debugPrint(asMap().toString());
}
