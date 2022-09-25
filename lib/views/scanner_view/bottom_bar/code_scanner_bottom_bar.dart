import 'package:badges/badges.dart';
import 'package:bluestock/context/context.dart';
import 'package:bluestock/controllers/controllers.dart';
import 'package:bluestock/models/models.dart';
import 'package:bluestock/views/scanner_view/bottom_bar/tabs/add_article_count.dart';
import 'package:bluestock/views/scanner_view/bottom_bar/tabs/article_info.dart';
import 'package:bluestock/views/scanner_view/bottom_bar/tabs/code_scanner_list.dart';
import 'package:flutter/material.dart';
import 'package:tab_container/tab_container.dart';

class ScannerBottomBar extends StatefulWidget {
  final ValueNotifier<Article?> articleFound;
  final ValueNotifier<Widget?> widgetCode;
  final ValueNotifier<int> number;

  final Function close;
  final Function open;
  final Function softClose;

  const ScannerBottomBar({
    Key? key,
    required this.widgetCode,
    required this.close,
    required this.articleFound,
    required this.open,
    required this.softClose,
    required this.number,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ScannerBottomBarState();
}

class ScannerBottomBarState extends State<ScannerBottomBar> {
  final sheetController = DraggableScrollableController();
  final tabContainerController = TabContainerController(length: 2);
  TextEditingController textController = TextEditingController();
  final ValueNotifier<DateTime?> peremption = ValueNotifier<DateTime?>(null);

  bool state = false;
  final FocusNode node = FocusNode();
  final tabAnim = const Duration(milliseconds: 500);

  void open() {
    if (state == true) return;
    state = true;
    sheetController.animateTo(0.7, duration: tabAnim, curve: Curves.linear);
    BluestockContext.of(context).scannerController.stop();
    widget.open();
  }

  void close() {
    if (state == false) return;
    textController.clear();
    state = false;
    sheetController.animateTo(0.1, duration: tabAnim, curve: Curves.linear);
    widget.softClose();
  }

  void jumpTo(int index) => tabContainerController.jumpTo(index);

  @override
  void initState() {
    super.initState();
    tabContainerController.addListener(onchange);
    sheetController.addListener(sheetControllerMove);
  }

  @override
  void dispose() {
    tabContainerController.removeListener(onchange);
    sheetController.removeListener(sheetControllerMove);
    super.dispose();
  }

  void sheetControllerMove() {
    if (sheetController.size == 0.7) {
      showCountList.value = true;
      return ;
    }
    if (sheetController.size == 0.1){
      if (BluestockContext.of(context).previousZone == null) {
        BluestockContext.of(context).scannerController.start();
      }
      return ;
    }
    showCountList.value = false;
    widget.number.value = 0;
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
      widget.number.value = 0;
      return;
    }

    Zone zone = BluestockContext.of(context).currentZone.value!;

    ArticleCount ac = ArticleCount();
    ac.article = article;
    ac.number = widget.number.value;
    ac.zone = zone;
    ac.commentaire = textController.value.text;
    if (peremption.value != null) {
      ac.peremption = peremption.value!;
    }

    textController.clear();
    ac = await ArticleCountController().insert(ac, article, zone);
    zone.articlesCount.add(ac);

    widget.close();
    widget.number.value = 0;
    peremption.value = null;
  }

  ValueNotifier updateBadge = ValueNotifier(false);
  ValueNotifier showCountList = ValueNotifier(false);

  void updateBottomBar() => updateBadge.value = !updateBadge.value;

  List<dynamic> tabs() {
    var appContext = BluestockContext.of(context);
    return [
      const Icon(Icons.home_outlined),
      ValueListenableBuilder<Zone?>(
          valueListenable: appContext.currentZone,
          builder: (context, value, _) {
            if (value == null) {
              return const Icon(Icons.insert_drive_file_outlined);
            }
            return ValueListenableBuilder(
                valueListenable: updateBadge,
                builder: (context, _, child) {
                  return Badge(
                      showBadge: widget.articleFound.value == null,
                      badgeColor: Colors.blue,
                      badgeContent: Text(value.articlesCount.length.toString(),
                          style: const TextStyle(color: Colors.white)),
                      position: BadgePosition.topEnd(end: -30),
                      child: Icon(widget.articleFound.value != null
                          ? Icons.insert_drive_file_outlined
                          : Icons.discount_outlined));
                });
          }),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        maxChildSize: 0.7,
        initialChildSize: 0.1,
        minChildSize: 0.1,
        snap: false,
        expand: false,
        controller: sheetController,
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
                            tabs: tabs(),
                            children: [
                              AddArticleCount(
                                onPressed: () => addArticleCount(article),
                                number: widget.number,
                                codeBar: widget.widgetCode.value,
                                textController: textController,
                                article: widget.articleFound.value,
                                peremption: peremption,
                                node: node,
                              ),
                              ValueListenableBuilder(
                                valueListenable: showCountList,
                                builder: (context, value, _) {
                                  if (value == false) {
                                    return const SizedBox.shrink();
                                  }
                                  return article != null
                                      ? ArticleInfo(article: article)
                                      : ArticleCountList(updateBottomBar);
                                },
                              ),
                            ],
                          ));
                    })),
          );
        });
  }
}
