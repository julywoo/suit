import 'package:bykak/src/components/alert_fucntion.dart';
import 'package:bykak/src/components/hex_color.dart';
import 'package:bykak/src/components/number_format.dart';
import 'package:bykak/src/widget/custom_text_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';
import 'package:url_launcher/url_launcher.dart';

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

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

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
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: Text(
      //     '멤버십 포인트 조회',
      //     style: TextStyle(fontWeight: FontWeight.bold),
      //   ),
      // ),
      body: SingleChildScrollView(
        controller: controller,
        child: Center(
          child: Container(
            padding: EdgeInsets.all(20),
            width: 360,
            height: Get.height,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 50, 50, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Image.asset(
                            'assets/logo.png',
                            height: 50,
                            // height: MediaQuery.of(context).size.height * 0.3,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '테일러샵 멤버십 포인트 조회 서비스',
                      style: TextStyle(
                          color: mainColor,
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          "이름",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: mainColor),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: CustomTextFormField(
                            lines: 1, hint: "이름", controller: nameController),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          "휴대폰",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: mainColor),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: CustomTextFormField(
                                  lines: 1,
                                  hint: "- 없이 핸드폰 번호 입력",
                                  controller: phoneController),
                            ),
                            // SizedBox(
                            //   width: 5,
                            // ),
                            // authOk
                            //     ? ElevatedButton(
                            //         onPressed: () {},
                            //         child: Text("인증완료1"))
                            //     : phoneController.text.length == 10 ||
                            //             phoneController.text.length ==
                            //                 11
                            //         ? ElevatedButton(
                            //             onPressed: () async {
                            //               setState(() {
                            //                 showLoading = true;
                            //               });
                            //               await _auth.verifyPhoneNumber(
                            //                 timeout: const Duration(
                            //                     seconds: 60),
                            //                 codeAutoRetrievalTimeout:
                            //                     (String
                            //                         verificationId) {
                            //                   // Auto-resolution timed out...
                            //                 },
                            //                 phoneNumber: "+8210" +
                            //                     phoneNumberController1
                            //                         .text
                            //                         .trim() +
                            //                     phoneNumberController2
                            //                         .text
                            //                         .trim(),
                            //                 verificationCompleted:
                            //                     (phoneAuthCredential) async {
                            //                   print("otp 문자옴");
                            //                 },
                            //                 verificationFailed:
                            //                     (verificationFailed) async {
                            //                   print(verificationFailed
                            //                       .code);

                            //                   print("코드발송실패");
                            //                   setState(() {
                            //                     showLoading = false;
                            //                   });
                            //                 },
                            //                 codeSent: (verificationId,
                            //                     resendingToken) async {
                            //                   print("코드보냄");
                            //                   Fluttertoast.showToast(
                            //                       msg:
                            //                           "010-${phoneNumberController1.text}-${phoneNumberController2.text} 로 인증코드를 발송하였습니다. 문자가 올때까지 잠시만 기다려 주세요.",
                            //                       toastLength: Toast
                            //                           .LENGTH_SHORT,
                            //                       timeInSecForIosWeb: 1,
                            //                       backgroundColor:
                            //                           Colors.green,
                            //                       fontSize: 12.0);
                            //                   setState(() {
                            //                     requestedAuth = true;
                            //                     FocusScope.of(context)
                            //                         .requestFocus(
                            //                             otpFocusNode);
                            //                     showLoading = false;
                            //                     this.verificationId =
                            //                         verificationId;
                            //                   });
                            //                 },
                            //               );
                            //             },
                            //             child: Text("인증요청2"))
                            //         : ElevatedButton(
                            //             style: TextButton.styleFrom(
                            //               primary: mainColor, //글자색
                            //               onSurface: Colors
                            //                   .white, //onpressed가 null일때 색상
                            //               backgroundColor: Colors.white,
                            //               shadowColor:
                            //                   Colors.white, //그림자 색상
                            //               elevation: 10, // 버튼 입체감
                            //               textStyle: TextStyle(
                            //                   fontSize: 10,
                            //                   fontWeight:
                            //                       FontWeight.bold),
                            //               //padding: EdgeInsets.all(16.0),
                            //               minimumSize:
                            //                   Size(50, 40), //최소 사이즈
                            //               side: BorderSide(
                            //                   color:
                            //                       HexColor('#172543'),
                            //                   width: 1.0), //선
                            //               shape:
                            //                   StadiumBorder(), // : 각진버튼, CircleBorder : 동그라미버튼, StadiumBorder : 모서리가 둥근버튼,
                            //               alignment: Alignment.center,
                            //             ), //글자위치 변경
                            //             onPressed: () {},
                            //             child: Text(
                            //               '인증요청3',
                            //             ),
                            //           ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: TextButton.styleFrom(
                      primary: HexColor('#FFFFFF'), //글자색
                      onSurface: Colors.white, //onpressed가 null일때 색상
                      backgroundColor: mainColor,
                      shadowColor: Colors.white, //그림자 색상
                      elevation: 10, // 버튼 입체감
                      textStyle:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      //padding: EdgeInsets.all(16.0),
                      minimumSize: Size(180, 50), //최소 사이즈
                      side: BorderSide(
                          color: HexColor('#172543'), width: 1.0), //선
                      shape:
                          StadiumBorder(), // : 각진버튼, CircleBorder : 동그라미버튼, StadiumBorder : 모서리가 둥근버튼,
                      alignment: Alignment.center,
                    ), //글자위치 변경
                    onPressed: () {
                      try {
                        SystemChrome.setPreferredOrientations([
                          DeviceOrientation.portraitUp,
                          DeviceOrientation.portraitDown
                        ]);

                        searchCustomerPoint(nameController.text.toString(),
                            phoneController.text.toString());
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Text(
                      '멤버십 포인트 조회',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
                  searchResult
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 40,
                            ),
                            Divider(
                              thickness: 3,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              '포인트 조회 결과',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            _isLoading
                                ? Container(
                                    height: 160,
                                    child: Center(
                                      child: SizedBox(
                                        height: 30,
                                        width: 30,
                                        child: CircularProgressIndicator(
                                          color: HexColor('#172543'),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: storeList.length * 170,
                                    child: ListView.separated(
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Container(
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      storeList[index],
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                    Text(
                                                      moneyFormat(pointList[
                                                                  index])
                                                              .toString() +
                                                          ' P',
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    ElevatedButton(
                                                      style:
                                                          TextButton.styleFrom(
                                                        primary:
                                                            mainColor, //글자색
                                                        onSurface:
                                                            mainColor, //onpressed가 null일때 색상
                                                        backgroundColor:
                                                            Colors.white,
                                                        // shadowColor:
                                                        //     mainColor, //그림자 색상
                                                        elevation: 2, // 버튼 입체감
                                                        textStyle: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                        //padding: EdgeInsets.all(16.0),
                                                        minimumSize: Size(
                                                            140, 40), //최소 사이즈
                                                        side: BorderSide(
                                                            color: HexColor(
                                                                '#172543'),
                                                            width: 1.0), //선
                                                        shape:
                                                            StadiumBorder(), // : 각진버튼, CircleBorder : 동그라미버튼, StadiumBorder : 모서리가 둥근버튼,
                                                        alignment:
                                                            Alignment.center,
                                                      ), //글자위치 변경
                                                      onPressed: () async {
                                                        if (storeTelList[0]
                                                                .toString()
                                                                .length >
                                                            9) {
                                                          String url =
                                                              'tel://' +
                                                                  storeTelList[
                                                                      0];
                                                          final parseUrl =
                                                              Uri.parse(url);
                                                          if (await canLaunchUrl(
                                                              parseUrl)) {
                                                            await launchUrl(
                                                              parseUrl,
                                                            );
                                                          }
                                                        }
                                                      },
                                                      child: Row(
                                                        children: [
                                                          LineIcon.phone(
                                                            size: 16,
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            '전화걸기',
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    ElevatedButton(
                                                      style:
                                                          TextButton.styleFrom(
                                                        primary:
                                                            mainColor, //글자색
                                                        onSurface:
                                                            mainColor, //onpressed가 null일때 색상
                                                        backgroundColor:
                                                            Colors.white,
                                                        // shadowColor:
                                                        //     mainColor, //그림자 색상
                                                        elevation: 2, // 버튼 입체감
                                                        textStyle: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                        //padding: EdgeInsets.all(16.0),
                                                        minimumSize: Size(
                                                            140, 40), //최소 사이즈
                                                        side: BorderSide(
                                                            color: HexColor(
                                                                '#172543'),
                                                            width: 1.0), //선
                                                        shape:
                                                            StadiumBorder(), // : 각진버튼, CircleBorder : 동그라미버튼, StadiumBorder : 모서리가 둥근버튼,
                                                        alignment:
                                                            Alignment.center,
                                                      ), //글자위치 변경
                                                      onPressed: () async {
                                                        try {
                                                          var url = Uri.parse(
                                                              reserveLinkList[
                                                                      index]
                                                                  .toString());
                                                          if (await canLaunchUrl(
                                                              url)) {
                                                            launchUrl(url,
                                                                mode: LaunchMode
                                                                    .externalApplication);
                                                          }
                                                        } catch (e) {
                                                          print(e);
                                                        }
                                                      },
                                                      child: Row(
                                                        children: [
                                                          LineIcon
                                                              .calendarCheck(
                                                            size: 16,
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            '예약하기',
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        separatorBuilder:
                                            (BuildContext context, int index) {
                                          return Divider(
                                            thickness: 1,
                                          );
                                        },
                                        itemCount: storeList.length)),
                          ],
                        )
                      : Container(),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  final controller = ScrollController();
  bool searchResult = false;
  bool _isLoading = true;
  List storeList = [];
  List pointList = [];
  List storeTelList = [];
  List reserveLinkList = [];
  searchCustomerPoint(String name, String phone) async {
    var userResult = await FirebaseFirestore.instance
        .collection('customers')
        .where('name', isEqualTo: name)
        .where('phone', isEqualTo: phone)
        .get();

    setState(() {
      pointList = [];
      storeList = [];
      storeTelList = [];
      reserveLinkList = [];
    });
    for (var result in userResult.docs) {
      storeList.add(result['storeName']);
      pointList.add(result['point']);
    }

    for (var i = 0; i < storeList.length; i++) {
      var tailorShopResult = await FirebaseFirestore.instance
          .collection('tailorShop')
          .doc(storeList[i])
          .get();

      storeTelList.add(tailorShopResult['storeTel']);
      reserveLinkList.add(tailorShopResult['reserveLink']);
    }
    if (storeList.length > 0) {
      setState(() {
        searchResult = true;
      });

      Future.delayed(Duration(seconds: storeList.length * 1), () {
        setState(() {
          _isLoading = false;
        });
      });
    } else {
      searchResult = false;
      failAlert('고객 정보가 존재하지 않습니다.');
    }
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
