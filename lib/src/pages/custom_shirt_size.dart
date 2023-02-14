import 'package:bykak/src/app.dart';
import 'package:bykak/src/components/hex_color.dart';
import 'package:bykak/src/model/order_model.dart';
import 'package:bykak/src/model/shirt_size_model.dart';
import 'package:bykak/src/model/top_size_model.dart';
import 'package:bykak/src/pages/custom_pants_size.dart';
import 'package:bykak/src/pages/input_bottom_size.dart';
import 'package:bykak/src/pages/order_picture.dart';
import 'package:bykak/src/pages/sample.dart';
import 'package:bykak/src/pages/search_page.dart';
import 'package:bykak/src/widget/custom_text_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomShirtSize extends StatefulWidget {
  CustomShirtSize({Key? key}) : super(key: key);

  @override
  State<CustomShirtSize> createState() => _CustomShirtSizeState();
}

class _CustomShirtSizeState extends State<CustomShirtSize> {
  List<String> orderNoList = Get.arguments['orderNoList'];
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.initState();
  }

  // @override
  // void dispose() {
  //   SystemChrome.setPreferredOrientations([]);
  //   SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  //   super.dispose();
  // }

  @override
  void dispose() {
    // 세로 화면 고정
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  TextEditingController neck = TextEditingController();
  TextEditingController shoulder = TextEditingController();
  TextEditingController sleeve = TextEditingController();
  TextEditingController sangdong = TextEditingController();
  TextEditingController jungdong = TextEditingController();
  TextEditingController hip = TextEditingController();
  TextEditingController topHeight = TextEditingController();
  TextEditingController armhole = TextEditingController();
  TextEditingController armSize = TextEditingController();
  TextEditingController wrist = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        elevation: 0,
        title: Text(
          '셔츠 사이즈 입력',
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
                //     '셔츠 사이즈 입력',
                //     style: TextStyle(color: Colors.black, fontSize: 16),
                //   ),
                // ),
                Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    _inputForm(),
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
                        //로그아웃 버튼
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
                          child: const Text('셔츠 사이즈 저장'),
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

  ShirtSize? _inputShirtSize;
  String orderType = '';
  CollectionReference? orders;
  void saveDesign() {
    orders = FirebaseFirestore.instance.collection('orders');
    _inputShirtSize = ShirtSize(
      neck: neck.text,
      shoulder: shoulder.text,
      sleeve: sleeve.text,
      sangdong: sangdong.text,
      jungdong: jungdong.text,
      hip: hip.text,
      topHeight: topHeight.text,
      armhole: armhole.text,
      armSize: armSize.text,
      wrist: wrist.text,
    );

    try {
//      orders.doc(orderNo).update({'topSize': inputTopSize as TopSize});

      for (var i = 0; i < orderNoList.length; i++) {
        getOrderType(orderNoList[i]);
      }

      Get.offAll(App());
      // Get.to(OrderPicture(), arguments: {'orderNoList': orderNoList});
    } catch (e) {
      print(e);
    }
  }

  getOrderType(String orderNo) async {
    var userResult = await firestore.collection('orders').doc(orderNo).get();

    setState(() {
      orderType = userResult['orderType'];
    });

    if (orderType == "2") {
      orders!.doc(orderNo).update({'shirtSize': _inputShirtSize!.toJson()});
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
                '목',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
            CustomTextFormField(
              type: TextInputType.numberWithOptions(decimal: true),
              lines: 1,
              hint: "",
              controller: neck,
            ),
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
                '힢',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
            CustomTextFormField(
              type: TextInputType.numberWithOptions(decimal: true),
              lines: 1,
              hint: "",
              controller: hip,
            ),
            Container(
              child: Text(
                '기장',
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
                '팔통',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
            CustomTextFormField(
              type: TextInputType.numberWithOptions(decimal: true),
              lines: 1,
              hint: "",
              controller: armSize,
            ),
            Container(
              child: Text(
                '손목',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
            CustomTextFormField(
              type: TextInputType.numberWithOptions(decimal: true),
              lines: 1,
              hint: "",
              controller: wrist,
            ),
          ],
        )),
      ),
    );
  }
}
