import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:math';
import 'package:flutter/foundation.dart';

import 'package:bykak/src/app.dart';
import 'package:bykak/src/user/join_page.dart';
import 'package:bykak/src/user/pswd_reset_page.dart';
import 'package:bykak/src/widget/custom_elevated_buttod.dart';
import 'package:bykak/src/widget/custom_login_form_field.dart';
import 'package:bykak/src/widget/custom_text_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool _isKaKaoTalkInstalled = true;

  TextEditingController emailInputController = TextEditingController();

  TextEditingController passwordInputController = TextEditingController();

  Future<void> resetPassword(String email) async {
    await auth.sendPasswordResetEmail(email: email);
  }

  bool kisweb = true;
  @override
  void initState() {
    checkPlatform();
    super.initState();
  }

  void checkPlatform() {
    try {
      if (defaultTargetPlatform == TargetPlatform.iOS) {
      } else if (defaultTargetPlatform == TargetPlatform.android) {
        // Some android/ios specific code

      } else {}
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          color: HexColor('#FFFFFF'),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Container(
                    child: Image.asset(
                      'assets/logo.png',
                      height: 50,
                    ),
                  ),
                ),

                SizedBox(
                  height: 50,
                  //height: MediaQuery.of(context).size.height * 0.1,
                ),
                // kisweb
                //     ?

                Container(
                    //width: MediaQuery.of(context).size.width * 0.8,
                    width: 400,
                    child: _LoginForm())
                // : Container(
                //    // width: MediaQuery.of(context).size.width * 0.8,
                //     child: _LoginForm()),
                // Send Password Reset Email by Korean
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _LoginForm() {
    return Form(
        child: Column(
      children: [
        CustomLoginFormField(
          hint: "이메일",
          lines: 1,
          controller: emailInputController,
          loginMethod: checkAuth,
        ),
        CustomLoginFormField(
          hint: "비밀번호",
          lines: 1,
          controller: passwordInputController,
          loginMethod: checkAuth,
        ),
        // CustomTextFormField(
        //   hint: "Password",
        //   controller: passwordInputController,
        // ),
        // SizedBox(
        //   height: 20,
        // ),
        SizedBox(
          height: 10,
        ),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                  onPressed: () {
                    Get.to(JoinPage());
                  },
                  child: Text(
                    '이메일 회원가입',
                    style: TextStyle(color: HexColor('#172543'), fontSize: 12),
                  )),
              const Text('|'),
              TextButton(
                  onPressed: () {
                    Get.to(PswdResetPage());
                  },
                  child: Text(
                    '비밀번호 찾기',
                    style: TextStyle(color: HexColor('#172543'), fontSize: 12),
                  )),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),

        CustomElevatedButton(
          text: "Log In",
          buttonTextColor: "#FFFFFF",
          buttonColor: "#172543",

          // pageRoute: () => Get.offAll(App()),
          pageRoute: () async {
            try {
              checkAuth();
            } catch (e) {}
          },
        ),
      ],
    ));
  }

//계정 권한이 존재하는지
  checkAuth() async {
    String returnVal = "0";

    try {
      var users = await FirebaseFirestore.instance
          .collection('users')
          .doc(emailInputController.text)
          .get();

      setState(() {
        try {
          returnVal = users['userAuthority'];
        } catch (e) {
          returnVal = "0";
        }
      });

      if (returnVal == "0") {
        loginFailAlert();
      }
    } catch (e) {
      loginFailAlert();
    }

    if (returnVal == "1") {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailInputController.text,
          password: passwordInputController.text,
        );
        // Get.offAll(App());

        _onLoading();
      } catch (e) {
        loginFailAlert();
      }
    } else if (returnVal == "2") {
      authFailAlert();
    }
    // else {
    //   print('10');
    //   loginFailAlert();
    // }
  }

  void _onLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: SizedBox(
            height: 30,
            width: 30,
            child: CircularProgressIndicator(
              color: HexColor('#172543'),
            ),
          ),
        );
        // Dialog(
        //   backgroundColor: Colors.transparent,
        //   elevation: 0.1,
        //   child: Container(
        //     width: 200,
        //     height: 150,
        //     decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(50),
        //       color: Colors.transparent,
        //     ),
        //     child: Center(
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.center,
        //         mainAxisSize: MainAxisSize.min,
        //         children: [
        //           CircularProgressIndicator(
        //             color: HexColor('#172543'),
        //           ),
        //           SizedBox(
        //             height: 20,
        //           ),
        //           Text("로그인 중..."),
        //         ],
        //       ),
        //     ),
        //   ),
        // );
      },
    );
    new Future.delayed(new Duration(seconds: 1), () {
      Get.offAll(App());
    });
  }

  void loginFailAlert() {
    Fluttertoast.showToast(
        webBgColor: "linear-gradient(to right, #F44336, #F44336)",
        webPosition: "center",
        msg: "이메일 혹은 패스워드를 확인하세요.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Color(0xffF44336),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void authFailAlert() {
    Fluttertoast.showToast(
        webBgColor: "linear-gradient(to right, #F44336, #F44336)",
        webPosition: "center",
        msg: "계정 승인 대기 중 입니다.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Color(0xffF44336),
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
