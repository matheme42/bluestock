import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:bluestock/context/context.dart';
import 'package:bluestock/controllers/controllers.dart';
import 'package:bluestock/models/models.dart';
import 'package:bluestock/views/inventory_view/resume/articles_tile.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

void inventoryResumePopup(BuildContext context, Inventory inventory) {
  showAnimatedDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return InventoryResume(inventory: inventory);
    },
    animationType: DialogTransitionType.size,
    curve: Curves.fastOutSlowIn,
    duration: const Duration(seconds: 1),
  );
}

class InventoryResume extends StatefulWidget {
  final Inventory inventory;

  const InventoryResume({Key? key, required this.inventory}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return InventoryResumeState();
  }
}

class InventoryResumeState extends State<InventoryResume> {
  Future<void> export() async {
    File file = await widget.inventory.generateCsv();
    final date = DateFormat('dd-MM-yyyy').format(widget.inventory.date);
    final name = widget.inventory.site.name;
    await Share.shareFiles([file.path], text: '$name $date');
  }

  int tArticleScan = 0;
  int tAcScan = 0;
  int nbZoneLock = 0;
  ValueNotifier<bool> updateBottomBar = ValueNotifier(false);

  void removeItem(ArticleCount ac) {
    tArticleScan -= 1;
    tAcScan -= ac.number;
    updateBottomBar.value = !updateBottomBar.value;
  }

  @override
  Widget build(BuildContext context) {
    Inventory inventory = widget.inventory;

    for (var zone in inventory.site.zones) {
      tArticleScan += zone.articlesCount.length;
      if (zone.lock.value == true) {
        nbZoneLock += 1;
      }
      for (var ac in zone.articlesCount) {
        tAcScan += ac.number;
      }
    }

    return Scaffold(
        backgroundColor: const Color(0xFF112473),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: Text(inventory.site.name.toUpperCase(),
              style: const TextStyle(color: Colors.white)),
          actions: widget.inventory.done == true
              ? [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        customButton: const Icon(
                          Icons.more_horiz,
                          color: Colors.white,
                        ),
                        items: [
                          DropdownMenuItem<String>(
                            value: 'reprendre',
                            onTap: () {
                              var appContext = BluestockContext.of(context);
                              inventory.done = false;
                              InventoryController().update(inventory).then((_) {
                                appContext.currentInventory.value = inventory;
                                Navigator.pop(context);
                              });
                            },
                            child: const Text(
                              'reprendre',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DropdownMenuItem<String>(
                            onTap: () {
                              InventoryController()
                                  .destroy(inventory)
                                  .then((_) {
                                var appContext = BluestockContext.of(context);
                                appContext.inventories.remove(inventory);
                                appContext.updater.value =
                                    !appContext.updater.value;
                                Navigator.pop(context);
                              });
                            },
                            value: 'supprimer',
                            child: const Text(
                              'supprimer',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                        onChanged: (_) {},
                        itemHeight: 48,
                        itemPadding: const EdgeInsets.only(left: 16, right: 16),
                        dropdownWidth: 160,
                        dropdownPadding:
                            const EdgeInsets.symmetric(vertical: 6),
                        dropdownDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: const Color(0xFF112473),
                        ),
                        dropdownElevation: 8,
                        offset: const Offset(0, 8),
                      ),
                    ),
                  ),
                ]
              : null,
        ),
        body: Container(
            margin: const EdgeInsets.all(8),
            child: FutureBuilder(
              future: Future.delayed(const Duration(seconds: 1)),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const SizedBox.shrink();
                }
               return InventoryResumeList(inventory: widget.inventory, removeAc: removeItem);
              },
            )),
        bottomNavigationBar: widget.inventory.done == true
            ? Card(
                color: Colors.deepPurple,
                elevation: 3,
                child: ListTile(
                  onTap: () {
                    export().then((value) {
                      Navigator.pop(context);
                    });
                  },
                  onLongPress: () {
                    export().then((value) {
                      Navigator.pop(context);
                    });
                  },
                  title: const Icon(
                    Icons.upload,
                    color: Colors.white,
                  ),
                  subtitle: Text(
                    'export'.tr,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white),
                  ),
                  visualDensity: const VisualDensity(vertical: -4),
                ),
              )
            : Card(
                color: Colors.transparent,
                child: ValueListenableBuilder(
                  builder: (context, value, _) {
                    return ListTile(
                        leading: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.discount, color: Colors.white),
                              AutoSizeText(
                                '$tAcScan',
                                minFontSize: 5,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        title: AutoSizeText(
                          '$tArticleScan articles scanné(s)',
                          minFontSize: 5,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.done, color: Colors.white),
                            AutoSizeText(
                              '$nbZoneLock / ${inventory.site.zones.length}',
                              minFontSize: 5,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ));
                  },
                  valueListenable: updateBottomBar,
                ),
              ));
  }
}

class InventoryResumeList extends StatelessWidget {
  final Inventory inventory;
  final ValueNotifier updater = ValueNotifier(false);
  final List<ArticleCount> acList = [];
  final Function(ArticleCount) removeAc;

  InventoryResumeList(
      {Key? key, required this.inventory, required this.removeAc})
      : super(key: key);

  void removeItem(ArticleCount ac) {
    removeAc(ac);
    ac.zone.articlesCount.remove(ac);
    acList.remove(ac);
    ArticleCountController().delete(ac).then((_) {
      updater.value = !updater.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    acList.clear();
    for (var elm in inventory.site.zones) {
      acList.addAll(elm.articlesCount);
    }
    return ValueListenableBuilder(
        valueListenable: updater,
        builder: (context, v, child) {
          if (acList.isEmpty) {
            return const SizedBox.shrink();
          }
          return StickyGroupedListView<ArticleCount, String>(
            stickyHeaderBackgroundColor: const Color(0xFF112473),
            elements: acList,
            groupBy: (element) => element.zone.name,
            groupSeparatorBuilder: (ac) {
              return Card(
                color: Colors.transparent,
                child: ListTile(
                  subtitle: AutoSizeText(
                    '${ac.zone.articlesCount.length.toString()} articles scanné(s)',
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    minFontSize: 5,
                    style: const TextStyle(color: Colors.white),
                  ),
                  title: Text(
                    ac.zone.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
            itemBuilder: (context, ac) {
              return ArticleTile(ac: ac, remove: removeItem);
            },
            itemComparator: (element1, element2) => element1.article.codeProduct
                .compareTo(element2.article.codeProduct),
            // optional
            itemScrollController: GroupedItemScrollController(),
            // optional
            order: StickyGroupedListOrder.ASC, // optional
          );
        });
  }
}
