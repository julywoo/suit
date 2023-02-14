import 'dart:io';

import 'package:bykak/src/pages/intro_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bykak/src/app.dart';
import 'package:bykak/src/pages/home.dart';
//import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:bykak/src/user/login_page.dart';

//import '../components/introduction_page.dart';

class LoginRouter extends StatefulWidget {
  const LoginRouter({Key? key}) : super(key: key);

  @override
  State<LoginRouter> createState() => _LoginRouterState();
}

class _LoginRouterState extends State<LoginRouter> {
  bool checkMobile = true;

  @override
  void initState() {
    checkPlatform();

    super.initState();
  }

  void checkPlatform() {
    try {
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        checkMobile = true;
      } else if (defaultTargetPlatform == TargetPlatform.android) {
        checkMobile = true;
      } else {
        checkMobile = false;
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    var widthVal = MediaQuery.of(context).size.width;
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext _, AsyncSnapshot<User?> user) {
        if (user.hasData) {
          return App();
        } else {
          return kIsWeb
              ? checkMobile
                  ? LoginPage()
                  : const IntroPage()
              : LoginPage();
          // widthVal < 1201 ? LoginPage() : const IntroPage();
        }
      },
    );
  }
}

// class LoginRouter extends StatefulWidget {
//   _LoginRouterState createState() => _LoginRouterState();
// }

// class _LoginRouterState extends State<LoginRouter> {
//   // /FirebaseAuth auth = FirebaseAuth.instance;

//   @override
//   Widget build(BuildContext context) {
//     return 
//     FutureBuilder(
//       future: Firebase.initializeApp(),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return Center(
//             child: Text("firebase load fail"),
//           );
//         }
//         if (snapshot.connectionState == ConnectionState.done) {
//           print(snapshot.connectionState);
//           print(snapshot.connectionState.toString());
//           if (snapshot.hasData) {
//             return App();
//           } else {
//             return AnimatedSplashScreen(
//               nextScreen: LoginPage(),
//               //nextScreen: LoginPage(),
//               splash: Image.asset('assets/splash.png'),
//               splashTransition: SplashTransition.fadeTransition,
//               duration: 2000,
//               backgroundColor: Color(0xff17191F),
//             );
//           }
//         } else {
//           return AnimatedSplashScreen(
//             nextScreen: LoginPage(),
//             //nextScreen: LoginPage(),
//             splash: Image.asset('assets/splash.png'),
//             splashTransition: SplashTransition.fadeTransition,
//             duration: 2000,
//             backgroundColor: Color(0xff17191F),
//           );
//         }
//       },
//     );
//     // return StreamBuilder<FirebaseUser>(
//     //   stream: FirebaseAuth.instance.authStateChanges(),
//     //   builder: (BuildContext context, snapshot) {
//     //     if (snapshot.connectionState == ConnectionState.waiting) {
//     //       return Splash();
//     //     } else {
//     //       if (snapshot.hasData) {
//     //         return Home();
//     //       }
//     //       return Login();
//     //     }
//     //   },
//     // );
//   }
// }

// class Splash extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).backgroundColor,
//       body: Container(
//           width: MediaQuery.of(context).size.width,
//           child: Center(
//             child: Text("Splash"),
//           )),
//     );
//   }
// }
