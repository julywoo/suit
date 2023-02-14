import 'package:bykak/src/app.dart';
import 'package:bykak/src/pages/search_page.dart';
import 'package:bykak/src/pages/take_pic_page.dart';
import 'package:bykak/src/widget/custom_elevated_buttod.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OrderPicture extends StatefulWidget {
  OrderPicture({Key? key}) : super(key: key);

  @override
  State<OrderPicture> createState() => _OrderPictureState();
}

class _OrderPictureState extends State<OrderPicture> {
  bool agreePicture = false;
  var orderNo = Get.arguments['orderNo'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
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
                          // Get.to(TakePicPage(),
                          //     arguments: {'orderNo': orderNo});
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Text('촬영하기')),
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
                          setState(() {
                            agreePicture = false;
                          });
                          Get.to(SearchPage());
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Text('상담종료 & 상담내역 조회')),
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
}
