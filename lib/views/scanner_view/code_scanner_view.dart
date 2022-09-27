import 'package:bluestock/context/context.dart';
import 'package:bluestock/models/models.dart';
import 'package:bluestock/views/scanner_view/bottom_bar/code_scanner_bottom_bar.dart';
import 'package:bluestock/views/scanner_view/code_scanner_app_bar.dart';
import 'package:bluestock/views/scanner_view/tools_menu.dart';
import 'package:bluestock/widgets/HawkFabMenu/hawk_fab_menu.dart';
import 'package:bluestock/widgets/code_image/code_image.dart';
import 'package:bluestock/widgets/empty_square/empty_square.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerState extends State<BarcodeScanner> {
  ValueNotifier<Article?> articleFound = ValueNotifier(null);
  ValueNotifier<Widget?> widgetCode = ValueNotifier(null);
  GlobalKey<ScannerBottomBarState> scannerBottomBarKey = GlobalKey();
  final HawkFabMenuController hawkFabMenuController = HawkFabMenuController();
  ValueNotifier<bool> showCameraParameters = ValueNotifier(true);
  final ValueNotifier<int> number = ValueNotifier<int>(0);

  void onDetect(String? code, String type) {
    BluestockContext appContext = BluestockContext.of(context);
    List<Article> articles = appContext.currentInventory.value!.articles;

    String articleTitle = 'not_define'.tr;
    Article? a;
    try {
      a = articles.firstWhere((elm) => elm.code == code);
      articleTitle = a.commercialDenomination;
    } catch (_) {}

    if (hawkFabMenuController.isOpen()) {
      hawkFabMenuController.toggleMenu();
    }
    showCameraParameters.value = false;
    CodeScannerAppBar.open(articleTitle);
    widgetCode.value = CodeImage(code: code ?? '', type: type);
    articleFound.value = a;
    scannerBottomBarKey.currentState?.open();
  }

  void onSuggestionTap(String name) {
    BluestockContext appContext = BluestockContext.of(context);
    List<Article> articles = appContext.currentInventory.value!.articles;
    primaryFocus?.unfocus();

    var a = articles.firstWhere((elm) => elm.commercialDenomination == name);
    appContext.scannerController.stop();
    showCameraParameters.value = false;
    widgetCode.value = CodeImage(code: a.code, type: null);
    CodeScannerAppBar.open(a.commercialDenomination);
    articleFound.value = a;
    scannerBottomBarKey.currentState?.open();
  }

  void clean() {
    BluestockContext appContext = BluestockContext.of(context);
    if (hawkFabMenuController.isOpen()) {
      hawkFabMenuController.toggleMenu();
    }
    showCameraParameters.value = true;
    scannerBottomBarKey.currentState?.jumpTo(0);
    scannerBottomBarKey.currentState?.close();
    widgetCode.value = null;
    articleFound.value = null;
    number.value = 0;

    CodeScannerAppBar.close();
    appContext.scannerController.start();
  }

  void exitEnter() {
    BluestockContext appContext = BluestockContext.of(context);
    if (appContext.previousZone != null) {
      appContext.currentZone.value = appContext.previousZone;
      appContext.previousZone = null;
      showCameraParameters.value = true;
      appContext.scannerController.start();
      return;
    }
    appContext.scannerController.stop();
    appContext.previousZone = appContext.currentZone.value;
    if (hawkFabMenuController.isOpen()) {
      hawkFabMenuController.toggleMenu();
    }
    scannerBottomBarKey.currentState?.jumpTo(0);
    scannerBottomBarKey.currentState?.close();

    appContext.currentZone.value = null;
  }

  void onSearchOpen() {
    BluestockContext appContext = BluestockContext.of(context);
    if (hawkFabMenuController.isOpen()) {
      hawkFabMenuController.toggleMenu();
    }
    showCameraParameters.value = false;
    appContext.scannerController.stop();
  }

  void onTabsOpen() {
    if (hawkFabMenuController.isOpen()) {
      hawkFabMenuController.toggleMenu();
    }
    showCameraParameters.value = false;
  }

  void onTabsClose() {
    showCameraParameters.value = true;
  }

  bool checkBarcodeOffsetInProgress = false;

  bool checkBarcodeOffset(List<Offset>? offsets, Size ecranSize) {
    if (offsets == null) return false;

    Size cameraSize = const Size(480, 640);
    Size ecranCenter = Size(ecranSize.width / 2, ecranSize.height / 2);
    Size cameraCenter = Size(cameraSize.width / 2, cameraSize.height / 2);

    Size zoom = Size(cameraSize.width / ecranSize.width,
        cameraSize.height / ecranSize.height);

    var dx = (offsets[0].dx - cameraCenter.width) / zoom.width;
    dx += ecranCenter.width;
    var dy = (offsets[0].dy - cameraCenter.height) / zoom.height;
    dy += ecranCenter.height;

    if (!(dx > ecranSize.width * 0.2 && dy > ecranSize.height * 1 / 3)) {
      return false;
    }

    var dx2 = (offsets[2].dx - cameraCenter.width) / zoom.width;
    dx2 += ecranCenter.width;
    var dy2 = (offsets[2].dy - cameraCenter.height) / zoom.height;
    dy2 += ecranCenter.height;

    if (!(dx2 < ecranSize.width * 0.8 && dy2 < ecranSize.height * 2 / 3)) {
      return false;
    }
    return (true);
  }

  @override
  Widget build(BuildContext context) {
    BluestockContext appContext = BluestockContext.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CodeScannerAppBar.build(
          appContext: appContext,
          articles: appContext.currentInventory.value!.articles,
          onSuggestionTap: onSuggestionTap,
          onSearchClose: clean,
          onSearchOpen: onSearchOpen,
          onLeadingTap: exitEnter),
      bottomNavigationBar: ScannerBottomBar(
        key: scannerBottomBarKey,
        widgetCode: widgetCode,
        articleFound: articleFound,
        close: clean,
        open: onTabsOpen,
        softClose: onTabsClose,
        number: number,
      ),
      body: Builder(builder: (context) {
        var query = MediaQuery.of(context);
        Size ecranSize = Size(query.size.width, query.size.height);
        return Stack(
          children: [
            MobileScanner(
                controller: appContext.scannerController,
                allowDuplicates: true,
                fit: BoxFit.cover,
                onDetect: (Barcode barcode, _) {
                  if (checkBarcodeOffsetInProgress == true) return;
                  checkBarcodeOffsetInProgress = true;

                  if (appContext.cameraFocus.value == true &&
                      checkBarcodeOffset(barcode.corners, ecranSize) == false) {
                    checkBarcodeOffsetInProgress = false;
                    return;
                  }

                  appContext.scannerController.stop();
                  Future.delayed(const Duration(milliseconds: 100))
                      .then((value) {
                    onDetect(barcode.rawValue, barcode.format.toString());
                    checkBarcodeOffsetInProgress = false;
                  });
                }),
            ValueListenableBuilder<bool>(
                valueListenable: appContext.cameraFocus,
                builder: (context, value, _) {
                  if (value == false) {
                    return const SizedBox.shrink();
                  }
                  return const EmptySquare();
                }),
            ValueListenableBuilder(
              builder: (context, value, child) {
                return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: value == true
                        ? ToolsMenu(
                            hawkFabMenuController: hawkFabMenuController)
                        : const SizedBox.shrink());
              },
              valueListenable: showCameraParameters,
            )
          ],
        );
      }),
    );
  }
}

class BarcodeScanner extends StatefulWidget {
  const BarcodeScanner({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => BarcodeScannerState();
}
