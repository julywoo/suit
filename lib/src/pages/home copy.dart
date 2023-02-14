import 'dart:io';

import 'package:bykak/src/components/hex_color.dart';
import 'package:bykak/src/pages/calculate_page.dart';
import 'package:bykak/src/pages/customer/customer_list_page.dart';
import 'package:bykak/src/pages/factory/factory_cost.dart';
import 'package:bykak/src/pages/input_suit_data.dart';
import 'package:bykak/src/pages/progress_page.dart';
import 'package:bykak/src/pages/qr_scanner_page.dart';

import 'package:bykak/src/pages/search_page.dart';
import 'package:bykak/src/pages/tailorShop/consult_step_change_page.dart';
import 'package:bykak/src/pages/tailorShop/cost_intro_page.dart';
import 'package:bykak/src/pages/tailorShop/cost_list_page.dart';
import 'package:bykak/src/pages/tailorShop/csv_upload_page.dart';
import 'package:bykak/src/pages/tailorShop/options_select_page.dart';
import 'package:bykak/src/pages/tailorShop/price_manage_page.dart';

import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<String> slideList = [
    'assets/slide/slide1.png',
    'assets/slide/slide2.png',
    'assets/slide/slide3.png'
  ];

  final List mainPageList = [
    InputSuitData(),
    SearchPage(),
  ];

  final firestore = FirebaseFirestore.instance;
  User? auth = FirebaseAuth.instance.currentUser;
  String userType = "";
  getData() async {
    try {
      var userData =
          await firestore.collection('users').doc(auth!.email.toString()).get();

      setState(() {
        userType = userData['userType'];
      });
    } catch (e) {}
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   //backgroundColor: HexColor('#'),

      //   backgroundColor: Colors.white,
      //   elevation: 0,
      // ),
      body: Center(
        child: Container(
          width: 1000,
          //color: HexColor('#172543'),
          color: Colors.white,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 50, 50, 20),
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
                  // Container(
                  //   padding: const EdgeInsets.fromLTRB(0, 50, 20, 50),
                  //   child: IconButton(
                  //     onPressed: () {},
                  //     icon: Icon(Icons.notifications_none_sharp),
                  //   ),
                  // ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              // Expanded(
              //   child: Swiper(
              //     autoplay: true,
              //     itemBuilder: (context, index) {
              //       return Padding(
              //         padding: const EdgeInsets.fromLTRB(20, 0, 20, 70),
              //         child: Image.asset(
              //           slideList[index],
              //         ),
              //       );
              //     },
              //     itemCount: slideList.length,
              //     pagination: SwiperPagination(
              //       builder: new DotSwiperPaginationBuilder(
              //           color: Colors.grey,
              //           activeColor: HexColor('#172543'),
              //           size: 10,
              //           activeSize: 15,
              //           space: 10),
              //     ),
              //     control: SwiperControl(color: Colors.transparent),
              //     scrollDirection: Axis.horizontal,
              //   ),
              //   //  child: Image.asset('assets/slide/slide4.png'),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                                child: userType != '2'
                                    ? Container(
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                            shape: getShape(),
                                            elevation: getElevation(),
                                            foregroundColor: getColor(
                                                HexColor('#172543'),
                                                Colors.white),
                                            backgroundColor: getColor(
                                                Colors.white,
                                                HexColor('#172543')),
                                            side: getBorder(HexColor('#172543'),
                                                HexColor('#172543')),
                                          ),
                                          onPressed: () {
                                            Get.to(
                                              InputSuitData(),
                                              //arguments: {'orderType': '3'}
                                            );
                                          },
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                '맞춤복 상담',
                                                style: TextStyle(
                                                    // fontFamily: 'Caveat',
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                'Make A Suit',
                                                style: TextStyle(
                                                    // fontFamily: 'Caveat',

                                                    fontStyle: FontStyle.italic,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : ElevatedButton(
                                        style: ButtonStyle(
                                          shape: getShape(),
                                          elevation: getElevation(),
                                          foregroundColor: getColor(
                                              HexColor('#172543'),
                                              Colors.white),
                                          backgroundColor: getColor(
                                              Colors.white,
                                              HexColor('#172543')),
                                          side: getBorder(HexColor('#172543'),
                                              HexColor('#172543')),
                                        ),
                                        onPressed: () {
                                          Get.to(
                                            FactoryCost(),

                                            //arguments: {'orderType': '3'}
                                          );
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '공임비 관리',
                                              style: TextStyle(
                                                  // fontFamily: 'Caveat',
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              'Management of labor costs',
                                              style: TextStyle(
                                                  // fontFamily: 'Caveat',

                                                  fontStyle: FontStyle.italic,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      )),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.15,
                              child: userType != '2'
                                  ? ElevatedButton(
                                      style: ButtonStyle(
                                        shape: getShape(),
                                        elevation: getElevation(),
                                        foregroundColor: getColor(
                                            HexColor('#172543'), Colors.white),
                                        backgroundColor: getColor(
                                            Colors.white, HexColor('#172543')),
                                        side: getBorder(HexColor('#172543'),
                                            HexColor('#172543')),
                                      ),
                                      onPressed: () {
                                        Get.to(
                                          SearchPage(),
                                          //arguments: {'orderType': '3'}
                                        );
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '작업지시서 조회',
                                            style: TextStyle(
                                                // fontFamily: 'Caveat',

                                                fontWeight: FontWeight.w600,
                                                fontSize: 16),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            'Search Work Sheet',
                                            style: TextStyle(
                                                // fontFamily: 'Caveat',

                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    )
                                  : ElevatedButton(
                                      style: ButtonStyle(
                                        shape: getShape(),
                                        elevation: getElevation(),
                                        foregroundColor: getColor(
                                            HexColor('#172543'), Colors.white),
                                        backgroundColor: getColor(
                                            Colors.white, HexColor('#172543')),
                                        side: getBorder(HexColor('#172543'),
                                            HexColor('#172543')),
                                      ),
                                      onPressed: () {
                                        Get.to(
                                          QrScannerPage(),
                                          //arguments: {'orderType': '3'}
                                        );
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'QR 스캐너',
                                            style: TextStyle(
                                                // fontFamily: 'Caveat',

                                                fontWeight: FontWeight.w600,
                                                fontSize: 16),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            'Qr Scan of Work Sheet',
                                            style: TextStyle(
                                                // fontFamily: 'Caveat',

                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
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
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.15,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  shape: getShape(),
                                  elevation: getElevation(),
                                  foregroundColor: getColor(
                                      HexColor('#172543'), Colors.white),
                                  backgroundColor: getColor(
                                      Colors.white, HexColor('#172543')),
                                  side: getBorder(
                                      HexColor('#172543'), HexColor('#172543')),
                                ),
                                onPressed: () {
                                  Get.to(
                                    ProgressPage(),
                                    //arguments: {'orderType': '3'}
                                  );
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '제작 현황',
                                      style: TextStyle(
                                          // fontFamily: 'Caveat',

                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'State Of Production',
                                      style: TextStyle(
                                          // fontFamily: 'Caveat',

                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.15,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  shape: getShape(),
                                  elevation: getElevation(),
                                  foregroundColor: getColor(
                                      HexColor('#172543'), Colors.white),
                                  backgroundColor: getColor(
                                      Colors.white, HexColor('#172543')),
                                  side: getBorder(
                                      HexColor('#172543'), HexColor('#172543')),
                                ),
                                onPressed: () {
                                  Get.to(
                                    QrScannerPage(),
                                    //arguments: {'orderType': '3'}
                                  );
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'QR 스캐너',
                                      style: TextStyle(
                                          // fontFamily: 'Caveat',

                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Qr Scan of Work Sheet',
                                      style: TextStyle(
                                          // fontFamily: 'Caveat',

                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
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
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.15,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  shape: getShape(),
                                  elevation: getElevation(),
                                  foregroundColor: getColor(
                                      HexColor('#172543'), Colors.white),
                                  backgroundColor: getColor(
                                      Colors.white, HexColor('#172543')),
                                  side: getBorder(
                                      HexColor('#172543'), HexColor('#172543')),
                                ),
                                onPressed: () {
                                  Get.to(
                                    CostList(),
                                    //arguments: {'orderType': '3'}
                                  );
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '공임비 관리',
                                      style: TextStyle(
                                          // fontFamily: 'Caveat',

                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Labor Cost',
                                      style: TextStyle(
                                          // fontFamily: 'Caveat',

                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.15,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  shape: getShape(),
                                  elevation: getElevation(),
                                  foregroundColor: getColor(
                                      HexColor('#172543'), Colors.white),
                                  backgroundColor: getColor(
                                      Colors.white, HexColor('#172543')),
                                  side: getBorder(
                                      HexColor('#172543'), HexColor('#172543')),
                                ),
                                onPressed: () {
                                  Get.to(
                                    CalculatePage(),
                                    //arguments: {'orderType': '3'}
                                  );
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      userType == '1' ? '제품 판매 목록' : '제품 제작 목록',
                                      style: TextStyle(
                                          // fontFamily: 'Caveat',

                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      userType == '1'
                                          ? 'Sales List'
                                          : 'Production List',
                                      style: TextStyle(
                                          // fontFamily: 'Caveat',

                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
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
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.15,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  shape: getShape(),
                                  elevation: getElevation(),
                                  foregroundColor: getColor(
                                      HexColor('#172543'), Colors.white),
                                  backgroundColor: getColor(
                                      Colors.white, HexColor('#172543')),
                                  side: getBorder(
                                      HexColor('#172543'), HexColor('#172543')),
                                ),
                                onPressed: () {
                                  Get.to(

                                      //OptionsSelect());
                                      // ConsultStepChange());
                                      PriceManage());
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '결제 금액 관리',
                                      style: TextStyle(
                                          // fontFamily: 'Caveat',

                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                    ),
                                    // Text(
                                    //   '상담 옵션 관리',
                                    //   style: TextStyle(
                                    //       // fontFamily: 'Caveat',

                                    //       fontWeight: FontWeight.w600,
                                    //       fontSize: 16),
                                    // ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Payment Management',
                                      style: TextStyle(
                                          // fontFamily: 'Caveat',

                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.15,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  shape: getShape(),
                                  elevation: getElevation(),
                                  foregroundColor: getColor(
                                      HexColor('#172543'), Colors.white),
                                  backgroundColor: getColor(
                                      Colors.white, HexColor('#172543')),
                                  side: getBorder(
                                      HexColor('#172543'), HexColor('#172543')),
                                ),
                                onPressed: () {
                                  Get.to(
                                      // CsvUpload(),
                                      CustomerList()
                                      //arguments: {'orderType': '3'}
                                      );
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '고객 관리',
                                      style: TextStyle(
                                          // fontFamily: 'Caveat',

                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      userType == '1'
                                          ? 'Customer Management'
                                          : 'Production List',
                                      style: TextStyle(
                                          // fontFamily: 'Caveat',

                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
//
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  MaterialStateProperty<Color> getColor(Color color, Color colorPressed) {
    final getColor = (Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed)) {
        return colorPressed;
      } else {
        return color;
      }
    };

    return MaterialStateProperty.resolveWith(getColor);
  }

  MaterialStateProperty<BorderSide> getBorder(Color color, Color colorPressed) {
    final getBorder = (Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed)) {
        return BorderSide(color: colorPressed, width: 2);
      } else {
        return BorderSide(color: color, width: 2);
      }
    };

    return MaterialStateProperty.resolveWith(getBorder);
  }

  MaterialStateProperty<double> getElevation() {
    final getElevation = (Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed)) {
        return 10.0;
      } else {
        return 0.0;
      }
    };

    return MaterialStateProperty.resolveWith(getElevation);
  }

  MaterialStateProperty<OutlinedBorder> getShape() {
    final getShape = (Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed)) {
        return RoundedRectangleBorder(borderRadius: BorderRadius.circular(20));
      } else {
        return RoundedRectangleBorder(borderRadius: BorderRadius.circular(20));
      }
    };

    return MaterialStateProperty.resolveWith(getShape);
  }
}
