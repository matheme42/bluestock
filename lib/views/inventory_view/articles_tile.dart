import 'package:auto_size_text/auto_size_text.dart';
import 'package:bluestock/database/models/article.dart';
import 'package:bluestock/database/models/article_count.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ArticleTile extends StatelessWidget {
  final ArticleCount ac;
  final Function(ArticleCount) remove;

  const ArticleTile({Key? key, required this.ac, required this.remove})
      : super(key: key);

  List<Widget> buildInfo() {
    List<Widget> list = [];
    Map map = ac.article.asMap()..remove('id');

    for (int i = 0; i < map.length; i++) {
      String key = Article.keysInfo[i].toString();
      String value = map.values.elementAt(i).toString();
      if (value.isEmpty) {
        value = 'not_define'.tr;
      }
      list.add(Container(
        height: 50,
        margin: const EdgeInsets.only(bottom: 5),
        child: ListTile(
          title: Text(key.toLowerCase(),
              style: const TextStyle(color: Colors.grey)),
          dense: true,
          subtitle: Text(value.toLowerCase(),
              style: const TextStyle(color: Colors.white)),
        ),
      ));
    }

    if (ac.zone.lock.value == false) {
      list.add(MaterialButton(
        onPressed: () => remove(ac),
        child: Text('remove1'.tr, style: const TextStyle(color: Colors.orangeAccent)),
      ));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      child: ExpandablePanel(
          theme:
              const ExpandableThemeData(iconColor: Colors.white, iconSize: 0),
          controller: ExpandableController(),
          header: ListTile(
            title: AutoSizeText(
              ac.article.commercialDenomination,
              style: const TextStyle(color: Colors.white),
              maxLines: 2,
              minFontSize: 3,
            ),
            subtitle: Text(
              ac.article.codeProduct,
              style: const TextStyle(color: Colors.white),
            ),
            trailing: Text(
              ac.number.toString(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          collapsed: const SizedBox.shrink(),
          expanded: Card(
            color: Colors.transparent,
            child: FractionallySizedBox(
                widthFactor: 1,
                child: Column(
                  children: buildInfo(),
                )),
          )),
    );
  }
}
