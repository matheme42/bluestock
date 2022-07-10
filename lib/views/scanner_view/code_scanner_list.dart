import 'package:auto_size_text/auto_size_text.dart';
import 'package:bluestock/context/context.dart';
import 'package:bluestock/database/article_count_controller.dart';
import 'package:bluestock/database/models/article_count.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

class ArticleCountList extends StatefulWidget {
  const ArticleCountList({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ArticleCountListState();
  }
}

class ArticleCountListState extends State<ArticleCountList> {
  List<ArticleCount> articleCount = [];
  final int step = 10;

  @override
  void initState() {
    super.initState();
    loadMore();
  }

  void loadMore() {
    BluestockContext appContext = BluestockContext.of(context);
    if (appContext.currentZone.value == null) return ;
    List<ArticleCount> all = appContext.currentZone.value!.articlesCount.reversed.toList();
    int padding = articleCount.length + step;
    if (padding > all.length) {
      padding = all.length;
    }
    setState(() {
      articleCount.addAll(all.sublist(articleCount.length, padding));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
        child: LazyLoadScrollView(
          onEndOfPage: () => loadMore(),
          child: ListView.builder(
            itemCount: articleCount.length,
            itemBuilder: (context, index) {
              ArticleCount ac = articleCount[index];
              GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

              return FlipCard(
                key: cardKey,
                flipOnTouch: true,
                direction: FlipDirection.VERTICAL,
                fill: Fill.fillBack,
                front: ListTile(
                  title: AutoSizeText(
                    ac.article.commercialDenomination.toString(),
                    maxLines: 1,
                  ),
                  isThreeLine: true,
                  leading: const Icon(Icons.more_horiz),
                  subtitle: AutoSizeText(ac.article.codeProduct.toString()),
                  trailing: AutoSizeText(
                    ac.number.toString(),
                    maxLines: 1,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                back: ListTile(
                  title: AutoSizeText(
                    ac.article.commercialDenomination.toString(),
                    maxLines: 1,
                  ),
                  isThreeLine: true,
                  subtitle: AutoSizeText(ac.article.codeProduct.toString()),
                  leading: InkWell(
                    child: const Icon(
                      Icons.delete_rounded,
                      color: Colors.red,
                    ),
                    onTap: () {
                      ArticleCountController().delete(ac).then((_) {
                        setState(() {
                          var appCon = BluestockContext.of(context);
                          appCon.currentZone.value!.articlesCount.remove(ac);
                          articleCount.remove(ac);
                        });
                      });
                    },
                  ),
                  trailing: AutoSizeText(
                    ac.number.toString(),
                    maxLines: 1,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
