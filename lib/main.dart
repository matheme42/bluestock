import 'package:bluestock/context/context.dart';
import 'package:bluestock/custom_widget/root/root.dart';
import 'package:bluestock/dart/loading.dart';
import 'package:bluestock/language/translation.dart';
import 'package:bluestock/views/inventory_view/inventory_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:wakelock/wakelock.dart';
import 'package:yaml/yaml.dart';


/// entry point du programme
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  Wakelock.enable();
  var m = loadYaml(await rootBundle.loadString('assets/language.yaml')) as Map;
  m.forEach((key, value) {
    Map <String, String>map = {};
    (value as Map).forEach((key2, value2) {
      map[key2.toString()] = value2.toString();
    });
    LocaleString.data[key.toString()] = map;
  });
  Future.delayed(const Duration(milliseconds: 500), () {
    runApp(Root<BluestockContext>(
        title: 'Bluestock',
        translations: LocaleString(),
        onLoading: Loading.loading,
        locale: const Locale('fr','FR'),
        showPerformanceOverlay: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('fr', ''),
        ],
        onLoadingScreen: Container(
          color: Colors.black,
        ),
        appContext: BluestockContext(),
        initialRoute: '/',
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => Home()},

    ));
  });
}
