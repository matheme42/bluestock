import 'dart:convert';
import 'dart:io';

import 'package:bluestock/database/article_controller.dart';
import 'package:bluestock/database/inventory_controller.dart';
import 'package:bluestock/database/models/article.dart';
import 'package:bluestock/database/models/article_strings.dart';
import 'package:bluestock/database/models/model.dart';
import 'package:bluestock/database/models/site.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class Inventory extends Model {
  late Site site;
  late DateTime date;
  late List<Article> articles = [];
  bool done = false;
  late String process;

  ValueNotifier<bool> articleLoaded = ValueNotifier(false);
  ValueNotifier<bool> zoneLockChange = ValueNotifier(false);


  @override
  void fromMap(Map<String, dynamic> data) {
    data.containsKey("date") ? date = DateTime.parse(data['date']) : 0;
    data.containsKey("process") ? process = data['process'].toString().trim() : 0;
    data.containsKey("done")
        ? done = done = data["done"] == 0 ? false : true
        : 0;
    data.containsKey("articleloaded")
        ? articleLoaded.value = data["articleloaded"] == 0 ? false : true
        : 0;
    super.fromMap(data);
  }

  @override
  Map<String, dynamic> asMap() {
    Map<String, dynamic> message = {};
    message['date'] = date.toIso8601String();
    message['process'] = process;
    message['done'] = done == false ? 0 : 1;
    message['articleloaded'] = articleLoaded.value == false ? 0 : 1;
    message.addAll(super.asMap());
    return message;
  }

  Future<void> importArticle(List<String> data) async {
    articleLoaded.value = false;
    for (var line in data) {
      var elm = line.toString().substring(1, line.toString().length - 1).split(',');
      if (elm[0].toString().toLowerCase().trim() == process) {
        var ars = ArticleStrings();
        ars.string = line.toString();
        ars = await ArticleController().insert(ars, site);
        var ar = Article();
        ar.fromList(elm);
        ar.id = ars.id;
        articles.add(ar);
      }
    }
    articleLoaded.value = true;
    await InventoryController().update(this);
  }


  Future<File> generateCsv() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final fileName = site.name.toUpperCase();
    final filePath = '$path/$fileName.csv';
    final file = File(filePath);
    if (await file.exists()) {
      file.delete();
    }

    String line = "process,date,site,lieu,produit,quantité,commentaire\n";
    await file.writeAsString(line, encoding: latin1, mode: FileMode.append);

    for (var zone in site.zones) {
      for (var ac in zone.articlesCount) {
          String line =
              "${ac.article.process.toUpperCase()},"
              "${DateFormat.yMd().format(date)},"
              "${site.name},"
              "${zone.num},"
              "${ac.article.codeProduct},"
              "${ac.number},"
              "${ac.commentaire}\n";
          await file.writeAsString(line, encoding: latin1, mode: FileMode.append);
      }}
    return (file);
  }
}
