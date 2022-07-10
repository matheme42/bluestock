import 'package:bluestock/context/context.dart';
import 'package:bluestock/custom_widget/code_image/code_image.dart';
import 'package:bluestock/database/models/article.dart';
import 'package:bluestock/views/scanner_view/code_scanner_app_bar.dart';
import 'package:bluestock/views/scanner_view/code_scanner_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerState extends State<BarcodeScanner> {
  ValueNotifier<Article?> articleFound = ValueNotifier(null);
  ValueNotifier<Widget?> widgetCode = ValueNotifier(null);
  GlobalKey<ScannerBottomBarState> scannerBottomBarKey = GlobalKey();

  void onDetect(String? code, String type) {
    BluestockContext appContext = BluestockContext.of(context);
    List<Article> articles = appContext.currentInventory.value!.articles;

    String articleTitle = 'non définie';
    try {
      articleFound.value = articles.firstWhere((elm) => elm.code == code);
      articleFound.value!.commercialDenomination.toString();
    } catch (_) {}
    CodeScannerAppBar.open(articleTitle);
    appContext.scannerController.stop();
    widgetCode.value = CodeImage(code: code ?? '', type: type);
    scannerBottomBarKey.currentState?.open();
  }

  void onSuggestionTap(String name) {
    BluestockContext appContext = BluestockContext.of(context);
    List<Article> articles = appContext.currentInventory.value!.articles;
    primaryFocus?.unfocus();

    var a = articles.firstWhere((elm) => elm.commercialDenomination == name);
    appContext.scannerController.stop();
    widgetCode.value = CodeImage(code: a.code, type: null);
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
    scannerBottomBarKey.currentState?.jumpTo(0);
    scannerBottomBarKey.currentState?.close();
    if (appContext.previousZone != null) {
      appContext.currentZone.value = appContext.previousZone;
      appContext.previousZone = null;
      appContext.scannerController.start();
      return;
    }
    appContext.scannerController.stop();
    appContext.previousZone = appContext.currentZone.value;
    appContext.currentZone.value = null;
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
          onLeadingTap: exitEnter),
      body: Stack(
        children: [
          MobileScanner(
              controller: appContext.scannerController,
              allowDuplicates: true,
              onDetect: (Barcode barcode, _) {
                onDetect(barcode.rawValue, barcode.format.toString());
              }),

          ScannerBottomBar(
            key: scannerBottomBarKey,
            widgetCode: widgetCode,
            articleFound: articleFound,
            close: clean,
          ),
        ],
      ),
    );
  }
}

class BarcodeScanner extends StatefulWidget {
  const BarcodeScanner({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => BarcodeScannerState();
}
