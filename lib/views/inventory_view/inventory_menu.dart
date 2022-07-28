import 'package:auto_size_text/auto_size_text.dart';
import 'package:bluestock/context/context.dart';
import 'package:bluestock/dart/import.dart';
import 'package:bluestock/database/models/inventory.dart';
import 'package:bluestock/database/models/site.dart';
import 'package:bluestock/database/models/zone.dart';
import 'package:bluestock/database/zone_controller.dart';
import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class InventoryMenu extends StatelessWidget {
  const InventoryMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BluestockContext appContext = BluestockContext.of(context);
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 8),
      child: Scaffold(
        backgroundColor: const Color(0xFF112473),
        body: Container(
          margin: const EdgeInsets.only(top: 10),
          child: ValueListenableBuilder(
            valueListenable: appContext.currentInventory,
            builder: (context, data, _) {
              if (data == null) {
                return Container();
              }
              Site site = (data as Inventory).site;
              return ValueListenableBuilder<bool>(
                  valueListenable: Import.articleCsvInLoading,
                  builder: (context, articleCsvInLoading, _) {
                    return ValueListenableBuilder<bool>(
                        valueListenable:
                            appContext.currentInventory.value!.articleLoaded,
                        builder: (context, articleLoaded, _) {
                          return Skeleton(
                            isLoading: !articleLoaded,
                            shimmerGradient: const LinearGradient(colors: [
                              Color(0xFF112473),
                              Colors.white10,
                              Color(0xFF112473),
                            ]),
                            skeleton: ListView.builder(
                                itemCount: appContext
                                    .currentInventory.value!.site.zones.length,
                                itemBuilder: (context, index) {
                                  return SkeletonListTile(
                                    titleStyle:
                                        const SkeletonLineStyle(height: 30),
                                    hasLeading: false,
                                  );
                                }),
                            child: ValueListenableBuilder(
                                valueListenable: appContext.currentZone,
                                builder: (context, data, _) {
                                  Zone? zone = (data as Zone?) ??
                                      appContext.previousZone;
                                  return ListView.builder(
                                    itemCount: site.zones.length,
                                    itemBuilder: (context, index) {
                                      return ValueListenableBuilder<bool>(
                                        valueListenable: site.zones[index].lock,
                                        builder: (context, lock, _) {
                                          return Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 10),
                                            child: ListTile(
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                selected:
                                                    site.zones[index].name ==
                                                            zone?.name
                                                        ? true
                                                        : false,
                                                iconColor: Colors.white,
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10))),
                                                tileColor: lock
                                                    ? Colors.green
                                                    : Colors.black26,
                                                selectedTileColor: lock
                                                    ? Colors.green
                                                    : Colors.deepPurple,
                                                selectedColor: Colors.white,
                                                enabled: true,
                                                trailing: AutoSizeText(
                                                  site.zones[index].num,
                                                  maxLines: 1,
                                                  minFontSize: 5,
                                                ),
                                                onTap: () {
                                                  if (lock) {
                                                    return;
                                                  }
                                                  appContext.previousZone =
                                                      null;
                                                  appContext.currentZone.value =
                                                      site.zones[index];
                                                  appContext.scannerController
                                                      .start();
                                                },
                                                onLongPress: () {
                                                  if (lock) {
                                                    return;
                                                  }
                                                  appContext.previousZone =
                                                      null;
                                                  appContext.currentZone.value =
                                                      site.zones[index];
                                                  appContext.scannerController
                                                      .start();
                                                },
                                                visualDensity:
                                                    const VisualDensity(
                                                        vertical: -3),
                                                textColor: Colors.white,
                                                leading: IconButton(
                                                  onPressed: () {
                                                    Inventory inventory =
                                                        appContext
                                                            .currentInventory
                                                            .value!;
                                                    inventory.zoneLockChange
                                                            .value =
                                                        !inventory
                                                            .zoneLockChange
                                                            .value;
                                                    site.zones[index].lock
                                                            .value =
                                                        !site.zones[index].lock
                                                            .value;
                                                    ZoneController().update(
                                                        site.zones[index]);
                                                  },
                                                  icon: Icon(lock
                                                      ? Icons.check_box_outlined
                                                      : Icons
                                                          .check_box_outline_blank_sharp),
                                                ),
                                                title: AutoSizeText(
                                                  site.zones[index].name,
                                                  textAlign: TextAlign.center,
                                                )),
                                          );
                                        },
                                      );
                                    },
                                  );
                                }),
                          );
                        });
                  });
            },
          ),
        ),
      ),
    );
  }
}
