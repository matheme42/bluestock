import 'package:bluestock/context/context.dart';
import 'package:bluestock/models/models.dart';
import 'package:bluestock/views/scanner_view/bottom_bar/code_scanner_bottom_bar.dart';
import 'package:bluestock/views/scanner_view/code_scanner_app_bar.dart';
import 'package:bluestock/widgets/code_image/code_image.dart';
import 'package:bluestock/widgets/empty_square/empty_square.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerState extends State<BarcodeScanner> {
  ValueNotifier<Article?> articleFound = ValueNotifier(null);
  ValueNotifier<Widget?> widgetCode = ValueNotifier(null);
  GlobalKey<ScannerBottomBarState> scannerBottomBarKey = GlobalKey();

  void onDetect(String? code, String type) {
    BluestockContext appContext = BluestockContext.of(context);
    List<Article> articles = appContext.currentInventory.value!.articles;

    String articleTitle = 'not_define'.tr;
    Article? a;
    try {
      a = articles.firstWhere((elm) => elm.code == code);
      articleTitle = a.commercialDenomination;
    } catch (_) {}
    CodeScannerAppBar.open(articleTitle);
    appContext.scannerController.stop();
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
    widgetCode.value = CodeImage(code: a.code, type: null);
    CodeScannerAppBar.open(a.commercialDenomination);
    articleFound.value = a;
    scannerBottomBarKey.currentState?.open();
  }

  void clean() {
    BluestockContext appContext = BluestockContext.of(context);
    scannerBottomBarKey.currentState?.jumpTo(0);
    scannerBottomBarKey.currentState?.close();
    widgetCode.value = null;
    articleFound.value = null;

    CodeScannerAppBar.close();
    appContext.scannerController.start();
  }

  void exitEnter() {
    BluestockContext appContext = BluestockContext.of(context);
    if (appContext.previousZone != null) {
      appContext.currentZone.value = appContext.previousZone;
      appContext.previousZone = null;
      appContext.scannerController.start();
      return;
    }
    appContext.scannerController.stop();
    appContext.previousZone = appContext.currentZone.value;
    scannerBottomBarKey.currentState?.jumpTo(0);
    scannerBottomBarKey.currentState?.close();
    appContext.currentZone.value = null;
  }

  void onSearchOpen() {
    BluestockContext appContext = BluestockContext.of(context);
    appContext.scannerController.stop();
  }

  bool checkBarcodeOffset(List<Offset>? offsets, MediaQueryData query) {
    if (offsets == null) return false;

    Size cameraSize = const Size(480, 640);
    Size cameraCenter = Size(cameraSize.width / 2, cameraSize.height / 2);

    Size ecranSize = Size(query.size.width, query.size.height);

    Size zoom = Size(cameraSize.width / ecranSize.width,
        cameraSize.height / ecranSize.height);

    var dx = (offsets[0].dx - cameraCenter.width) / zoom.width;
    dx += ecranSize.width / 2;
    var dy = (offsets[0].dy - cameraCenter.height) / zoom.height;
    dy += ecranSize.height / 2;

    if (!(dx > ecranSize.width * 0.2 && dy > ecranSize.height * 1 / 3)) {
      return false;
    }

    var dx2 = (offsets[2].dx - cameraCenter.width) / zoom.width;
    dx2 += ecranSize.width / 2;
    var dy2 = (offsets[2].dy - cameraCenter.height) / zoom.height;
    dy2 += ecranSize.height / 2;

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
      ),
      body: Builder(builder: (context) {
        return Stack(
          children: [
            MobileScanner(
                controller: appContext.scannerController,
                allowDuplicates: true,
                fit: BoxFit.cover,
                onDetect: (Barcode barcode, _) {
                  if (appContext.cameraFocus.value == false ||
                      checkBarcodeOffset(
                          barcode.corners, MediaQuery.of(context))) {
                    onDetect(barcode.rawValue, barcode.format.toString());
                  }
                }),
            ValueListenableBuilder<bool>(
                valueListenable: appContext.cameraFocus,
                builder: (context, value, _) {
                  if (value == false) {
                    return const SizedBox.shrink();
                  }
                  return const EmptySquare();
                })
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
