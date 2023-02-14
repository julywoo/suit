import 'package:bykak/src/model/user_model.dart';
import 'package:bykak/src/widget/custom_elevated_buttod.dart';
import 'package:bykak/src/widget/custom_login_form_field.dart';
import 'package:bykak/src/widget/custom_text_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bykak/src/user/login_page.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class JoinPage extends StatefulWidget {
  @override
  State<JoinPage> createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {
  //const JoinPage({Key? key}) : super(key: key);
  TextEditingController emailInputController = TextEditingController();

  TextEditingController passwordInputController = TextEditingController();

  TextEditingController nameInputController = TextEditingController();

  TextEditingController storeNameInputController = TextEditingController();

  TextEditingController userPhoneController = TextEditingController();

  TextEditingController passwordConfirmInputController =
      TextEditingController();

  int _selectedIndex = 0;
  List<String> joinList = ['테일러샵', '제작공장'];
  bool _loading = false;
  var returnId;

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
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 400,
            color: HexColor('#FFFFFF'),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: 30,
                    child: Text(
                      '회원가입',
                      style: TextStyle(
                          color: HexColor('#172543'),
                          fontSize: 22,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _JoinForm()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _JoinForm() {
    var withtVal = MediaQuery.of(context).size.width;
    return Container(
      child: Form(
          child: Column(
        children: [
          CustomLoginFormField(
            lines: 1,
            hint: "이메일",
            controller: emailInputController,
            loginMethod: checkAuth,
          ),
          CustomLoginFormField(
            lines: 1,
            hint: "비밀번호",
            controller: passwordInputController,
            loginMethod: checkAuth,
          ),
          CustomLoginFormField(
            lines: 1,
            hint: "비밀번호 확인",
            controller: passwordConfirmInputController,
            loginMethod: checkAuth,
          ),
          CustomLoginFormField(
            lines: 1,
            hint: "이름",
            controller: nameInputController,
            loginMethod: checkAuth,
          ),
          CustomLoginFormField(
            lines: 1,
            hint: "연락처",
            controller: userPhoneController,
            loginMethod: checkAuth,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              customRadio(joinList[0], 1, withtVal),
              customRadio(joinList[1], 2, withtVal),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          CustomLoginFormField(
            lines: 1,
            hint: "Store Name",
            controller: storeNameInputController,
            loginMethod: checkAuth,
          ),
          SizedBox(
            height: 30,
          ),
          CustomElevatedButton(
            text: "이메일 회원가입",
            buttonTextColor: "#FFFFFF",
            buttonColor: "#172543",
            // pageRoute: () => Get.offAll(LoginPage()),
            pageRoute: () async {
              checkAuth();
            },
          )
        ],
      )),
    );
  }

  checkValidate() async {
    try {
      if (passwordInputController.text != passwordConfirmInputController.text) {
        //비밀번호 & 비밀번호 확인 일치여부
        loginFailAlert();
      } else {
        //이메일 패스워드 정규표현식 여부

        if (validateEmail(emailInputController.text) == false ||
            validatePswd(passwordInputController.text) == false) {
        } else {
          if (nameInputController.text != "" &&
              _selectedIndex != 0 &&
              storeNameInputController.text != "" &&
              userPhoneController.text != "") {
            try {
              try {
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: emailInputController.text,
                  password: passwordInputController.text,
                );

                await FirebaseAuth.instance.currentUser!
                    .updateDisplayName(nameInputController.text);

                await FirebaseAuth.instance.currentUser!.reload();

                _onLoading();
              } catch (e) {
                print(e);
                String msg = '이미 존재하는 계정입니다.';
                joinFailAlert(msg);
              }
            } catch (e) {}
          } else if (nameInputController.text == "") {
            var errMsg = '이름 혹은 닉네임을 입력하세요.';

            joinFailAlert(errMsg);
          } else if (userPhoneController.text == "") {
            var errMsg = '연락처를 입력하세요.';

            joinFailAlert(errMsg);
          } else if (storeNameInputController.text == "") {
            var errMsg = '업체명을 입력하세요.';

            joinFailAlert(errMsg);
          } else if (_selectedIndex == 0) {
            var errMsg = '업체 타입을 선택하세요.';

            joinFailAlert(errMsg);
          } else {}
        }
      }
    } catch (e) {
      print(e);
    }
  }

  bool validateEmail(String value) {
    if (value.isEmpty) {
      String msg = '이메일 주소를 입력하세요';
      joinFailAlert(msg);
      return false;
    } else {
      var pattern =
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
      //r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp = new RegExp(pattern);
      if (!regExp.hasMatch(value)) {
        //포커스를 해당 textformfield에 맞춘다.
        String msg = '잘못된 이메일 형식입니다.';
        joinFailAlert(msg);
        return false;
      } else {
        return true;
      }
    }
  }

  checkAuth() async {
    String returnVal = "0";

    try {
      var users = await FirebaseFirestore.instance
          .collection('users')
          .doc(emailInputController.text)
          .get();

      setState(() {
        try {
          returnVal = users['userId'];
        } catch (e) {
          returnVal = "0";
        }
      });
    } catch (e) {}

    if (returnVal != emailInputController.text) {
      try {
        checkValidate();
      } catch (e) {}
    } else {
      String msg = '이미 존재하는 계정입니다.';
      joinFailAlert(msg);
    }
  }

  bool validatePswd(String value) {
    if (value.isEmpty) {
      String msg = '비밀번호를 입력하세요';
      joinFailAlert(msg);
      return false;
    } else {
      var pattern =
          //r'^[A-Za-z0-9]{8,15}$';
          r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?~^<>,.&+=])[A-Za-z\d$@$!%*#?~^<>,.&+=]{8,15}$';
      RegExp regExp = new RegExp(pattern);

      if (!regExp.hasMatch(value)) {
        String msg = '특수문자, 대소문자, 숫자 포함 8자 이상 15자 이내로 입력하세요.';
        joinFailAlert(msg);
        return false;
      } else {
        return true;
      }
    }
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

    new Future.delayed(
      new Duration(milliseconds: 5),
      () {
        userDataSave();
        Get.offAll(LoginPage());
      },
    );
  }

  UserData? _userData;

  void userDataSave() {
    final users = FirebaseFirestore.instance
        .collection('users')
        .doc(emailInputController.text);
    var _toDay = DateTime.now();

    _userData = UserData(
      userName: nameInputController.text,
      userPhone: userPhoneController.text,
      userId: emailInputController.text,
      userAuthority: '2',
      storeName: storeNameInputController.text,
      userType: _selectedIndex.toString(),
      userGrade: '',
      userTailorPart: '',
      userFactoryPart: '',
      registDate: _toDay.toString().substring(0, 10),
      factoryName: '',
    );

    if (_selectedIndex == 2) {
      final factory = FirebaseFirestore.instance
          .collection('factory')
          .doc(storeNameInputController.text);

      _userData = UserData(
        userName: nameInputController.text,
        userPhone: userPhoneController.text,
        userId: emailInputController.text,
        userAuthority: '2',
        storeName: storeNameInputController.text,
        userType: _selectedIndex.toString(),
        userGrade: '',
        userTailorPart: '',
        userFactoryPart: '',
        registDate: _toDay.toString().substring(0, 10),
        factoryName: storeNameInputController.text,
      );

      factory.set(_userData!.toJson());
    }

    try {
      users.set(_userData!.toJson());

      Get.offAll(LoginPage());
    } catch (e) {
      print(e);
    }
  }

  void joinFailAlert(String msg) {
    Fluttertoast.showToast(
        webBgColor: "linear-gradient(to right, #F44336, #F44336)",
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Color(0xffF44336),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void loginFailAlert() {
    Fluttertoast.showToast(
        webBgColor: "linear-gradient(to right, #F44336, #F44336)",
        msg: "비밀번호가 일치하지 않습니다.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Color(0xffF44336),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void changeIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget customRadio(String text, int index, withtVal) {
    return OutlinedButton(
      onPressed: () {
        changeIndex(index);
      },
      child: Text(text,
          style: TextStyle(
              color: _selectedIndex == index
                  ? HexColor('#FFFFFF')
                  : Colors.black87)),
      style: OutlinedButton.styleFrom(
        //minimumSize: Size(Get.width * 0.45, 50), //최소 사이즈

        backgroundColor:
            _selectedIndex == index ? HexColor('#172543') : Colors.transparent,
        minimumSize: withtVal < 481
            ? Size(Get.width * 0.35, 40)
            : Size(170, 50), //최소 사이즈
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),

        side: BorderSide(
            width: _selectedIndex == index ? 3 : 1,
            color:
                _selectedIndex == index ? HexColor('#172543') : Colors.black87),
      ),
    );
  }
}
