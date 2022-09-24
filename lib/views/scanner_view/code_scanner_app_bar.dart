import 'package:auto_size_text/auto_size_text.dart';
import 'package:bluestock/context/context.dart';
import 'package:bluestock/models/models.dart';
import 'package:bluestock/shared_preferences/shared_preference_controller.dart';
import 'package:bluestock/widgets/easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CodeScannerAppBar {
  static final GlobalKey<EasySearchBarState> _easySearchBarKey = GlobalKey();

  static Future<List<String>> _getSuggestion(
      String search, List<Article> articles) async {
    await Future.delayed(const Duration(seconds: 1));
    if (search.isEmpty) return [];
    List<String> suggestions = [];
    for (var elm in articles) {
      bool add = false;
      if (elm.codeProduct.toString().contains(search)) {
        add = true;
      }
      if (elm.code.toString().contains(search)) {
        add = true;
      }
      if (elm.commercialDenomination.toString().contains(search)) {
        add = true;
      }
      if (elm.internalDenomination.toString().contains(search)) {
        add = true;
      }
      if (elm.referenceUnit.toString().contains(search)) {
        add = true;
      }
      if (elm.family.toString().contains(search)) {
        add = true;
      }
      if (elm.underFamily.toString().contains(search)) {
        add = true;
      }
      if (add == true) {
        suggestions.add("${elm.commercialDenomination};${elm.codeProduct}");
      }
      if (suggestions.length >= 40) {
        break;
      }
    }
    suggestions.sort((a, b) => a.compareTo(b));
    return suggestions;
  }

  static open(String? text) =>
      _easySearchBarKey.currentState?.forceOpen(text ?? '');

  static close() => _easySearchBarKey.currentState?.clear();

  static PreferredSizeWidget build(
      {required BluestockContext appContext,
      required Function() onLeadingTap,
      Function(String)? onSuggestionTap,
      Function()? onSearchOpen,
      Function()? onSearchClose,
      List<Article> articles = const []}) {
    return EasySearchBar(
      key: _easySearchBarKey,
      searchBackgroundColor: const Color(0xFF112473),
      searchCursorColor: Colors.white,
      backgroundColor: Colors.deepPurple,
      isFloating: false,
      onStateChange: (state) {
        if (state == false) {
          onSearchClose != null ? onSearchClose() : 0;
        } else {
          onSearchOpen != null ? onSearchOpen() : 0;
        }
      },
      searchTextStyle: const TextStyle(color: Colors.white),
      onSearch: (value) {},
      suggestionLoaderBuilder: () => const SizedBox.shrink(),
      suggestionBackgroundColor: Colors.transparent,
      suggestionBuilder: (string) {
        List data = string.split(';');
        return Card(
          child: ListTile(
            trailing: AutoSizeText(
              data[1],
              minFontSize: 5,
              maxLines: 1,
            ),
            title: AutoSizeText(
              data[0],
              minFontSize: 5,
              maxLines: 2,
            ),
          ),
        );
      },
      debounceDuration: const Duration(milliseconds: 200),
      asyncSuggestions: (search) async =>
          await _getSuggestion(search, articles),
      iconTheme: const IconThemeData(color: Colors.white),
      searchBackIconTheme: const IconThemeData(color: Colors.white),
      actions: [
        IconButton(
          color: Colors.white,
          icon: ValueListenableBuilder<TorchState>(
            valueListenable: appContext.scannerController.torchState,
            builder: (context, state, child) {
              if (state == TorchState.off) {
                return const Icon(Icons.flash_off, color: Colors.grey);
              }
              return const Icon(Icons.flash_on, color: Colors.yellow);
            },
          ),
          iconSize: 32.0,
          onPressed: () => appContext.scannerController.toggleTorch(),
        ),
        IconButton(
          color: Colors.white,
          icon: ValueListenableBuilder<bool>(
            valueListenable: appContext.cameraFocus,
            builder: (context, value, child) {
              if (value == false) {
                return const Icon(Icons.fullscreen, color: Colors.white);
              }
              return const Icon(Icons.center_focus_weak_sharp, color: Colors.white);
            },
          ),
          iconSize: 32.0,
          onPressed: () {
            bool val = !appContext.cameraFocus.value;
            SharedPreferenceController.setCameraFocus(val).then((value) {
              appContext.cameraFocus.value = val;
            });
          }
        ),
        IconButton(
          color: Colors.white,
          icon: ValueListenableBuilder(
            valueListenable: appContext.scannerController.cameraFacingState,
            builder: (context, state, child) {
              return const Icon(Icons.cameraswitch);
            },
          ),
          iconSize: 32.0,
          onPressed: () => appContext.scannerController.switchCamera(),
        ),
      ],
      leading: ValueListenableBuilder<Zone?>(
          valueListenable: appContext.currentZone,
          child: IconButton(
              onPressed: onLeadingTap,
              icon: const Icon(Icons.menu, color: Colors.white)),
          builder: (context, zone, child) {
            if (appContext.previousZone != null) {
              return ValueListenableBuilder<bool>(
                  valueListenable: appContext.previousZone!.lock,
                  builder: (context, lock, _) {
                    return lock ? const SizedBox.shrink() : child!;
                  });
            }
            return zone != null ? child! : const SizedBox.shrink();
          }),
      suggestionsElevation: 5,
      onSuggestionTap: (string) => onSuggestionTap!(string.split(';').first),
      title: const Text(''),
    );
  }
}
