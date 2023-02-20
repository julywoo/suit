import 'package:bykak/src/model/customer/customer_model.dart';
import 'package:bykak/src/model/order_model.dart';
import 'package:bykak/src/model/tailorShop/payment_model.dart';
import 'package:bykak/src/model/top_size_model.dart';
import 'package:bykak/src/model/vest_size_model.dart';
import 'package:bykak/src/pages/custom_clothes_step1.dart';
import 'package:bykak/src/pages/custom_jacket_size.dart';
import 'package:bykak/src/pages/custom_pants_size.dart';
import 'package:bykak/src/pages/custom_shirt_size.dart';
import 'package:bykak/src/pages/same_item_additional_page.dart';
import 'package:bykak/src/pages/search_page.dart';
import 'package:bykak/src/widget/custom_elevated_buttod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../model/bottom_size_model.dart';
import '../model/shirt_size_model.dart';

class CustomClothesStep2 extends StatefulWidget {
  CustomClothesStep2({Key? key}) : super(key: key);

  @override
  State<CustomClothesStep2> createState() => _CustomClothesStep2State();
}

class _CustomClothesStep2State extends State<CustomClothesStep2> {
  Order orderData = Get.arguments['orderData'];
  String orderNo = Get.arguments['orderNo'];

  @override
  void initState() {
    print(orderData.toString());
    print(orderNo.toString());
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);

    super.initState();
  }

  @override
  void dispose() {
    // 세로 화면 고정

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      // ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(),
                flex: 1,
              ),
              Column(
                children: [
                  ElevatedButton(
                      style: TextButton.styleFrom(
                        primary: HexColor('#172543'), //글자색
                        onSurface: Colors.white, //onpressed가 null일때 색상
                        backgroundColor: HexColor('#FFFFFF'),
                        shadowColor: Colors.white, //그림자 색상
                        elevation: 10, // 버튼 입체감
                        textStyle: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                        //padding: EdgeInsets.all(16.0),
                        minimumSize: Size(300, 60), //최소 사이즈
                        side: BorderSide(
                            color: HexColor('#172543'), width: 1.0), //선
                        shape:
                            StadiumBorder(), // : 각진버튼, CircleBorder : 동그라미버튼, StadiumBorder : 모서리가 둥근버튼,
                        alignment: Alignment.center,
                      ), //글자위치 변경
                      onPressed: () {
                        try {
                          Get.to(SameItemAdditional(), arguments: {
                            'orderData': orderData,
                            'orderNo': orderNo,
                            //'orderList': orderNoList,
                          });
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Text('동일 제품 추가 구매')),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      style: TextButton.styleFrom(
                        primary: Colors.white, //글자색
                        onSurface: Colors.white, //onpressed가 null일때 색상
                        backgroundColor: HexColor('#172543'),
                        shadowColor: Colors.white, //그림자 색상
                        elevation: 10, // 버튼 입체감
                        textStyle: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                        //padding: EdgeInsets.all(16.0),
                        minimumSize: Size(300, 60), //최소 사이즈
                        side: BorderSide(
                            color: HexColor('#172543'), width: 1.0), //선
                        shape:
                            StadiumBorder(), // : 각진버튼, CircleBorder : 동그라미버튼, StadiumBorder : 모서리가 둥근버튼,
                        alignment: Alignment.center,
                      ), //글자위치 변경
                      onPressed: () {
                        try {
                          Get.to(CustomClothesStep1(), arguments: {
                            'orderType': "3",
                            'orderData': orderData,
                            //'orderList': orderNoList,
                          });
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Text('제품 추가 상담')),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      style: TextButton.styleFrom(
                        primary: HexColor('#172543'), //글자색
                        onSurface: Colors.white, //onpressed가 null일때 색상
                        backgroundColor: HexColor('#FFFFFF'),
                        shadowColor: Colors.white, //그림자 색상
                        elevation: 10, // 버튼 입체감
                        textStyle: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                        //padding: EdgeInsets.all(16.0),
                        minimumSize: Size(300, 60), //최소 사이즈
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

                          setCustomerInfo();
                          getSizeInputDate();
                          // Get.to(CustomJacketSize(),
                          //     arguments: {'orderData': orderData});
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Text('상담종료 & 사이즈 측정')),
                ],
              ),
              Expanded(
                child: Container(),
                flex: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  DateTime now = DateTime.now();

  String orderDate = "";
  String visitDate = "";
  List<String> orderNoList = [];
  List<String> orderTypeList = [];
  List<String> orderPabricList = [];
  List priceList = [];

  setCustomerInfo() async {
    visitDate = DateFormat('yyyyMMdd').format(now);
    String userPhone = "";
    if (orderData.phone.toString().length == 11) {
      userPhone = orderData.phone.toString().substring(7, 11);
    } else if (orderData.phone.toString().length == 10) {
      userPhone = orderData.phone.toString().substring(6, 10);
    } else {
      userPhone = "";
    }

    TopSize _inputTopSize = TopSize();
    BottomSize _inputBottomSize = BottomSize();
    VestSize _inputVestSize = VestSize();
    ShirtSize _inputShirtSize = ShirtSize();
    try {
      var userResult = await FirebaseFirestore.instance
          .collection('customers')
          .doc('${orderData.name}_${userPhone}_${orderData.storeName}')
          .get();
      int visitCnt = 0;

      var updateUser = await FirebaseFirestore.instance
          .collection('customers')
          .doc('${orderData.name}_${userPhone}_${orderData.storeName}');

      Future<void> updateUserData() async {
        return await updateUser.update(
          {
            'purchaseCount': visitCnt + 1,
          },
        );
      }

      visitCnt = userResult['purchaseCount'];
      updateUserData();
    } catch (e) {
      final customers = FirebaseFirestore.instance
          .collection('customers')
          .doc('${orderData.name}_${userPhone}_${orderData.storeName}');

      Customer customerData = Customer(
          name: orderData.name,
          phone: orderData.phone,
          gender: orderData.gender,
          birthDate: '',
          firstVisitDate: visitDate,
          lastVisitDate: visitDate,
          storeName: orderData.storeName,
          point: 0,
          accruedPoint: 0,
          purchaseAmount: 0,
          purchaseCount: 1,
          etc: '',
          height: '',
          weight: '',
          shoulderShape: '',
          pointHistory: [],
          legShape: '',
          posture: '',
          eventAgree: 'Y',
          topSize: _inputTopSize,
          bottomSize: _inputBottomSize,
          vestSize: _inputVestSize,
          shirtSize: _inputShirtSize);
      try {
        customers.set(customerData.toJson());
      } catch (e) {
        print(e);
      }
    }
  }

  getSizeInputDate() async {
    orderDate = DateFormat('yyMMdd').format(now);
    try {
      var userResult = await FirebaseFirestore.instance
          .collection('orders')
          .where(
            'phone',
            isEqualTo: orderData.phone,
          )
          .where(
            'name',
            isEqualTo: orderData.name,
          )
          .where(
            'gender',
            isEqualTo: orderData.gender,
          )
          .where(
            'age',
            isEqualTo: orderData.age,
          )
          .where(
            'storeName',
            isEqualTo: orderData.storeName,
          )
          //.where('orderNo', arrayContains: orderDate)
          .where('productionProcess', isEqualTo: 0)
          .get();

      //print(userResult.docs.contains(orderDate));
      String date = DateFormat('yyyy-MM-dd').format(now);
      for (var i in userResult.docs) {
        // print(i['orderNo']);

        try {
          if (i['consultDate'].toString().substring(0, 10) == date) {
            setState(() {
              orderTypeList.add(i['orderType']);
              orderNoList.add(i['orderNo']);
              orderPabricList.add(i['pabric']);
              priceList.add('0');
            });
          }
        } catch (e) {}
      }

      int suitCnt = 0; // 수트 자켓  조끼
      int shirtCnt = 0;
      int coatCnt = 0;
      int pantsCnt = 0;
      for (var i = 0; i < orderTypeList.length; i++) {
        if (orderTypeList[i] == '2') {
          setState(() {
            shirtCnt += 1;
          });
        } else if (orderTypeList[i] == '5') {
          setState(() {
            coatCnt += 1;
          });
        } else if (orderTypeList[i] == "3") {
          setState(() {
            pantsCnt += 1;
          });
        } else {
          setState(() {
            suitCnt += 1;
          });
        }
      }

      if (suitCnt != 0) {
        print('a');
        Get.to(CustomJacketSize(), arguments: {
          'orderNoList': orderNoList,
          'suitCnt': suitCnt,
          'shirtCnt': shirtCnt,
          'coatCnt': coatCnt,
          'pantsCnt': pantsCnt
        });
      } else if (suitCnt == 0 && shirtCnt != 0) {
        Get.to(CustomShirtSize(), arguments: {
          'orderNoList': orderNoList,
          'suitCnt': suitCnt,
          'shirtCnt': shirtCnt,
          'coatCnt': coatCnt,
          'pantsCnt': pantsCnt
        });
      } else if (suitCnt == 0 && pantsCnt != 0) {
        print('b');
        Get.to(CustomPantsSize(), arguments: {
          'orderNoList': orderNoList,
          'suitCnt': suitCnt,
          'shirtCnt': shirtCnt,
          'coatCnt': coatCnt,
          'pantsCnt': pantsCnt
        });
      } else {
        print('코트부분 보류');
      }

      String phoneVal = orderData.phone.toString();
      if (phoneVal.length == 11) {
        phoneVal = phoneVal.substring(7, 11);
      } else if (phoneVal.length == 10) {
        phoneVal = phoneVal.substring(6, 10);
      }
      final payment = FirebaseFirestore.instance.collection('payment').doc(
          orderData.name.toString() +
              '_' +
              phoneVal +
              '_' +
              orderData.consultDate
                  .toString()
                  .substring(0, 10)
                  .replaceAll('-', ''));
      Payment paymentData = Payment(
        tailorShop: orderData.storeName,
        name: orderData.name,
        manager: orderData.makerName,
        phone: orderData.phone,
        totalPrice: 0,
        totalPrepayment: 0,
        consultDate: orderData.consultDate.toString().substring(0, 10),
        orderList: orderNoList,
        orderTypeList: orderTypeList,
        orderPabricList: orderPabricList,
        priceList: priceList,
        givePointResult: 'N',
        usePointResult: 'N',
        givePoint: 0,
        discount: 0,
        discountSub: 0,
        usePoint: 0,
        paymentHistory: [],
        paymentChangeHistory: [],
      );

      try {
        payment.set(paymentData.toJson());
      } catch (e) {}
    } catch (e) {}
  }
}
