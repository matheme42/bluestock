import 'package:bluestock/context/context.dart';
import 'package:bluestock/models/models.dart';
import 'package:bluestock/views/helper_view/inventaire.dart';
import 'package:bluestock/views/helper_view/popup.dart';
import 'package:bluestock/views/inventory_view/resume/inventory_resume_view.dart';
import 'package:flutter/material.dart';

class InventoryAppBar {
  static AppBar inventory(BuildContext context, Inventory inventory) {
    return AppBar(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      title: Text(inventory.site.name.toUpperCase(),
          style: const TextStyle(color: Colors.white)),
      leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            BluestockContext appContext = BluestockContext.of(context);
            if (appContext.currentZone.value != null) {
              appContext.previousZone = appContext.currentZone.value;
              BluestockContext.of(context).scannerController.stop();
              appContext.currentZone.value == null;
            }
            if (appContext.currentInventory.value != null) {
              appContext.previousZone = null;
              appContext.currentInventory.value = null;
            }
          }),
      actions: [
        IconButton(
            onPressed: () => inventoryResumePopup(
                context, BluestockContext.of(context).currentInventory.value!),
            icon: const Icon(Icons.article_outlined)),
        IconButton(
            onPressed: () {
              helpPopup(context, const HelpInventaire());
            },
            icon: const Icon(
              Icons.help,
              color: Colors.white,
            )),
      ],
    );
  }
}
