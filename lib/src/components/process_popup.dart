import 'package:bykak/src/components/hex_color.dart';
import 'package:bykak/src/model/suit_option.dart';
import 'package:bykak/src/widget/custom_text_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../model/order_model.dart';

class ProcessPopup extends StatefulWidget {
  final String? title;
  final String? message;
  final List<String>? factoryList;
  final List<String>? brandRateList;
  final List<String>? factoryCapacity;
  final int? step;
  final int? length;
  final String? userId;
  final String? customerName;
  final String? storeName;
  final String? factoryName;
  final String? orderNo;
  final String? pabricSub1;
  final String? pabricSub2;
  final String? orderType;

  //final Function()? okCallback;
  final Function()? cancleCallback;

  const ProcessPopup(
      {Key? key,
      required this.title,
      required this.message,
      //  required this.okCallback,
      required this.factoryList,
      required this.factoryCapacity,
      required this.brandRateList,
      required this.orderNo,
      required this.storeName,
      required this.factoryName,
      required this.userId,
      required this.customerName,
      required this.orderType,
      required this.pabricSub1,
      required this.pabricSub2,
      required this.step,
      required this.length,
      this.cancleCallback})
      : super(key: key);

  @override
  State<ProcessPopup> createState() => _ProcessPopupState();
}

class _ProcessPopupState extends State<ProcessPopup> {
  TextEditingController pabricAmount = new TextEditingController();
  TextEditingController pabricAmount1 = new TextEditingController();
  TextEditingController pabricAmount2 = new TextEditingController();
  bool kisweb = true;
  String selectFactory = "";
  String selectBrandRate = "";
  var returnData;
  String returnJacket = "";
  var returnPants;
  var returnVest;
  var returnShirt;

  @override
  void initState() {
    //calcCost(widget.orderNo!, widget.orderType!);
    // if (widget.step! == 1) {
    //   getData(widget.orderNo!);
    // }

    super.initState();
  }

  bool vestVal = false;

  @override
  Widget build(BuildContext context) {
    var withtVal = MediaQuery.of(context).size.width;
    var factoryList = widget.factoryList!;
    var brandRateList = widget.brandRateList!;
    var factoryCapacity = widget.factoryCapacity!;
    int step = widget.step!;

    String userId = widget.userId!;
    String customerName = widget.customerName!;
    String storeName = widget.storeName!;
    String factoryName = widget.factoryName!;
    String orderNo = widget.orderNo!;
    String orderType = widget.orderType!;
    String pabricSub1 = widget.pabricSub1!;
    String pabricSub2 = widget.pabricSub2!;
    var widthVal = MediaQuery.of(context).size.width;

    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              width: widthVal < 481 ? widthVal * 0.95 : 420,
              // width: kisweb ? Get.width * 0.65 : Get.width * 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  step == 0
                      ? Container()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                //onSurface: mainColor,
                                primary: mainColor,
                                textStyle: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              onPressed: () {
                                updateDownProcess(step, orderNo);
                                Get.back();
                              },
                              child: Text(
                                  '이전 상태(' + processOption[step - 1] + ')로 변경'),
                            ),
                          ],
                        ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.title!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.message!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: 100,
                        child: Text(
                          processOption[step],
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: 40,
                        child: Icon(
                          Icons.arrow_forward_ios_sharp,
                          size: 12,
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: 100,
                        child: Text(
                          step == 4 && orderType == '2'
                              ? processOption[step + 9]
                              : processOption[step + 1],
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      )
                    ],
                  ),
                  step == 3 || step == 8 || (step == 12 && factoryName == "")
                      ? Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '공장선택',
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              child: DropdownButtonFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: HexColor('#172543')),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        BorderSide(color: HexColor('#172543')),
                                  ),
                                  filled: true,
                                ),
                                //value: selectFactory,
                                items: factoryList.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(items),
                                        // Text(factoryCapacity[
                                        //     factoryList.indexOf(items)]),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectFactory = newValue!;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '제품라인선택',
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              child: DropdownButtonFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: HexColor('#172543')),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        BorderSide(color: HexColor('#172543')),
                                  ),
                                  filled: true,
                                ),
                                //value: selectFactory,
                                items: brandRateList.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(items),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectBrandRate = newValue!;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            step == 8
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      customRadio("봉제시작", 1, withtVal),
                                      customRadio("중가봉", 2, withtVal),
                                    ],
                                  )
                                : Container(
                                    height: 15,
                                  ),
                            SizedBox(
                              height: 35,
                            ),
                          ],
                        )
                      : SizedBox(
                          height: 15,
                        ),
                  step == 2
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '원단 요척 입력',
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  height: 60,
                                  width: 200,
                                  child: CustomTextFormField(
                                    lines: 1,
                                    hint: "",
                                    controller: pabricAmount,
                                  ),
                                ),
                                Text(' 야드(yd)')
                              ],
                            ),
                            pabricSub1 != ""
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        height: 60,
                                        width: 200,
                                        child: CustomTextFormField(
                                          lines: 1,
                                          hint: "조끼",
                                          controller: pabricAmount1,
                                        ),
                                      ),
                                      Text(' 야드(yd)')
                                    ],
                                  )
                                : SizedBox(
                                    height: 0,
                                  ),
                            pabricSub2 != ""
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        height: 60,
                                        width: 200,
                                        child: CustomTextFormField(
                                          lines: 1,
                                          hint: "하의",
                                          controller: pabricAmount2,
                                        ),
                                      ),
                                      Text(' 야드(yd)')
                                    ],
                                  )
                                : SizedBox(
                                    height: 0,
                                  ),
                            SizedBox(
                              height: 50,
                            ),
                          ],
                        )
                      : SizedBox(
                          height: 15,
                        ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        // width: kisweb ? Get.width * 0.2 : Get.width * 0.3,
                        width: 140,
                        child: ElevatedButton(
                          onPressed: () {
                            if (step == widget.length!) {
                              Get.back();
                            } else {
                              // if (step == 2) {
                              //   print('factory' + val);
                              // }
                              _selectedIndex != 1 ? step += 1 : step = 13;
                              updateProcess(step, orderNo, orderType, storeName,
                                  selectFactory, selectBrandRate);

                              step == 6 || step == 10 || step == 15
                                  ? insertAlarm(
                                      step,
                                      orderNo,
                                      orderType,
                                      storeName,
                                      factoryName,
                                      userId,
                                      customerName,
                                    )
                                  : null;

                              Get.back();
                            }
                          },
                          //widget.okCallback!,

                          child: Text('확인'),
                          style: TextButton.styleFrom(
                            primary: Colors.white, //글자색
                            onSurface: Colors.white, //onpressed가 null일때 색상
                            backgroundColor: HexColor('#172543'),
                            shadowColor: Colors.white, //그림자 색상
                            elevation: 1, // 버튼 입체감
                            textStyle: TextStyle(fontSize: 16),
                            //padding: EdgeInsets.all(16.0),
                            side: BorderSide(
                                color: HexColor('#172543'), width: 1.0), //선
                            shape:
                                StadiumBorder(), // : 각진버튼, CircleBorder : 동그라미버튼, StadiumBorder : 모서리가 둥근버튼,
                            alignment: Alignment.center,
                          ), //글자위치 변경
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        // width: kisweb ? Get.width * 0.2 : Get.width * 0.3,
                        width: 140,
                        child: ElevatedButton(
                          onPressed: widget.cancleCallback, child: Text('취소'),
                          style: TextButton.styleFrom(
                            primary: HexColor('#172543'), //글자색
                            onSurface: Colors.white, //onpressed가 null일때 색상
                            backgroundColor: Colors.white,
                            shadowColor: Colors.white, //그림자 색상
                            elevation: 1, // 버튼 입체감
                            textStyle: TextStyle(fontSize: 16),
                            //padding: EdgeInsets.all(16.0),
                            side: BorderSide(
                                color: HexColor('#172543'), width: 1.0), //선
                            shape:
                                StadiumBorder(), //BeveledRectangleBorder : 각진버튼, CircleBorder : 동그라미버튼, StadiumBorder : 모서리가 둥근버튼,
                            alignment: Alignment.center,
                          ), //글자위치 변경
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  CollectionReference orders = FirebaseFirestore.instance.collection('orders');

  Future<void> updateDownProcess(int step, String orderNo) {
    return orders
        .doc(orderNo)
        .update({'productionProcess': step - 1})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  // //셔츠는 가봉 프로세스 없이 바로 봉제 상태까지 변경
  // Future<void> updateShirtProcess(String orderNo) {
  //   return orders
  //       .doc(orderNo)
  //       .update({'productionProcess': 13})
  //       .then((value) => print("User Updated"))
  //       .catchError((error) => print("Failed to update user: $error"));
  // }

  void updateProcess(int step, String orderNo, String orderType,
      String storeName, String selectFactory, String selectBrandRate) {
    try {
      // if (orderType == '2') {
      // } else {
      //가봉

      step == 4
          ? FirebaseFirestore.instance.collection('orders').doc(orderNo).set({
              //'suitDesign': _suitDesign!.toJson(),
              'productionProcess': step,
              'gabongFactory': selectFactory,
              'brandRate': selectBrandRate
            }, SetOptions(merge: true))
          //중가봉,봉제 공장 선택
          : step == 9 || step == 13
              ? FirebaseFirestore.instance
                  .collection('orders')
                  .doc(orderNo)
                  .set({
                  //'suitDesign': _suitDesign!.toJson(),
                  'productionProcess': step,
                  'factory': selectFactory,
                  'brandRate': selectBrandRate
                }, SetOptions(merge: true))
              : FirebaseFirestore.instance
                  .collection('orders')
                  .doc(orderNo)
                  .set({
                  //'suitDesign': _suitDesign!.toJson(),
                  'productionProcess': step,
                }, SetOptions(merge: true));

      step == 3
          ? FirebaseFirestore.instance.collection('orders').doc(orderNo).set({
              //'suitDesign': _suitDesign!.toJson(),
              'pabricUsage': pabricAmount.text,
              'pabricUsage1': pabricAmount1.text,
              'pabricUsage2': pabricAmount2.text,
              'productionProcess': step,
            }, SetOptions(merge: true))
          : null;

      step == 5 && orderType == '2'
          ? FirebaseFirestore.instance.collection('orders').doc(orderNo).set({
              //'suitDesign': _suitDesign!.toJson(),
              'productionProcess': 13,
              'gabongFactory': selectFactory,
              'brandRate': selectBrandRate
            }, SetOptions(merge: true))
          : null;

      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      step == 6
          ? FirebaseFirestore.instance.collection('orders').doc(orderNo).set({
              //'suitDesign': _suitDesign!.toJson(),
              'gabongFinishDate': formattedDate,
              'productionProcess': step,
            }, SetOptions(merge: true))
          : null;

      step == 15
          ? FirebaseFirestore.instance.collection('orders').doc(orderNo).set({
              //'suitDesign': _suitDesign!.toJson(),
              'bongjeFinishDate': formattedDate,
              'productionProcess': step,
            }, SetOptions(merge: true))
          : null;
      step == 4
          ? calcCost(orderNo, orderType, storeName, selectFactory,
              selectBrandRate, step)
          : step == 13
              ? calcCost(orderNo, orderType, storeName, selectFactory,
                  selectBrandRate, step)
              : null;
    } catch (e) {
      print(e);
    }
  }

  insertAlarm(int step, String orderNo, String orderType, String storeName,
      String factoryName, String userId, String customerName) async {
    try {
      // 1. 알람을 보낼 유저 목록 추출
      // 공장명이 없을 때 OR 공장명이 있을 때로 구분
      var doc;

      List userList = [];
      String sendUserName = "";

      var userListResult = await FirebaseFirestore.instance
          .collection('users')
          .where('storeName', isEqualTo: storeName)
          .get();

      for (doc in userListResult.docs) {
        setState(() {
          userList.add(doc['userId']);
          if (userId == doc['userId']) {
            sendUserName = doc['userName'];
          }
        });
      }

      if (orderType == "0") {
        orderType = "수트";
      } else if (orderType == "1") {
        orderType = "자켓";
      } else if (orderType == "2") {
        orderType = "셔츠";
      } else if (orderType == "3") {
        orderType = "바지";
      } else if (orderType == "4") {
        orderType = "조끼";
      } else {
        orderType = "코트";
      }
      String productState = processOption[step];
      try {
        if (factoryName != "") {
          List factoryUserList = [];
          var factoryUserResult = await FirebaseFirestore.instance
              .collection('users')
              .where('storeName', isEqualTo: factoryName)
              .get();

          for (doc in factoryUserResult.docs) {
            userList.add(doc['userId']);
          }
          userList.remove(userId);
          for (int i = 0; i < userList.length; i++) {
            FirebaseFirestore.instance.collection('alarms').add({
              //'suitDesign': _suitDesign!.toJson(),
              'sendUser': '[' + storeName + '] ' + sendUserName,
              'recvUserList': userList[i],
              'sendDate': "2022-09-06",
              'readState': "N",
              'sendMsg': 'No: ' +
                  orderNo +
                  " " +
                  customerName +
                  '님의 ' +
                  orderType +
                  " 제품 " +
                  productState +
                  "으로(로) 상태 변경 되었습니다."
            });
          }
        } else {
          userList.remove(userId);
          for (int i = 0; i < userList.length; i++) {
            FirebaseFirestore.instance.collection('alarms').add({
              //'suitDesign': _suitDesign!.toJson(),
              'sendUser': userId,
              'recvUserList': userList[i],

              'sendDate': "2022-09-06",
              'readState': "N",
              'sendMsg': 'No: ' +
                  orderNo +
                  " " +
                  customerName +
                  '님의 ' +
                  orderType +
                  " 제품 " +
                  productState +
                  "으로(로) 상태 변경 되었습니다."
            });
          }
        }
      } catch (e) {
        print(e);
      }
    } catch (e) {
      print(e);
    }
  }

  List jacketValueList = [];
  List jacketKeyList = [];
  List vestValueList = [];
  List vestKeyList = [];
  List pantsValueList = [];
  List pantsKeyList = [];
  List shirtValueList = [];
  List shirtKeyList = [];
  List coatValueList = [];
  List coatKeyList = [];
  int totalFactoryCost = 0; // 공임비
  int normalCost = 0; // 기본공임비
  int gabongCost = 0; // 가봉비
  int gabongSubCost = 0; // 중가봉비
  int jacketCost = 0; // 중가봉비
  int pantsCost = 0; // 중가봉비
  int vestCost = 0; // 중가봉비
  int shirtCost = 0; // 중가봉비
  int suitCost = 0; // 중가봉비
  String priceDetail = ""; // 공임비상세
  String factoryPrice = "";
  calcCost(String orderNo, String orderType, String storeName,
      String factoryName, String brandRate, int step) async {
    var orderInfo = await FirebaseFirestore.instance
        .collection('orders')
        .where('orderNo', isEqualTo: orderNo)
        .get();
    print("orderType:" + orderType);
    for (var item in orderInfo.docs) {
      //셔츠
      if (orderType == '2') {
        shirtValueList = item['shirtOption'].values.toList();
        shirtKeyList = item['shirtOption'].keys.toList();
      }
      //바지
      else if (orderType == '3') {
        pantsValueList = item['pantsOption'].values.toList();
        pantsKeyList = item['pantsOption'].keys.toList();
      }
      //조끼
      else if (orderType == '4') {
        vestValueList = item['vestOption'].values.toList();
        vestKeyList = item['vestOption'].keys.toList();
      }
      //코트
      else if (orderType == '5') {
      }
      //자켓
      else if (orderType == '1') {
        jacketValueList = item['jacketOption'].values.toList();
        jacketKeyList = item['jacketOption'].keys.toList();
      }
      //수트
      else {
        jacketValueList = item['jacketOption'].values.toList();
        jacketKeyList = item['jacketOption'].keys.toList();
        vestValueList = item['vestOption'].values.toList();
        vestKeyList = item['vestOption'].keys.toList();
        pantsValueList = item['pantsOption'].values.toList();
        pantsKeyList = item['pantsOption'].keys.toList();
      }
    }

    for (var item in orderInfo.docs) {
      //셔츠
      if (orderType == '2') {
        shirtKeyList.insert(0, '기본공임');
        shirtValueList.insert(0, ['기본공임', '가봉공임', '중가봉공임']);

        for (var i = 0; i < shirtKeyList.length; i++) {
          try {
            var costResult = await FirebaseFirestore.instance
                .collection('produceCost')
                .doc(storeName + '_' + factoryName + '_' + brandRate)
                .collection('costDetail')
                .doc('셔츠_' + shirtKeyList[i])
                .get();

            if (i == 0) {
              normalCost +=
                  int.parse(costResult['optionsProduceCost'][0].toString());
              gabongCost +=
                  int.parse(costResult['optionsProduceCost'][1].toString());
              gabongSubCost +=
                  int.parse(costResult['optionsProduceCost'][2].toString());
            } else {
              if (costResult['brandRate'] == brandRate) {
                List a = costResult['optionsList'];
                int idx = a.indexOf(shirtValueList[i]);

                try {
                  shirtCost += int.parse(
                      costResult['optionsProduceCost'][idx].toString());
                } catch (e) {
                  print(e);
                }
              }
            }
          } catch (e) {
            continue;
          }
        }
        factoryPrice = '셔츠[' + shirtCost.toString() + "] ";
      }
      //바지
      else if (orderType == '3') {
        print('1');
        pantsKeyList.insert(0, '기본공임');
        pantsValueList.insert(0, ['기본공임', '가봉공임', '중가봉공임']);

        for (var i = 0; i < pantsKeyList.length; i++) {
          try {
            var costResult = await FirebaseFirestore.instance
                .collection('produceCost')
                .doc(storeName + '_' + factoryName + '_' + brandRate)
                .collection('costDetail')
                .doc('바지_' + pantsKeyList[i])
                .get();

            if (i == 0) {
              print(costResult['optionsProduceCost'][0].toString());
              print(costResult['optionsProduceCost'][1].toString());
              print(costResult['optionsProduceCost'][2].toString());

              normalCost +=
                  int.parse(costResult['optionsProduceCost'][0].toString());
              gabongCost +=
                  int.parse(costResult['optionsProduceCost'][1].toString());
              gabongSubCost +=
                  int.parse(costResult['optionsProduceCost'][2].toString());
            } else {
              if (costResult['brandRate'] == brandRate) {
                List a = costResult['optionsList'];
                int idx = a.indexOf(pantsValueList[i]);

                try {
                  pantsCost += int.parse(
                      costResult['optionsProduceCost'][idx].toString());
                } catch (e) {
                  print(e);
                }
              }
            }
          } catch (e) {
            continue;
          }
        }
        factoryPrice = '바지[' + pantsCost.toString() + "]";
      }
      //조끼
      else if (orderType == '4') {
        print('2');
        vestKeyList.insert(0, '기본공임');
        vestValueList.insert(0, ['기본공임', '가봉공임', '중가봉공임']);
        for (var i = 0; i < vestKeyList.length; i++) {
          try {
            var costResult = await FirebaseFirestore.instance
                .collection('produceCost')
                .doc(storeName + '_' + factoryName + '_' + brandRate)
                .collection('costDetail')
                .doc('조끼_' + vestKeyList[i])
                .get();

            if (i == 0) {
              print(costResult['optionsProduceCost'][0].toString());
              print(costResult['optionsProduceCost'][1].toString());
              print(costResult['optionsProduceCost'][2].toString());
              normalCost +=
                  int.parse(costResult['optionsProduceCost'][0].toString());
              gabongCost +=
                  int.parse(costResult['optionsProduceCost'][1].toString());
              gabongSubCost +=
                  int.parse(costResult['optionsProduceCost'][2].toString());
            } else {
              if (costResult['brandRate'] == brandRate) {
                List a = costResult['optionsList'];
                int idx = a.indexOf(vestValueList[i]);

                try {
                  vestCost += int.parse(
                      costResult['optionsProduceCost'][idx].toString());
                } catch (e) {
                  print(e);
                }
              }
            }
          } catch (e) {
            continue;
          }
        }
        factoryPrice = '조끼[' + vestCost.toString() + "] ";
      }
      //코트
      else if (orderType == '5') {
      }
      //자켓
      else if (orderType == '1') {
        print('3');
        jacketKeyList.insert(0, '기본공임');
        jacketValueList.insert(0, ['기본공임', '가봉공임', '중가봉공임']);

        for (var i = 0; i < jacketKeyList.length; i++) {
          try {
            var costResult = await FirebaseFirestore.instance
                .collection('produceCost')
                .doc(storeName + '_' + factoryName + '_' + brandRate)
                .collection('costDetail')
                .doc('자켓_' + jacketKeyList[i])
                .get();

            if (i == 0) {
              print(costResult['optionsProduceCost'][0].toString());
              print(costResult['optionsProduceCost'][1].toString());
              print(costResult['optionsProduceCost'][2].toString());
              normalCost +=
                  int.parse(costResult['optionsProduceCost'][0].toString());
              gabongCost +=
                  int.parse(costResult['optionsProduceCost'][1].toString());
              gabongSubCost +=
                  int.parse(costResult['optionsProduceCost'][2].toString());
            } else {
              if (costResult['brandRate'] == brandRate) {
                List a = costResult['optionsList'];
                int idx = a.indexOf(jacketValueList[i]);

                try {
                  jacketCost += int.parse(
                      costResult['optionsProduceCost'][idx].toString());
                } catch (e) {
                  print(e);
                }
              }
            }
          } catch (e) {
            continue;
          }
        }
        factoryPrice = '자켓[' + jacketCost.toString() + "] ";
      }
      //수트
      else {
        jacketKeyList.insert(0, '기본공임');
        jacketValueList.insert(0, ['기본공임', '가봉공임', '중가봉공임']);

        for (var i = 0; i < jacketKeyList.length; i++) {
          try {
            var costResult = await FirebaseFirestore.instance
                .collection('produceCost')
                .doc(storeName + '_' + factoryName + '_' + brandRate)
                .collection('costDetail')
                .doc('자켓_' + jacketKeyList[i])
                .get();

            if (i == 0) {
              print(costResult['optionsProduceCost'][0].toString());
              print(costResult['optionsProduceCost'][1].toString());
              print(costResult['optionsProduceCost'][2].toString());
              normalCost +=
                  int.parse(costResult['optionsProduceCost'][0].toString());
              gabongCost +=
                  int.parse(costResult['optionsProduceCost'][1].toString());
              gabongSubCost +=
                  int.parse(costResult['optionsProduceCost'][2].toString());
            } else {
              if (costResult['brandRate'] == brandRate) {
                List a = costResult['optionsList'];
                int idx = a.indexOf(jacketValueList[i]);

                try {
                  jacketCost += int.parse(
                      costResult['optionsProduceCost'][idx].toString());
                } catch (e) {
                  print(e);
                }
              }
            }
          } catch (e) {
            continue;
          }
        }
        vestKeyList.insert(0, '기본공임');
        vestValueList.insert(0, ['기본공임', '가봉공임', '중가봉공임']);
        for (var i = 0; i < vestKeyList.length; i++) {
          try {
            var costResult = await FirebaseFirestore.instance
                .collection('produceCost')
                .doc(storeName + '_' + factoryName + '_' + brandRate)
                .collection('costDetail')
                .doc('조끼_' + vestKeyList[i])
                .get();

            if (i == 0) {
              print(costResult['optionsProduceCost'][0].toString());
              print(costResult['optionsProduceCost'][1].toString());
              print(costResult['optionsProduceCost'][2].toString());
              normalCost +=
                  int.parse(costResult['optionsProduceCost'][0].toString());
              gabongCost +=
                  int.parse(costResult['optionsProduceCost'][1].toString());
              gabongSubCost +=
                  int.parse(costResult['optionsProduceCost'][2].toString());
            } else {
              if (costResult['brandRate'] == brandRate) {
                List a = costResult['optionsList'];
                int idx = a.indexOf(vestValueList[i]);

                try {
                  vestCost += int.parse(
                      costResult['optionsProduceCost'][idx].toString());
                } catch (e) {
                  print(e);
                }
              }
            }
          } catch (e) {
            continue;
          }
        }

        pantsKeyList.insert(0, '기본공임');
        pantsValueList.insert(0, ['기본공임', '가봉공임', '중가봉공임']);

        for (var i = 0; i < pantsKeyList.length; i++) {
          try {
            var costResult = await FirebaseFirestore.instance
                .collection('produceCost')
                .doc(storeName + '_' + factoryName + '_' + brandRate)
                .collection('costDetail')
                .doc('바지_' + pantsKeyList[i])
                .get();

            if (i == 0) {
              print(costResult['optionsProduceCost'][0].toString());
              print(costResult['optionsProduceCost'][1].toString());
              print(costResult['optionsProduceCost'][2].toString());

              normalCost +=
                  int.parse(costResult['optionsProduceCost'][0].toString());
              gabongCost +=
                  int.parse(costResult['optionsProduceCost'][1].toString());
              gabongSubCost +=
                  int.parse(costResult['optionsProduceCost'][2].toString());
            } else {
              if (costResult['brandRate'] == brandRate) {
                List a = costResult['optionsList'];
                int idx = a.indexOf(pantsValueList[i]);

                try {
                  pantsCost += int.parse(
                      costResult['optionsProduceCost'][idx].toString());
                } catch (e) {
                  print(e);
                }
              }
            }
          } catch (e) {
            continue;
          }
        }
        factoryPrice = '자켓[' +
            jacketCost.toString() +
            "] " +
            '조끼[' +
            vestCost.toString() +
            "] " +
            '바지[' +
            pantsCost.toString() +
            "]";
      }
    }

    print('gabongCost:' + gabongCost.toString());
    step == 4
        ?
        //기본공임비
        FirebaseFirestore.instance.collection('orders').doc(orderNo).set({
            //'suitDesign': _suitDesign!.toJson(),
            'gabongPrice': gabongCost,
            'factoryPriceDetail': priceDetail
          }, SetOptions(merge: true))

        //기본공임비
        : FirebaseFirestore.instance.collection('orders').doc(orderNo).set({
            //'suitDesign': _suitDesign!.toJson(),
            'factoryPrice': factoryPrice,
            'normalPrice': normalCost,
            'factoryPriceDetail': priceDetail
          }, SetOptions(merge: true));
  }

//   getData(String orderNo) async {
//     var orderInfo = await FirebaseFirestore.instance
//         .collection('orders')
//         .where('orderNo', isEqualTo: orderNo)
//         .get();

//     for (var item in orderInfo.docs) {
//       returnData = item['suitDesignVal'];

//       //자켓값
//       returnJacket = returnData['jacketButton'] +
//           ',' +
//           returnData['jacketLapel'] +
//           ',' +
//           returnData['jacketVent'] +
//           ',' +
//           returnData['jacketShoulder'] +
//           ',' +
//           returnData['jacketSidePocket'] +
//           ',' +
//           returnData['jacketChestPocket'];
// //바지값
//       returnPants = returnData['pantsBreak'] +
//           ',' +
//           returnData['pantsDetailOne'] +
//           ',' +
//           returnData['pantsDetailThree'] +
//           ',' +
//           returnData['pantsDetailTwo'] +
//           ',' +
//           returnData['pantsPermanentPleats'] +
//           ',' +
//           returnData['pantsPleats'];
// //조기값
//       returnVest = returnData['vestButton'] + ',' + returnData['vestLapel'];

//       if (item['suitDesignVal']['vestButton'] != "") {
//         setState(() {
//           vestVal = true;
//         });
//       } else {
//         setState(() {
//           vestVal = false;
//         });
//       }
//     }
//   }

//   checkCost(String orderNo, String orderType, String storeName,
//       String selectFactory, String selectBrandRate, int step) async {
//     // 0 수트 , 1자켓 , 2셔츠, 3바지, 4조끼, 5코트
//     getData(orderNo);
//     int totalFactoryCost = 0; // 공임비
//     int normalCost = 0; // 기본공임비
//     int gabongCost = 0; // 가봉비
//     int gabongSubCost = 0; // 중가봉비
//     int jacketCost = 0; // 중가봉비
//     int pantsCost = 0; // 중가봉비
//     int vestCost = 0; // 중가봉비
//     int shirtCost = 0; // 중가봉비
//     int suitCost = 0; // 중가봉비
//     String priceDetail = ""; // 공임비상세

//     try {
//       //특정 테일러샵의 가격표가 따로 있다면

//       var costList = await FirebaseFirestore.instance
//           .collection('factory')
//           .doc(selectFactory)
//           .collection('costList')
//           .where('storeName', isEqualTo: storeName)
//           .where('factoryName', isEqualTo: selectFactory)
//           .where('selectBrandRate', isEqualTo: selectBrandRate)
//           .get();

//       for (var item in costList.docs) {
//         //자켓

//         if (orderType == "0") {
//           normalCost += item['costNormal']['normal1'] as int;
//           gabongCost += item['costGabong']['gabong1'] as int;

//           print(returnJacket);
//           //자켓 특징별 공입
//           //더블
//           if (returnJacket.toString().contains('더블')) {
//             jacketCost += item['costJacket']['jacket1'] as int;
//             priceDetail += '자켓더블,';
//           }
//           if (returnJacket.toString().contains('갱애리')) {
//             jacketCost += item['costJacket']['jacket2'] as int;
//             priceDetail += '갱애리,';
//           }
//           if (returnJacket.toString().contains('숄카라')) {
//             jacketCost += item['costJacket']['jacket3'] as int;
//             priceDetail += '숄카라,';
//           }
//           if (returnJacket.toString().contains('홍아개')) {
//             jacketCost += item['costJacket']['jacket4'] as int;
//             priceDetail += '홍아개,';
//           }
//           //아웃포켓
//           if (returnJacket.toString().contains('학꼬 아웃트')) {
//             jacketCost += item['costJacket']['jacket5'] as int;
//             priceDetail += '학꼬 아웃트,';
//           }
//           if (returnJacket.toString().contains('보카시')) {
//             jacketCost += item['costJacket']['jacket6'] as int;
//             priceDetail += '보카시,';
//           }
//           if (returnJacket.toString().contains('콩주머니')) {
//             jacketCost += item['costJacket']['jacket7'] as int;
//             priceDetail += '콩주머니,';
//           }
//           if (returnJacket.toString().contains('긴자꾸')) {
//             jacketCost += item['costJacket']['jacket8'] as int;
//             priceDetail += '갱애리,';
//           }
//           if (returnJacket.toString().contains('공단애리')) {
//             jacketCost += item['costJacket']['jacket9'] as int;
//             priceDetail += '공단애리,';
//           }
//           if (returnJacket.toString().contains('자바라')) {
//             jacketCost += item['costJacket']['jacket10'] as int;
//             priceDetail += '자바라,';
//           }
//           if (returnJacket.toString().contains('농구애리')) {
//             jacketCost += item['costJacket']['jacket11'] as int;
//             priceDetail += '농구애리,';
//           }
//           if (returnJacket.toString().contains('나그랑')) {
//             jacketCost += item['costJacket']['jacket12'] as int;
//             priceDetail += '나그랑,';
//           }
//           if (returnJacket.toString().contains('별식')) {
//             jacketCost += item['costJacket']['jacket13'] as int;
//             priceDetail += '자켓별식,';
//           }
//           if (returnPants.toString().contains('구르카')) {
//             pantsCost += item['costPants']['pants1'] as int;
//             priceDetail += '구르카,';
//           }
//           if (returnPants.toString().contains('깡바지')) {
//             pantsCost += item['costPants']['pants2'] as int;
//             priceDetail += '깡바지,';
//           }
//           if (returnPants.toString().contains('판치에리나')) {
//             pantsCost += item['costPants']['pants3'] as int;
//             priceDetail += '판치에리나,';
//           }
//           if (returnPants.toString().contains('턱시도레일깡')) {
//             pantsCost += item['costPants']['pants4'] as int;
//             priceDetail += '턱시도레일깡,';
//           }
//           if (returnPants.toString().contains('슬라이드버클')) {
//             pantsCost += item['costPants']['pants5'] as int;
//             priceDetail += '슬라이드버클,';
//           }
//           if (returnPants.toString().contains('별식')) {
//             pantsCost += item['costPants']['pants6'] as int;
//             priceDetail += '바지별식';
//           }

//           if (returnVest != "") {
//             normalCost += item['costNormal']['normal4'] as int;
//             gabongCost += item['costGabong']['gabong4'] as int;

//             if (returnVest.toString().contains('더블')) {
//               vestCost += item['costVest']['vest1'] as int;
//               priceDetail += '조끼더블,';
//             }
//             if (returnVest.toString().contains('애리')) {
//               vestCost += item['costVest']['vest2'] as int;
//               priceDetail += '조끼애리,';
//             }
//             if (returnVest.toString().contains('별식')) {
//               vestCost += item['costVest']['vest3'] as int;
//               priceDetail += '조끼별식';
//             }
//           }
//         } else if (orderType == "1") {
//           normalCost += item['costNormal']['normal2'] as int;
//           gabongCost += item['costGabong']['gabong2'] as int;

//           if (returnJacket.toString().contains('더블')) {
//             jacketCost += item['costJacket']['jacket1'] as int;
//             priceDetail += '자켓더블,';
//           }
//           if (returnJacket.toString().contains('갱애리')) {
//             jacketCost += item['costJacket']['jacket2'] as int;
//             priceDetail += '갱애리,';
//           }
//           if (returnJacket.toString().contains('숄카라')) {
//             jacketCost += item['costJacket']['jacket3'] as int;
//             priceDetail += '숄카라,';
//           }
//           if (returnJacket.toString().contains('홍아개')) {
//             jacketCost += item['costJacket']['jacket4'] as int;
//             priceDetail += '홍아개,';
//           }
//           //아웃포켓
//           if (returnJacket.toString().contains('학꼬 아웃트')) {
//             jacketCost += item['costJacket']['jacket5'] as int;
//             priceDetail += '학꼬 아웃트,';
//           }
//           if (returnJacket.toString().contains('보카시')) {
//             jacketCost += item['costJacket']['jacket6'] as int;
//             priceDetail += '보카시,';
//           }
//           if (returnJacket.toString().contains('콩주머니')) {
//             jacketCost += item['costJacket']['jacket7'] as int;
//             priceDetail += '콩주머니,';
//           }
//           if (returnJacket.toString().contains('긴자꾸')) {
//             jacketCost += item['costJacket']['jacket8'] as int;
//             priceDetail += '갱애리,';
//           }
//           if (returnJacket.toString().contains('공단애리')) {
//             jacketCost += item['costJacket']['jacket9'] as int;
//             priceDetail += '공단애리,';
//           }
//           if (returnJacket.toString().contains('자바라')) {
//             jacketCost += item['costJacket']['jacket10'] as int;
//             priceDetail += '자바라,';
//           }
//           if (returnJacket.toString().contains('농구애리')) {
//             jacketCost += item['costJacket']['jacket11'] as int;
//             priceDetail += '농구애리,';
//           }
//           if (returnJacket.toString().contains('나그랑')) {
//             jacketCost += item['costJacket']['jacket12'] as int;
//             priceDetail += '나그랑,';
//           }
//           if (returnJacket.toString().contains('별식')) {
//             jacketCost += item['costJacket']['jacket13'] as int;
//             priceDetail += '자켓별식,';
//           }
//         } else if (orderType == "3") {
//           //바지
//           normalCost += item['costNormal']['normal3'] as int;
//           gabongCost += item['costGabong']['gabong3'] as int;

//           if (returnPants.toString().contains('구르카')) {
//             pantsCost += item['costPants']['pants1'] as int;
//             priceDetail += '구르카,';
//           }
//           if (returnPants.toString().contains('깡바지')) {
//             pantsCost += item['costPants']['pants2'] as int;
//             priceDetail += '깡바지,';
//           }
//           if (returnPants.toString().contains('판치에리나')) {
//             pantsCost += item['costPants']['pants3'] as int;
//             priceDetail += '판치에리나,';
//           }
//           if (returnPants.toString().contains('턱시도레일깡')) {
//             pantsCost += item['costPants']['pants4'] as int;
//             priceDetail += '턱시도레일깡,';
//           }
//           if (returnPants.toString().contains('슬라이드버클')) {
//             pantsCost += item['costPants']['pants5'] as int;
//             priceDetail += '슬라이드버클,';
//           }
//           if (returnPants.toString().contains('별식')) {
//             pantsCost += item['costPants']['pants6'] as int;
//             priceDetail += '바지별식';
//           }
//         } else if (orderType == "4") {
//           //조끼
//           normalCost += item['costNormal']['normal4'] as int;
//           gabongCost += item['costGabong']['gabong4'] as int;

//           if (returnVest.toString().contains('더블')) {
//             vestCost += item['costVest']['vest1'] as int;
//             priceDetail += '조끼더블,';
//           }
//           if (returnVest.toString().contains('애리')) {
//             vestCost += item['costVest']['vest2'] as int;
//             priceDetail += '조끼애리,';
//           }
//           if (returnVest.toString().contains('별식')) {
//             vestCost += item['costVest']['vest3'] as int;
//             priceDetail += '조끼별식';
//           }
//         } else {
//           print('준비중');
//         }

//         step == 4
//             ?
//             //기본공임비
//             FirebaseFirestore.instance.collection('orders').doc(orderNo).set({
//                 //'suitDesign': _suitDesign!.toJson(),
//                 'gabongPrice': gabongCost,
//                 'factoryPriceDetail': priceDetail
//               }, SetOptions(merge: true))

//             //기본공임비
//             : FirebaseFirestore.instance.collection('orders').doc(orderNo).set({
//                 //'suitDesign': _suitDesign!.toJson(),
//                 'factoryPrice': jacketCost + vestCost + pantsCost,
//                 'normalPrice': normalCost,
//                 'factoryPriceDetail': priceDetail
//               }, SetOptions(merge: true));
//       }
//     } catch (e) {}
//   }

  int _selectedIndex = 0;
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
