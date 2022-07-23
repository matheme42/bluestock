import 'package:bluestock/context/context.dart';
import 'package:bluestock/database/models/inventory.dart';
import 'package:bluestock/views/form_view/form_view.dart';
import 'package:bluestock/views/helper/inventaire.dart';
import 'package:bluestock/views/helper/popup.dart';
import 'package:bluestock/views/inventory_view/inventory_resume.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar {
  static AppBar home(BuildContext context) {
    BluestockContext appContext = BluestockContext.of(context);
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Text('title'.tr),
      actions: [
        ValueListenableBuilder<bool>(
            valueListenable: appContext.cguAccepted,
            child: IconButton(
                onPressed: () => inventoryNewPopup(context),
                icon: const Icon(Icons.add)),
            builder: (context, value, child) {
              return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: value == false ? const SizedBox.shrink() : child!);
            }),
      ],
    );
  }

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
