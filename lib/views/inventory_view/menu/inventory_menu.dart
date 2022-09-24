import 'package:bluestock/context/context.dart';
import 'package:bluestock/functions/import.dart';
import 'package:bluestock/models/models.dart';
import 'package:bluestock/views/inventory_view/menu/inventory_menu_tile.dart';
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
          child: ValueListenableBuilder<Inventory?>(
            valueListenable: appContext.currentInventory,
            builder: (context, data, _) {
              if (data == null) {
                return const SizedBox.shrink();
              }
              Site site = data.site;
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
                                itemCount: site.zones.length,
                                itemBuilder: (context, index) {
                                  return SkeletonListTile(
                                    titleStyle:
                                        const SkeletonLineStyle(height: 30),
                                    hasLeading: false,
                                  );
                                }),
                            child: ValueListenableBuilder<Zone?>(
                                valueListenable: appContext.currentZone,
                                builder: (context, data, _) {
                                  Zone? pZone = data ?? appContext.previousZone;
                                  return ListView.builder(
                                    itemCount: site.zones.length,
                                    itemBuilder: (context, index) {
                                      return ValueListenableBuilder<bool>(
                                        valueListenable: site.zones[index].lock,
                                        builder: (context, lock, _) {
                                          return InventoryMenuTile(
                                            zone: site.zones[index],
                                            previousZone: pZone,
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
