import 'package:auto_size_text/auto_size_text.dart';
import 'package:bluestock/context/context.dart';
import 'package:bluestock/controllers/zone_controller.dart';
import 'package:bluestock/models/models.dart';
import 'package:flutter/material.dart';

class InventoryMenuTile extends StatelessWidget {
  final Zone zone;
  final Zone? previousZone;

  const InventoryMenuTile({Key? key, required this.zone, this.previousZone})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appContext = BluestockContext.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          selected: zone.id == previousZone?.id ? true : false,
          iconColor: Colors.white,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          tileColor: zone.lock.value ? Colors.green : Colors.black26,
          selectedTileColor: zone.lock.value ? Colors.green : Colors.deepPurple,
          selectedColor: Colors.white,
          enabled: true,
          trailing: AutoSizeText(
            zone.num,
            maxLines: 1,
            minFontSize: 5,
          ),
          onTap: () {
            if (zone.lock.value) {
              return;
            }
            appContext.previousZone = null;
            appContext.currentZone.value = zone;
            appContext.scannerController.start();
          },
          onLongPress: () {
            if (zone.lock.value) {
              return;
            }
            appContext.previousZone = null;
            appContext.currentZone.value = zone;
            appContext.scannerController.start();
          },
          visualDensity: const VisualDensity(vertical: -3),
          textColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Inventory inventory = appContext.currentInventory.value!;
              inventory.zoneLockChange.value = !inventory.zoneLockChange.value;
              zone.lock.value = !zone.lock.value;
              ZoneController().update(zone);
            },
            icon: Icon(zone.lock.value
                ? Icons.check_box_outlined
                : Icons.check_box_outline_blank_sharp),
          ),
          title: AutoSizeText(
            zone.name,
            textAlign: TextAlign.center,
          )),
    );
  }
}
