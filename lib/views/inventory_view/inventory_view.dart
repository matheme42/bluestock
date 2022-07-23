import 'package:bluestock/context/context.dart';
import 'package:bluestock/custom_widget/shrink_side_menu/shrink_sidemenu.dart';
import 'package:bluestock/database/inventory_controller.dart';
import 'package:bluestock/database/models/inventory.dart';
import 'package:bluestock/views/home_view/home_app_bar.dart';
import 'package:bluestock/views/home_view/welcome_view.dart';
import 'package:bluestock/views/inventory_view/inventory_menu.dart';
import 'package:bluestock/views/scanner_view/code_scanner_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletons/skeletons.dart';

final GlobalKey<BarcodeScannerState> _barCodeScannerKey =
    GlobalKey<BarcodeScannerState>();

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);
  final Widget scanner = BarcodeScanner(key: _barCodeScannerKey);
  final ValueNotifier<bool> sideMenuOpened = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    BluestockContext appContext = BluestockContext.of(context);
    return SkeletonTheme(
      shimmerGradient: const LinearGradient(
        colors: [
          Color(0xFFD8E3E7),
          Color(0xFFC8D5DA),
          Color(0xFFD8E3E7),
        ],
        stops: [
          0.1,
          0.5,
          0.9,
        ],
      ),
      darkShimmerGradient: const LinearGradient(
        colors: [
          Color(0xFF222222),
          Color(0xFF242424),
          Color(0xFF2B2B2B),
          Color(0xFF242424),
          Color(0xFF222222),
        ],
        stops: [
          0.0,
          0.2,
          0.5,
          0.8,
          1,
        ],
        begin: Alignment(-2.4, -0.2),
        end: Alignment(2.4, 0.2),
        tileMode: TileMode.clamp,
      ),
      child: WillPopScope(
        onWillPop: () async {
          if (_barCodeScannerKey.currentState != null) {
            if (_barCodeScannerKey.currentState!.articleFound.value != null ||
                _barCodeScannerKey.currentState!.scannerBottomBarKey
                        .currentState!.tabContainerController.index ==
                    1) {
              _barCodeScannerKey.currentState!.clean();
              return false;
            }
          }

          if (appContext.currentZone.value != null) {
            appContext.previousZone = appContext.currentZone.value;
            BluestockContext.of(context).scannerController.stop();
            appContext.currentZone.value = null;
            return false;
          }
          if (appContext.currentInventory.value != null) {
            appContext.previousZone = null;
            appContext.currentInventory.value = null;
          }
          return false;
        },
        child: ValueListenableBuilder(
            valueListenable: appContext.currentZone,
            builder: (context, zone, _) {
              if (zone == null && sideMenuOpened.value == false) {
                sideMenuOpened.value = true;
              } else if (zone != null && sideMenuOpened.value == true) {
                sideMenuOpened.value = false;
              }
              return ValueListenableBuilder<Inventory?>(
                  valueListenable: appContext.currentInventory,
                  builder: (context, inventory, _) {

                    return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, anm) {
                          return FadeTransition(opacity: anm, child: child);
                        },
                        child: inventory == null ? const WelcomePage() : Stack(
                          children: [
                            SideMenu(
                                closeIcon: null,
                                menu: const InventoryMenu(),
                                extra: Scaffold(
                                  backgroundColor: const Color(0xFF112473),
                                  appBar: CustomAppBar.inventory(context, inventory),
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
                                      appContext.currentInventory.value!.done =
                                      true;
                                      InventoryController()
                                          .update(
                                          appContext.currentInventory.value!)
                                          .then((_) {
                                        appContext.currentInventory.value = null;
                                        appContext.previousZone = null;
                                      });
                                    },
                                    onTap: () {
                                      appContext.currentInventory.value!.done =
                                      true;
                                      InventoryController()
                                          .update(
                                          appContext.currentInventory.value!)
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
                                    visualDensity:
                                    const VisualDensity(vertical: -4),
                                  ),
                                ),
                              ),
                              builder: (context, _, child) {
                                for (var a in inventory.site.zones) {
                                  if (a.lock.value == false) {
                                    child = Container();
                                    break;
                                  }
                                }
                                return AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 500),
                                    child: child!);
                              },
                            )
                          ],
                        )
                    );
                  });
            }),
      ),
    );
  }
}
