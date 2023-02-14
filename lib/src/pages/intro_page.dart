import 'package:bykak/src/pages/customer/membership_search_page.dart';
import 'package:bykak/src/pages/privacy_terms_page.dart';
import 'package:bykak/src/user/login_page.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/hex_color.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  List<String> onboardList = [
    'assets/slide/slide1.png',
    'assets/slide/slide2.png',
    'assets/slide/slide3.png',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 80,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 50, right: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Image.asset(
                              'assets/logo.png',
                              height: 50,
                            ),
                          ),
                          Container(
                            child: Row(children: [
                              GestureDetector(
                                child: Container(
                                  //로그아웃 버튼
                                  // width: MediaQuery.of(context).size.width,
                                  child: ElevatedButton(
                                    style: TextButton.styleFrom(
                                      primary: HexColor('#172543'), //글자색
                                      onSurface:
                                          Colors.white, //onpressed가 null일때 색상
                                      backgroundColor: HexColor('#FFFFFF'),
                                      shadowColor: Colors.white, //그림자 색상
                                      elevation: 1, // 버튼 입체감

                                      //padding: EdgeInsets.all(16.0),
                                      minimumSize: Size(150, 50), //최소 사이즈
                                      side: BorderSide(
                                          color: HexColor('#172543'),
                                          width: 1.0), //선
                                      shape:
                                          StadiumBorder(), // : 각진버튼, CircleBorder : 동그라미버튼, StadiumBorder : 모서리가 둥근버튼,
                                      alignment: Alignment.center,
                                    ), //글자위치 변경
                                    onPressed: () {
                                      _send();
                                    },

                                    child: Row(
                                      children: [
                                        Icon(Icons.mail),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        const Text(
                                          '문의하기',
                                          style: TextStyle(
                                              fontFamily: 'NanumGothic'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  _send();
                                },
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              GestureDetector(
                                child: Container(
                                  //로그아웃 버튼
                                  // width: MediaQuery.of(context).size.width,
                                  child: ElevatedButton(
                                    style: TextButton.styleFrom(
                                      primary: HexColor('#172543'), //글자색
                                      onSurface:
                                          Colors.white, //onpressed가 null일때 색상
                                      backgroundColor: HexColor('#FFFFFF'),
                                      shadowColor: Colors.white, //그림자 색상
                                      elevation: 1, // 버튼 입체감

                                      //padding: EdgeInsets.all(16.0),
                                      minimumSize: Size(150, 50), //최소 사이즈
                                      side: BorderSide(
                                          color: HexColor('#172543'),
                                          width: 1.0), //선
                                      shape:
                                          StadiumBorder(), // : 각진버튼, CircleBorder : 동그라미버튼, StadiumBorder : 모서리가 둥근버튼,
                                      alignment: Alignment.center,
                                    ), //글자위치 변경
                                    onPressed: () {
                                      Get.to(LoginPage());
                                    },

                                    child: Row(
                                      children: [
                                        const Text(
                                          '웹에서 이용하기',
                                          style: TextStyle(
                                              fontFamily: 'NanumGothic'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Get.to(LoginPage());
                                },
                              ),
                              // SizedBox(
                              //   width: 20,
                              // ),
                              // GestureDetector(
                              //   child: Container(
                              //     //로그아웃 버튼
                              //     // width: MediaQuery.of(context).size.width,
                              //     child: ElevatedButton(
                              //       style: TextButton.styleFrom(
                              //         primary: HexColor('#172543'), //글자색
                              //         onSurface:
                              //             Colors.white, //onpressed가 null일때 색상
                              //         backgroundColor: HexColor('#FFFFFF'),
                              //         shadowColor: Colors.white, //그림자 색상
                              //         elevation: 1, // 버튼 입체감

                              //         //padding: EdgeInsets.all(16.0),
                              //         minimumSize: Size(150, 50), //최소 사이즈
                              //         side: BorderSide(
                              //             color: HexColor('#172543'),
                              //             width: 1.0), //선
                              //         shape:
                              //             StadiumBorder(), // : 각진버튼, CircleBorder : 동그라미버튼, StadiumBorder : 모서리가 둥근버튼,
                              //         alignment: Alignment.center,
                              //       ), //글자위치 변경
                              //       onPressed: () {
                              //         Get.to(MembershipSearch());
                              //       },

                              //       child: Row(
                              //         children: [
                              //           const Text(
                              //             '멤버십 포인트 조회',
                              //             style: TextStyle(
                              //                 fontFamily: 'NanumGothic'),
                              //           ),
                              //         ],
                              //       ),
                              //     ),
                              //   ),
                              //   onTap: () {
                              //     Get.to(MembershipSearch());
                              //   },
                              // ),
                            ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      height: Get.height * 0.7,
                      color: Colors.white,
                      child: 
                      Swiper(
                        autoplay: true,
                        itemBuilder: (context, index) {
                          return Container(
                            child: Image.asset(
                              onboardList[index],
                              scale: 1.8,
                            ),
                          );
                        },
                        itemCount: 3,
                        pagination: SwiperPagination(
                          builder: new DotSwiperPaginationBuilder(
                              color: Colors.grey,
                              activeColor: HexColor('#172543'),
                              size: 15,
                              activeSize: 20,
                              space: 10),
                        ),
                        control: SwiperControl(color: Colors.transparent),
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                  ),
                  Container(
                    height: 120,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(50, 50, 50, 0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 100,
                                            child: Text(
                                              'COMPANY',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: HexColor('#172543'),
                                                  fontSize: 12),
                                            ),
                                          ),
                                          Text(
                                            '데시그너(주)',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: 100,
                                            child: Text(
                                              'ADDRESS',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: HexColor('#172543'),
                                                  fontSize: 12),
                                            ),
                                          ),
                                          Text(
                                            '인천 미추홀구 석정로 200',
                                            style: TextStyle(fontSize: 12),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: 100,
                                            child: Text(
                                              'TEL',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: HexColor('#172543'),
                                                  fontSize: 12),
                                            ),
                                          ),
                                          Text(
                                            '070-4897-3059',
                                            style: TextStyle(fontSize: 12),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: 100,
                                            child: Text(
                                              'MAIL',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: HexColor('#172543'),
                                                  fontSize: 12),
                                            ),
                                          ),
                                          GestureDetector(
                                            child: Text(
                                              'desingercom@naver.com',
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            onTap: () {
                                              _send();
                                            },
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 100,
                                            child: Text(
                                              '대표자',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: HexColor('#172543'),
                                                  fontSize: 12),
                                            ),
                                          ),
                                          Text(
                                            '김주현',
                                            style: TextStyle(fontSize: 12),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: 100,
                                            child: Text(
                                              '사업자등록번호',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: HexColor('#172543'),
                                                  fontSize: 12),
                                            ),
                                          ),
                                          Text(
                                            '720-86-02241',
                                            style: TextStyle(fontSize: 12),
                                          )
                                        ],
                                      ),
                                      Row(),
                                      Row(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 150,
                            ),
                            Container(
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          GestureDetector(
                                            child: Container(
                                              width: 150,
                                              child: Text(
                                                '개인정보취급방침',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: HexColor('#172543'),
                                                    fontSize: 12),
                                              ),
                                            ),
                                            onTap: () {
                                              Get.to(const PrivacyTerms());
                                            },
                                          )
                                        ],
                                      ),
                                      Row(),
                                      Row(),
                                      Row(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ]),
                    ),
                  ),
                ],
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
}
