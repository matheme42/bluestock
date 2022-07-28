import 'package:bluestock/context/context.dart';
import 'package:bluestock/custom_widget/root/root.dart';
import 'package:bluestock/dart/loading.dart';
import 'package:bluestock/database/shared_preference_controller.dart';
import 'package:bluestock/views/inventory_view/inventory_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// entry point du programme
Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  /// on recupere le language de depart de l'application
  var appContext = BluestockContext();
  appContext.language = await SharedPreferenceController.getLanguage();
  Root<BluestockContext>(
    title: 'Bluestock',
    languageYamlPath: 'assets/language.yaml',
    preLoading: Loading.loading,
    locale: appContext.language,
    showPerformanceOverlay: false,
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [Locale('en', ''), Locale('fr', '')],
    appContext: appContext,
    initialRoute: '/',
    debugShowCheckedModeBanner: false,
    routes: {'/': (context) => Home()},
  ).run();
}
