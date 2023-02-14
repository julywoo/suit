import 'dart:io';

import 'package:bykak/src/app.dart';
import 'package:bykak/src/components/message_popup.dart';
import 'package:bykak/src/pages/privacy_terms_page.dart';
import 'package:bykak/src/widget/custom_elevated_buttod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bykak/src/user/login_page.dart';
import 'package:url_launcher/url_launcher.dart';

class UserPage extends StatefulWidget {
  UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  Future<void> signOut() async {
    await Firebase.initializeApp();

    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deleteAccount() async {
    await Firebase.initializeApp();
    await firestore.collection('users').doc(auth!.email.toString()).delete();
    try {
      await FirebaseAuth.instance.currentUser!.delete();
    } catch (e) {
      print(e.toString());
    }
  }

  bool kisweb = true;
  User? auth = FirebaseAuth.instance.currentUser;

  final firestore = FirebaseFirestore.instance;
  String userName = "";
  getData() async {
    try {
      var userResult =
          await firestore.collection('users').doc(auth!.email.toString()).get();

      setState(() {
        userName = userResult['userName'];
      });
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    checkPlatform();
    getData();
  }

  void checkPlatform() {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        kisweb = false;
      } else {
        kisweb = true;
      }
    } catch (e) {
      kisweb = true;
    }
  }

  @override
  Widget build(BuildContext context) {
//      String userName = auth!.displayName.toString().replaceAll(' ', '');
    var widthVal = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back, size: 25.0, color: Colors.black),
        ),
        elevation: 2,
        title: Text(
          '마이페이지',
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(App());
            },
            icon: Icon(Icons.home_filled, size: 25.0, color: Colors.black),
          ),
          Container(
            width: 25,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          child: Container(
            color: Colors.white,
            child: Center(
              child: Container(
                width: widthVal < 481 ? 480 : 800,
                child: Column(
                  children: [
                    Container(
                      width: kisweb
                          ? MediaQuery.of(context).size.width * 0.8
                          : MediaQuery.of(context).size.width * 0.8,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          height: 100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    userName,
                                    style: TextStyle(
                                        fontSize: 24,
                                        color: HexColor('#172543')),
                                  ),
                                  Text(
                                    '님, 반갑습니다.',
                                    style: TextStyle(fontSize: 20),
                                  )
                                ],
                              ),
                              Text(auth!.email.toString()),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: kisweb
                          ? MediaQuery.of(context).size.width * 0.8
                          : MediaQuery.of(context).size.width * 0.8,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                        child: Divider(
                          color: Colors.black54,
                          thickness: 1,
                        ),
                      ),
                    ),
                    Container(
                      width: kisweb
                          ? MediaQuery.of(context).size.width * 0.8
                          : MediaQuery.of(context).size.width * 0.8,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          height: 350,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // TextButton(
                              //   onPressed: () {},
                              //   child: Text(
                              //     '공지사항',
                              //     style: TextStyle(fontSize: 16, color: Colors.black87),
                              //   ),
                              // ),

                              SizedBox(
                                height: 25,
                              ),
                              GestureDetector(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '고객지원',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  _send();
                                  //makePhoneCall("tel://07048973059");
                                },
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              GestureDetector(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '개인정보 처리방침',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  Get.to(const PrivacyTerms());
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      color: Colors.white,
                      width: kisweb
                          ? MediaQuery.of(context).size.width * 0.8
                          : MediaQuery.of(context).size.width * 0.8,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Column(
                          children: [
                            Container(
                              //로그아웃 버튼
                              width: MediaQuery.of(context).size.width,
                              height: 40,
                              child: ElevatedButton(
                                style: TextButton.styleFrom(
                                  primary: Colors.white, //글자색
                                  onSurface:
                                      Colors.white, //onpressed가 null일때 색상
                                  backgroundColor: HexColor('#172543'),
                                  shadowColor: Colors.white, //그림자 색상
                                  elevation: 1, // 버튼 입체감
                                  textStyle: TextStyle(fontSize: 16),
                                  //padding: EdgeInsets.all(16.0),
                                  minimumSize: Size(300, 50), //최소 사이즈
                                  side: BorderSide(
                                      color: HexColor('#172543'),
                                      width: 1.0), //선
                                  shape:
                                      BeveledRectangleBorder(), // : 각진버튼, CircleBorder : 동그라미버튼, StadiumBorder : 모서리가 둥근버튼,
                                  alignment: Alignment.center,
                                ), //글자위치 변경
                                onPressed: () {
                                  showDialog(
                                      context: Get.context!,
                                      builder: (context) => MessagePopup(
                                            title: '로그아웃',
                                            message: '로그아웃 하시겠습니까?',
                                            okCallback: () {
                                              signOut();
                                              //controller.ChangeInitPage();
                                              Get.offAll(LoginPage());
                                            },
                                            cancleCallback: Get.back,
                                          ));
                                },
                                child: const Text('로그아웃'),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              color: Colors.white,

                              //로그아웃 버튼
                              width: MediaQuery.of(context).size.width,
                              height: 40,
                              child: ElevatedButton(
                                style: TextButton.styleFrom(
                                  primary: HexColor('#172543'), //글자색
                                  onSurface:
                                      Colors.white, //onpressed가 null일때 색상
                                  backgroundColor: Colors.white,
                                  shadowColor: Colors.white, //그림자 색상
                                  elevation: 1, // 버튼 입체감
                                  textStyle: TextStyle(fontSize: 16),
                                  //padding: EdgeInsets.all(16.0),
                                  minimumSize: Size(300, 50), //최소 사이즈
                                  side: BorderSide(
                                      color: HexColor('#172543'),
                                      width: 1.0), //선
                                  shape:
                                      BeveledRectangleBorder(), // : 각진버튼, CircleBorder : 동그라미버튼, StadiumBorder : 모서리가 둥근버튼,
                                  alignment: Alignment.center,
                                ), //글자위치 변경
                                child: Text('회원탈퇴'),
                                onPressed: () {
                                  showDialog(
                                      context: Get.context!,
                                      builder: (context) => MessagePopup(
                                            title: '회원탈퇴',
                                            message: '정말로 회원탈퇴 하시겠습니까?',
                                            okCallback: () {
                                              deleteAccount();
                                              //controller.ChangeInitPage();
                                              Get.offAll(LoginPage());
                                            },
                                            cancleCallback: Get.back,
                                          ));
                                },
                              ),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _send() {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'desingercom@naver.com',
      query: encodeQueryParameters(<String, String>{'subject': '[수잇 문의]'}),
    );

    try {
      launchUrl(emailLaunchUri);
    } catch (e) {
      String title = "문의하기";
      String msg =
          "기본 메일 앱을 사용할 수 없기 때문에 앱에서 바로 문의를 전송하기 어려운 상황입니다.\n\n아래 이메일로 연락주시면 친절하게 답변해드릴게요 :)\n\ndesingercom@naver.com";
      _showErrorAlert(title, msg);
    }
  }

  void _showErrorAlert(String title, String msg) {
    Get.dialog(AlertDialog(
      title: Text(title),
      content: Text(msg),
      actions: [
        Center(
          child: TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('확인')),
        )
      ],
    ));
  }

  void makePhoneCall(String phone) async {
    //await launch(phone);
  }
}
