import 'dart:math';

import 'package:bykak/src/components/hex_color.dart';
import 'package:bykak/src/components/message_popup.dart';
import 'package:bykak/src/components/number_format.dart';
import 'package:bykak/src/components/responsive.dart';
import 'package:bykak/src/model/suit_option.dart';
import 'package:bykak/src/pages/factory/wages_charge_page.dart';
import 'package:bykak/src/pages/result_page.dart';
import 'package:bykak/src/pages/result_page_web.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChargeListDetail extends StatefulWidget {
  ChargeListDetail({Key? key}) : super(key: key);

  @override
  State<ChargeListDetail> createState() => _ChargeListDetailState();
}

class _ChargeListDetailState extends State<ChargeListDetail> {
  var tailorShopName = Get.arguments['storeName'];
  var factoryName = Get.arguments['factoryName'];
  var startDate =
      Get.arguments['startDate'].toString().substring(0, 10) + ' 00:00:00';
  var endDate =
      Get.arguments['endDate'].toString().substring(0, 10) + ' 23:59:59';

  var chargeNoVal = Get.arguments['chargeNoVal'];
  var chargeComplete = Get.arguments['chargeComplete'];
  List orderNoChargeTypeArg = Get.arguments['orderNoChargeType'];
  List orderNoListArg = Get.arguments['orderNoList'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (chargeComplete == "N") {
      _getGabongCharge();
      _getBongjeCharge();
    } else {
      _getChageList();
    }
  }

  bool _isLoading = true;
  int gabongCount = 0;
  int gabongCost = 0;
  int bongjeCount = 0;
  int bongjeCost = 0;
  bool detailCost = false;

  List gabongList = [];
  List bongjeList = [];
  List totalList = [];
  List totalPriceList = [];
  List orderNoList = [];
  List orderNoChargeType = [];

  final firestore = FirebaseFirestore.instance;
  void _getChageList() async {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
    totalList = [];
    totalPriceList = [];
    gabongCount = 0;
    gabongCost = 0;
    bongjeCount = 0;
    bongjeCost = 0;

    try {
      for (var i = 0; i < orderNoListArg.length; i++) {
        var chargeListResult =
            await firestore.collection('orders').doc(orderNoListArg[i]).get();
        setState(() {
          totalList.add(chargeListResult);
        });

        if (orderNoChargeTypeArg[i] == "T") {
          int gabongPrice = 0;
          if (DateTime.parse(chargeListResult['bongjeFinishDate'])
                      .compareTo(DateTime.parse(startDate)) >
                  0 &&
              DateTime.parse(chargeListResult['bongjeFinishDate'])
                      .compareTo(DateTime.parse(endDate)) <
                  0) {
            int totalPrice = chargeListResult['normalPrice'] +
                chargeListResult['factoryPrice'];
            if (DateTime.parse(chargeListResult['gabongFinishDate'])
                        .compareTo(DateTime.parse(startDate)) >
                    0 &&
                DateTime.parse(chargeListResult['gabongFinishDate'])
                        .compareTo(DateTime.parse(endDate)) <
                    0) {
              gabongPrice = chargeListResult['gabongPrice'];
            }
            bongjeCost += totalPrice;
            gabongCost += gabongPrice;
            bongjeCount += 1;
            totalPriceList.add("?????? " +
                totalPrice.toString() +
                ' ???' +
                '\n' +
                "?????? " +
                gabongPrice.toString() +
                ' ???');
          }
          //??????
        } else if (orderNoChargeTypeArg[i] == "B") {
          //??????
          print('??????');
          if (DateTime.parse(chargeListResult['bongjeFinishDate'])
                      .compareTo(DateTime.parse(startDate)) >
                  0 &&
              DateTime.parse(chargeListResult['bongjeFinishDate'])
                      .compareTo(DateTime.parse(endDate)) <
                  0) {
            int totalPrice = chargeListResult['normalPrice'] +
                chargeListResult['factoryPrice'];

            bongjeCost += totalPrice;

            bongjeCount += 1;
            totalPriceList.add("?????? " +
                totalPrice.toString() +
                ' ???' +
                '\n' +
                "?????? " +
                0.toString() +
                ' ???');
          }
        } else {
          if (DateTime.parse(chargeListResult['gabongFinishDate'])
                      .compareTo(DateTime.parse(startDate)) >
                  0 &&
              DateTime.parse(chargeListResult['gabongFinishDate'])
                      .compareTo(DateTime.parse(endDate)) <
                  0) {
            int gabongPrice = chargeListResult['gabongPrice'];
            gabongCost += gabongPrice;
            gabongCount += 1;
            totalPriceList.add("?????? " +
                0.toString() +
                ' ???' +
                '\n' +
                "?????? " +
                moneyFormat(gabongPrice).toString() +
                ' ???');
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  //????????????
  void _getGabongCharge() async {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
    gabongCount = 0;
    gabongCost = 0;
    var doc;

    try {
      var gabongResult = await firestore
          .collection('orders')
          .where(
            'gabongFactory',
            isEqualTo: factoryName,
          )
          .where(
            'storeName',
            isEqualTo: tailorShopName,
          )
          .where(
            'productionProcess',
            isGreaterThan: 6,
          )
          // .where('gabongFinishDate', isGreaterThanOrEqualTo: startDate)
          // .where('gabongFinishDate', isLessThanOrEqualTo: endDate)
          .orderBy('productionProcess', descending: false)
          .orderBy('consultDate', descending: true)
          .get();

      if (gabongResult.docs.length != 0) {
        for (doc in gabongResult.docs) {
          if (doc['gabongFactory'] == factoryName ||
              (doc['factory'] != null && doc['factory'] != factoryName)) {
            try {
              if ((DateTime.parse(doc['gabongFinishDate'])
                              .compareTo(DateTime.parse(startDate)) >
                          0 &&
                      DateTime.parse(doc['gabongFinishDate'])
                              .compareTo(DateTime.parse(endDate)) <
                          0) &&
                  !(DateTime.parse(doc['bongjeFinishDate'])
                              .compareTo(DateTime.parse(startDate)) >
                          0 &&
                      DateTime.parse(doc['bongjeFinishDate'])
                              .compareTo(DateTime.parse(endDate)) <
                          0)) {
                if (doc['gabongChargeComplete'] != "Y"
                    //   && doc['chargeNo'] == null
                    ) {
                  int gabongPrice = doc['gabongPrice'];

                  setState(
                    () {
                      gabongList.add(doc);
                      gabongCount += 1;
                      gabongCost += gabongPrice;
                      totalList.add(doc);
                      orderNoList.add(doc['orderNo']);
                      orderNoChargeType.add('G');
                      totalPriceList.add("?????? " +
                          0.toString() +
                          ' ???' +
                          '\n' +
                          "?????? " +
                          moneyFormat(gabongPrice).toString() +
                          ' ???');
                    },
                  );
                }
              }
            } catch (e) {
              print(e);
            }
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  //????????????
  void _getBongjeCharge() async {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
    bongjeCount = 0;
    bongjeCost = 0;
    var doc;

    try {
      var bongjeResult = await firestore
          .collection('orders')
          .where(
            'factory',
            isEqualTo: factoryName,
          )
          .where(
            'storeName',
            isEqualTo: tailorShopName,
          )
          .where(
            'productionProcess',
            isGreaterThan: 14,
          )

          // .where('bongjeFinishDate', isGreaterThan: startDate)
          // .where('bongjeFinishDate', isLessThan: endDate)
          .orderBy('productionProcess')
          .orderBy('consultDate', descending: true)
          .get();
      if (bongjeResult.docs.length != 0) {
        for (doc in bongjeResult.docs) {
          if (doc['factory'] == doc['gabongFactory']) {
            if (DateTime.parse(doc['bongjeFinishDate'])
                        .compareTo(DateTime.parse(startDate)) >
                    0 &&
                DateTime.parse(doc['bongjeFinishDate'])
                        .compareTo(DateTime.parse(endDate)) <
                    0) {
              if (doc['bongjeChargeComplete'] != "Y"
                  //   && doc['chargeNo'] == null
                  ) {
                int factoryPrice = doc['factoryPrice'];
                int normalPrice = doc['normalPrice'];
                int gabongPrice = 0;

                if (doc['gabongChargeComplete'] == "Y" ||
                    DateTime.parse(doc['gabongFinishDate'])
                            .compareTo(DateTime.parse(startDate)) <
                        0) {
                  gabongPrice = 0;
                } else {
                  gabongPrice = doc['gabongPrice'];
                }
                int totalPrice = factoryPrice + normalPrice;
                setState(() {
                  if (doc['gabongChargeComplete'] == "Y") {
                  } else {
                    gabongCost += gabongPrice;
                  }
                  bongjeList.add(doc);
                  bongjeCount += 1;

                  bongjeCost += normalPrice + factoryPrice;
                  totalList.add(doc);
                  orderNoList.add(doc['orderNo']);
                  orderNoChargeType.add('T');
                  totalPriceList.add("?????? " +
                      moneyFormat(totalPrice).toString() +
                      ' ???' +
                      '\n' +
                      "?????? " +
                      moneyFormat(gabongPrice).toString() +
                      ' ???');
                });
              }
            }
          } else {
            if ((doc['factory'] != doc['gabongFactory']) &&
                doc['factory'] == factoryName) {
              if (DateTime.parse(doc['bongjeFinishDate'])
                          .compareTo(DateTime.parse(startDate)) >
                      0 &&
                  DateTime.parse(doc['bongjeFinishDate'])
                          .compareTo(DateTime.parse(endDate)) <
                      0) {
                if (doc['bongjeChargeComplete'] !=
                        "Y" //   && doc['chargeNo'] == null
                    ) {
                  int factoryPrice = doc['factoryPrice'];
                  int normalPrice = doc['normalPrice'];
                  int totalPrice = factoryPrice + normalPrice;
                  setState(() {
                    bongjeList.add(doc);
                    bongjeCount += 1;

                    bongjeCost += normalPrice + factoryPrice;
                    orderNoList.add(doc['orderNo']);
                    orderNoChargeType.add('B');
                    totalList.add(doc);
                    totalPriceList.add("?????? " +
                        moneyFormat(totalPrice).toString() +
                        ' ???' +
                        '\n' +
                        "?????? " +
                        0.toString() +
                        ' ???');
                  });
                }
              }
            }
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final widthVal = MediaQuery.of(context).size.width;
    final heightVal = MediaQuery.of(context).size.height;
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
            '??????????????? ??????',
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        body: Responsive.isMobile(context)
            ? _isLoading
                ? Center(
                    child: SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                        color: HexColor('#172543'),
                      ),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              startDate.toString().substring(0, 10) +
                                  ' ~ ' +
                                  endDate.toString().substring(0, 10) +
                                  '  ????????????',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black54),
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Text(
                                  moneyFormat((gabongCost + bongjeCost))
                                          .toString() +
                                      ' ??? ',
                                  style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        detailCost = true;
                                      });
                                    },
                                    icon: Icon(Icons.arrow_drop_down_sharp))
                              ],
                            ),
                            detailCost == true
                                ? Container(
                                    height: 50,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          '?????? ?????? ??????   ' +
                                              moneyFormat(gabongCost) +
                                              ' ???',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                            '?????? ?????? ??????   ' +
                                                moneyFormat(bongjeCost) +
                                                ' ???',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w500)),
                                      ],
                                    ),
                                  )
                                : SizedBox(),
                            SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(''),
                                Text('??? ' +
                                    (gabongCount + bongjeCount).toString() +
                                    '???')
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: widthVal,
                              height: 1,
                              color: Colors.black38,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: ListView.separated(
                              itemCount: gabongCount + bongjeCount,
                              itemBuilder: (BuildContext context, int index) {
                                return Center(
                                  child: InkWell(
                                    onTap: () {
                                      !Responsive.isMobile(context)
                                          ? Get.to(ResultPageWeb(), arguments: {
                                              'data': totalList[index],
                                              'orderNo': totalList[index]
                                                  ['orderNo'],
                                            })
                                          : Get.to(ResultPage(), arguments: {
                                              'data': totalList[index],
                                              'orderNo': totalList[index]
                                                  ['orderNo'],
                                            });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      height: 120,
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(totalList[index]['orderNo']),
                                              Container(
                                                width: 100,
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  totalPriceList[index]
                                                      .toString(),
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(totalList[index]['name']),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(productType[int.parse(
                                                  totalList[index]
                                                      ['orderType'])]),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                '????????????',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(''),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                (totalList[index][
                                                            'factoryPriceDetail'] ??
                                                        "")
                                                    .toString()
                                                    .replaceAll(',', " "),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(''),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const Divider(
                                        height: 0.5,
                                        color: Colors.black54,
                                      )),
                        ),
                      )
                    ],
                  )
            : _isLoading
                ? Center(
                    child: SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                        color: HexColor('#172543'),
                      ),
                    ),
                  )
                : Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: Get.width * 0.5,
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                startDate.toString().substring(0, 10) +
                                    ' ~ ' +
                                    endDate.toString().substring(0, 10) +
                                    '  ????????????',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black54),
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Text(
                                    moneyFormat((gabongCost + bongjeCost))
                                            .toString() +
                                        ' ??? ',
                                    style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          detailCost = true;
                                        });
                                      },
                                      icon: Icon(Icons.arrow_drop_down_sharp))
                                ],
                              ),
                              detailCost == true
                                  ? Container(
                                      height: 50,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            '?????? ?????? ??????   ' +
                                                moneyFormat(gabongCost) +
                                                ' ???',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Text(
                                              '?????? ?????? ??????   ' +
                                                  moneyFormat(bongjeCost) +
                                                  ' ???',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.w500)),
                                        ],
                                      ),
                                    )
                                  : SizedBox(),
                              SizedBox(
                                height: 30,
                              ),
                              // Container(
                              //   width: Get.width * 0.5,
                              //   child: Padding(
                              //     padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                              //     child: Column(
                              //       children: [
                              //         Container(
                              //           //???????????? ??????
                              //           width: MediaQuery.of(context).size.width,

                              //           child: ElevatedButton(
                              //             style: TextButton.styleFrom(
                              //               primary: Colors.white, //?????????
                              //               onSurface:
                              //                   Colors.white, //onpressed??? null?????? ??????
                              //               backgroundColor: HexColor('#172543'),
                              //               shadowColor: Colors.white, //????????? ??????
                              //               elevation: 1, // ?????? ?????????
                              //               textStyle: TextStyle(fontSize: 16),
                              //               //padding: EdgeInsets.all(16.0),
                              //               minimumSize: Size(300, 50), //?????? ?????????
                              //               side: BorderSide(
                              //                   color: HexColor('#172543'),
                              //                   width: 1.0), //???
                              //               shape:
                              //                   StadiumBorder(), // : ????????????, CircleBorder : ??????????????????, StadiumBorder : ???????????? ????????????,
                              //               alignment: Alignment.center,
                              //             ), //???????????? ??????
                              //             onPressed: () {
                              //               showDialog(
                              //                   context: Get.context!,
                              //                   builder: (context) => MessagePopup(
                              //                         title: '????????? ??????',
                              //                         message:
                              //                             '????????? ?????? ???????????? ???????????? ?????????????????????????',
                              //                         okCallback: () {
                              //                           // signOut();
                              //                           //controller.ChangeInitPage();
                              //                           _updateChargeDate();
                              //                           Get.to(WagesChargePage());
                              //                         },
                              //                         cancleCallback: Get.back,
                              //                       ));
                              //             },
                              //             child: const Text('????????????'),
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        Container(
                          width: Get.width * 0.5,
                          child: Padding(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(''),
                                    Text('??? ' +
                                        (gabongCount + bongjeCount).toString() +
                                        '???')
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: Get.width * 0.5,
                                  height: 1,
                                  color: Colors.black38,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: Get.width * 0.5,
                            padding: EdgeInsets.all(20),
                            child: ListView.separated(
                                itemCount: gabongCount + bongjeCount,
                                itemBuilder: (BuildContext context, int index) {
                                  return Center(
                                    child: InkWell(
                                      onTap: () {
                                        !Responsive.isMobile(context)
                                            ? Get.to(ResultPageWeb(),
                                                arguments: {
                                                    'data': totalList[index],
                                                    'orderNo': totalList[index]
                                                        ['orderNo'],
                                                  })
                                            : Get.to(ResultPage(), arguments: {
                                                'data': totalList[index],
                                                'orderNo': totalList[index]
                                                    ['orderNo'],
                                              });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        height: 120,
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(totalList[index]
                                                    ['orderNo']),
                                                Container(
                                                  width: 100,
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    totalPriceList[index]
                                                        .toString(),
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(totalList[index]['name']),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(productType[int.parse(
                                                    totalList[index]
                                                        ['orderType'])]),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  '????????????',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(''),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  (totalList[index][
                                                              'factoryPriceDetail'] ??
                                                          "")
                                                      .toString()
                                                      .replaceAll(',', " "),
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(''),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        const Divider(
                                          height: 0.5,
                                          color: Colors.black54,
                                        )),
                          ),
                        )
                      ],
                    ),
                  ));
  }

  _updateChargeDate() async {
    var chargeNo = '';
    var chargeNoReturn = await firestore
        .collection('charges')
        .where(
          'factory',
          isEqualTo: factoryName,
        )
        .where(
          'tailorShop',
          isEqualTo: tailorShopName,
        )
        .where(
          'chargeStartDate',
          isEqualTo: startDate,
        )
        .where(
          'chargeEndDate',
          isEqualTo: endDate,
        )
        .where(
          'chargeComplete',
          isEqualTo: 'N',
        )
        .get();

    for (var doc in chargeNoReturn.docs) {
      setState(() {
        chargeNo = doc['chargeNo'];
      });
    }

    var _toDay = DateTime.now();
    var formatDate = DateFormat('yyMMddHHmm').format(_toDay);
    var chargeNoRandom = Random().nextInt(1000);
    var chargeNoFormat = formatDate + chargeNoRandom.toString();

    if (chargeNo == '') {
      try {
        FirebaseFirestore.instance
            .collection('charges')
            .doc(chargeNoFormat)
            .set({
          //'suitDesign': _suitDesign!.toJson(),
          'factory': factoryName,
          'tailorShop': tailorShopName,
          'chargeNo': chargeNoFormat,
          'chargeStartDate': startDate,
          'chargeEndDate': endDate,
          'chargeCost': (gabongCost + bongjeCost).toString(),
          'chargeGabongCost': gabongCost.toString(),
          'chargeBongjeCost': bongjeCost.toString(),
          'chargeComplete': 'N',
        }, SetOptions(merge: true));
      } catch (e) {
        print(e);
      }

      for (var i = 0; i < totalList.length; i++) {
        FirebaseFirestore.instance
            .collection('orders')
            .doc(totalList[i]['orderNo'])
            .set({
          //'suitDesign': _suitDesign!.toJson(),
          'chargeNo': chargeNoFormat,
        }, SetOptions(merge: true));
      }
    } else {
      try {
        FirebaseFirestore.instance.collection('charges').doc(chargeNo).set({
          //'suitDesign': _suitDesign!.toJson(),
          'factory': factoryName,
          'tailorShop': tailorShopName,
          'chargeNo': chargeNo,
          'chargeStartDate': startDate,
          'chargeEndDate': endDate,
          'chargeCost': (gabongCost + bongjeCost).toString(),
          'chargeGabongCost': gabongCost.toString(),
          'chargeBongjeCost': bongjeCost.toString(),
          'chargeComplete': 'N',
        }, SetOptions(merge: true));
      } catch (e) {
        print(e);
      }

      for (var i = 0; i < totalList.length; i++) {
        FirebaseFirestore.instance
            .collection('orders')
            .doc(totalList[i]['orderNo'])
            .set({
          //'suitDesign': _suitDesign!.toJson(),
          'chargeNo': chargeNo,
        }, SetOptions(merge: true));
      }
    }
  }
}
