import 'package:bluestock/context/context.dart';
import 'package:bluestock/functions/loading.dart';
import 'package:bluestock/shared_preferences/shared_preference_controller.dart';
import 'package:bluestock/views/scaffold_view/home.dart';
import 'package:bluestock/widgets/root/root.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// entry point du programme
Future<void> main() async {
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
    appContext: appContext,
    initialRoute: '/',
    debugShowCheckedModeBanner: false,
    routes: {'/': (context) => const Home()},
  ).run();
}
