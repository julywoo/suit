import 'package:bykak/src/components/hex_color.dart';
import 'package:bykak/src/model/suit_option.dart';
import 'package:bykak/src/pages/result_page.dart';
import 'package:bykak/src/pages/result_page_web.dart';
import 'package:bykak/src/pages/shirt_result_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  List<String> orderType = ['SUIT', 'JACKET', 'SHIRT', 'PANTS', 'VEST', 'COAT'];

  getData() async {
    var _toDay = DateTime.now();
    int difference = 0;
    int diffFinish = 0;

    try {
      try {
        var userResult = await firestore
            .collection('users')
            .doc(auth!.email.toString())
            .get();

        setState(() {
          storeName = userResult['storeName'];
          userType = userResult['userType'];
        });
      } catch (e) {}

      if (userType == "2") {
        var result = await firestore
            .collection('orders')
            .where('factory', isEqualTo: storeName)
            .orderBy('productionProcess', descending: false)
            .orderBy('consultDate', descending: true)
            .get();

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
            if (doc['factory'] == storeName) {
              setState(() {
                processList.add(doc);
                finishDateDiff.add(diffFinish);
              });
            } else {}
          }
        }
      } else {
        var result = await firestore
            .collection('orders')
            .where('storeName', isEqualTo: storeName)
            .orderBy('productionProcess', descending: false)
            .orderBy('consultDate', descending: true)
            .get();

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
    } catch (e) {
      print(e);
    }
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
          width: widthVal < 481 ? widthVal : 800,
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
                      height: 50,
                      child: Row(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: 90,
                            child: Text(
                              '제작상태',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: 100,
                            child: Text(
                              '제품타입',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: 160,
                            child: Text(
                              '주문번호',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: 70,
                            child: Text(
                              '고객명',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: 70,
                            child: Text(
                              '우선순위',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: 100,
                            child: Text(
                              '상담일자',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: 100,
                            child: Text(
                              '완성일자',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: 100,
                            child: Text(
                              '진행률',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.only(top: 20),
                        itemCount: processList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Table(
                            border: TableBorder.symmetric(),
                            children: [
                              TableRow(children: [
                                InkWell(
                                  onTap: () {
                                    try {
                                      processList[index]['orderType'] != '2'
                                          ? widthVal > 480
                                              ? Get.to(ResultPageWeb(),
                                                  arguments: {
                                                      'data':
                                                          processList[index],
                                                      'orderNo':
                                                          processList[index]
                                                              ['orderNo'],
                                                    })
                                              : Get.to(ResultPage(),
                                                  arguments: {
                                                      'data':
                                                          processList[index],
                                                      'orderNo':
                                                          processList[index]
                                                              ['orderNo'],
                                                    })
                                          : Get.to(ShirtResultPage(),
                                              arguments: {
                                                  'data': processList[index],
                                                  'orderNo': processList[index]
                                                      ['orderNo'],
                                                });
                                    } catch (e) {
                                      print(e);
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    width: 800,
                                    height: 50,
                                    color: Colors.white,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 90,
                                          height: 30,
                                          decoration: BoxDecoration(
                                              color: HexColor(processColor[
                                                  processList[index]
                                                      ['productionProcess']]),
                                              borderRadius:
                                                  BorderRadius.circular(25.0)),
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Center(
                                              child: Text(
                                                processOption[processList[index]
                                                    ['productionProcess']],
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 90,
                                          child: Align(
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
                                        ),
                                        Container(
                                          width: 160,
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            height: 20,
                                            //child: Center(
                                            child: Text(
                                              processList[index]['orderNo'],
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            //),
                                          ),
                                        ),
                                        Container(
                                          width: 70,
                                          child: Container(
                                            height: 20,
                                            child: Center(
                                              child: Text(
                                                processList[index]['name'] ==
                                                        null
                                                    ? " "
                                                    : processList[index]
                                                        ['name'],
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 70,
                                          child: Container(
                                            height: 20,
                                            child: Center(
                                                child: processList[index][
                                                            'productionProcess'] ==
                                                        12
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          Container(),
                                                          Container(),
                                                        ],
                                                      )
                                                    : finishDateDiff[index] < 15
                                                        ? Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .arrow_upward_sharp,
                                                                color: Colors
                                                                    .redAccent,
                                                                size: 16,
                                                              ),
                                                              Text(
                                                                '높음',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .redAccent),
                                                              )
                                                            ],
                                                          )
                                                        : finishDateDiff[
                                                                    index] <
                                                                22
                                                            ? Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .horizontal_rule,
                                                                    color: Colors
                                                                        .black87,
                                                                    size: 16,
                                                                  ),
                                                                  Text(
                                                                    '보통',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black87),
                                                                  )
                                                                ],
                                                              )
                                                            : Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .arrow_downward_sharp,
                                                                    color: Colors
                                                                        .black87,
                                                                    size: 16,
                                                                  ),
                                                                  Text(
                                                                    '낮음',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black87),
                                                                  )
                                                                ],
                                                              )),
                                          ),
                                        ),
                                        Container(
                                          width: 100,
                                          child: Container(
                                            height: 20,
                                            child: Center(
                                              child: Text(
                                                processList[index]
                                                            ['consultDate'] ==
                                                        null
                                                    ? " "
                                                    : processList[index]
                                                            ['consultDate']
                                                        .toString()
                                                        .substring(0, 10),
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 100,
                                          child: Container(
                                            height: 20,
                                            child: Center(
                                              child: Text(
                                                processList[index]
                                                            ['finishDate'] ==
                                                        null
                                                    ? " "
                                                    : processList[index]
                                                        ['finishDate'],
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 100,
                                          child: Container(
                                            height: 20,
                                            child: Center(
                                              child: Text(
                                                (((processList[index]['productionProcess'] /
                                                                    16) *
                                                                100)
                                                            .ceil())
                                                        .toString() +
                                                    '%',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
