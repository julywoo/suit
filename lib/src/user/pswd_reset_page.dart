import 'package:bykak/src/widget/custom_elevated_buttod.dart';
import 'package:bykak/src/widget/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bykak/src/user/login_page.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PswdResetPage extends StatelessWidget {
  //const JoinPage({Key? key}) : super(key: key);

  TextEditingController emailInputController = TextEditingController();
  TextEditingController passwordInputController = TextEditingController();
  TextEditingController nameInputController = TextEditingController();
  TextEditingController passwordConfirmInputController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black, // 햄버거버튼 아이콘 생성
          onPressed: () {
            // 아이콘 버튼 실행
            Get.back();
          },
        ),
        elevation: 0,
      ),
      body: Center(
        child: Container(
          width: 400,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 100,
                  child: Text(
                    '비밀번호 재발급',
                    style: TextStyle(
                      color: Color(0xff172543),
                      fontSize: 35,
                      fontFamily: 'gangwon1',
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: _JoinForm())
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _JoinForm() {
    return Container(
      child: Form(
          child: Column(
        children: [
          CustomTextFormField(hint: "Email", controller: emailInputController),
          SizedBox(
            height: 50,
          ),
          CustomElevatedButton(
            text: "이메일로 비밀번호 재발급",
            buttonTextColor: "#FFFFFF",
            buttonColor: "#172543",
            // pageRoute: () => Get.offAll(LoginPage()),
            pageRoute: () async {
              try {
                await FirebaseAuth.instance
                    .sendPasswordResetEmail(email: emailInputController.text);

                Get.offAll(LoginPage());
              } catch (e) {
                loginFailAlert();
              }
            },
          )
        ],
      )),
    );
  }

  void loginFailAlert() {
    Fluttertoast.showToast(
        msg: "이메일 주소가 정확하지 않거나 \n 가입된 계정 정보가 없습니다.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        webBgColor: "linear-gradient(to right, #F44336, #F44336)",
        timeInSecForIosWeb: 1,
        backgroundColor: Color(0xffF44336),
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
