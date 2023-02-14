import 'dart:io';

import 'dart:math';
import 'package:bykak/src/components/hex_color.dart';
import 'package:bykak/src/model/order_model.dart';
import 'package:bykak/src/pages/custom_clothes_step1.dart';
import 'package:bykak/src/pages/sample.dart';
import 'package:bykak/src/pages/shirt_design_choice.dart';
import 'package:bykak/src/pages/suit_design_choice.dart';
import 'package:bykak/src/widget/custom_text_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';

final firestore = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance.currentUser;

class InputSuitData extends StatefulWidget {
  InputSuitData({Key? key}) : super(key: key);

  @override
  State<InputSuitData> createState() => _InputSuitDataState();
}

class _InputSuitDataState extends State<InputSuitData> {
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController pabric = TextEditingController();
  TextEditingController age = TextEditingController();

  TextEditingController visitRoute = TextEditingController();
  TextEditingController visitRouteEtc = TextEditingController();

  // /String orderType = Get.arguments['orderType'];
  List<String> list = ['남성', '여성'];
  List<String> visitList = ['네이버검색', 'SNS', '유튜브', '지인소개', '웨딩업체', '기타'];
  List<String> useList = ['일반', '예복'];

  int _selectedIndex = 0;
  int _selectedVisitRoute = 0;
  int _selectedUse = 0;
  var ageValue = '10대';
  //late List<String> orderNoList;

  bool kisweb = true;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    //getData();
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  //boolean
  final TextEditingController _filter = TextEditingController();
  String _searchText = "";
  _InputSuitDataState() {
    // phone.addListener(() {
    //   setState(() {
    //     _searchText = phone.text;
    //     if (_searchText.length > 1) {
    //       // phone.text = phoneNumber(_searchText);
    //       buttonenabled = true;
    //     }
    //   });
    // });
  }
  String phoneNumber(String val) {
    String returnVal = val.replaceAllMapped(RegExp(r'(\d{3})(\d{3,4})(\d+)'),
        (Match m) => "${m[1]}-${m[2]}-${m[3]}");

    return returnVal;
  }

  @override
  Widget build(BuildContext context) {
    var widthtVal = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back, size: 25.0, color: Colors.black),
          ),
        ),
        elevation: 2,
        title: Text(
          '고객 정보 입력',
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            color: Colors.white,
            child: Center(
              child: Container(
                color: Colors.white,
                width: 480,
                // height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          _inputForm(widthtVal),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 50),
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Container(
                              width: kisweb
                                  ? MediaQuery.of(context).size.width * 0.8
                                  : MediaQuery.of(context).size.width * 0.8,
                              //로그아웃 버튼
                              // width: MediaQuery.of(context).size.width,
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
                                      StadiumBorder(), // : 각진버튼, CircleBorder : 동그라미버튼, StadiumBorder : 모서리가 둥근버튼,
                                  alignment: Alignment.center,
                                ), //글자위치 변경
                                onPressed: () {
                                  if (name.text == "") {
                                    failAlert();
                                  } else {
                                    sendModel();
                                  }
                                },

                                child: const Text('제품 및 원단선택'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Order? orderData;

  // void loginFailAlert() {
  void sendModel() {
    // print(orderNo);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(now);
    //String storeName = auth!.displayName.toString();
    print(_selectedUse);
    orderData = Order(
        name: name.text,
        phone: phone.text,
        gender: _selectedIndex.toString(),
        productUse: _selectedUse.toString(),
        age: ageValue.toString(),
        visitRoute: '${visitList[_selectedVisitRoute]} (${visitRouteEtc.text})',
        productionProcess: 0,
        consultDate: formattedDate);

    // if (orderType == "3") {
    Get.to(CustomClothesStep1(), arguments: {
      'orderData': orderData,
      //'orderType': orderType,
      //'orderNoList': orderNoList
    });
    // } else if (orderType == "4") {
    //   print('shirt');
    //   Get.to(const SuitDesignChoice(), arguments: {
    //     'orderData': orderData,
    //     //'orderNo': orderNo,
    //     'orderType': orderType
    //   });
    // }
  }

  Widget _inputForm(widthtVal) {
    // Initial Selected Value

    // List of items in our dropdown menu
    var items = [
      '10대',
      '20대',
      '30대',
      '40대',
      '50대',
      '60대',
      '70대',
      '80대',
      '90대',
    ];
    return Center(
      child: Container(
        width: widthtVal * 0.8,
        child: Form(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Text('고객 성함',style: TextStyle(color: Colors.white),
            Container(
              child: Text(
                '성명',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
            CustomTextFormField(
              lines: 1,
              hint: "",
              controller: name,
            ),
            //Text('고객 성함',style: TextStyle(color: Colors.white),
            Container(
              child: Text(
                '연락처',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
            CustomTextFormField(
              lines: 1,
              hint: "",
              controller: phone,
              type: TextInputType.number,
            ),
            Container(
              child: Text(
                '성별',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  customRadio(list[0], 0, widthtVal),
                  customRadio(list[1], 1, widthtVal)
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Text(
                '용도',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  customRadio2(useList[0], 0, widthtVal),
                  customRadio2(useList[1], 1, widthtVal)
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Text(
                '연령대',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: widthtVal * 0.8,
              height: 60,
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: HexColor('#172543')),
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
                    borderSide: BorderSide(color: HexColor('#172543')),
                  ),
                  filled: true,
                ),
                value: ageValue,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: items.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    ageValue = newValue!;
                  });
                },
              ),
            ),

            SizedBox(
              height: 10,
            ),

            Container(
              child: Text(
                '방문경로',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: widthtVal * 0.8,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      customRadio1(visitList[0], 0, widthtVal),
                      customRadio1(visitList[1], 1, widthtVal)
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      customRadio1(visitList[2], 2, widthtVal),
                      customRadio1(visitList[3], 3, widthtVal)
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      customRadio1(visitList[4], 4, widthtVal),
                      customRadio1(visitList[5], 5, widthtVal)
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          '방문경로 상세 입력 (선택)',
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                      ),
                      CustomTextFormField(
                        lines: 1,
                        hint: "",
                        controller: visitRouteEtc,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }

  void failAlert() {
    Fluttertoast.showToast(
        webBgColor: "linear-gradient(to right, #F44336, #F44336)",
        webPosition: "center",
        msg: "이름을 입력하세요",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Color(0xffF44336),
        textColor: Colors.white,
        fontSize: 16.0);
  }

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
            : Size(200, 40), //최소 사이즈
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

  void changeIndex1(int index) {
    setState(() {
      _selectedVisitRoute = index;
    });
  }

  Widget customRadio1(String text, int index, withtVal) {
    return OutlinedButton(
      onPressed: () {
        changeIndex1(index);
      },
      child: Text(text,
          style: TextStyle(
              color: _selectedVisitRoute == index
                  ? HexColor('#FFFFFF')
                  : Colors.black87)),
      style: OutlinedButton.styleFrom(
        //minimumSize: Size(Get.width * 0.45, 50), //최소 사이즈

        backgroundColor: _selectedVisitRoute == index
            ? HexColor('#172543')
            : Colors.transparent,
        minimumSize: withtVal < 481
            ? Size(Get.width * 0.35, 40)
            : Size(200, 40), //최소 사이즈
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),

        side: BorderSide(
            width: _selectedVisitRoute == index ? 3 : 1,
            color: _selectedVisitRoute == index
                ? HexColor('#172543')
                : Colors.black87),
      ),
    );
  }

  void changeIndex2(int index) {
    setState(() {
      _selectedUse = index;
    });
  }

  Widget customRadio2(String text, int index, withtVal) {
    return OutlinedButton(
      onPressed: () {
        changeIndex2(index);
      },
      child: Text(text,
          style: TextStyle(
              color: _selectedUse == index
                  ? HexColor('#FFFFFF')
                  : Colors.black87)),
      style: OutlinedButton.styleFrom(
        //minimumSize: Size(Get.width * 0.45, 50), //최소 사이즈

        backgroundColor:
            _selectedUse == index ? HexColor('#172543') : Colors.transparent,
        minimumSize: withtVal < 481
            ? Size(Get.width * 0.35, 40)
            : Size(200, 40), //최소 사이즈
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),

        side: BorderSide(
            width: _selectedUse == index ? 3 : 1,
            color:
                _selectedUse == index ? HexColor('#172543') : Colors.black87),
      ),
    );
  }
}
