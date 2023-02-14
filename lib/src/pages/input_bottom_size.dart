import 'package:bykak/src/app.dart';
import 'package:bykak/src/components/hex_color.dart';
import 'package:bykak/src/model/bottom_size_model.dart';
import 'package:bykak/src/model/order_model.dart';
import 'package:bykak/src/model/top_size_model.dart';
import 'package:bykak/src/pages/home.dart';
import 'package:bykak/src/pages/order_picture.dart';
import 'package:bykak/src/pages/sample.dart';
import 'package:bykak/src/widget/custom_text_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class InputBottomSize extends StatefulWidget {
  InputBottomSize({Key? key}) : super(key: key);

  @override
  State<InputBottomSize> createState() => _InputBottomSizeState();
}

class _InputBottomSizeState extends State<InputBottomSize> {
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

  TextEditingController waist = TextEditingController();
  TextEditingController hips = TextEditingController();
  TextEditingController crotch = TextEditingController();
  TextEditingController outHeight = TextEditingController();
  TextEditingController vestHeight = TextEditingController();
  TextEditingController thigh = TextEditingController();
  TextEditingController circumference = TextEditingController();
  TextEditingController pantsBottom = TextEditingController();

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
          '하의 사이즈 입력',
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
                //     '하의 사이즈 입력',
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
                    //   mainAxisAlignment: MainAxisAlignmentaceAround,
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
                            saveDesign();
                          },
                          child: const Text('하의 사이즈 입력'),
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

  BottomSize? _inputBottomSize;

  void saveDesign() {
    String orderNo = Get.arguments['orderNo'];
    TopSize _inputTopSize = Get.arguments['inputTopSize'];
    final orders = FirebaseFirestore.instance.collection('orders');
    _inputBottomSize = BottomSize(
      waist: waist.text,
      hips: hips.text,
      crotch: crotch.text,
      outHeight: outHeight.text,
      // vestHeight: vestHeight.text,
      thigh: thigh.text,
      circumference: circumference.text,
      pantsBottom: pantsBottom.text,
    );

    try {
//      orders.doc(orderNo).update({'topSize': inputTopSize as TopSize});
      orders.doc(orderNo).update({
        'topSize': _inputTopSize.toJson(),
        'bottomSize': _inputBottomSize!.toJson()
      });
      print('데이터 저장 완료');
      //Get.to(App());
      Get.offAll(App());
      // Get.to(OrderPicture(), arguments: {'orderNo': orderNo});
    } catch (e) {
      print(e);
    }
  }

  Widget _inputForm() {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Form(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Text('고객 성함',style: TextStyle(color: Colors.black),
            Container(
              child: Text(
                '허리',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
            CustomTextFormField(
              type: TextInputType.numberWithOptions(decimal: true),
              lines: 1,
              hint: "",
              controller: waist,
            ),
            Container(
              child: Text(
                '힙',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
            CustomTextFormField(
              type: TextInputType.numberWithOptions(decimal: true),
              lines: 1,
              hint: "",
              controller: hips,
            ),
            Container(
              child: Text(
                '밑위길이',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
            CustomTextFormField(
              type: TextInputType.numberWithOptions(decimal: true),
              lines: 1,
              hint: "",
              controller: crotch,
            ),
            Container(
              child: Text(
                '바깥기장',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
            CustomTextFormField(
              type: TextInputType.numberWithOptions(decimal: true),
              lines: 1,
              hint: "",
              controller: outHeight,
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
        child: Form(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Text(
                '조끼장',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
            CustomTextFormField(
              type: TextInputType.numberWithOptions(decimal: true),
              lines: 1,
              hint: "",
              controller: vestHeight,
            ),
            //Text('고객 성함',style: TextStyle(color: Colors.black),
            Container(
              child: Text(
                '허벅',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
            CustomTextFormField(
              type: TextInputType.numberWithOptions(decimal: true),
              lines: 1,
              hint: "",
              controller: thigh,
            ),
            Container(
              child: Text(
                '둘레',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
            CustomTextFormField(
              type: TextInputType.numberWithOptions(decimal: true),
              lines: 1,
              hint: "",
              controller: circumference,
            ),
            Container(
              child: Text(
                '밑통',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
            CustomTextFormField(
              type: TextInputType.numberWithOptions(decimal: true),
              lines: 1,
              hint: "",
              controller: pantsBottom,
            ),
          ],
        )),
      ),
    );
  }
}
