import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:bluestock/context/context.dart';
import 'package:bluestock/database/article_count_controller.dart';
import 'package:bluestock/database/inventory_controller.dart';
import 'package:bluestock/database/models/article_count.dart';
import 'package:bluestock/database/models/inventory.dart';
import 'package:bluestock/views/inventory_view/articles_tile.dart';
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
    final date = DateFormat.yMd().format(widget.inventory.date);
    final name = widget.inventory.site.name;
    await Share.shareFiles([file.path], text: '$name $date');
  }

  @override
  Widget build(BuildContext context) {
    Inventory inventory = widget.inventory;
    ValueNotifier<bool> delete = ValueNotifier(false);
    return ValueListenableBuilder<bool>(
        valueListenable: delete,
        builder: (context, value, _) {
          return Scaffold(
              backgroundColor: const Color(0xFF112473),
              appBar: AppBar(
                centerTitle: true,
                backgroundColor: Colors.transparent,
                title: Text(inventory.site.name.toUpperCase(),
                    style: const TextStyle(color: Colors.white)),
                actions: widget.inventory.done == true
                    ? [
                        Center(
                            child: delete.value == false
                                ? IconButton(
                                    icon: const Icon(
                                      Icons.more_horiz,
                                      color: Colors.white70,
                                    ),
                                    onPressed: () {
                                      delete.value = true;
                                    },
                                  )
                                : IconButton(
                                    onPressed: () {
                                      delete.value = false;
                                    },
                                    icon: const Icon(Icons.undo))),
                      ]
                    : null,
              ),
              body: Container(
                  margin: const EdgeInsets.all(8),
                  child: InventoryResumeList(inventory: widget.inventory)),
              bottomNavigationBar: widget.inventory.done == true
                  ? delete.value == false
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
                      : Row(
                          children: [
                            Flexible(
                              flex: 2,
                              child: Card(
                                color: Colors.deepPurple,
                                child: ListTile(
                                  onLongPress: () {
                                    var appContext =
                                        BluestockContext.of(context);
                                    inventory.done = false;
                                    InventoryController()
                                        .update(inventory)
                                        .then((_) {
                                      appContext.currentInventory.value =
                                          inventory;
                                      Navigator.pop(context);
                                    });
                                  },
                                  onTap: () {
                                    var appContext =
                                        BluestockContext.of(context);
                                    inventory.done = false;
                                    InventoryController()
                                        .update(inventory)
                                        .then((_) {
                                      appContext.currentInventory.value =
                                          inventory;
                                      Navigator.pop(context);
                                    });
                                  },
                                  title: AutoSizeText(
                                    'edit'.tr,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.white),
                                    maxLines: 1,
                                  ),
                                  visualDensity:
                                      const VisualDensity(vertical: 0),
                                ),
                              ),
                            ),
                            Flexible(
                              child: Card(
                                color: Colors.red,
                                child: ListTile(
                                  onLongPress: () {
                                    InventoryController()
                                        .destroy(inventory)
                                        .then((_) {
                                      var appContext =
                                          BluestockContext.of(context);
                                      appContext.inventories.remove(inventory);
                                      appContext.updater.value =
                                          !appContext.updater.value;
                                      Navigator.pop(context);
                                    });
                                  },
                                  onTap: () {
                                    InventoryController()
                                        .destroy(inventory)
                                        .then((_) {
                                      var appContext =
                                          BluestockContext.of(context);
                                      appContext.inventories.remove(inventory);
                                      appContext.updater.value =
                                          !appContext.updater.value;
                                      Navigator.pop(context);
                                    });
                                  },
                                  title: AutoSizeText(
                                    'remove'.tr,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.white),
                                    maxLines: 1,
                                  ),
                                  visualDensity:
                                      const VisualDensity(vertical: 0),
                                ),
                              ),
                            ),
                          ],
                        )
                  : null);
        });
  }
}

class InventoryResumeList extends StatelessWidget {
  final Inventory inventory;
  final ValueNotifier updater = ValueNotifier(false);
  final List<ArticleCount> acList = [];

  InventoryResumeList({Key? key, required this.inventory}) : super(key: key);

  void removeItem(ArticleCount ac) {
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
          return StickyGroupedListView<ArticleCount, String>(
            stickyHeaderBackgroundColor: Colors.deepPurple,
            elements: acList,
            groupBy: (element) => element.zone.name,
            groupSeparatorBuilder: (ac) {
              return ListTile(
                title: Text(
                  ac.zone.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
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
