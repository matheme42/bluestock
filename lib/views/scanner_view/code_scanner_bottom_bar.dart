import 'package:bluestock/context/context.dart';
import 'package:bluestock/custom_widget/number_picker/number_picker.dart';
import 'package:bluestock/database/article_count_controller.dart';
import 'package:bluestock/database/models/article.dart';
import 'package:bluestock/database/models/article_count.dart';
import 'package:bluestock/database/models/zone.dart';
import 'package:bluestock/views/scanner_view/code_scanner_list.dart';
import 'package:flutter/material.dart';
import 'package:tab_container/tab_container.dart';

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
                        const Expanded(child: Divider(color: Colors.black38)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(key.toLowerCase()),
                        ),
                        const Expanded(child: Divider(color: Colors.black38)),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(value.toLowerCase(),
                          textAlign: TextAlign.center),
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}

class AddArticleCount extends StatelessWidget {
  final Article? article;
  final FocusNode node;
  final ValueNotifier<int> number;
  final TextEditingController textController;
  final Function() onPressed;
  final Widget? codeBar;

  const AddArticleCount({
    Key? key,
    required this.article,
    required this.node,
    required this.number,
    required this.textController,
    required this.onPressed,
    required this.codeBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => node.unfocus(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                  alignment: Alignment.center,
                  child: codeBar ?? const SizedBox.shrink()),
            ),
            article != null
                ? ArticleNumberPicker(currentValue: number)
                : const SizedBox.shrink(),
            article != null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      focusNode: node,
                      controller: textController,
                      decoration: const InputDecoration(
                          labelText: 'commentaire',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)))),
                    ),
                  )
                : const SizedBox.shrink(),
            MaterialButton(
              onPressed: onPressed,
              child: Text(article != null ? 'Ajouter' : 'retour'),
            )
          ],
        ),
      ),
    );
  }
}

class ScannerBottomBar extends StatefulWidget {
  final ValueNotifier<Article?> articleFound;
  final ValueNotifier<Widget?> widgetCode;
  final Function close;

  const ScannerBottomBar({
    Key? key,
    required this.widgetCode,
    required this.close,
    required this.articleFound,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ScannerBottomBarState();
}

class ScannerBottomBarState extends State<ScannerBottomBar> {
  final _sheetController = DraggableScrollableController();
  final tabContainerController = TabContainerController(length: 2);
  TextEditingController textController = TextEditingController();
  final ValueNotifier<int> number = ValueNotifier<int>(0);
  bool state = false;
  final FocusNode node = FocusNode();
  final tabAnim = const Duration(milliseconds: 500);

  void open() {
    if (state == true) return;
    state = true;
    _sheetController.animateTo(0.8, duration: tabAnim, curve: Curves.linear);
    BluestockContext.of(context).scannerController.stop();
  }

  void close() {
    if (state == false) return;
    textController.clear();
    state = false;
    _sheetController.animateTo(0.1, duration: tabAnim, curve: Curves.linear);
    if (BluestockContext.of(context).previousZone == null) {
      BluestockContext.of(context).scannerController.start();
    }
  }

  void jumpTo(int index) => tabContainerController.jumpTo(index);

  @override
  void initState() {
    super.initState();
    tabContainerController.addListener(onchange);
  }

  @override
  void dispose() {
    tabContainerController.removeListener(onchange);
    super.dispose();
  }

  void onchange() {
    node.unfocus();
    if (tabContainerController.index == 0 && widget.widgetCode.value == null) {
      close();
      return;
    }
    open();
  }

  Future<void> addArticleCount(Article? article) async {
    if (article == null) {
      widget.close();
      number.value = 0;
      return;
    }

    Zone zone = BluestockContext.of(context).currentZone.value!;

    ArticleCount ac = ArticleCount();
    ac.article = article;
    ac.number = number.value;
    ac.zone = zone;
    ac.commentaire = textController.value.text;

    textController.clear();
    ac = await ArticleCountController().insert(ac, article, zone);
    zone.articlesCount.add(ac);

    widget.close();
    number.value = 0;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        maxChildSize: 0.8,
        initialChildSize: 0.1,
        minChildSize: 0.1,
        snap: false,
        controller: _sheetController,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF112473), Colors.deepPurple],
            )),
            child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                controller: scrollController,
                child: ValueListenableBuilder<Article?>(
                    valueListenable: widget.articleFound,
                    builder: (context, article, _) {
                      return Container(
                          height: MediaQuery.of(context).size.height * 0.67,
                          margin: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Flexible(
                                child: TabContainer(
                                  colors: const <Color>[
                                    Colors.white54,
                                    Colors.white54,
                                  ],
                                  isStringTabs: false,
                                  tabEdge: TabEdge.top,
                                  tabCurve: Curves.easeIn,
                                  radius: 20,
                                  controller: tabContainerController,
                                  tabs: const [
                                    Icon(Icons.home_outlined),
                                    Icon(Icons.insert_drive_file_outlined),
                                  ],
                                  children: [
                                    AddArticleCount(
                                      onPressed: () => addArticleCount(article),
                                      number: number,
                                      codeBar: widget.widgetCode.value,
                                      textController: textController,
                                      article: widget.articleFound.value,
                                      node: node,
                                    ),
                                    article != null
                                        ? ArticleInfo(article: article)
                                        : const ArticleCountList(),
                                  ],
                                ),
                              ),
                            ],
                          ));
                    })),
          );
        });
  }
}
