import 'package:bluestock/context/context.dart';
import 'package:bluestock/controllers/controllers.dart';
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
    Inventory inventory = appContext.currentInventory.value!;
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 8, right: 15),
      child: Scaffold(
        backgroundColor: const Color(0xFF112473),
        extendBodyBehindAppBar: false,
        appBar: AppBar(
          elevation: 20,
          leading: ValueListenableBuilder(
            valueListenable: inventory.zoneLockChange,
            builder: (context, value, child) {
              int nbZoneLock = 0;
              var zones = inventory.site.zones;
              for (var z in zones) {
                if (z.lock.value == true) {
                  nbZoneLock += 1;
                }
              }
              return IconButton(
                  onPressed: () async {
                    if (nbZoneLock == zones.length) {
                      for (var z in zones) {
                        z.lock.value = false;
                        await ZoneController().update(z);
                        inventory.zoneLockChange.value =
                            !inventory.zoneLockChange.value;
                      }
                    } else {
                      for (var z in zones) {
                        z.lock.value = true;
                        await ZoneController().update(z);
                        inventory.zoneLockChange.value =
                            !inventory.zoneLockChange.value;
                      }
                    }
                  },
                  icon: Icon(nbZoneLock == zones.length
                      ? Icons.check_box_outlined
                      : Icons.square_outlined));
            },
          ),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10))),
          backgroundColor: const Color(0xFF223584),
          title: const Text('Zones'),
          centerTitle: true,
          actions: [
            ValueListenableBuilder(
              valueListenable: inventory.zoneLockChange,
              builder: (context, value, child) {
                int nbZoneLock = 0;
                var zones = inventory.site.zones;
                for (var z in zones) {
                  if (z.lock.value == true) {
                    nbZoneLock += 1;
                  }
                }
                return Center(
                  child: Padding(
                      padding: const EdgeInsets.only(right: 14.0),
                      child: Text('$nbZoneLock / ${zones.length}')),
                );
              },
            ),
          ],
        ),
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
