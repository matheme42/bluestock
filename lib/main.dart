import 'package:bluestock/context/context.dart';
import 'package:bluestock/custom_widget/root/root.dart';
import 'package:bluestock/dart/loading.dart';
import 'package:bluestock/views/home_view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


/// entry point du programme
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  Wakelock.enable();
  Future.delayed(const Duration(milliseconds: 500), () {
    runApp(Root<BluestockContext>(
        title: 'Bluestock',
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
        routes: {'/': (context) => Home()}));
  });
}
