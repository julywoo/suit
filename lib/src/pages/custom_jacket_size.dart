import 'package:bykak/src/app.dart';
import 'package:bykak/src/components/hex_color.dart';
import 'package:bykak/src/model/order_model.dart';
import 'package:bykak/src/model/top_size_model.dart';
import 'package:bykak/src/model/vest_size_model.dart';
import 'package:bykak/src/pages/custom_pants_size.dart';
import 'package:bykak/src/pages/custom_shirt_size.dart';
import 'package:bykak/src/pages/input_bottom_size.dart';
import 'package:bykak/src/pages/sample.dart';
import 'package:bykak/src/pages/search_page.dart';
import 'package:bykak/src/widget/custom_text_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomJacketSize extends StatefulWidget {
  CustomJacketSize({Key? key}) : super(key: key);

  @override
  State<CustomJacketSize> createState() => _CustomJacketSizeState();
}

class _CustomJacketSizeState extends State<CustomJacketSize> {
  //Order orderData = Get.arguments['orderData'];
  List<String> orderNoList = Get.arguments['orderNoList'];
  int suitCnt = Get.arguments['suitCnt']; // 수트 자켓  조끼
  int shirtCnt = Get.arguments['shirtCnt'];
  int coatCnt = Get.arguments['coatCnt'];
  int pantsCnt = Get.arguments['pantsCnt'];

  @override
  void initState() {
    //getData();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.initState();
  }

  @override
  void dispose() {
    // 세로 화면 고정
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  String storeName = "";
  String bykakCnt = "";
  String totalCnt = "";
  DateTime now = DateTime.now();
  String orderNo = "";
  String orderDate = "";

  List<String> orderTypeList = [];

  TextEditingController shoulder = TextEditingController();
  TextEditingController shoulderFront = TextEditingController();
  TextEditingController shoulderBack = TextEditingController();
  TextEditingController jindong = TextEditingController();
  TextEditingController sleeve = TextEditingController();
  TextEditingController sangdong = TextEditingController();
  TextEditingController armhole = TextEditingController();
  TextEditingController angle = TextEditingController();
  TextEditingController apgil = TextEditingController();
  TextEditingController jungdong = TextEditingController();
  TextEditingController hadong = TextEditingController();
  TextEditingController topHeight = TextEditingController();
  TextEditingController frontForm = TextEditingController();
  TextEditingController backForm = TextEditingController();
  TextEditingController totalHeight = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: true,
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
        elevation: 0,
        title: Text(
          '자켓 사이즈 입력',
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: HexColor('#FFFFFF'),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Container(
                //   width: 300,
                //   child: Text(
                //     '상의 사이즈 입력',
                //     style: TextStyle(color: Colors.black, fontSize: 16),
                //   ),
                // ),
                Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    _inputForm(),
                    _inputForm1(),

                    SizedBox(
                      height: 30,
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //   children: [_inputForm(), _inputForm1()],
                    // )
//                    _inputForm(),
                  ],
                  //child: _inputForm(),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: ElevatedButton(
                          style: TextButton.styleFrom(
                            primary: Colors.white, //글자색
                            onSurface: Colors.white, //onpressed가 null일때 색상
                            backgroundColor: HexColor('#172543'),
                            shadowColor: Colors.white, //그림자 색상
                            elevation: 1, // 버튼 입체감
                            textStyle: TextStyle(fontSize: 16),
                            //padding: EdgeInsets.all(16.0),
                            minimumSize: Size(300, 50), //최소 사이즈
                            side: BorderSide(
                                color: HexColor('#172543'), width: 1.0), //선
                            shape:
                                StadiumBorder(), // : 각진버튼, CircleBorder : 동그라미버튼, StadiumBorder : 모서리가 둥근버튼,
                            alignment: Alignment.center,
                          ), //글자위치 변경
                          onPressed: () {
                            //loginFailAlert();
                            //Get.to(InputBottomSize());
                            saveDesign();
                          },
                          child: const Text('상의 사이즈 저장'),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TopSize? inputTopSize;

  String orderType = '';
  CollectionReference? orders;
  void saveDesign() {
    orders = FirebaseFirestore.instance.collection('orders');
    inputTopSize = TopSize(
      shoulder: shoulder.text,
      shoulderFront: shoulderFront.text,
      shoulderBack: shoulderBack.text,
      jindong: jindong.text,
      sleeve: sleeve.text,
      sangdong: sangdong.text,
      armhole: armhole.text,
      angle: angle.text,
      apgil: apgil.text,
      jungdong: jungdong.text,
      hadong: hadong.text,
      topHeight: topHeight.text,
      frontForm: frontForm.text,
      backForm: backForm.text,
      totalHeight: totalHeight.text,
    );

    try {
//      orders.doc(orderNo).update({'topSize': inputTopSize as TopSize});

      for (var i = 0; i < orderNoList.length; i++) {
        getOrderType(orderNoList[i]);
      }
      if (suitCnt != 0) {
        Get.to(CustomPantsSize(), arguments: {
          'orderNoList': orderNoList,
          'suitCnt': suitCnt,
          'shirtCnt': shirtCnt,
          'coatCnt': coatCnt,
          'pantsCnt': pantsCnt,
          'angle': angle.text,
          'sangdong': sangdong.text,
          'jungdong': jungdong.text,
          'apgil': apgil.text,
        });
      } else if (shirtCnt != 0 && (suitCnt == 0 || pantsCnt == 0)) {
        Get.to(CustomShirtSize(), arguments: {
          'orderNoList': orderNoList,
          'suitCnt': suitCnt,
          'shirtCnt': shirtCnt,
          'coatCnt': coatCnt,
          'pantsCnt': pantsCnt
        });
      } else {
        Get.offAll(App());
      }
    } catch (e) {
      print(e);
    }
  }

  getOrderType(String orderNo) async {
    var userResult = await firestore.collection('orders').doc(orderNo).get();

    setState(() {
      orderType = userResult['orderType'];
    });

    if (orderType == "0" || orderType == "1" || orderType == "4") {
      orders!.doc(orderNo).update({'topSize': inputTopSize!.toJson()});
      print('데이터 저장 완료');
    } else {
      print('데이터 저장 스킵');
    }
  }

  Widget _inputForm() {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        // height: 80.h,
        child: Form(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Text('고객 성함',style: TextStyle(color: Colors.white),
            Container(
              child: Text(
                '어깨',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
            CustomTextFormField(
              type: TextInputType.numberWithOptions(decimal: true),
              lines: 1,
              hint: "",
              controller: shoulder,
            ),
            Container(
              child: Text(
                '앞어깨',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
            CustomTextFormField(
              type: TextInputType.numberWithOptions(decimal: true),
              lines: 1,
              hint: "",
              controller: shoulderFront,
            ),
            Container(
              child: Text(
                '등어깨',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
            CustomTextFormField(
              type: TextInputType.numberWithOptions(decimal: true),
              lines: 1,
              hint: "",
              controller: shoulderBack,
            ),
            Container(
              child: Text(
                '진동',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
            CustomTextFormField(
              type: TextInputType.numberWithOptions(decimal: true),
              lines: 1,
              hint: "",
              controller: jindong,
            ),
            Container(
              child: Text(
                '소매',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
            CustomTextFormField(
              type: TextInputType.numberWithOptions(decimal: true),
              lines: 1,
              hint: "",
              controller: sleeve,
            ),
            Container(
              child: Text(
                '상동',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
            CustomTextFormField(
              type: TextInputType.numberWithOptions(decimal: true),
              lines: 1,
              hint: "",
              controller: sangdong,
            ),
            Container(
              child: Text(
                '암홀',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
            CustomTextFormField(
              type: TextInputType.numberWithOptions(decimal: true),
              lines: 1,
              hint: "",
              controller: armhole,
            ),
            Container(
              child: Text(
                '각도',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
            CustomTextFormField(
              type: TextInputType.numberWithOptions(decimal: true),
              lines: 1,
              hint: "",
              controller: angle,
            ),
          ],
        )),
      ),
    );
  }

  Widget _inputForm1() {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        // height: 80.h,
        child: Form(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Text(
                '앞길',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
            CustomTextFormField(
              type: TextInputType.numberWithOptions(decimal: true),
              lines: 1,
              hint: "",
              controller: apgil,
            ),
            //Text('고객 성함',style: TextStyle(color: Colors.black),
            Container(
              child: Text(
                '중동',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
            CustomTextFormField(
              type: TextInputType.numberWithOptions(decimal: true),
              lines: 1,
              hint: "",
              controller: jungdong,
            ),
            Container(
              child: Text(
                '하동',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
            CustomTextFormField(
              type: TextInputType.numberWithOptions(decimal: true),
              lines: 1,
              hint: "",
              controller: hadong,
            ),
            Container(
              child: Text(
                '상의장',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
            CustomTextFormField(
              type: TextInputType.numberWithOptions(decimal: true),
              lines: 1,
              hint: "",
              controller: topHeight,
            ),
            Container(
              child: Text(
                '앞폼',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
            CustomTextFormField(
              type: TextInputType.numberWithOptions(decimal: true),
              lines: 1,
              hint: "",
              controller: frontForm,
            ),
            Container(
              child: Text(
                '뒷폼',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
            CustomTextFormField(
              type: TextInputType.numberWithOptions(decimal: true),
              lines: 1,
              hint: "",
              controller: backForm,
            ),
            Container(
              child: Text(
                '총장',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
            CustomTextFormField(
              type: TextInputType.numberWithOptions(decimal: true),
              lines: 1,
              hint: "",
              controller: totalHeight,
            ),
          ],
        )),
      ),
    );
  }
}
