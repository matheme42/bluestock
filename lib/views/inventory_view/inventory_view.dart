import 'package:bluestock/context/context.dart';
import 'package:bluestock/controllers/controllers.dart';
import 'package:bluestock/models/models.dart';
import 'package:bluestock/views/inventory_view/inventory_app_bar.dart';
import 'package:bluestock/views/inventory_view/menu/inventory_menu.dart';
import 'package:bluestock/views/scaffold_view/home.dart';
import 'package:bluestock/views/scanner_view/code_scanner_view.dart';
import 'package:bluestock/widgets/shrink_side_menu/shrink_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class InventoryView extends StatelessWidget {
  final Widget scanner = BarcodeScanner(key: barCodeScannerKey);
  final ValueNotifier<bool> sideMenuOpened = ValueNotifier(true);
  final Inventory inventory;

  InventoryView({Key? key, required this.inventory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appContext = BluestockContext.of(context);
    return ValueListenableBuilder(
        valueListenable: appContext.currentZone,
        builder: (context, zone, _) {
          if (zone == null && sideMenuOpened.value == false) {
            sideMenuOpened.value = true;
          } else if (zone != null && sideMenuOpened.value == true) {
            sideMenuOpened.value = false;
          }
          return Stack(
            children: [
              SideMenu(
                  closeIcon: null,
                  menu: const InventoryMenu(),
                  extra: Scaffold(
                    backgroundColor: const Color(0xFF112473),
                    appBar: InventoryAppBar.inventory(context, inventory),
                  ),
                  opened: sideMenuOpened,
                  child: scanner),
              ValueListenableBuilder(
                valueListenable: inventory.zoneLockChange,
                child: Align(
                  alignment: const Alignment(0, 1),
                  child: Card(
                    color: Colors.deepPurple,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: ListTile(
                      onLongPress: () {
                        appContext.currentInventory.value!.done = true;
                        InventoryController()
                            .update(appContext.currentInventory.value!)
                            .then((_) {
                          appContext.currentInventory.value = null;
                          appContext.previousZone = null;
                        });
                      },
                      onTap: () {
                        appContext.currentInventory.value!.done = true;
                        InventoryController()
                            .update(appContext.currentInventory.value!)
                            .then((_) {
                          appContext.currentInventory.value = null;
                          appContext.previousZone = null;
                        });
                      },
                      title: const Icon(
                        Icons.done_outline,
                        color: Colors.white,
                      ),
                      subtitle: Text(
                        'finish'.tr,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white),
                      ),
                      visualDensity: const VisualDensity(vertical: -4),
                    ),
                  ),
                ),
                builder: (context, _, child) {
                  for (var a in inventory.site.zones) {
                    if (a.lock.value == false) {
                      child = const SizedBox.shrink();
                      break;
                    }
                  }
                  return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: child!);
                },
              )
            ],
          );
        });
  }
}
