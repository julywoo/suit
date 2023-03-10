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
                                  '?????? ??????(' + processOption[step - 1] + ')??? ??????'),
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
                                '????????????',
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
                                '??????????????????',
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
                                      customRadio("????????????", 1, withtVal),
                                      customRadio("?????????", 2, withtVal),
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
                                '?????? ?????? ??????',
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
                                Text(' ??????(yd)')
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
                                          hint: "??????",
                                          controller: pabricAmount1,
                                        ),
                                      ),
                                      Text(' ??????(yd)')
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
                                          hint: "??????",
                                          controller: pabricAmount2,
                                        ),
                                      ),
                                      Text(' ??????(yd)')
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

                          child: Text('??????'),
                          style: TextButton.styleFrom(
                            primary: Colors.white, //?????????
                            onSurface: Colors.white, //onpressed??? null?????? ??????
                            backgroundColor: HexColor('#172543'),
                            shadowColor: Colors.white, //????????? ??????
                            elevation: 1, // ?????? ?????????
                            textStyle: TextStyle(fontSize: 16),
                            //padding: EdgeInsets.all(16.0),
                            side: BorderSide(
                                color: HexColor('#172543'), width: 1.0), //???
                            shape:
                                StadiumBorder(), // : ????????????, CircleBorder : ??????????????????, StadiumBorder : ???????????? ????????????,
                            alignment: Alignment.center,
                          ), //???????????? ??????
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        // width: kisweb ? Get.width * 0.2 : Get.width * 0.3,
                        width: 140,
                        child: ElevatedButton(
                          onPressed: widget.cancleCallback, child: Text('??????'),
                          style: TextButton.styleFrom(
                            primary: HexColor('#172543'), //?????????
                            onSurface: Colors.white, //onpressed??? null?????? ??????
                            backgroundColor: Colors.white,
                            shadowColor: Colors.white, //????????? ??????
                            elevation: 1, // ?????? ?????????
                            textStyle: TextStyle(fontSize: 16),
                            //padding: EdgeInsets.all(16.0),
                            side: BorderSide(
                                color: HexColor('#172543'), width: 1.0), //???
                            shape:
                                StadiumBorder(), //BeveledRectangleBorder : ????????????, CircleBorder : ??????????????????, StadiumBorder : ???????????? ????????????,
                            alignment: Alignment.center,
                          ), //???????????? ??????
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

  // //????????? ?????? ???????????? ?????? ?????? ?????? ???????????? ??????
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
      //??????

      step == 4
          ? FirebaseFirestore.instance.collection('orders').doc(orderNo).set({
              //'suitDesign': _suitDesign!.toJson(),
              'productionProcess': step,
              'gabongFactory': selectFactory,
              'brandRate': selectBrandRate
            }, SetOptions(merge: true))
          //?????????,?????? ?????? ??????
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
      // 1. ????????? ?????? ?????? ?????? ??????
      // ???????????? ?????? ??? OR ???????????? ?????? ?????? ??????
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
        orderType = "??????";
      } else if (orderType == "1") {
        orderType = "??????";
      } else if (orderType == "2") {
        orderType = "??????";
      } else if (orderType == "3") {
        orderType = "??????";
      } else if (orderType == "4") {
        orderType = "??????";
      } else {
        orderType = "??????";
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
                  '?????? ' +
                  orderType +
                  " ?????? " +
                  productState +
                  "??????(???) ?????? ?????? ???????????????."
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
                  '?????? ' +
                  orderType +
                  " ?????? " +
                  productState +
                  "??????(???) ?????? ?????? ???????????????."
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
  int totalFactoryCost = 0; // ?????????
  int normalCost = 0; // ???????????????
  int gabongCost = 0; // ?????????
  int gabongSubCost = 0; // ????????????
  int jacketCost = 0; // ????????????
  int pantsCost = 0; // ????????????
  int vestCost = 0; // ????????????
  int shirtCost = 0; // ????????????
  int suitCost = 0; // ????????????
  String priceDetail = ""; // ???????????????
  String factoryPrice = "";
  calcCost(String orderNo, String orderType, String storeName,
      String factoryName, String brandRate, int step) async {
    var orderInfo = await FirebaseFirestore.instance
        .collection('orders')
        .where('orderNo', isEqualTo: orderNo)
        .get();
    print("orderType:" + orderType);
    for (var item in orderInfo.docs) {
      //??????
      if (orderType == '2') {
        shirtValueList = item['shirtOption'].values.toList();
        shirtKeyList = item['shirtOption'].keys.toList();
      }
      //??????
      else if (orderType == '3') {
        pantsValueList = item['pantsOption'].values.toList();
        pantsKeyList = item['pantsOption'].keys.toList();
      }
      //??????
      else if (orderType == '4') {
        vestValueList = item['vestOption'].values.toList();
        vestKeyList = item['vestOption'].keys.toList();
      }
      //??????
      else if (orderType == '5') {
      }
      //??????
      else if (orderType == '1') {
        jacketValueList = item['jacketOption'].values.toList();
        jacketKeyList = item['jacketOption'].keys.toList();
      }
      //??????
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
      //??????
      if (orderType == '2') {
        shirtKeyList.insert(0, '????????????');
        shirtValueList.insert(0, ['????????????', '????????????', '???????????????']);

        for (var i = 0; i < shirtKeyList.length; i++) {
          try {
            var costResult = await FirebaseFirestore.instance
                .collection('produceCost')
                .doc(storeName + '_' + factoryName + '_' + brandRate)
                .collection('costDetail')
                .doc('??????_' + shirtKeyList[i])
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
        factoryPrice = '??????[' + shirtCost.toString() + "] ";
      }
      //??????
      else if (orderType == '3') {
        print('1');
        pantsKeyList.insert(0, '????????????');
        pantsValueList.insert(0, ['????????????', '????????????', '???????????????']);

        for (var i = 0; i < pantsKeyList.length; i++) {
          try {
            var costResult = await FirebaseFirestore.instance
                .collection('produceCost')
                .doc(storeName + '_' + factoryName + '_' + brandRate)
                .collection('costDetail')
                .doc('??????_' + pantsKeyList[i])
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
        factoryPrice = '??????[' + pantsCost.toString() + "]";
      }
      //??????
      else if (orderType == '4') {
        print('2');
        vestKeyList.insert(0, '????????????');
        vestValueList.insert(0, ['????????????', '????????????', '???????????????']);
        for (var i = 0; i < vestKeyList.length; i++) {
          try {
            var costResult = await FirebaseFirestore.instance
                .collection('produceCost')
                .doc(storeName + '_' + factoryName + '_' + brandRate)
                .collection('costDetail')
                .doc('??????_' + vestKeyList[i])
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
        factoryPrice = '??????[' + vestCost.toString() + "] ";
      }
      //??????
      else if (orderType == '5') {
      }
      //??????
      else if (orderType == '1') {
        print('3');
        jacketKeyList.insert(0, '????????????');
        jacketValueList.insert(0, ['????????????', '????????????', '???????????????']);

        for (var i = 0; i < jacketKeyList.length; i++) {
          try {
            var costResult = await FirebaseFirestore.instance
                .collection('produceCost')
                .doc(storeName + '_' + factoryName + '_' + brandRate)
                .collection('costDetail')
                .doc('??????_' + jacketKeyList[i])
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
        factoryPrice = '??????[' + jacketCost.toString() + "] ";
      }
      //??????
      else {
        jacketKeyList.insert(0, '????????????');
        jacketValueList.insert(0, ['????????????', '????????????', '???????????????']);

        for (var i = 0; i < jacketKeyList.length; i++) {
          try {
            var costResult = await FirebaseFirestore.instance
                .collection('produceCost')
                .doc(storeName + '_' + factoryName + '_' + brandRate)
                .collection('costDetail')
                .doc('??????_' + jacketKeyList[i])
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
        vestKeyList.insert(0, '????????????');
        vestValueList.insert(0, ['????????????', '????????????', '???????????????']);
        for (var i = 0; i < vestKeyList.length; i++) {
          try {
            var costResult = await FirebaseFirestore.instance
                .collection('produceCost')
                .doc(storeName + '_' + factoryName + '_' + brandRate)
                .collection('costDetail')
                .doc('??????_' + vestKeyList[i])
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

        pantsKeyList.insert(0, '????????????');
        pantsValueList.insert(0, ['????????????', '????????????', '???????????????']);

        for (var i = 0; i < pantsKeyList.length; i++) {
          try {
            var costResult = await FirebaseFirestore.instance
                .collection('produceCost')
                .doc(storeName + '_' + factoryName + '_' + brandRate)
                .collection('costDetail')
                .doc('??????_' + pantsKeyList[i])
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
        factoryPrice = '??????[' +
            jacketCost.toString() +
            "] " +
            '??????[' +
            vestCost.toString() +
            "] " +
            '??????[' +
            pantsCost.toString() +
            "]";
      }
    }

    print('gabongCost:' + gabongCost.toString());
    step == 4
        ?
        //???????????????
        FirebaseFirestore.instance.collection('orders').doc(orderNo).set({
            //'suitDesign': _suitDesign!.toJson(),
            'gabongPrice': gabongCost,
            'factoryPriceDetail': priceDetail
          }, SetOptions(merge: true))

        //???????????????
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

//       //?????????
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
// //?????????
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
// //?????????
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
//     // 0 ?????? , 1?????? , 2??????, 3??????, 4??????, 5??????
//     getData(orderNo);
//     int totalFactoryCost = 0; // ?????????
//     int normalCost = 0; // ???????????????
//     int gabongCost = 0; // ?????????
//     int gabongSubCost = 0; // ????????????
//     int jacketCost = 0; // ????????????
//     int pantsCost = 0; // ????????????
//     int vestCost = 0; // ????????????
//     int shirtCost = 0; // ????????????
//     int suitCost = 0; // ????????????
//     String priceDetail = ""; // ???????????????

//     try {
//       //?????? ??????????????? ???????????? ?????? ?????????

//       var costList = await FirebaseFirestore.instance
//           .collection('factory')
//           .doc(selectFactory)
//           .collection('costList')
//           .where('storeName', isEqualTo: storeName)
//           .where('factoryName', isEqualTo: selectFactory)
//           .where('selectBrandRate', isEqualTo: selectBrandRate)
//           .get();

//       for (var item in costList.docs) {
//         //??????

//         if (orderType == "0") {
//           normalCost += item['costNormal']['normal1'] as int;
//           gabongCost += item['costGabong']['gabong1'] as int;

//           print(returnJacket);
//           //?????? ????????? ??????
//           //??????
//           if (returnJacket.toString().contains('??????')) {
//             jacketCost += item['costJacket']['jacket1'] as int;
//             priceDetail += '????????????,';
//           }
//           if (returnJacket.toString().contains('?????????')) {
//             jacketCost += item['costJacket']['jacket2'] as int;
//             priceDetail += '?????????,';
//           }
//           if (returnJacket.toString().contains('?????????')) {
//             jacketCost += item['costJacket']['jacket3'] as int;
//             priceDetail += '?????????,';
//           }
//           if (returnJacket.toString().contains('?????????')) {
//             jacketCost += item['costJacket']['jacket4'] as int;
//             priceDetail += '?????????,';
//           }
//           //????????????
//           if (returnJacket.toString().contains('?????? ?????????')) {
//             jacketCost += item['costJacket']['jacket5'] as int;
//             priceDetail += '?????? ?????????,';
//           }
//           if (returnJacket.toString().contains('?????????')) {
//             jacketCost += item['costJacket']['jacket6'] as int;
//             priceDetail += '?????????,';
//           }
//           if (returnJacket.toString().contains('????????????')) {
//             jacketCost += item['costJacket']['jacket7'] as int;
//             priceDetail += '????????????,';
//           }
//           if (returnJacket.toString().contains('?????????')) {
//             jacketCost += item['costJacket']['jacket8'] as int;
//             priceDetail += '?????????,';
//           }
//           if (returnJacket.toString().contains('????????????')) {
//             jacketCost += item['costJacket']['jacket9'] as int;
//             priceDetail += '????????????,';
//           }
//           if (returnJacket.toString().contains('?????????')) {
//             jacketCost += item['costJacket']['jacket10'] as int;
//             priceDetail += '?????????,';
//           }
//           if (returnJacket.toString().contains('????????????')) {
//             jacketCost += item['costJacket']['jacket11'] as int;
//             priceDetail += '????????????,';
//           }
//           if (returnJacket.toString().contains('?????????')) {
//             jacketCost += item['costJacket']['jacket12'] as int;
//             priceDetail += '?????????,';
//           }
//           if (returnJacket.toString().contains('??????')) {
//             jacketCost += item['costJacket']['jacket13'] as int;
//             priceDetail += '????????????,';
//           }
//           if (returnPants.toString().contains('?????????')) {
//             pantsCost += item['costPants']['pants1'] as int;
//             priceDetail += '?????????,';
//           }
//           if (returnPants.toString().contains('?????????')) {
//             pantsCost += item['costPants']['pants2'] as int;
//             priceDetail += '?????????,';
//           }
//           if (returnPants.toString().contains('???????????????')) {
//             pantsCost += item['costPants']['pants3'] as int;
//             priceDetail += '???????????????,';
//           }
//           if (returnPants.toString().contains('??????????????????')) {
//             pantsCost += item['costPants']['pants4'] as int;
//             priceDetail += '??????????????????,';
//           }
//           if (returnPants.toString().contains('??????????????????')) {
//             pantsCost += item['costPants']['pants5'] as int;
//             priceDetail += '??????????????????,';
//           }
//           if (returnPants.toString().contains('??????')) {
//             pantsCost += item['costPants']['pants6'] as int;
//             priceDetail += '????????????';
//           }

//           if (returnVest != "") {
//             normalCost += item['costNormal']['normal4'] as int;
//             gabongCost += item['costGabong']['gabong4'] as int;

//             if (returnVest.toString().contains('??????')) {
//               vestCost += item['costVest']['vest1'] as int;
//               priceDetail += '????????????,';
//             }
//             if (returnVest.toString().contains('??????')) {
//               vestCost += item['costVest']['vest2'] as int;
//               priceDetail += '????????????,';
//             }
//             if (returnVest.toString().contains('??????')) {
//               vestCost += item['costVest']['vest3'] as int;
//               priceDetail += '????????????';
//             }
//           }
//         } else if (orderType == "1") {
//           normalCost += item['costNormal']['normal2'] as int;
//           gabongCost += item['costGabong']['gabong2'] as int;

//           if (returnJacket.toString().contains('??????')) {
//             jacketCost += item['costJacket']['jacket1'] as int;
//             priceDetail += '????????????,';
//           }
//           if (returnJacket.toString().contains('?????????')) {
//             jacketCost += item['costJacket']['jacket2'] as int;
//             priceDetail += '?????????,';
//           }
//           if (returnJacket.toString().contains('?????????')) {
//             jacketCost += item['costJacket']['jacket3'] as int;
//             priceDetail += '?????????,';
//           }
//           if (returnJacket.toString().contains('?????????')) {
//             jacketCost += item['costJacket']['jacket4'] as int;
//             priceDetail += '?????????,';
//           }
//           //????????????
//           if (returnJacket.toString().contains('?????? ?????????')) {
//             jacketCost += item['costJacket']['jacket5'] as int;
//             priceDetail += '?????? ?????????,';
//           }
//           if (returnJacket.toString().contains('?????????')) {
//             jacketCost += item['costJacket']['jacket6'] as int;
//             priceDetail += '?????????,';
//           }
//           if (returnJacket.toString().contains('????????????')) {
//             jacketCost += item['costJacket']['jacket7'] as int;
//             priceDetail += '????????????,';
//           }
//           if (returnJacket.toString().contains('?????????')) {
//             jacketCost += item['costJacket']['jacket8'] as int;
//             priceDetail += '?????????,';
//           }
//           if (returnJacket.toString().contains('????????????')) {
//             jacketCost += item['costJacket']['jacket9'] as int;
//             priceDetail += '????????????,';
//           }
//           if (returnJacket.toString().contains('?????????')) {
//             jacketCost += item['costJacket']['jacket10'] as int;
//             priceDetail += '?????????,';
//           }
//           if (returnJacket.toString().contains('????????????')) {
//             jacketCost += item['costJacket']['jacket11'] as int;
//             priceDetail += '????????????,';
//           }
//           if (returnJacket.toString().contains('?????????')) {
//             jacketCost += item['costJacket']['jacket12'] as int;
//             priceDetail += '?????????,';
//           }
//           if (returnJacket.toString().contains('??????')) {
//             jacketCost += item['costJacket']['jacket13'] as int;
//             priceDetail += '????????????,';
//           }
//         } else if (orderType == "3") {
//           //??????
//           normalCost += item['costNormal']['normal3'] as int;
//           gabongCost += item['costGabong']['gabong3'] as int;

//           if (returnPants.toString().contains('?????????')) {
//             pantsCost += item['costPants']['pants1'] as int;
//             priceDetail += '?????????,';
//           }
//           if (returnPants.toString().contains('?????????')) {
//             pantsCost += item['costPants']['pants2'] as int;
//             priceDetail += '?????????,';
//           }
//           if (returnPants.toString().contains('???????????????')) {
//             pantsCost += item['costPants']['pants3'] as int;
//             priceDetail += '???????????????,';
//           }
//           if (returnPants.toString().contains('??????????????????')) {
//             pantsCost += item['costPants']['pants4'] as int;
//             priceDetail += '??????????????????,';
//           }
//           if (returnPants.toString().contains('??????????????????')) {
//             pantsCost += item['costPants']['pants5'] as int;
//             priceDetail += '??????????????????,';
//           }
//           if (returnPants.toString().contains('??????')) {
//             pantsCost += item['costPants']['pants6'] as int;
//             priceDetail += '????????????';
//           }
//         } else if (orderType == "4") {
//           //??????
//           normalCost += item['costNormal']['normal4'] as int;
//           gabongCost += item['costGabong']['gabong4'] as int;

//           if (returnVest.toString().contains('??????')) {
//             vestCost += item['costVest']['vest1'] as int;
//             priceDetail += '????????????,';
//           }
//           if (returnVest.toString().contains('??????')) {
//             vestCost += item['costVest']['vest2'] as int;
//             priceDetail += '????????????,';
//           }
//           if (returnVest.toString().contains('??????')) {
//             vestCost += item['costVest']['vest3'] as int;
//             priceDetail += '????????????';
//           }
//         } else {
//           print('?????????');
//         }

//         step == 4
//             ?
//             //???????????????
//             FirebaseFirestore.instance.collection('orders').doc(orderNo).set({
//                 //'suitDesign': _suitDesign!.toJson(),
//                 'gabongPrice': gabongCost,
//                 'factoryPriceDetail': priceDetail
//               }, SetOptions(merge: true))

//             //???????????????
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
        //minimumSize: Size(Get.width * 0.45, 50), //?????? ?????????

        backgroundColor:
            _selectedIndex == index ? HexColor('#172543') : Colors.transparent,
        minimumSize: withtVal < 481
            ? Size(Get.width * 0.35, 40)
            : Size(170, 50), //?????? ?????????
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
