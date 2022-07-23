import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';


class RootObserver extends StatefulWidget {
  final Widget child;
  final Function? onTurnBackground;
  final Function? onTurnForeground;
  final Future<void> Function(BuildContext context)? onLoading;
  final Widget? onLoadingScreen;
  final Duration? onLoadingMinDuration;

  const RootObserver(
      {Key? key,
      required this.child,
      this.onTurnBackground,
      this.onTurnForeground,
      this.onLoading,
      this.onLoadingScreen,
      this.onLoadingMinDuration})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return RootObserverState();
  }
}

class RootObserverState extends State<RootObserver>
    with WidgetsBindingObserver {
  bool loading = false;

  Future<void> onLoading() async {
    DateTime startLoading = DateTime.now().toUtc();
    await widget.onLoading!(context);
    while (DateTime.now().toUtc().difference(startLoading).inSeconds <
        widget.onLoadingMinDuration!.inSeconds) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
    if (widget.onLoading != null) {
      loading = true;
      onLoading().then((value) {
        setState(() {
          loading = false;
        });
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        if (widget.onTurnBackground == null) break;
        widget.onTurnBackground!();
        break;
      case AppLifecycleState.resumed:
        if (widget.onTurnForeground == null) break;
        widget.onTurnForeground!();
        break;
      case AppLifecycleState.paused:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedSwitcher(
          duration: const Duration(seconds: 1, milliseconds: 500),
          child: loading ? widget.onLoadingScreen : widget.child,
        ),
      ],
    );
  }
}

class Root<T extends ChangeNotifier> extends StatelessWidget {
  /// personnalisation
  final String title;
  final ThemeData? darkTheme;
  final ThemeData? theme;

  /// routing
  final Map<String, Widget Function(BuildContext)> routes;
  final String initialRoute;

  /// internationalisation
  final Iterable<Locale> supportedLocales;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final Locale? locale;

  /// app initialisation
  final Future<void> Function(BuildContext context)? onLoading;
  final Widget? onLoadingScreen;
  final Duration onLoadingMinDuration;

  /// app state
  final Function(bool)? onKeyBoardChange;
  final Function? onTurnBackground;
  final Function? onTurnForeground;

  ///debugger
  final bool debugShowCheckedModeBanner;
  final bool showPerformanceOverlay;
  final bool showSemanticsDebugger;
  final bool debugShowMaterialGrid;

  final RouteFactory? onUnknownRoute;
  final RouteFactory? onGenerateRoute;

  /// AppContext
  final T appContext;
  final Translations translations;

  // ignore: use_key_in_widget_constructors
  const Root({
    required this.title,
    this.theme,
    this.darkTheme,
    required this.routes,
    required this.initialRoute,
    this.onLoading,
    this.onLoadingScreen,
    this.onLoadingMinDuration = const Duration(seconds: 0),
    this.onKeyBoardChange,
    this.onTurnBackground,
    this.onTurnForeground,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.localizationsDelegates,
    this.locale,
    this.debugShowCheckedModeBanner = true,
    this.showPerformanceOverlay = false,
    this.showSemanticsDebugger = false,
    this.debugShowMaterialGrid = false,
    this.onUnknownRoute,
    required this.appContext,
    this.onGenerateRoute,
    required this.translations,
  }) : assert((onLoading != null && onLoadingScreen != null) ||
            onLoading == null);

  static Root? ofContext(BuildContext context) {
    return context.findAncestorWidgetOfExactType<Root>();
  }

  @override
  Widget build(BuildContext context) {
    bool globalKeyboardIsVisible = false;
    return GetMaterialApp(
        title: title,
        routes: routes,
        theme: theme,
        darkTheme: darkTheme,
        showPerformanceOverlay: showPerformanceOverlay,
        showSemanticsDebugger: showSemanticsDebugger,
        debugShowMaterialGrid: debugShowMaterialGrid,
        supportedLocales: supportedLocales,
        localizationsDelegates: localizationsDelegates,
        initialRoute: initialRoute,
        locale: locale,
        translations: translations,
        onGenerateRoute: onGenerateRoute,
        onUnknownRoute: onUnknownRoute,
        debugShowCheckedModeBanner: debugShowCheckedModeBanner,
        builder: (context, navigator) {
          MediaQueryData query = MediaQuery.of(context);
          double height =
              query.viewInsets.bottom + query.size.height - query.padding.top;
          return SafeArea(
              child: MaterialButton(
            splashColor: Colors.transparent,
            onPressed: () {
              Focus.of(context).unfocus();
              SystemChrome.restoreSystemUIOverlays();
            },
            padding: EdgeInsets.zero,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: SizedBox(
                  height: height,
                  child: ChangeNotifierProvider(
                      create: (context) => appContext,
                      child: KeyboardVisibilityBuilder(
                        builder: (context, isKeyboardVisible) {
                          if (isKeyboardVisible == false && globalKeyboardIsVisible == true) {
                            SystemChrome.restoreSystemUIOverlays();
                          }
                          globalKeyboardIsVisible = isKeyboardVisible;
                          return RootObserver(
                            onTurnBackground: onTurnBackground,
                            onTurnForeground: onTurnForeground,
                            onLoadingScreen: onLoadingScreen,
                            onLoading: onLoading,
                            onLoadingMinDuration: onLoadingMinDuration,
                            child: navigator!,
                          );
                        }
                      ))),
            ),
          ));
        });
  }
}
