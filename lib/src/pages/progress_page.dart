import 'package:bykak/src/components/alert_fucntion.dart';
import 'package:bykak/src/components/hex_color.dart';
import 'package:bykak/src/components/process_popup.dart';
import 'package:bykak/src/model/suit_option.dart';
import 'package:bykak/src/pages/result_page.dart';
import 'package:bykak/src/pages/result_page_web.dart';
import 'package:bykak/src/pages/schedule_detail_page.dart';
import 'package:bykak/src/pages/shirt_result_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:path/path.dart';

class ProgressPage extends StatefulWidget {
  ProgressPage({Key? key}) : super(key: key);

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  var doc;
  int listCount = 0;
  late List processList;
  late List finishDateDiff;
  final firestore = FirebaseFirestore.instance;
  User? auth = FirebaseAuth.instance.currentUser;
  String storeName = "";
  String userType = "";
  bool _detailView = false;

  List<String> orderType = ['수트', '자켓', '셔츠', '바지', '조끼', '코트'];
  List processOptionList = [
    '상담중',
    '상담완료',
    '요척',
    '원부자재입고',
    '재단',
    '가봉중', //공장
    '가봉완료', // 공장
    '가봉출고', // 공장 > 테일러샵
    '가봉입고/수정', // 테일러샵  (수정 후 제작 Or 중가봉)
    '중가봉중', //공장
    '중가봉완료', // 공장
    '중가봉출고', // 공장 > 테일러샵
    '중가봉입고/수정', // 테일러샵  (수정 후 제작 Or 중가봉)
    '봉제/작업자확인',
    '작업중',
    '제작완료',
    '고객전달완료'
  ];
  List processColorList = [
    '#e9473a',
    '#eb958e',
    '#465af1',
    '#8ecbeb',
    '#efba3c',
    '#1f1972',
    '#703ae9',
    '#bc8eeb',
    '#d5bfeb',
    '#1f1972',
    '#703ae9',
    '#bc8eeb',
    '#d5bfeb',
    '#e6501c',
    '#e8764e',
    '#f0b19b',
    '#a3a3a3',
  ];
  List totalList = [];
  List purchaseDateList = [];
  List orderNoList = [];
  List orderProcessConut = [0, 0, 0, 0];
  List orderProcessList = [];
  List orderPabricList = [];
  List orderTypeList = [];
  late List<String> factoryList;

  late List<String> brandRateList;
  getData() async {
    var _toDay = DateTime.now();
    int difference = 0;
    int diffGabong = 0;
    int diffFinish = 0;

    try {
      try {
        factoryList = [];

        var result = await firestore
            .collection('users')
            //.orderBy('productionProcess', descending: false)
            .where('userId', isEqualTo: auth!.email.toString())
            .get();

        for (doc in result.docs) {
          setState(() {
            storeName = doc['storeName'];
            userType = doc['userType'];
          });
        }

        try {
          var factoryResult = await firestore
              .collection('produceCost')
              //.doc(doc['storeName'])
              .get();

          for (var doc in factoryResult.docs) {
            factoryList.add(doc['factoryName']);
          }
        } catch (e) {}

        brandRateList = [];
        var brandListResult = await firestore
            .collection('tailorShop')
            .doc(doc['storeName'])
            .get();

        setState(() {
          if (brandListResult['brandRate1'] != "") {
            brandRateList.add(brandListResult['brandRate1']);
          }
          if (brandListResult['brandRate2'] != "") {
            brandRateList.add(brandListResult['brandRate2']);
          }
          if (brandListResult['brandRate3'] != "") {
            brandRateList.add(brandListResult['brandRate3']);
          }
          if (brandListResult['brandRate4'] != "") {
            brandRateList.add(brandListResult['brandRate4']);
          }
          if (brandListResult['brandRate5'] != "") {
            brandRateList.add(brandListResult['brandRate5']);
          }
        });
      } catch (e) {
        print(e);
      }

      if (userType == "2") {
      } else {
        var result = await firestore
            .collection('orders')
            .where('storeName', isEqualTo: storeName)
            .where('productionProcess', isNotEqualTo: 16)
            // .orderBy('consultDate', descending: true)
            .get();

        purchaseDateList = [];
        for (var item in result.docs) {
          purchaseDateList = [];
          purchaseDateList.add(item['name']);
          purchaseDateList.add(item['phone']);
          purchaseDateList.add(item['consultDate'].toString().substring(0, 10));

          if (!totalList.toString().contains(purchaseDateList[0].toString())) {
            orderNoList = [];
            orderProcessList = [];
            orderPabricList = [];
            orderTypeList = [];
            orderProcessConut = [0, 0, 0, 0];
            var orderList = await firestore
                .collection('orders')
                .where('name', isEqualTo: item['name'])
                .where('phone', isEqualTo: item['phone'])
                .where('consultDate', isEqualTo: item['consultDate'])
                .get();

            for (var docs in orderList.docs) {
              if (docs['productionProcess'] < 5) {
                orderProcessConut[0] = orderProcessConut[0] + 1;
              } else if (docs['productionProcess'] > 4 &&
                  docs['productionProcess'] < 9) {
                orderProcessConut[1] = orderProcessConut[1] + 1;
              } else if (docs['productionProcess'] > 8 &&
                  docs['productionProcess'] < 15) {
                orderProcessConut[2] = orderProcessConut[2] + 1;
              } else if (docs['productionProcess'] == 15) {
                orderProcessConut[3] = orderProcessConut[3] + 1;
              }

              orderNoList.add(docs['orderNo']);
              orderProcessList.add(docs['productionProcess']);
              if (docs['pabricSub1'] != "" || docs['pabricSub2'] != "") {
                orderPabricList.add(
                  '복수 원단:' +
                      " 조끼 " +
                      docs['pabricSub1'] +
                      " 바지 " +
                      docs['pabricSub2'],
                );
              } else {
                orderPabricList.add(docs['pabric']);
              }
              orderTypeList.add(docs['orderType']);
            }

            String finishDate = DateFormat('yyyy-MM-dd').format(
                DateTime.parse(item['consultDate']).add(Duration(days: 30)));
            String gabongDate = DateFormat('yyyy-MM-dd').format(
                DateTime.parse(item['consultDate']).add(Duration(days: 10)));

            diffGabong = int.parse(_toDay
                .difference(DateTime.parse(gabongDate))
                .inDays
                .toString());

            diffFinish = int.parse(_toDay
                .difference(DateTime.parse(finishDate))
                .inDays
                .toString());
            purchaseDateList.add('');
            purchaseDateList.add(diffGabong);
            purchaseDateList.add(diffFinish);
            purchaseDateList.add(orderNoList);
            purchaseDateList.add(orderProcessConut);
            purchaseDateList.add(orderProcessList);
            purchaseDateList.add(orderPabricList);
            purchaseDateList.add(orderTypeList);

            totalList.add(purchaseDateList);
          }
        }

        for (doc in result.docs) {
          difference = int.parse(_toDay
              .difference(DateTime.parse(doc['consultDate']))
              .inDays
              .toString());

          diffFinish = int.parse(DateTime.parse(doc['finishDate'])
              .difference(_toDay)
              .inDays
              .toString());

          if (difference < 61) {
            //if (doc['storeName'] == storeName) {

            setState(() {
              processList.add(doc);
              finishDateDiff.add(diffFinish);
            });
            // } else {}
          }
        }
      }
    } catch (e) {}
  }

  @override
  void initState() {
    storeName = auth!.displayName.toString();
    super.initState();
    processList = [];
    finishDateDiff = [];

    getData();
  }

  @override
  Widget build(BuildContext context) {
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
          '제작현황',
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      body: Center(
        child: Container(
          width: widthVal < 481 ? widthVal : 1100,
          color: Colors.white,
          child: widthVal < 481
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Padding(
                    //   padding: const EdgeInsets.all(20.0),
                    //   child: Container(
                    //     height: 30,
                    //     child: Text(
                    //       '제작 현황',
                    //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    //     ),
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        height: 20,
                        child: Text(
                          '고객 상담 후, 60일 이내의 제작현황이 제공됩니다. ',
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.all(20),
                        itemCount: processList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              try {
                                processList[index]['orderType'] != '2'
                                    ? widthVal > 480
                                        ? Get.to(ResultPageWeb(), arguments: {
                                            'data': processList[index],
                                            'orderNo': processList[index]
                                                ['orderNo'],
                                          })
                                        : Get.to(ResultPage(), arguments: {
                                            'data': processList[index],
                                            'orderNo': processList[index]
                                                ['orderNo'],
                                          })
                                    : Get.to(ShirtResultPage(), arguments: {
                                        'data': processList[index],
                                        'orderNo': processList[index]
                                            ['orderNo'],
                                      });
                              } catch (e) {
                                print(e);
                              }
                            },
                            child: Container(
                              height: 70,
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 100,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        color: HexColor(processColor[
                                            processList[index]
                                                ['productionProcess']]),
                                        borderRadius:
                                            BorderRadius.circular(25.0)),
                                    child: Center(
                                      child: Text(
                                        processOption[processList[index]
                                            ['productionProcess']],
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 11),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 160,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              processList[index]['orderNo'],
                                              style: TextStyle(
                                                  color:
                                                      finishDateDiff[index] < 15
                                                          ? Colors.redAccent
                                                          : Colors.black),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              processList[index]['name'] == null
                                                  ? ""
                                                  : '고객명 : ' +
                                                      processList[index]
                                                          ['name'],
                                              style: TextStyle(
                                                  color:
                                                      finishDateDiff[index] < 15
                                                          ? Colors.redAccent
                                                          : Colors.black),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              processList[index]
                                                          ['finishDate'] ==
                                                      null
                                                  ? '완성일 : '
                                                  : '완성일 : ' +
                                                      processList[index]
                                                          ['finishDate'],
                                              style: TextStyle(
                                                  color:
                                                      finishDateDiff[index] < 15
                                                          ? Colors.redAccent
                                                          : Colors.black),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 60,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: Container(
                                            width: 50,
                                            height: 20,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black,
                                                    width: 1.0),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        15.0)),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                orderType[int.parse(
                                                    processList[index]
                                                        ['orderType'])],
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 10),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        height: 20,
                        child: Text(
                          '고객 상담 후, 60일 이내의 제작현황이 제공됩니다. ',
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      height: 70,
                      child: Row(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: 100,
                            child: Text(
                              '고객명',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: 130,
                            child: Text(
                              '연락처',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: 120,
                            child: Text(
                              '상담일자',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: 120,
                            child: Text(
                              '사용예정일',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: 60,
                            child: Text(
                              '가봉마감',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: 60,
                            child: Text(
                              '완성마감',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: 350,
                            child: Text(
                              '제작현황',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: 100,
                            child: Text(
                              '고객문의',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.only(top: 20),
                        itemCount: totalList.length,
                        itemBuilder: (BuildContext context, int index) {
                          List stepList = totalList[index][7];
                          return Table(
                            border: TableBorder.symmetric(),
                            children: [
                              TableRow(children: [
                                ExpansionTile(
                                  title: Column(
                                    children: [
                                      Container(
                                        width: 1100,
                                        height: 50,
                                        color: Colors.white,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              alignment: Alignment.center,
                                              width: 100,
                                              height: 30,
                                              child: Center(
                                                child: Text(
                                                  totalList[index][0],
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              width: 130,
                                              height: 30,
                                              child: Text(
                                                phoneMaskingFormat(
                                                    totalList[index][1]
                                                        .toString()),
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              width: 120,
                                              height: 30,
                                              child: Center(
                                                child: Text(
                                                  totalList[index][2]
                                                      .toString()
                                                      .substring(0, 10),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              width: 120,
                                              height: 30,
                                              child: Center(
                                                child: Text(
                                                  '',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              width: 60,
                                              height: 30,
                                              child: Center(
                                                child: Text(
                                                  totalList[index][4] > 0
                                                      ? 'D +' +
                                                          totalList[index][4]
                                                              .toString()
                                                      : 'D ' +
                                                          totalList[index][4]
                                                              .toString(),
                                                  style: TextStyle(
                                                      color: totalList[index]
                                                                  [4] >
                                                              0
                                                          ? Colors.black
                                                          : Colors.redAccent,
                                                      fontSize: 15),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              width: 60,
                                              height: 30,
                                              child: Center(
                                                child: Text(
                                                  totalList[index][5] > 0
                                                      ? 'D +' +
                                                          totalList[index][5]
                                                              .toString()
                                                      : 'D ' +
                                                          totalList[index][5]
                                                              .toString(),
                                                  style: TextStyle(
                                                      color: totalList[index]
                                                                  [5] >
                                                              0
                                                          ? Colors.black
                                                          : Colors.redAccent,
                                                      fontSize: 15),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.only(
                                                  left: 10, right: 10),
                                              width: 360,
                                              height: 30,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width: 40,
                                                        height: 30,
                                                        decoration: BoxDecoration(
                                                            color: mainColor
                                                                .withOpacity(
                                                                    0.35),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0)),
                                                        child: Center(
                                                          child: Text(
                                                            '상담',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        stepList[0].toString(),
                                                        style: TextStyle(
                                                            fontSize: 14),
                                                      )
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width: 40,
                                                        height: 30,
                                                        decoration: BoxDecoration(
                                                            color: mainColor
                                                                .withOpacity(
                                                                    0.55),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0)),
                                                        child: Center(
                                                          child: Text(
                                                            '가봉',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        stepList[1].toString(),
                                                        style: TextStyle(
                                                            fontSize: 14),
                                                      )
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width: 40,
                                                        height: 30,
                                                        decoration: BoxDecoration(
                                                            color: mainColor
                                                                .withOpacity(
                                                                    0.75),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0)),
                                                        child: Center(
                                                          child: Text(
                                                            '제작',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        stepList[2].toString(),
                                                        style: TextStyle(
                                                            fontSize: 14),
                                                      )
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width: 40,
                                                        height: 30,
                                                        decoration: BoxDecoration(
                                                            color: mainColor
                                                                .withOpacity(
                                                                    1.0),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0)),
                                                        child: Center(
                                                          child: Text(
                                                            '완성',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        stepList[3].toString(),
                                                        style: TextStyle(
                                                            fontSize: 14),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              width: 80,
                                              height: 30,
                                              child: Center(
                                                child: IconButton(
                                                  icon: Icon(
                                                    LineIcons.phone,
                                                    size: 20,
                                                  ),
                                                  onPressed: () {
                                                    Get.to(ScheduleDetail(),
                                                        arguments: {
                                                          'name':
                                                              totalList[index]
                                                                  [0],
                                                          'phone':
                                                              totalList[index]
                                                                  [1],
                                                          'consultDate':
                                                              totalList[index]
                                                                  [2],
                                                        });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  initiallyExpanded: false,
                                  collapsedTextColor: Colors.black,
                                  collapsedIconColor: Colors.black,
                                  iconColor: Colors.black,
                                  textColor: Colors.black,
                                  backgroundColor: Colors.white,
                                  expandedAlignment: Alignment.centerLeft,
                                  expandedCrossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  childrenPadding: EdgeInsets.only(left: 50),
                                  children: [
                                    Text(
                                      '주문 목록',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      height: totalList[index][6].length * 35,
                                      child: ListView.builder(
                                        itemBuilder: ((context, i) {
                                          return Container(
                                            width: 1000,
                                            height: 35,
                                            child: Row(
                                              children: [
                                                InkWell(
                                                  child: Container(
                                                    width: 100,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                        color: HexColor(
                                                            processColor[
                                                                totalList[index]
                                                                    [8][i]]),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    25.0)),
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Center(
                                                        child: Text(
                                                          processOption[
                                                              totalList[index]
                                                                  [8][i]],
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 11),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    showDialog(
                                                      context: Get.context!,
                                                      builder: (context) =>
                                                          ProcessPopup(
                                                        title: '제작 현황 변경',
                                                        message:
                                                            '제작 현황을 아래와 같이 변경 하시겠습니까?',
                                                        factoryList:
                                                            factoryList,
                                                        brandRateList:
                                                            brandRateList,
                                                        factoryCapacity: [],
                                                        step: int.parse(
                                                            totalList[index][8]
                                                                    [i]
                                                                .toString()),
                                                        orderNo:
                                                            totalList[index][6]
                                                                [i],
                                                        userId: auth!.email
                                                            .toString(),
                                                        customerName:
                                                            totalList[index][0],
                                                        storeName: storeName,
                                                        factoryName: "",
                                                        orderType:
                                                            totalList[index][10]
                                                                .toString(),
                                                        pabricSub1: "",
                                                        pabricSub2: "",
                                                        length: processOption
                                                                .length -
                                                            1,
                                                        cancleCallback:
                                                            Get.back,
                                                      ),
                                                    );
                                                  },
                                                ),
                                                Container(
                                                  alignment: Alignment.center,
                                                  width: 80,
                                                  child: Text(
                                                    orderType[int.parse(
                                                        totalList[index][10]
                                                            [i])],
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  width: 130,
                                                  child: Text(
                                                    totalList[index][6][i],
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  width: totalList[index][9]
                                                          .length *
                                                      200,
                                                  child: Text(
                                                    totalList[index][9][i],
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                        itemCount: totalList[index][6].length,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ])
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
