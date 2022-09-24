import 'package:auto_size_text/auto_size_text.dart';
import 'package:bluestock/context/context.dart';
import 'package:bluestock/controllers/controllers.dart';
import 'package:bluestock/models/models.dart';
import 'package:bluestock/widgets/code_image/code_image.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:intl/intl.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

class ArticleCountList extends StatefulWidget {
  final Function update;

  const ArticleCountList(this.update, {Key? key}) : super(key: key);

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
    if (appContext.currentZone.value == null) return;
    List<ArticleCount> all =
        appContext.currentZone.value!.articlesCount.reversed.toList();
    int padding = articleCount.length + step;
    if (padding > all.length) {
      padding = all.length;
    }
    setState(() {
      articleCount.addAll(all.sublist(articleCount.length, padding));
    });
  }

  void removeCard(ArticleCount ac) {
    ArticleCountController().delete(ac).then((_) {
      setState(() {
        var appCon = BluestockContext.of(context);
        appCon.currentZone.value!.articlesCount.remove(ac);
        articleCount.remove(ac);
      });
      widget.update();
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
              return ArticleCountCard(ac: ac, onTap: removeCard);
            },
          ),
        ),
      ),
    );
  }
}

class ArticleCountCard extends StatelessWidget {
  final ArticleCount ac;
  final Function(ArticleCount) onTap;

  const ArticleCountCard({Key? key, required this.ac, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTileCard(
      baseColor: Colors.transparent,
      expandedColor: Colors.white12,
      expandedTextColor: Colors.black,
      elevation: 0,
      title: AutoSizeText(
        ac.article.commercialDenomination,
        maxLines: 2,
        minFontSize: 5,
      ),
      subtitle: Text(ac.article.codeProduct),
      leading: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(children: [
          const Icon(Icons.discount),
          AutoSizeText(
            ac.number.toString(),
            textScaleFactor: 1.3,
            maxLines: 1,
            minFontSize: 5,
            style: const TextStyle(color: Colors.black),
          ),
        ]),
      ),
      children: [
        ac.peremption != null
            ? Banner(
                location: BannerLocation.topEnd,
                message: DateFormat('dd-MM-yyyy').format(ac.peremption!),
                child: const Divider(
                  thickness: 1.0,
                  height: 1.0,
                ),
              )
            : const Divider(
                thickness: 1.0,
                height: 1.0,
              ),
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: CodeImage(code: ac.article.code, type: ac.codeBarType),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Text(ac.commentaire),
          ),
        ),
        ButtonBar(
          alignment: MainAxisAlignment.spaceAround,
          buttonHeight: 52.0,
          buttonMinWidth: 90.0,
          children: <Widget>[
            TextButton(
              onPressed: () => onTap(ac),
              child: Column(
                children: <Widget>[
                  const Icon(
                    Icons.delete,
                    color: Colors.orangeAccent,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.0),
                  ),
                  Text(
                    'remove1'.tr,
                    style: const TextStyle(color: Colors.orangeAccent),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
