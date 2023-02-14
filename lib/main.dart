import 'package:bykak/firebase_options.dart';
import 'package:bykak/src/app.dart';
import 'package:bykak/src/controller/router.dart';
import 'package:bykak/src/pages/customer/membership_search_page.dart';
import 'package:bykak/src/pages/tailorShop/cost_list_page.dart';
import 'package:bykak/src/user/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:url_strategy/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  late bool isDarkMode;
  setPathUrlStrategy();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent, // navigation bar color
    statusBarColor: Colors.transparent, // Color for Andr
    // statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
    // statusBarBrightness: isDarkMode
    //     ? Platform.isIOS
    //         ? Brightness.dark
    //         : Brightness.light
    //     : Platform.isIOS
    //         ? Brightness.light
    //         : Brightness.dark
  ));

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // runApp(
  //   DevicePreview(
  //     enabled: true,
  //     tools: [
  //       ...DevicePreview.defaultTools,
  //       //const CustomPlugin(),
  //     ],
  //     builder: (context) => const MyApp(),
  //   ),
  // );
  runApp(Container(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    try {
      return GetMaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('ko', 'KR'),
        ],
        // builder: (context, child) => ResponsiveWrapper.builder(child,
        //     maxWidth: 1200,
        //     minWidth: 480,
        //     defaultScale: true,
        //     breakpoints: [
        //       ResponsiveBreakpoint.resize(480, name: MOBILE),
        //       ResponsiveBreakpoint.autoScale(800, name: TABLET),
        //       ResponsiveBreakpoint.resize(1000, name: DESKTOP),
        //     ],
        //     background: Container(
        //       color: Colors.white,
        //     )),

        debugShowCheckedModeBanner: false,
        title: '수잇',
        theme: ThemeData(
          primaryColor: Colors.white,
          //primarySwatch: Colors.blue,
          splashColor: Colors.transparent,
          appBarTheme: const AppBarTheme(
              iconTheme: IconThemeData(color: Colors.black),
              backgroundColor: Colors.white,
              titleTextStyle: TextStyle(color: Colors.black87, fontSize: 16)),
          textTheme: TextTheme(bodyText1: TextStyle(fontFamily: 'NanumGothic')),
        ),

        // initialRoute: '/',
        // getPages: [
        //   GetPage(name: '/login', page: () => LoginPage()),
        //   GetPage(name: '/', page: () => App()),
        // ],

        routes: {
          '/memberShip': (context) => MembershipSearch(),
        },

        home: LoginRouter(),
      );
    } catch (e) {
      return GetMaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('ko', 'KR'),
        ],
        // builder: (context, child) => ResponsiveWrapper.builder(child,
        //     maxWidth: 1200,
        //     minWidth: 480,
        //     defaultScale: true,
        //     breakpoints: [
        //       ResponsiveBreakpoint.resize(480, name: MOBILE),
        //       ResponsiveBreakpoint.autoScale(800, name: TABLET),
        //       ResponsiveBreakpoint.resize(1000, name: DESKTOP),
        //     ],
        //     background: Container(
        //       color: Colors.white,
        //     )),

        debugShowCheckedModeBanner: false,
        title: '수잇',
        theme: ThemeData(
          primaryColor: Colors.white,
          //primarySwatch: Colors.blue,
          splashColor: Colors.transparent,
          appBarTheme: const AppBarTheme(
              iconTheme: IconThemeData(color: Colors.black),
              backgroundColor: Colors.white,
              titleTextStyle: TextStyle(color: Colors.black87, fontSize: 16)),
          textTheme: TextTheme(bodyText1: TextStyle(fontFamily: 'NanumGothic')),
        ),

        home: LoginRouter(),
      );
    }
  }
}
