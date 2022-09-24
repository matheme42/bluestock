import 'package:bluestock/models/models.dart';
import 'package:flutter/material.dart';

class ArticleStrings extends Model {
  late String string;

  /// data liée a un article

  @override
  void fromMap(Map<String, dynamic> data) {
    data.containsKey("string") ? string = data["string"].toString() : 0;
    super.fromMap(data);
  }

  @override
  Map<String, dynamic> asMap() {
    Map<String, dynamic> message = {};
    message['string'] = string.toString();
    message.addAll(super.asMap());
    return message;
  }

  void print() => debugPrint(asMap().toString());
}
