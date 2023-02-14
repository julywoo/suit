import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class MembershipSearch extends StatefulWidget {
  const MembershipSearch({Key? key}) : super(key: key);

  @override
  State<MembershipSearch> createState() => _MembershipSearchState();
}

class _MembershipSearchState extends State<MembershipSearch> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController verifyPasswordController = TextEditingController();
  TextEditingController phoneNumberController1 = TextEditingController();
  TextEditingController phoneNumberController2 = TextEditingController();
  TextEditingController otpController = TextEditingController();

  FocusNode passwordFocusNode = FocusNode();
  FocusNode verifyPasswordFocusNode = FocusNode();
  FocusNode phoneNumberFocusNode1 = FocusNode();
  FocusNode phoneNumberFocusNode2 = FocusNode();
  FocusNode otpFocusNode = FocusNode();

  bool authOk = false;

  bool passwordHide = true;
  bool requestedAuth = false;
  String verificationId = "";
  bool showLoading = false;

  FirebaseAuth _auth = FirebaseAuth.instance;
  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });
    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);
      setState(() {
        showLoading = false;
      });
      if (authCredential.user != null) {
        setState(() {
          print("인증완료 및 로그인성공");
          authOk = true;
          requestedAuth = false;
        });
        await _auth.currentUser!.delete();
        print("auth정보삭제");
        _auth.signOut();
        print("phone로그인된것 로그아웃");
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        print("인증실패..로그인실패");
        showLoading = false;
      });

      await Fluttertoast.showToast(
          msg: '에러',
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          fontSize: 16.0);
    }
  }

  // Future<UserCredential> signUpUserCredential(
  //     {String? email, String? password}) async {
  //   try {
  //     return await _auth.createUserWithEmailAndPassword(
  //         email: email, password: password);
  //   } catch (e) {
  //     void errorToast(String message) {
  //       Fluttertoast.showToast(
  //           msg: message,
  //           toastLength: Toast.LENGTH_SHORT,
  //           timeInSecForIosWeb: 1,
  //           backgroundColor: Colors.red,
  //           fontSize: 16.0);
  //     }

  //     switch (e) {
  //       case "email-already-in-use":
  //         errorToast("이미 사용중인 이메일입니다");

  //         break;
  //       case "invalid-email":
  //         errorToast("잘못된 이메일 형식입니다");
  //         break;
  //       case "operation-not-allowed":
  //         errorToast("사용할 수 없는 방식입니다");

  //         break;
  //       case "weak-password":
  //         errorToast("비밀번호 보안 수준이 너무 낮습니다");

  //         break;
  //       default:
  //         errorToast("알수없는 오류가 발생했습니다");
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('멤버십 포인트 조회'),
        ),
        body: Center(
          child: Container(
            width: 360,
            height: Get.height,
            child: Stack(
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(flex: 1, child: Text("이름")),
                          Expanded(
                            flex: 3,
                            child: Container(
                              child: TextFormField(
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                                decoration: InputDecoration(
                                  contentPadding: new EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 10.0),
                                  isDense: true,
                                  hintText: "이름 입력",
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                ),
                                textInputAction: TextInputAction.next,
                                onEditingComplete: () => FocusScope.of(context)
                                    .requestFocus(passwordFocusNode),
                                keyboardType: TextInputType.emailAddress,
                                controller: emailController,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(flex: 1, child: Text("휴대폰")),
                          Expanded(
                            flex: 3,
                            child: Row(
                              children: [
                                Expanded(
                                    child: Row(
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: numberInsert(
                                          editAble: false,
                                          hintText: "010",
                                        )),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: numberInsert(
                                        editAble: authOk ? false : true,
                                        hintText: "0000",
                                        focusNode: phoneNumberFocusNode1,
                                        controller: phoneNumberController1,
                                        textInputAction: TextInputAction.next,
                                        maxLegnth: 4,
                                        widgetFunction: () {
                                          FocusScope.of(context).requestFocus(
                                              phoneNumberFocusNode2);
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: numberInsert(
                                        editAble: authOk ? false : true,
                                        hintText: "0000",
                                        focusNode: phoneNumberFocusNode2,
                                        controller: phoneNumberController2,
                                        textInputAction: TextInputAction.done,
                                        maxLegnth: 4,
                                      ),
                                    ),
                                  ],
                                )),
                                SizedBox(
                                  width: 5,
                                ),
                                authOk
                                    ? ElevatedButton(
                                        onPressed: () {}, child: Text("인증완료"))
                                    : phoneNumberController1.text.length == 4 &&
                                            phoneNumberController2
                                                    .text.length ==
                                                4
                                        ? ElevatedButton(
                                            onPressed: () async {
                                              setState(() {
                                                showLoading = true;
                                              });
                                              await _auth.verifyPhoneNumber(
                                                timeout:
                                                    const Duration(seconds: 60),
                                                codeAutoRetrievalTimeout:
                                                    (String verificationId) {
                                                  // Auto-resolution timed out...
                                                },
                                                phoneNumber: "+8210" +
                                                    phoneNumberController1.text
                                                        .trim() +
                                                    phoneNumberController2.text
                                                        .trim(),
                                                verificationCompleted:
                                                    (phoneAuthCredential) async {
                                                  print("otp 문자옴");
                                                },
                                                verificationFailed:
                                                    (verificationFailed) async {
                                                  print(
                                                      verificationFailed.code);

                                                  print("코드발송실패");
                                                  setState(() {
                                                    showLoading = false;
                                                  });
                                                },
                                                codeSent: (verificationId,
                                                    resendingToken) async {
                                                  print("코드보냄");
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "010-${phoneNumberController1.text}-${phoneNumberController2.text} 로 인증코드를 발송하였습니다. 문자가 올때까지 잠시만 기다려 주세요.",
                                                      toastLength:
                                                          Toast.LENGTH_SHORT,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor:
                                                          Colors.green,
                                                      fontSize: 12.0);
                                                  setState(() {
                                                    requestedAuth = true;
                                                    FocusScope.of(context)
                                                        .requestFocus(
                                                            otpFocusNode);
                                                    showLoading = false;
                                                    this.verificationId =
                                                        verificationId;
                                                  });
                                                },
                                              );
                                            },
                                            child: Text("인증요청"))
                                        : ElevatedButton(
                                            child: Text("인증요청"),
                                            onPressed: () {},
                                          ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      authOk
                          ? SizedBox()
                          : Visibility(
                              visible: requestedAuth,
                              child: Row(
                                children: [
                                  Expanded(flex: 1, child: Text("")),
                                  Expanded(
                                    flex: 3,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: numberInsert(
                                            editAble: true,
                                            hintText: "6자리 입력",
                                            focusNode: otpFocusNode,
                                            controller: otpController,
                                            textInputAction:
                                                TextInputAction.done,
                                            maxLegnth: 6,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        ElevatedButton(
                                            onPressed: () {
                                              PhoneAuthCredential
                                                  phoneAuthCredential =
                                                  PhoneAuthProvider.credential(
                                                      verificationId:
                                                          verificationId,
                                                      smsCode:
                                                          otpController.text);

                                              signInWithPhoneAuthCredential(
                                                  phoneAuthCredential);
                                            },
                                            child: Text("확인")),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        child: Text('멤버십 포인트 조회'),
                        onPressed: () async {
                          if (emailController.text.length > 1 &&
                              passwordController.text.length > 1 &&
                              verifyPasswordController.text.length > 1) {
                            if (passwordController.text ==
                                verifyPasswordController.text) {
                              if (authOk) {
                                setState(() {
                                  showLoading = true;
                                });

                                // await signUpUserCredential(
                                //     email: emailController.text,
                                //     password: passwordController.text);

                                // setState(() {
                                //   showLoading = false;
                                // });
                              } else {
                                Fluttertoast.showToast(
                                    msg: "휴대폰 인증을 완료해주세요.",
                                    toastLength: Toast.LENGTH_SHORT,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    fontSize: 16.0);
                              }
                            } else {
                              Fluttertoast.showToast(
                                  msg: "비밀번호를 확인해 주세요.",
                                  toastLength: Toast.LENGTH_SHORT,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  fontSize: 16.0);
                            }
                          } else {
                            Fluttertoast.showToast(
                                msg: "이메일 및 비밀번호를 입력해 주세요.",
                                toastLength: Toast.LENGTH_SHORT,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                fontSize: 16.0);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                            padding: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 10),
                            minimumSize: Size(double.infinity, 0),
                            textStyle: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
                // Positioned.fill(
                //   child: Visibility(
                //       visible: showLoading,
                //       child: Container(
                //           width: double.infinity,
                //           height: double.infinity,
                //           child: Center(
                //               child: Container(
                //                   width: MediaQuery.of(context).size.width * 0.9,
                //                   height: 80,
                //                   color: Colors.white,
                //                   child: Center(
                //                       child: Row(
                //                     mainAxisAlignment: MainAxisAlignment.center,
                //                     children: [
                //                       SizedBox(
                //                           width: 20,
                //                           height: 20,
                //                           child: CircularProgressIndicator()),
                //                       SizedBox(
                //                         width: 20,
                //                       ),
                //                       Text("잠시만 기다려 주세요"),
                //                       SizedBox(
                //                         width: 20,
                //                       ),
                //                       Opacity(
                //                         opacity: 0,
                //                         child: SizedBox(
                //                             width: 20,
                //                             height: 20,
                //                             child: CircularProgressIndicator()),
                //                       ),
                //                     ],
                //                   )))))),
                // )
              ],
            ),
          ),
        ));
  }

  Widget numberInsert({
    bool? editAble,
    String? hintText,
    FocusNode? focusNode,
    TextEditingController? controller,
    TextInputAction? textInputAction,
    Function? widgetFunction,
    int? maxLegnth,
  }) {
    return TextFormField(
      enabled: editAble,
      style: TextStyle(
        fontSize: 12,
      ),
      decoration: InputDecoration(
        contentPadding:
            new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        isDense: true,
        counterText: "",
        hintText: hintText,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
      textInputAction: textInputAction,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      focusNode: focusNode,
      controller: controller,
      maxLength: maxLegnth,
      onChanged: (value) {
        if (value.length >= maxLegnth!) {
          if (widgetFunction == null) {
            print("noFunction");
          } else {
            widgetFunction();
          }
        }
        setState(() {});
      },
      onEditingComplete: () {
        if (widgetFunction == null) {
          print("noFunction");
        } else {
          widgetFunction();
        }
      },
    );
  }
}
