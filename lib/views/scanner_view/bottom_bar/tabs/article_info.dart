import 'package:bluestock/models/models.dart';
import 'package:flutter/material.dart';

class ArticleInfo extends StatelessWidget {
  final Article article;

  const ArticleInfo({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map map = article.asMap()..remove('id');
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView.builder(
          itemCount: map.length,
          itemBuilder: (context, index) {
            String key = Article.keysInfo[index].toString();
            String value = map.values.elementAt(index).toString();
            if (value.isEmpty) {
              value = 'non défini';
            }
            return Column(
              children: [
                Container(
                  color: Colors.transparent,
                  margin: const EdgeInsets.only(bottom: 5),
                  child: ListTile(
                    title: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(key),
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(value),
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
