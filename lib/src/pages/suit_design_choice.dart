import 'dart:io';

import 'package:bykak/src/components/hex_color.dart';
import 'package:bykak/src/model/bottom_size_model.dart';
import 'package:bykak/src/model/order_model.dart';
import 'package:bykak/src/model/shirt_design.dart';
import 'package:bykak/src/model/shirt_design_val.dart';
import 'package:bykak/src/model/shirt_size_model.dart';
import 'package:bykak/src/model/suit_design_model.dart';
import 'package:bykak/src/model/suit_design_val.dart';
import 'package:bykak/src/model/top_size_model.dart';
import 'package:bykak/src/pages/custom_clothes_step2.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

import '../model/suit_option.dart';

class SuitDesignChoice extends StatefulWidget {
  const SuitDesignChoice({Key? key}) : super(key: key);

  @override
  State<SuitDesignChoice> createState() => _SuitDesignChoiceState();
}

class _SuitDesignChoiceState extends State<SuitDesignChoice> {
  int orderType = Get.arguments['orderType'];
  String orderNo = Get.arguments['orderNo'];
  var orderData = Get.arguments['orderData'];
  //List<String> orderNoList = Get.arguments['orderNoList'];
  var orderNoList = Get.arguments['orderNoList'];

  int itemCnt = 0;
  late int startIndex;
  late List suitSet;

  @override
  void initState() {
    if (orderType == 0) {
      setState(() {
        suitSet = suitOption2.sublist(0, 14);
        itemCnt = 14;
        startIndex = 0;
      });
    } else if (orderType == 1) {
      setState(() {
        suitSet = suitOption2.sublist(0, 6);
        itemCnt = 6;
        startIndex = 0;
      });
    } else if (orderType == 2) {
      setState(() {
        suitSet = suitOption2.sublist(14, 19);
        itemCnt = 5;
        startIndex = 14;
      });
    } else if (orderType == 3) {
      setState(() {
        suitSet = suitOption2.sublist(8, 14);
        itemCnt = 6;
        startIndex = 8;
      });
    } else if (orderType == 4) {
      setState(() {
        suitSet = suitOption2.sublist(6, 8);
        itemCnt = 2;
        startIndex = 6;
      });
    } else if (orderType == 5) {
      suitSet = suitOption2;
    }

    checkPlatform();
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    super.initState();
  }

  @override
  void dispose() {
    // 세로 화면 고정
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  bool kisweb = true;
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

  final checkOption = List<String>.filled(19, "");
  final checkOptionVal = List<String>.filled(19, "");

  String? jacketButton;
  String? jacketLapel;
  String? chestPocket;
  String? jacketShoulder;
  String? jacketSidePocket;
  String? jacketVent;
  String? vestButton;
  String? vestLapel;
  String? pantsPleats;
  String? pantsDetailOne;
  String? pantsDetailTwo;
  String? pantsDetailThree;
  String? pantsBreak;
  String? pantsPermanentPleats;

  SuitDesign? suitDesign;
  SuitDesignVal? suitDesignVal;
  SwiperController _controller = SwiperController();

  final double runSpacing = 4;
  final double spacing = 4;

  @override
  Widget build(BuildContext context) {
    var widVal = MediaQuery.of(context).size.width;
    var heightVal = MediaQuery.of(context).size.height;
    heightVal < 850
        ? SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ])
        : SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ]);

    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Swiper(
            itemCount: itemCnt,
            loop: false,
            control: kIsWeb
                ? SwiperControl(
                    color: Colors.white,
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0))
                : null,
            controller: _controller,
            itemBuilder: (BuildContext context, int index1) {
              List<String> selectList =
                  List.from(suitSet[index1]['selectList']);
              List<String> selectListVal =
                  List.from(suitSet[index1]['selectListVal']);

              if ((orderType == 0 || orderType == 1) && index1 == 1) {
                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => Dialog(
                          insetPadding: EdgeInsets.all(0),
                          backgroundColor: Colors.transparent,
                          child: GestureDetector(
                            onTap: () {
                              Get.bottomSheet(
                                Container(
                                  height: heightVal < 481 ? 140 : 170,
                                  decoration: BoxDecoration(
                                    color: HexColor('#172543'),
                                    borderRadius: new BorderRadius.only(
                                      topLeft: const Radius.circular(20.0),
                                      topRight: const Radius.circular(20.0),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: heightVal < 480
                                        ? const EdgeInsets.only(top: 20)
                                        : const EdgeInsets.only(top: 20),
                                    child: Wrap(
                                      runSpacing: runSpacing,
                                      spacing: spacing,
                                      alignment: WrapAlignment.center,
                                      children: List.generate(selectList.length,
                                          (index) {
                                        //item 의 반목문 항목 형성

                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5, right: 5),
                                          child: Container(
                                            width: heightVal < 480
                                                ? widVal * 0.22
                                                : widVal * 0.23,
                                            height: heightVal < 480 ? 40 : 55,
                                            color: HexColor('#172543'),
                                            child: ElevatedButton(
                                              style: TextButton.styleFrom(
                                                primary:
                                                    HexColor('#172543'), //글자색
                                                onSurface: Colors
                                                    .white, //onpressed가 null일때 색상
                                                backgroundColor: Colors.white,
                                                shape:
                                                    StadiumBorder(), // : 각진버튼, CircleBorder :
                                                side: BorderSide(
                                                    color: HexColor('#172543'),
                                                    width: 1.0), //선
                                              ),
                                              onPressed: () {
                                                var list;
                                                var listVal;

                                                list = selectList[index]
                                                    .toString();
                                                listVal = selectListVal[index]
                                                    .toString();

                                                setState(() {
                                                  checkOption[startIndex] =
                                                      list;
                                                  checkOptionVal[startIndex] =
                                                      listVal;
                                                  startIndex++;
                                                  Get.back();
                                                  _controller.next();

                                                  Get.back();
                                                });
                                              },
                                              child: Text(
                                                  selectList[index].toString()),
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Stack(
                              children: [
                                Container(
                                    alignment: Alignment.center,
                                    width: double.infinity,
                                    child: PhotoView(
                                      imageProvider: AssetImage(
                                          'assets/option/sam2_1.png'),
                                    )),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: IconButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    icon: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    );
                  },
                  child: Container(
                      alignment: Alignment.center,
                      child: PhotoView(
                        imageProvider: AssetImage(suitSet[index1]['optionImg']),
                      )),
                );
              } else {
                return GestureDetector(
                  onTap: () {
                    Get.bottomSheet(
                      Container(
                        decoration: BoxDecoration(
                          color: HexColor('#172543'),
                          borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(20.0),
                            topRight: const Radius.circular(20.0),
                          ),
                        ),
                        height: heightVal < 481
                            ? selectListVal.length > 8
                                ? 170
                                : 140
                            : selectListVal.length > 8
                                ? 220
                                : 180,
                        // color: HexColor('#172543'),
                        child: Padding(
                          padding: heightVal < 480
                              ? const EdgeInsets.only(top: 20)
                              : const EdgeInsets.only(top: 20),
                          child: Wrap(
                            runSpacing: runSpacing,
                            spacing: spacing,
                            alignment: WrapAlignment.center,
                            children: List.generate(selectList.length, (index) {
                              //item 의 반목문 항목 형성

                              return Padding(
                                padding:
                                    const EdgeInsets.only(left: 5, right: 5),
                                child: Container(
                                  width: heightVal < 480
                                      ? widVal * 0.23
                                      : widVal * 0.23,
                                  height: heightVal < 480 ? 40 : 55,
                                  //padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  color: HexColor('#172543'),

                                  child: ElevatedButton(
                                    style: TextButton.styleFrom(
                                      primary: HexColor('#172543'), //글자색
                                      onSurface: Color.fromARGB(255, 26, 24,
                                          24), //onpressed가 null일때 색상
                                      backgroundColor: Colors.white,
                                      shape:
                                          StadiumBorder(), // : 각진버튼, CircleBorder :
                                      side: BorderSide(
                                          color: HexColor('#172543'),
                                          width: 1.0), //선
                                    ),
                                    onPressed: () {
                                      var list;
                                      var listVal;
                                      // if (selectList[index].toString() == "") {
                                      //   selectList = " ";
                                      // } else {
                                      list = selectList[index].toString();
                                      listVal = selectListVal[index].toString();
                                      //}
                                      // checkOption.add(list);
                                      // checkOptionVal.add(listVal);

                                      setState(() {
                                        checkOption[startIndex] = list;
                                        checkOptionVal[startIndex] = listVal;
                                        startIndex++;
                                        Get.back();

                                        if (index1 == itemCnt - 1) {
                                          //saveDesign();
                                          //Get.to(InputTopSize());
                                          orderData.orderType == "2"
                                              ? saveDesignShirt()
                                              : saveDesign();
                                        } else {
                                          _controller.next();
                                        }
                                      });
                                    },
                                    child: Text(selectList[index].toString()),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                    );
                  },
                  child: Container(
                      alignment: Alignment.center,
                      child: PhotoView(
                        imageProvider: AssetImage(suitSet[index1]['optionImg']),
                      )),
                );
              }
            }),
      ),
    );
  }

  TopSize? _inputTopSize;
  BottomSize? _inputBottomSize;
  ShirtSize? _inputShirtSize;
  ShirtDesign? _inputShirtDesign;
  ShirtDesignVal? _inputShirtDesignVal;
  void saveDesign() {
    final orders = FirebaseFirestore.instance.collection('orders').doc(orderNo);

    suitDesign = SuitDesign(
      jacketButton: checkOption[0],
      jacketLapel: checkOption[1],
      jacketChestPocket: checkOption[2],
      jacketShoulder: checkOption[3],
      jacketSidePocket: checkOption[4],
      jacketVent: checkOption[5],
      vestButton: checkOption[6],
      vestLapel: checkOption[7],
      pantsPleats: checkOption[8],
      pantsDetailOne: checkOption[9],
      pantsDetailTwo: checkOption[10],
      pantsDetailThree: checkOption[11],
      pantsBreak: checkOption[12],
      pantsPermanentPleats: checkOption[13],
    );
    suitDesignVal = SuitDesignVal(
      jacketButton: checkOptionVal[0],
      jacketLapel: checkOptionVal[1],
      jacketChestPocket: checkOptionVal[2],
      jacketShoulder: checkOptionVal[3],
      jacketSidePocket: checkOptionVal[4],
      jacketVent: checkOptionVal[5],
      vestButton: checkOptionVal[6],
      vestLapel: checkOptionVal[7],
      pantsPleats: checkOptionVal[8],
      pantsDetailOne: checkOptionVal[9],
      pantsDetailTwo: checkOptionVal[10],
      pantsDetailThree: checkOptionVal[11],
      pantsBreak: checkOptionVal[12],
      pantsPermanentPleats: checkOptionVal[13],
    );

    _inputShirtSize = ShirtSize();
    _inputTopSize = TopSize();
    _inputBottomSize = BottomSize();
    _inputShirtDesign = ShirtDesign();
    _inputShirtDesignVal = ShirtDesignVal();
    var orderData = Get.arguments['orderData'];
    orderData.suitDesign = suitDesign as SuitDesign;
    orderData.suitDesignVal = suitDesignVal as SuitDesignVal;
    orderData.topSize = _inputTopSize;
    orderData.bottomSize = _inputBottomSize;
    orderData.shirtSize = _inputShirtSize;
    orderData.shirtDesign = _inputShirtDesign;
    orderData.shirtDesignVal = _inputShirtDesignVal;
    //orders.add(orderData.toJson());

    //Get.to(InputTopSize(), arguments: {'orderData': orderData});

    try {
      orders.set(orderData.toJson());

      Get.offAll(CustomClothesStep2(), arguments: {
        'orderData': orderData,
        'orderNo': orderNo,
        //'orderNoList': orderNoList
      });
    } catch (e) {
      print(e);
    }
  }

  SuitDesign? _inputSuitDesign;
  SuitDesignVal? _inputSuitDesignVal;

  ShirtDesign? shirtDesign;
  ShirtDesignVal? shirtDesignVal;

  void saveDesignShirt() {
    String orderNo = Get.arguments['orderNo'];
    final orders = FirebaseFirestore.instance.collection('orders').doc(orderNo);

    shirtDesign = ShirtDesign(
      shirtPattern: checkOption[14],
      shirtCollar: checkOption[15],
      shirtCuffs: checkOption[16],
      shirtPlacket: checkOption[17],
      shirtOption: checkOption[18],
    );
    shirtDesignVal = ShirtDesignVal(
      shirtPattern: checkOptionVal[14],
      shirtCollar: checkOptionVal[15],
      shirtCuffs: checkOptionVal[16],
      shirtPlacket: checkOptionVal[17],
      shirtOption: checkOptionVal[18],
    );
    _inputShirtSize = ShirtSize();
    _inputTopSize = TopSize();
    _inputBottomSize = BottomSize();
    _inputSuitDesign = SuitDesign();
    _inputSuitDesignVal = SuitDesignVal();

    var orderData = Get.arguments['orderData'];
    orderData.shirtDesign = shirtDesign as ShirtDesign;
    orderData.shirtDesignVal = shirtDesignVal as ShirtDesignVal;
    orderData.topSize = _inputTopSize;
    orderData.bottomSize = _inputBottomSize;
    orderData.shirtSize = _inputShirtSize;
    orderData.suitDesign = _inputSuitDesign;
    orderData.suitDesignVal = _inputSuitDesignVal;
    try {
      orders.set(orderData.toJson());

      Get.offAll(CustomClothesStep2(), arguments: {
        'orderData': orderData,
        'orderNo': orderNo,
        //'orderNoList': orderNoList
      });
    } catch (e) {
      print(e);
    }
  }
}
